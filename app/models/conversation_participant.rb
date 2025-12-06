# app/models/conversation_participant.rb
class ConversationParticipant < ApplicationRecord
  # Associations
  belongs_to :conversation
  belongs_to :user
  
  # Validations
  validates :user_id, uniqueness: { scope: :conversation_id }
  
  # Callbacks
  after_create :touch_conversation
  
  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :inactive, -> { where(is_active: false) }
  
  private
  
  def touch_conversation
    conversation.touch
  end
end