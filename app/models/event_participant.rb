# app/models/event_participant.rb
class EventParticipant < ApplicationRecord
  # Associations
  belongs_to :community_event, counter_cache: :participants_count
  belongs_to :user
  
  # Validations
  validates :user_id, uniqueness: { scope: :community_event_id }
  validates :status, presence: true,
            inclusion: { in: %w[registered attended cancelled] }
  
  # Scopes
  scope :registered, -> { where(status: "registered") }
  scope :attended, -> { where(status: "attended") }
  scope :cancelled, -> { where(status: "cancelled") }
  
  # Instance methods
  def mark_as_attended
    update(status: "attended")
  end
  
  def cancel
    update(status: "cancelled")
  end
end