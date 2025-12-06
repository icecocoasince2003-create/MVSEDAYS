# app/models/community_event.rb
class CommunityEvent < ApplicationRecord
  # Associations
  belongs_to :community
  belongs_to :organizer, class_name: "User"
  belongs_to :museum, optional: true
  has_many :event_participants, dependent: :destroy
  has_many :participants, through: :event_participants, source: :user
  
  # Validations
  validates :title, presence: true, length: { maximum: 200 }
  validates :start_time, presence: true
  validates :status, presence: true,
            inclusion: { in: %w[scheduled ongoing completed cancelled] }
  validate :end_time_after_start_time
  validate :max_participants_not_exceeded
  
  # Callbacks
  after_create :notify_community_members
  
  # Scopes
  scope :upcoming, -> { where("start_time > ?", Time.current).order(:start_time) }
  scope :past, -> { where("start_time <= ?", Time.current).order(start_time: :desc) }
  scope :scheduled, -> { where(status: "scheduled") }
  scope :completed, -> { where(status: "completed") }
  scope :at_museum, ->(museum_id) { where(museum_id: museum_id) }
  
  # Instance methods
  def full?
    return false unless max_participants
    participants_count >= max_participants
  end
  
  def can_join?(user)
    return false if full?
    return false if participants.include?(user)
    true
  end
  
  def add_participant(user)
    return false unless can_join?(user)
    
    event_participants.create(user: user, status: "registered")
  end
  
  def remove_participant(user)
    event_participants.find_by(user: user)&.destroy
  end
  
  def start!
    update(status: "ongoing")
  end
  
  def complete!
    update(status: "completed")
  end
  
  def cancel!
    update(status: "cancelled")
  end
  
  private
  
  def end_time_after_start_time
    return unless end_time && start_time
    
    if end_time <= start_time
      errors.add(:end_time, "は開始時刻より後でなければなりません")
    end
  end
  
  def max_participants_not_exceeded
    return unless max_participants
    
    if max_participants < participants_count
      errors.add(:max_participants, "は現在の参加者数より少なくできません")
    end
  end
  
  def notify_community_members
    # 通知作成はバックグラウンドジョブで実行
  end
end