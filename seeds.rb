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

# 既存データのクリア(必要に応じてコメントアウト)
# Museum.destroy_all
# puts "✓ 既存の博物館データを削除しました"

puts "\n博物館データを投入中..."

# {name: '名称', prefecture: '都道府県', city: '市区町村', registration_type: '登録種別', museum_type: '館種', official_website: '公式サイトURL', is_featured: true/false}
museums_data = [
  # 北海道
  { name: '旭川市旭山動物園', prefecture: '北海道', city: '旭川市', registration_type: '登録博物館', museum_type: '動物園', official_website: 'https://www.city.asahikawa.hokkaido.jp/asahiyamazoo/', is_featured: true },
  { name: '旭川市科学館', prefecture: '北海道', city: '旭川市', registration_type: '登録博物館', museum_type: '科学', official_website: 'https://www.city.asahikawa.hokkaido.jp/science/', is_featured: false },
  { name: '旭川市博物館', prefecture: '北海道', city: '旭川市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.asahikawa.hokkaido.jp/hakubutukan/index.html', is_featured: false },
  { name: '中原悌二郎記念旭川市彫刻美術館', prefecture: '北海道', city: '旭川市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://www.city.asahikawa.hokkaido.jp/sculpture/', is_featured: false },
  { name: '北海道立旭川美術館', prefecture: '北海道', city: '旭川市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://artmuseum.pref.hokkaido.lg.jp/abj', is_featured: true },
  { name: '三浦綾子記念文学館', prefecture: '北海道', city: '旭川市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'https://www.hyouten.com/', is_featured: false },
  { name: '厚岸町海事記念館', prefecture: '北海道', city: '厚岸町', registration_type: '登録博物館', museum_type: '歴史', official_website: 'http://edu.town.akkeshi.hokkaido.jp/kaiji/', is_featured: false },
  { name: '網走市立郷土博物館', prefecture: '北海道', city: '網走市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.abashiri.hokkaido.jp/site/kyodo/', is_featured: false },
  { name: '網走市立美術館', prefecture: '北海道', city: '網走市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://www.city.abashiri.hokkaido.jp/site/artmuseum/', is_featured: false },
  { name: '博物館　網走監獄', prefecture: '北海道', city: '網走市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'https://www.kangoku.jp/', is_featured: false },
  { name: '北海道立北方民族博物館', prefecture: '北海道', city: '網走市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'https://hoppohm.org/index2.htm', is_featured: true },
  { name: '荒井記念美術館', prefecture: '北海道', city: '岩内町', registration_type: '登録博物館', museum_type: '美術', official_website: 'http://www.iwanai-h.com/art/', is_featured: false },
  { name: '浦河町立郷土博物館', prefecture: '北海道', city: '浦河町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.town.urakawa.hokkaido.jp/gyosei/culture/?category=100', is_featured: false },
  { name: '浦幌町立博物館', prefecture: '北海道', city: '浦幌町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://museum-urahoro.jp', is_featured: false },
  { name: 'オホーツクミュージアムえさし', prefecture: '北海道', city: '枝幸郡', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.esashi.jp/tourism/guide/museum.html', is_featured: true },
  { name: '小樽芸術村', prefecture: '北海道', city: '小樽市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://www.nitorihd.co.jp/otaru-art-base/', is_featured: true },
  { name: '小樽市総合博物館', prefecture: '北海道', city: '小樽市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.otaru.lg.jp/categories/bunya/shisetsu/bunka_kanko/museum/', is_featured: false },
  { name: 'おたる水族館', prefecture: '北海道', city: '小樽市', registration_type: '登録博物館', museum_type: '水族館', official_website: 'https://otaru-aq.jp/', is_featured: true },
  { name: '北一ヴェネツィア美術館', prefecture: '北海道', city: '小樽市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://venezia-museum.or.jp/', is_featured: false },
  { name: '市立小樽美術館', prefecture: '北海道', city: '小樽市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://www.city.otaru.lg.jp/categories/bunya/shisetsu/bunka_kanko/bijyutsukan/', is_featured: false },
  { name: '市立小樽文学館', prefecture: '北海道', city: '小樽市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'http://otarubungakusha.com/yakata', is_featured: false },
  { name: '帯広百年記念館', prefecture: '北海道', city: '帯広市', registration_type: '登録博物館', museum_type: '総合', official_website: 'http://museum-obihiro.jp/occm/', is_featured: false },
  { name: '北海道立帯広美術館', prefecture: '北海道', city: '帯広市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://artmuseum.pref.hokkaido.lg.jp/obj/', is_featured: true },
  { name: '標茶町博物館', prefecture: '北海道', city: '標茶町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.sip.or.jp/~shibecha-museum/', is_featured: true },
  { name: '北網圏北見文化センター', prefecture: '北海道', city: '北見市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://hokumouken.com/', is_featured: false },
  { name: '釧路市立博物館', prefecture: '北海道', city: '釧路市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.kushiro.lg.jp/museum/', is_featured: false },
  { name: '釧路市立美術館', prefecture: '北海道', city: '釧路市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://k-bijutsukan.net/', is_featured: false },
  { name: '北海道立釧路芸術館', prefecture: '北海道', city: '釧路市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://www.kushiro-artmu.jp/', is_featured: true },
  { name: '札幌市青少年科学館', prefecture: '北海道', city: '札幌市', registration_type: '登録博物館', museum_type: '科学', official_website: 'https://www.ssc.slp.or.jp/', is_featured: false },
  { name: '札幌市円山動物園', prefecture: '北海道', city: '札幌市', registration_type: '登録博物館', museum_type: '動物園', official_website: 'https://www.city.sapporo.jp/zoo/', is_featured: true },
  { name: '北海道立近代美術館', prefecture: '北海道', city: '札幌市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://artmuseum.pref.hokkaido.lg.jp/knb/', is_featured: true },
  { name: '北海道立文学館', prefecture: '北海道', city: '札幌市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'http://www.h-bungaku.or.jp/', is_featured: true },
  { name: '北海道立三岸好太郎美術館', prefecture: '北海道', city: '札幌市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://artmuseum.pref.hokkaido.lg.jp/mkb/', is_featured: true },
  { name: '士別市立博物館', prefecture: '北海道', city: '士別市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.shibetsu.lg.jp/gyoseisaito/kosodate_bunka_supotsu/shibetsushiritsuhakubutsukan/index.html', is_featured: false },
  { name: '斜里町立知床博物館', prefecture: '北海道', city: '斜里町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://shiretoko-museum.jpn.org/', is_featured: false },
  { name: '新ひだか町博物館', prefecture: '北海道', city: '新ひだか町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.shinhidaka-hokkaido.jp/hotnews/category/180.html', is_featured: false },
  { name: 'だて歴史文化ミュージアム', prefecture: '北海道', city: '伊達市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'https://date-museum.jp/', is_featured: true },
  { name: '苫小牧市科学センター', prefecture: '北海道', city: '苫小牧市', registration_type: '登録博物館', museum_type: '科学', official_website: 'https://www.city.tomakomai.hokkaido.jp/kagaku/', is_featured: false },
  { name: '苫小牧市美術博物館', prefecture: '北海道', city: '苫小牧市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.tomakomai.hokkaido.jp/hakubutsukan/', is_featured: true },
  { name: '名寄市北国博物館', prefecture: '北海道', city: '名寄市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'http://www.city.nayoro.lg.jp/section/museum/prkeql000000krpr.html', is_featured: false },
  { name: '市立函館博物館', prefecture: '北海道', city: '函館市', registration_type: '登録博物館', museum_type: '総合', official_website: 'http://hakohaku.com/', is_featured: false },
  { name: '函館市縄文文化交流センター', prefecture: '北海道', city: '函館市', registration_type: '登録博物館', museum_type: '歴史', official_website: 'http://www.hjcc.jp/', is_featured: false },
  { name: '北海道立函館美術館', prefecture: '北海道', city: '函館市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://artmuseum.pref.hokkaido.lg.jp/hbj', is_featured: false },
  { name: '日高山脈博物館', prefecture: '北海道', city: '日高町', registration_type: '登録博物館', museum_type: '科学', official_website: 'https://www.town.hidaka.hokkaido.jp/site/hmc/', is_featured: false },
  { name: '安田侃彫刻美術館アルテピアッツァ美唄', prefecture: '北海道', city: '美唄市', registration_type: '登録博物館', museum_type: '美術', official_website: 'https://artepiazza.jp/', is_featured: false },
  { name: '美幌博物館', prefecture: '北海道', city: '美幌町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.town.bihoro.hokkaido.jp/site/museum/', is_featured: false },
  { name: '平取町立二風谷アイヌ文化博物館', prefecture: '北海道', city: '平取町', registration_type: '登録博物館', museum_type: '歴史', official_website: 'https://nibutani-ainu-museum.com/', is_featured: false },
  { name: '広尾町海洋博物館', prefecture: '北海道', city: '広尾町', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.town.hiroo.lg.jp/kankou/leisurespot/rekishi/', is_featured: false },
  { name: '三笠市立博物館', prefecture: '北海道', city: '三笠市', registration_type: '登録博物館', museum_type: '総合', official_website: 'https://www.city.mikasa.hokkaido.jp/museum/', is_featured: true },
  { name: '穂別博物館', prefecture: '北海道', city: 'むかわ町', registration_type: '登録博物館', museum_type: '総合', official_website: 'http://www.town.mukawa.lg.jp/1908.htm', is_featured: false },
  { name: '北海道博物館', prefecture: '北海道', city: '札幌市', registration_type: '登録博物館', museum_type: '総合', official_website: 'http://www.hm.pref.hokkaido.lg.jp/', is_featured: true }
]

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