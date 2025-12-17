cd C:\Desktop\MVSEDAYS2

@"
class SetupController < ApplicationController
  skip_before_action :verify_authenticity_token

  def run_migrations
    ActiveRecord::Migrator.migrate(Rails.root.join('db/migrate'))
    render plain: " Migrations completed successfully!"
  rescue => e
    render plain: " Error: #{e.message}\n#{e.backtrace.first(5).join("\n")}", status: 500
  end

  def run_seeds
    load Rails.root.join('db/seeds.rb')
    render plain: " Seeds loaded successfully!\n管理者ユーザー: kokos\nパスワード: password"
  rescue => e
    render plain: " Error: #{e.message}\n#{e.backtrace.first(5).join("\n")}", status: 500
  end
end
"@ | Out-File -FilePath app\controllers\setup_controller.rb -Encoding UTF8 -NoNewline

# 確認
type app\controllers\setup_controller.rb
