class ImproveJournalsTable < ActiveRecord::Migration[7.2]
  def change
    # user_id に外部キー制約を追加 (もしまだなければ)
    unless foreign_key_exists?(:journals, :users)
      add_foreign_key :journals, :users
    end
    
    # user_id にインデックスを追加 (もしまだなければ)
    unless index_exists?(:journals, :user_id)
      add_index :journals, :user_id
    end

    # visit_date にインデックス追加 (日付検索の高速化)
    add_index :journals, :visit_date unless index_exists?(:journals, :visit_date)
    
    # 複合インデックス追加 (ユーザー別・美術館別の投稿検索を高速化)
    add_index :journals, [:user_id, :visit_date] unless index_exists?(:journals, [:user_id, :visit_date])
    add_index :journals, [:museum_id, :visit_date] unless index_exists?(:journals, [:museum_id, :visit_date])
  end
end
