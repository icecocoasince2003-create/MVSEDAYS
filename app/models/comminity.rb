# app/models/community.rb
class Community < ApplicationRecord
  # Associations
  belongs_to :owner, class_name: "User"
  has_many :community_memberships, dependent: :destroy
  has_many :members, through: :community_memberships, source: :user
  has_many :community_posts, dependent: :destroy
  has_many :community_events, dependent: :destroy
  has_one_attached :cover_image
  
  # Validations
  validates :name, presence: true, uniqueness: true,
            length: { maximum: 100 }
  validates :description, length: { maximum: 1000 }
  validates :community_type, presence: true,
            inclusion: { in: %w[public private secret] }
  validates :owner, presence: true
  
  # Callbacks
  after_create :add_owner_as_member
  
  # Scopes
  scope :active, -> { where(is_active: true) }
  scope :public_communities, -> { where(community_type: "public", is_active: true) }
  scope :private_communities, -> { where(community_type: "private") }
  scope :by_category, ->(category) { where(category: category) }
  scope :search_by_name, ->(keyword) {
    where("name LIKE ?", "%#{sanitize_sql_like(keyword)}%")
  }
  scope :popular, -> { order(members_count: :desc) }
  scope :recent, -> { order(created_at: :desc) }
  
  # Instance methods
  def public?
    community_type == "public"
  end
  
  def private?
    community_type == "private"
  end
  
  def secret?
    community_type == "secret"
  end
  
  def member?(user)
    community_memberships.active.exists?(user: user)
  end
  
  def owner?(user)
    owner_id == user.id
  end
  
  def admin?(user)
    community_memberships.active.exists?(user: user, role: %w[owner admin])
  end
  
  def moderator?(user)
    community_memberships.active.exists?(user: user, role: %w[owner admin moderator])
  end
  
  def can_view?(user)
    return true if public?
    return false unless user
    member?(user)
  end
  
  def can_post?(user)
    return false unless user
    member?(user)
  end
  
  def add_member(user, role: "member")
    community_memberships.create(
      user: user,
      role: role,
      status: "active",
      joined_at: Time.current
    )
  end
  
  def remove_member(user)
    community_memberships.find_by(user: user)&.destroy
  end
  
  # Class methods
  def self.categories
    distinct.pluck(:category).compact.sort
  end
  
  private
  
  def add_owner_as_member
    add_member(owner, role: "owner")
  end
end