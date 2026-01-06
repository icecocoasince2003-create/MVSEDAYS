class Journal < ApplicationRecord
  # リレーション
  belongs_to :user
  belongs_to :museum, optional: true
  has_many :journal_tag_relations, dependent: :destroy
  has_many :tags, through: :journal_tag_relations
  has_many_attached :images

  # バリデーション
  validates :body, presence: true
  validates :visit_date, presence: true
  validates :user_id, presence: true
  validates :overall, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 5 
  }, allow_nil: true
  validates :rate, numericality: { 
    only_integer: true, 
    greater_than_or_equal_to: 1, 
    less_than_or_equal_to: 5 
  }, allow_nil: true

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
  scope :by_date, -> { order(visit_date: :desc) }
  scope :with_museum, -> { where.not(museum_id: nil) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }
  scope :by_museum, ->(museum_id) { where(museum_id: museum_id) }
  scope :in_date_range, ->(start_date, end_date) { 
    where(visit_date: start_date..end_date) 
  }
  
  # ✅ 追加: タグで検索
  scope :by_tags, ->(tag_ids) {
    joins(:tags).where(tags: { id: tag_ids }).distinct
  }
  
  # ✅ 追加: タグ名で検索
  scope :by_tag_names, ->(tag_names) {
    tag_names = [tag_names] unless tag_names.is_a?(Array)
    joins(:tags).where(tags: { name: tag_names }).distinct
  }

  # インスタンスメソッド
  def museum_display_name
    if museum_id.present? && museum.present?
      museum.name
    elsif museum_name.present?
      museum_name
    else
      "未選択"
    end
  end

  # ✅ 修正: タグ一覧を取得（カンマ区切り）
  def tag_list
    tags.pluck(:name).join(", ")
  end

  # ✅ 修正: タグを保存（カンマ区切り文字列から）
  def tag_list=(names)
    return if names.blank?
    
    # 既存のタグをクリア
    self.tags.clear
    
    # 新しいタグを追加
    tag_names = names.to_s.split(",").map(&:strip).reject(&:blank?)
    tag_names.each do |name|
      tag = Tag.find_or_create_by(name: name.downcase)
      self.tags << tag unless self.tags.include?(tag)
    end
  end
  
  # いいね・コメント
  has_many :journal_likes, dependent: :destroy
  has_many :liked_users, through: :journal_likes, source: :user
  has_many :journal_comments, dependent: :destroy
  
  # 公開日記のみ
  scope :public_journals, -> { where(is_public: true) }
  
  # 非公開日記のみ
  scope :private_journals, -> { where(is_public: false) }
  
  # 人気の日記 (いいね数順)
  scope :popular, -> { 
    left_joins(:journal_likes)
      .group(:id)
      .order('COUNT(journal_likes.id) DESC, journals.created_at DESC')
  }
  
  # コメントが多い日記
  scope :most_commented, -> {
    left_joins(:journal_comments)
      .group(:id)
      .order('COUNT(journal_comments.id) DESC, journals.created_at DESC')
  }
  
  # 特定ユーザーがいいねした日記
  scope :liked_by, ->(user) {
    joins(:journal_likes).where(journal_likes: { user_id: user.id })
  }
  
  # キーワード検索
  scope :search_by_keyword, ->(keyword) {
    return all if keyword.blank?
    
    left_joins(:tags)
      .where(
        "journals.body LIKE :keyword OR journals.tweet LIKE :keyword OR tags.name LIKE :keyword",
        keyword: "%#{sanitize_sql_like(keyword)}%"
      )
      .distinct
  }
  
  # 複合検索
  scope :search_all, ->(params) {
    journals = all
    journals = journals.search_by_keyword(params[:keyword]) if params[:keyword].present?
    journals = journals.by_museum(params[:museum_id]) if params[:museum_id].present?
    journals = journals.by_tags(params[:tag_ids]) if params[:tag_ids].present?
    journals = journals.by_user(params[:user_id]) if params[:user_id].present?
    journals
  }
  
  # いいねされているか
  def liked_by?(user)
    return false unless user
    journal_likes.exists?(user_id: user.id)
  end

  # いいね数
  def likes_count
    journal_likes.count
  end
  
  # コメント数
  def comments_count
    journal_comments.count
  end

  # いいねトグル
  def toggle_like_by(user)
    if liked_by?(user)
      journal_likes.find_by(user: user)&.destroy
      false
    else
      journal_likes.create(user: user)
      true
    end
  end
  
  # コメント追加
  def add_comment(user, content)
    journal_comments.create(user: user, content: content)
  end
  
  # 公開・非公開切り替え
  def toggle_visibility
    update(is_public: !is_public)
  end
  
  # 公開日記か
  def public?
    is_public
  end
  
  # 閲覧可能か
  def viewable_by?(viewer)
    return true if is_public
    return true if user == viewer
    return true if viewer&.admin?
    false
  end
  
  # 統計情報
  def engagement_score
    (likes_count * 2) + (comments_count * 3)
  end
  
  # 人気度
  def popularity_rank
    case engagement_score
    when 0..5 then "新着"
    when 6..15 then "注目"
    when 16..30 then "人気"
    else "大人気"
    end
  end
end
