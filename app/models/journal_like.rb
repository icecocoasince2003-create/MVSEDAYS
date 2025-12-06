class JournalLike < ApplicationRecord
  belongs_to :user
  belongs_to :journal
  
  # 同じユーザーが同じ日記に複数回いいねできないようにする
  validates :user_id, uniqueness: { scope: :journal_id }
end