class CreateJournalComments < ActiveRecord::Migration[7.2]
  def change
    create_table :journal_comments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :journal, null: false, foreign_key: true
      t.text :body

      t.timestamps
    end

    add_index :journal_comments, :created_at
  end
end
