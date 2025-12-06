class JournalTagRelation < ApplicationRecord
  # リレーション
  belongs_to :journal
  belongs_to :tag

  # バリデーション
  validates :journal_id, presence: true
  validates :tag_id, presence: true
  validates :journal_id, uniqueness: { scope: :tag_id }

  # スコープ
  scope :recent, -> { order(created_at: :desc) }
end

# class TweetTagRelation < ApplicationRecord
#   belongs_to :journal
#   belongs_to :tag
# end