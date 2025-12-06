class CreateMuseums < ActiveRecord::Migration[7.2]
  def change
    create_table :museums do |t|
      t.timestamps
    end
  end
end
