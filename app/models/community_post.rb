# app/models/community_post.rb
class CommunityPost < ApplicationRecord
  # Associations
  belongs_to :community, counter_cache: :posts_count
  belongs_to :user
  belongs_to :journal, optional: true
  has_many :community_post_comments, dependent: :destroy
  has_many_attached :images
  
  # Validations
  validates :content, presence: true, unless: -> { journal.present? }
  validates :post_type, presence: true,
            inclusion: { in: %w[general journal_share event announcement] }
  
  # Callbacks
  after_create :notify_community_members
  
  # Scopes
  scope :not_deleted, -> { where(is_deleted: false) }
  scope :pinned, -> { where(is_pinned: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { order(likes_count: :desc, created_at: :desc) }
  scope :general_posts, -> { where(post_type: "general") }
  scope :journal_shares, -> { where(post_type: "journal_share") }
  
  # Instance methods
  def soft_delete
    update(is_deleted: true)
  end
  
  def pin
    update(is_pinned: true)
  end
  
  def unpin
    update(is_pinned: false)
  end
  
  def toggle_pin
    update(is_pinned: !is_pinned)
  end
  
  private
  
  def notify_community_members
    # 通知作成はバックグラウンドジョブで実行
    # NotificationJob.perform_later(self)
  end
end