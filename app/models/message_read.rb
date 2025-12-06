# app/models/message_read.rb
class MessageRead < ApplicationRecord
  # Associations
  belongs_to :message
  belongs_to :user
  
  # Validations
  validates :user_id, uniqueness: { scope: :message_id }
  validates :read_at, presence: true
  
  # Callbacks
  before_validation :set_read_at, on: :create
  
  # Scopes
  scope :recent, -> { order(read_at: :desc) }
  
  private
  
  def set_read_at
    self.read_at ||= Time.current
  end
end