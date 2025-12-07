# app/models/user_profile.rb
class UserProfile < ApplicationRecord
  # Associations
  belongs_to :user
  has_one_attached :avatar
  has_one_attached :cover_image
  
  # Validations
  # validates :user_id, uniqueness: true
  validates :display_name, length: { maximum: 50 }, allow_blank: true
  validates :bio, length: { maximum: 500 }, allow_blank: true
  validates :location, length: { maximum: 100 }, allow_blank: true
  validates :website, format: { 
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]),
    message: "は有効なURLを入力してください"
  }, allow_blank: true
  
  # Scopes
  scope :public_profiles, -> { where(is_public: true) }
  scope :accepting_messages, -> { where(allow_messages: true) }
  
  # Instance methods
  def display_name_or_username
    display_name.presence || user.username
  end
  
  def accepting_messages_from?(other_user)
    return false unless allow_messages
    return true if user.following?(other_user)
    is_public
  end
end