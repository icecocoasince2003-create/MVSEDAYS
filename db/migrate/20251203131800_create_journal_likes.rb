class CreateJournalLikes < ActiveRecord::Migration[7.2]
  def change
    create_table :journal_likes do |t|
      t.references :user, null: false, foreign_key: true
      t.references :journal, null: false, foreign_key: true

      t.timestamps
    end

    # 同じユーザーが同じ日記に複数回いいねできないようにする
    add_index :journal_likes, [:user_id, :journal_id], unique: true
  end
end
