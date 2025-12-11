class SetupController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :verify_token
  
    def run_migrations
      ActiveRecord::Migration.check_all_pending!
      ActiveRecord::Migrator.migrate(Rails.root.join('db/migrate'))
      render plain: "✅ Migrations completed successfully!"
    rescue => e
      render plain: "❌ Migration failed: #{e.message}", status: 500
    end
  
    def run_seeds
      load Rails.root.join('db/seeds.rb')
      render plain: "✅ Seeds loaded successfully!\n管理者ユーザー: kokos\nパスワード: password"
    rescue => e
      render plain: "❌ Seed failed: #{e.message}", status: 500
    end
  
    private
  
    def verify_token
      token = params[:token]
      expected_token = ENV['SETUP_TOKEN']
      
      unless token.present? && expected_token.present? && token == expected_token
        render plain: "❌ Unauthorized: Invalid or missing token", status: 401
      end
    end
  end
  