class Tag < ApplicationRecord
  # リレーション
  has_many :journal_tag_relations, dependent: :destroy
  has_many :journals, through: :journal_tag_relations

  # バリデーション
  validates :name, presence: true, 
                   uniqueness: { case_sensitive: false },
                   length: { maximum: 50 }

  # コールバック
  before_validation :normalize_name

  # スコープ
  scope :popular, -> { 
    joins(:journal_tag_relations)
      .group(:id)
      .order('COUNT(journal_tag_relations.id) DESC') 
  }
  scope :alphabetical, -> { order(:name) }

  # クラスメソッド
  def self.search(keyword)
    where("name LIKE ?", "%#{sanitize_sql_like(keyword)}%")
  end

  # インスタンスメソッド
  def usage_count
    journal_tag_relations.count
  end

  private

  def normalize_name
    self.name = name.strip.downcase if name.present?
  end
end

# class Tag < ApplicationRecord
#     validates :name, presence: :true
#     has_many :tweet_tag_relations, dependent: :destroy
#     has_many :journals, through: :tweet_tag_relations, dependent: :destroy
# end
