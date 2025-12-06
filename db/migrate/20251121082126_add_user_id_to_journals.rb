class AddUserIdToJournals < ActiveRecord::Migration[7.2]
  def change
    add_column :journals, :user_id, :integer
  end
end
