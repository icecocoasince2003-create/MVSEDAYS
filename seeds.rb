# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# db/seeds.rb

puts "=" * 60
puts "MVSEDAYSデータベース初期化"
puts "=" * 60

# =====================================
# 管理者ユーザー
# =====================================
puts "\n管理者ユーザーを作成中..."

admin_user = User.find_or_initialize_by(email: "icecocoa.since2003@icloud.com")

if admin_user.new_record?
  admin_user.password = "Icecocoa5959drink"
  admin_user.password_confirmation = "Icecocoa5959drink"
  admin_user.admin = true
  
  if admin_user.save
    puts "  ✓ 管理者ユーザーを作成しました: #{admin_user.email}"
  else
    puts "  ✗ エラー: #{admin_user.errors.full_messages.join(', ')}"
  end
else
  puts "  - 管理者ユーザーは既に存在します: #{admin_user.email}"
end

# =====================================
# タグデータ
# =====================================
puts "\nタグデータを作成中..."

tag_names = ['tag1', 'tag2', 'tag3', 'tag4', 'tag5']
tag_created = 0
tag_skipped = 0

tag_names.each do |tag_name|
  tag = Tag.find_or_initialize_by(name: tag_name)
  
  if tag.new_record?
    if tag.save
      tag_created += 1
      puts "  ✓ タグ作成: #{tag.name}"
    else
      puts "  ✗ エラー: #{tag.errors.full_messages.join(', ')}"
    end
  else
    tag_skipped += 1
    puts "  - スキップ(既存): #{tag.name}"
  end
end

puts "  作成: #{tag_created}件、スキップ: #{tag_skipped}件"

# =====================================
# 博物館データ
# =====================================

# 既存データのクリア
# Museum.destroy_all
# puts "✓ 既存の博物館データを削除しました"

puts "\n博物館データを投入中..."

# {name: '名称', prefecture: '都道府県', city: '市区町村', registration_type: '登録種別', museum_type: '館種', official_website: '公式サイトURL', is_featured: true/false}


# データ投入処理
created_count = 0
updated_count = 0
error_count = 0

museums_data.each do |data|
  museum = Museum.find_or_initialize_by(
    name: data[:name],
    prefecture: data[:prefecture]
  )
  
  was_new = museum.new_record?
  museum.assign_attributes(data)
  
  if museum.save
    if was_new
      created_count += 1
      print '+'
    else
      updated_count += 1
      print '.'
    end
  else
    error_count += 1
    puts "\n✗ #{museum.name}: #{museum.errors.full_messages.join(', ')}"
  end
end

puts "\n"
puts "=" * 60
puts "✓ 博物館データの投入完了"
puts "  新規作成: #{created_count}件"
puts "  更新: #{updated_count}件"
puts "  エラー: #{error_count}件" if error_count > 0
puts "  合計: #{Museum.count}件"
puts "=" * 60

# データ確認
if Museum.count > 0
  puts "\n【おすすめ博物館(is_featured=true)】"
  Museum.where(is_featured: true).limit(5).each do |m|
    puts "  ・#{m.name} (#{m.city})"
  end

  puts "\n【館種別の件数】"
  Museum.group(:museum_type).count.each do |type, count|
    puts "  #{type}: #{count}件"
  end

  puts "\n【都市別の件数(トップ5)】"
  Museum.group(:city).count.sort_by { |_, count| -count }.first(5).each do |city, count|
    puts "  #{city}: #{count}件"
  end
end

puts "\n" + "=" * 60
puts "シード投入完了"
puts "=" * 60