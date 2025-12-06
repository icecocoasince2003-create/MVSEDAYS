class AddMuseumToJournals < ActiveRecord::Migration[7.2]
  def change
    unless column_exists?(:journals,:museum_id)
      add_reference :journals, :museum, foreign_key:true, null:true
    end
  end
end