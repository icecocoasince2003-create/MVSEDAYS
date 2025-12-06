# app/models/conversation.rb
class Conversation < ApplicationRecord
  # Associations
  has_many :conversation_participants, dependent: :destroy
  has_many :users, through: :conversation_participants
  has_many :messages, dependent: :destroy
  
  # Validations
  validates :conversation_type, presence: true, 
            inclusion: { in: %w[direct group] }
  validates :title, presence: true, if: -> { group? }
  
  # Scopes
  scope :direct, -> { where(conversation_type: "direct") }
  scope :group, -> { where(conversation_type: "group") }
  scope :recent, -> { order(updated_at: :desc) }
  
  # Instance methods
  def direct?
    conversation_type == "direct"
  end
  
  def group?
    conversation_type == "group"
  end
  
  def last_message
    messages.order(created_at: :desc).first
  end
  
  def unread_count_for(user)
    return 0 unless participant = conversation_participants.find_by(user: user)
    
    messages
      .where("created_at > ?", participant.last_read_at || created_at)
      .where.not(user: user)
      .count
  end
  
  def mark_as_read_by(user)
    participant = conversation_participants.find_by(user: user)
    participant&.update(last_read_at: Time.current)
  end
  
  # Class methods
  def self.between_users(user1, user2)
    joins(:conversation_participants)
      .where(conversation_type: "direct")
      .group(:id)
      .having(
        "COUNT(DISTINCT conversation_participants.user_id) = 2"
      )
      .where(
        conversation_participants: { 
          user_id: [user1.id, user2.id] 
        }
      )
      .first
  end
  
  def self.find_or_create_direct_conversation(user1, user2)
    conversation = between_users(user1, user2)
    
    unless conversation
      conversation = create!(conversation_type: "direct")
      conversation.conversation_participants.create!([
        { user: user1 },
        { user: user2 }
      ])
    end
    
    conversation
  end
end