class CreateJournals < ActiveRecord::Migration[7.2]
  def change
    create_table :journals do |t|
      t.text :tweet
      t.date :visit_date
      t.date :post_date
      t.text :tag

      t.timestamps
    end
  end
end
