# app/models/notification.rb
class Notification < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :sender, class_name: "User", optional: true
  belongs_to :notifiable, polymorphic: true, optional: true
  
  # Validations
  validates :notification_type, presence: true,
            inclusion: { 
              in: %w[
                new_follower journal_like journal_comment 
                community_invite community_post_comment new_message
                event_reminder event_cancelled
              ] 
            }
  
  # Scopes
  scope :unread, -> { where(is_read: false) }
  scope :read, -> { where(is_read: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :by_type, ->(type) { where(notification_type: type) }
  
  # Instance methods
  def mark_as_read
    update(is_read: true, read_at: Time.current) unless is_read?
  end
  
  def mark_as_unread
    update(is_read: false, read_at: nil)
  end
  
  # Class methods
  def self.mark_all_as_read_for(user)
    where(user: user, is_read: false).update_all(
      is_read: true, 
      read_at: Time.current
    )
  end
end