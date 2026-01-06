class Museum < ApplicationRecord
  # リレーション
  has_many :journals, dependent: :nullify

  # バリデーション
  validates :name, presence: true, uniqueness: { scope: [:prefecture, :city] }
  validates :prefecture, presence: true
  validates :city, presence: true
  validates :museum_type, presence: true
  validates :official_website, format: { 
    with: URI::DEFAULT_PARSER.make_regexp(%w[http https]), 
    message: "は有効なURLを入力してください" 
  }, allow_blank: true

  # スコープ
  scope :featured, -> { where(is_featured: true) }
  scope :by_prefecture, ->(pref) { where(prefecture: pref) if pref.present? }
  scope :by_city, ->(city) { where(city: city) if city.present? }
  scope :by_type, ->(type) { where(museum_type: type) if type.present? }
  scope :by_registration, ->(reg_type) { where(registration_type: reg_type) if reg_type.present? }
  scope :popular, -> { order(visit_count: :desc) }
  scope :recent, -> { order(created_at: :desc) }

  # キーワード検索スコープ
  scope :search_by_keyword, ->(keyword) { 
    if keyword.present?
      sanitized_keyword = sanitize_sql_like(keyword)
      where("name LIKE ? OR city LIKE ? OR address LIKE ?",
            "%#{sanitized_keyword}%",
            "%#{sanitized_keyword}%",
            "%#{sanitized_keyword}%")
    end
  }

  # 複合検索
  def self.search(params)
    results = all
    results = results.by_prefecture(params[:prefecture]) if params[:prefecture].present?
    results = results.by_type(params[:museum_type]) if params[:museum_type].present?
    results = results.by_registration(params[:registration_type]) if params[:registration_type].present?
    results = results.search_by_keyword(params[:keyword]) if params[:keyword].present?
    results
  end

  # 都道府県リスト
  def self.prefectures_list
    distinct.pluck(:prefecture).compact.sort
  end

  # 館種リスト
  def self.museum_type_list
    distinct.pluck(:museum_type).compact.sort
  end

  # 登録区分リスト
  def self.registration_type_list
    distinct.pluck(:registration_type).compact.reject(&:empty?).uniq.sort
  end

  # インスタンスメソッド
  def full_address
    [prefecture, city, address].reject(&:blank?).join(' ')
  end

  # 訪問回数をインクリメント
  def increment_visit_count!
    increment!(:visit_count)
  end

  # 関連日記取得
  def related_journals
    journals.recent.limit(10)
  end

  # 総日記数
  def journals_count
    journals.count
  end

  # 総いいね数
  def total_likes
    journals.sum(:likes)
  end

  # 平均評価
  def average_rating
    journals.where.not(rate: nil).average(:rate)&.round(1)
  end
end