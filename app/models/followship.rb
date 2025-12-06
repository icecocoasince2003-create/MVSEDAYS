# app/models/followship.rb
class Followship < ApplicationRecord
  # Associations
  belongs_to :follower, class_name: "User"
  belongs_to :followee, class_name: "User"
  
  # Validations
  validates :follower_id, uniqueness: { scope: :followee_id }
  validate :cannot_follow_self
  
  # Callbacks
  after_create :increment_counters
  after_create :create_notification
  after_destroy :decrement_counters
  
  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  
  private
  
  def cannot_follow_self
    if follower_id == followee_id
      errors.add(:follower, "自分自身をフォローすることはできません")
    end
  end
  
  def increment_counters
    follower.user_profile&.increment!(:following_count)
    followee.user_profile&.increment!(:followers_count)
  end
  
  def decrement_counters
    follower.user_profile&.decrement!(:following_count)
    followee.user_profile&.decrement!(:followers_count)
  end
  
  def create_notification
    Notification.create(
      user: followee,
      sender: follower,
      notification_type: "new_follower",
      notifiable: self,
      content: "#{follower.username}さんがあなたをフォローしました"
    )
  end
end