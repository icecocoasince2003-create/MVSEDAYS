class AddMuseumNameToJournals < ActiveRecord::Migration[7.2]
  def change
    add_column :journals, :museum_name, :string
    add_index :journals, :museum_name
  end
end
