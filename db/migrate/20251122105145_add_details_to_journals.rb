class AddDetailsToJournals < ActiveRecord::Migration[7.2]
  def change
    add_column :journals, :overall, :integer
    add_column :journals, :rate, :integer
  end
end
