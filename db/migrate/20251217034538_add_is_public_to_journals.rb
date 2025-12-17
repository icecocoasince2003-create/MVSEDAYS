class AddIsPublicToJournals < ActiveRecord::Migration[7.2]
  def change
    add_column :journals, :is_public, :boolean, default: true, null: false
    add_index :journals, :is_public
  end
end
