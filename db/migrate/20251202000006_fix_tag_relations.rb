class FixTagRelations < ActiveRecord::Migration[7.2]
  def up
    if table_exists?(:tweet_tag_relations) && !table_exists?(:journal_tag_relations)
      # 外部キー制約を無効化
      execute "PRAGMA foreign_keys = OFF"
      
      # 新しいテーブルを作成（外部キーなし）
      create_table :journal_tag_relations, id: false do |t|
        t.primary_key :id
        t.integer :journal_id, null: false
        t.integer :tag_id, null: false
        t.timestamps
      end
      
      # データをコピー（tweet_id → journal_id にマッピング）
      execute <<-SQL
        INSERT INTO journal_tag_relations (id, journal_id, tag_id, created_at, updated_at)
        SELECT id, tweet_id, tag_id, created_at, updated_at
        FROM tweet_tag_relations
      SQL
      
      # 古いテーブルを削除
      drop_table :tweet_tag_relations, if_exists: true
      
      # インデックスを追加
      add_index :journal_tag_relations, :tag_id, name: "index_journal_tag_relations_on_tag_id"
      add_index :journal_tag_relations, :journal_id, name: "index_journal_tag_relations_on_journal_id"
      
      # 外部キー制約を追加
      add_foreign_key :journal_tag_relations, :journals, column: :journal_id
      add_foreign_key :journal_tag_relations, :tags, column: :tag_id
      
      # 外部キー制約を再度有効化
      execute "PRAGMA foreign_keys = ON"
    end
    
    # journals.tag カラムを削除
    if column_exists?(:journals, :tag)
      remove_column :journals, :tag
    end
  end
  
  def down
    # ロールバック処理
    if table_exists?(:journal_tag_relations) && !table_exists?(:tweet_tag_relations)
      execute "PRAGMA foreign_keys = OFF"
      
      # 外部キーを削除
      remove_foreign_key :journal_tag_relations, :journals if foreign_key_exists?(:journal_tag_relations, :journals)
      remove_foreign_key :journal_tag_relations, :tags if foreign_key_exists?(:journal_tag_relations, :tags)
      
      # 古いテーブル構造で再作成
      create_table :tweet_tag_relations, id: false do |t|
        t.primary_key :id
        t.integer :tweet_id, null: false
        t.integer :tag_id, null: false
        t.timestamps
      end
      
      # データを戻す（journal_id → tweet_id）
      execute <<-SQL
        INSERT INTO tweet_tag_relations (id, tweet_id, tag_id, created_at, updated_at)
        SELECT id, journal_id, tag_id, created_at, updated_at
        FROM journal_tag_relations
      SQL
      
      # 新しいテーブルを削除
      drop_table :journal_tag_relations
      
      # インデックスを追加
      add_index :tweet_tag_relations, :tag_id
      add_index :tweet_tag_relations, :tweet_id
      add_foreign_key :tweet_tag_relations, :tags
      
      execute "PRAGMA foreign_keys = ON"
    end
    
    # journals.tag カラムを復元
    unless column_exists?(:journals, :tag)
      add_column :journals, :tag, :text
    end
  end
end