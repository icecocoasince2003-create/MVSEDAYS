class JournalComment < ApplicationRecord
  belongs_to :user
  belongs_to :journal
  
  # バリデーション
  validates :body, presence: true, length: { minimum: 1, maximum: 1000 }
  
  # 新しい順に表示
  default_scope { order(created_at: :desc) }
end