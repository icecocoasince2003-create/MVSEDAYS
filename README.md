# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version: 7.2.3

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
==============================
博物館データの投入方法
==============================
1. プロジェクトのルートディレクトリで実行
python convert_museums.py
2. 生成されたファイルを確認
type db\seeds_museums_all.rb | more
3. 生成されたRubyファイルを直接実行
rails runner db/seeds_museums_all.rb
4. コマンドで確認
rails console
# 総件数の確認
Museum.count
# => 1440

# 都道府県別の件数
Museum.group(:prefecture).count.sort_by { |k, v| -v }
# => {"東京都"=>123, "北海道"=>98, ...}

# 博物館タイプ別の件数
Museum.group(:museum_type).count
# => {"博物館"=>500, "美術館"=>300, "科学館"=>150, ...}

# 登録状況別の件数
Museum.group(:registration_type).count

# ランダムに10件表示
Museum.order('RANDOM()').limit(10).each do |m|
  puts "#{m.name} (#{m.prefecture} #{m.city}) - #{m.museum_type}"
end

# 公式サイトがある博物館の数
Museum.where.not(official_website: [nil, '']).count

# 東京都の博物館
Museum.where(prefecture: '東京都').count

# 特定の名前で検索（例：国立）
Museum.where("name LIKE ?", "%国立%").pluck(:name)

# 最新のデータを5件表示
Museum.order(created_at: :desc).limit(5).each do |m|
  puts "#{m.name} (#{m.prefecture})"
end

exit

