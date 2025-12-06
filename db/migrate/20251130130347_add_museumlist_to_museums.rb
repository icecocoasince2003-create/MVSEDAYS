class AddMuseumlistToMuseums < ActiveRecord::Migration[7.2]
  def change
    add_column :museums, :name, :string
    add_column :museums, :prefecture, :string
    add_column :museums, :city, :string
    add_column :museums, :registration_type, :string
    add_column :museums, :museum_type, :string
    add_column :museums, :official_website, :string
    add_column :museums, :address, :text
    add_column :museums, :description, :text
    add_column :museums, :is_featured, :boolean
    add_column :museums, :visit_count, :integer

    add_index :museums, :name
    add_index :museums, :prefecture
    add_index :museums, :city
    add_index :museums, :museum_type
    add_index :museums, [:prefecture, :city]
  end
end
