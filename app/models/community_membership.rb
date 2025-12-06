# app/models/community_membership.rb
class CommunityMembership < ApplicationRecord
  # Associations
  belongs_to :community, counter_cache: :members_count
  belongs_to :user
  
  # Validations
  validates :user_id, uniqueness: { scope: :community_id }
  validates :role, presence: true,
            inclusion: { in: %w[owner admin moderator member] }
  validates :status, presence: true,
            inclusion: { in: %w[pending active banned] }
  
  # Callbacks
  before_create :set_joined_at, if: -> { active? }
  
  # Scopes
  scope :active, -> { where(status: "active") }
  scope :pending, -> { where(status: "pending") }
  scope :banned, -> { where(status: "banned") }
  scope :owners, -> { where(role: "owner") }
  scope :admins, -> { where(role: %w[owner admin]) }
  scope :moderators, -> { where(role: %w[owner admin moderator]) }
  scope :recent, -> { order(joined_at: :desc) }
  
  # Instance methods
  def active?
    status == "active"
  end
  
  def pending?
    status == "pending"
  end
  
  def banned?
    status == "banned"
  end
  
  def owner?
    role == "owner"
  end
  
  def admin?
    %w[owner admin].include?(role)
  end
  
  def moderator?
    %w[owner admin moderator].include?(role)
  end
  
  def approve
    update(status: "active", joined_at: Time.current)
  end
  
  def ban
    update(status: "banned")
  end
  
  private
  
  def set_joined_at
    self.joined_at ||= Time.current
  end
end