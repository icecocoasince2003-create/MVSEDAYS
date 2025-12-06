class AddConfirmableToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_column :users, :unconfirmed_email, :string

    add_index :users, :confirmation_token, unique: true
    
    # 既存ユーザーを自動承認
    # (新規インストールの場合は影響なし)
    reversible do |dir|
      dir.up do
        # Userモデルが存在する場合のみ実行
        User.update_all(confirmed_at: Time.current) if User.table_exists?
      end
    end
  end
end
