# app/models/message.rb
class Message < ApplicationRecord
  # Associations
  belongs_to :conversation, touch: true
  belongs_to :user
  has_many :message_reads, dependent: :destroy
  has_one_attached :attachment
  
  # Validations
  validates :content, presence: true, unless: -> { attachment.attached? }
  validates :message_type, presence: true, 
            inclusion: { in: %w[text image system] }
  
  # Callbacks
  after_create_commit :broadcast_message
  after_create :create_message_reads
  
  # Scopes
  scope :not_deleted, -> { where(is_deleted: false) }
  scope :recent, -> { order(created_at: :desc) }
  scope :text_messages, -> { where(message_type: "text") }
  scope :image_messages, -> { where(message_type: "image") }
  
  # Instance methods
  def read_by?(user)
    message_reads.exists?(user: user)
  end
  
  def mark_as_read_by(user)
    return if user == self.user
    
    message_reads.find_or_create_by(user: user) do |read|
      read.read_at = Time.current
    end
  end
  
  def soft_delete
    update(is_deleted: true)
  end
  
  private
  
  def broadcast_message
    ConversationChannel.broadcast_to(
      conversation,
      message: MessagesController.render(
        partial: "messages/message",
        locals: { message: self }
      )
    )
  end
  
  def create_message_reads
    # 自分以外の参加者に既読レコードを作成準備
    # 実際の既読は mark_as_read_by で記録
  end
end