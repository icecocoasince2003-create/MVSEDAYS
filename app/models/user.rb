class User < ApplicationRecord
  # Devise モジュール設定
  # :confirmable, :trackable, :lockable を追加
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :lockable

  # リレーション
  has_many :journals, dependent: :destroy
  has_many :messages, dependent: :destroy
  has_many :community_memberships, dependent: :destroy
  has_many :communities, through: :community_memberships

  # バリデーション
  validates :username, presence: true, 
                       uniqueness: { case_sensitive: false },
                       length: { minimum: 3, maximum: 20 },
                       format: { 
                         with: /\A[a-zA-Z0-9_]+\z/,
                         message: "は半角英数字とアンダースコアのみ使用できます" 
                       }
  validates :email, presence: true, uniqueness: { case_sensitive: false }

  # スコープ
  scope :admins, -> { where(admin: true) }
  scope :regular_users, -> { where(admin: false) }
  scope :confirmed, -> { where.not(confirmed_at: nil) }

  # メソッド
  def admin?
    admin == true
  end

  # usernameでログイン
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if (login = conditions.delete(:email))
      where(conditions).where(
        ["lower(email) = :value OR lower(username) = :value", 
         { value: login.downcase }]
      ).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions).first
    end
  end
  # ===== ソーシャル機能: 追加 =====
  # プロフィール
  has_one :user_profile, dependent: :destroy
  accepts_nested_attributes_for :user_profile
  after_create :create_default_profile
  
  # フォロー機能
  has_many :active_followships, class_name: "Followship", 
           foreign_key: "follower_id", dependent: :destroy
  has_many :passive_followships, class_name: "Followship",
           foreign_key: "followe_id", dependent: :destroy
  has_many :following, through: :active_followships, source: :follower
  has_many :followers, through: :passive_followships, source: :follower
  
  # チャット機能
  has_many :conversation_participants, dependent: :destroy
  has_many :conversations, through: :conversation_participants
  has_many :messages, dependent: :destroy
  
  # コミュニティ機能
  has_many :owned_communities, class_name: "Community",
           foreign_key: "owner_id", dependent: :destroy
  has_many :community_memberships, dependent: :destroy
  has_many :communities, through: :community_memberships
  has_many :community_posts, dependent: :destroy
  has_many :organized_events, class_name: "CommunityEvent",
           foreign_key: "organizer_id", dependent: :destroy
  has_many :event_participants, dependent: :destroy
  has_many :attending_events, through: :event_participants, 
           source: :community_event
  
  # いいね・コメント
  has_many :journal_likes, dependent: :destroy
  has_many :liked_journals, through: :journal_likes, source: :journal
  has_many :journal_comments, dependent: :destroy
  
  # 通知
  has_many :notifications, dependent: :destroy
  has_many :sent_notifications, class_name: "Notification",
           foreign_key: "sender_id", dependent: :nullify
  
  # ===== フォロー関連メソッド =====
  
  def follow(other_user)
    return false if self == other_user
    active_followships.find_or_create_by(followee: other_user)
  end
  
  def unfollow(other_user)
    active_followships.find_by(followee: other_user)&.destroy
  end
  
  def following?(other_user)
    following.include?(other_user)
  end
  
  def followed_by?(other_user)
    followers.include?(other_user)
  end
  
  # ===== いいね関連メソッド =====
  
  def like(journal)
    journal_likes.find_or_create_by(journal: journal)
  end
  
  def unlike(journal)
    journal_likes.find_by(journal: journal)&.destroy
  end
  
  def liked?(journal)
    liked_journals.include?(journal)
  end
  
  # ===== コミュニティ関連メソッド =====
  
  def join_community(community)
    return false if community.member?(self)
    
    status = community.public? ? "active" : "pending"
    community_memberships.create(
      community: community,
      status: status,
      joined_at: (status == "active" ? Time.current : nil)
    )
  end
  
  def leave_community(community)
    community_memberships.find_by(community: community)&.destroy
  end
  
  def member_of?(community)
    community.member?(self)
  end
  
  # ===== チャット関連メソッド =====
  
  def start_conversation_with(other_user)
    Conversation.find_or_create_direct_conversation(self, other_user)
  end
  
  def can_message?(other_user)
    return false if self == other_user
    other_user.user_profile&.accepting_messages_from?(self)
  end
  
  # ===== 通知関連メソッド =====
  
  def unread_notifications_count
    notifications.unread.count
  end
  
  def unread_messages_count
    conversations.sum { |conv| conv.unread_count_for(self) }
  end
  
  # ===== タイムライン関連メソッド =====
  
  def timeline_journals
    following_ids = following.pluck(:id)
    Journal.where(user_id: [id] + following_ids)
           .where(is_public: true)
           .includes(:user, :museum, :tags)
           .order(created_at: :desc)
  end
  
  def discover_journals
    Journal.where(is_public: true)
           .where.not(user_id: id)
           .includes(:user, :museum, :tags)
           .order(created_at: :desc)
  end
  
  # ===== プロフィール関連メソッド =====

  def display_name
    # username が存在すればそれを使用、なければ email の @ より前を使用
    if username.present?
      username
    elsif email.present?
      email.split('@').first
    else
      'ユーザー'
    end
  end
  
  # アバターの頭文字を取得
  def avatar_initial
    display_name.first.upcase
  end
  
  def avatar_url
    # user_profile が存在する場合のみチェック
    if defined?(UserProfile) && user_profile&.avatar&.attached?
      Rails.application.routes.url_helpers.url_for(user_profile.avatar)
    else
      "https://ui-avatars.com/api/?name=#{CGI.escape(display_name)}&size=200"
    end
  end  
  
  private
  
  def create_default_profile
    # UserProfile を自動作成
    create_user_profile! unless user_profile.present?
  rescue ActiveRecord::RecordInvalid => e
    Rails.logger.error "Failed to create user_profile: #{e.message}"
  end
end
# class User < ApplicationRecord
#   # Include default devise modules. Others available are:
#   # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
#   devise :database_authenticatable, :registerable,
#          :recoverable, :rememberable, :validatable

#   has_many :journals, dependent: :destroy
# end