# app/models/community_post_comment.rb
class CommunityPostComment < ApplicationRecord
  # Associations
  belongs_to :community_post, counter_cache: :comments_count
  belongs_to :user
  
  # Validations
  validates :content, presence: true, length: { maximum: 1000 }
  
  # Callbacks
  after_create :notify_post_author
  
  # Scopes
  scope :not_deleted, -> { where(is_deleted: false) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Instance methods
  def soft_delete
    update(is_deleted: true)
  end
  
  private
  
  def notify_post_author
    return if user == community_post.user
    
    Notification.create(
      user: community_post.user,
      sender: user,
      notification_type: "community_post_comment",
      notifiable: self,
      content: "#{user.username}さんがあなたのコミュニティ投稿にコメントしました"
    )
  end
end