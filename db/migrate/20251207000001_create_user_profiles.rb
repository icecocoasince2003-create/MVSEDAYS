class CreateUserProfiles < ActiveRecord::Migration[7.2]
    def change
      create_table :user_profiles do |t|
        t.references :user, null: false, foreign_key: true, index: { unique: true }
        t.string :display_name
        t.text :bio
        t.string :location
        t.string :website
        t.boolean :is_public, default: true, null: false
        t.boolean :allow_messages, default: true, null: false
  
        t.timestamps
      end
    end
  end  