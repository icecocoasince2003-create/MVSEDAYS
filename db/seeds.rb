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
puts "=" * 60# frozen_string_literal: true

# =================================================
# MVSEDAYS museum data
# 総データ数: 1440件
# 都道府県数: 47件
# 生成日時: 2025-12-02 23:17:41
# =================================================

puts '================================================'
puts '博物館データの投入を開始します'
puts '================================================'

created_count = 0
updated_count = 0
error_count = 0

# ================================
# 北海道 (73件)
# ================================
puts '北海道のデータを投入中...'

[
  {
    name: '旭川市旭山動物園',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/asahiyamazoo/',
    is_featured: false
  },
  {
    name: '旭川市科学館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/science/',
    is_featured: false
  },
  {
    name: '旭川市博物館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/hakubutukan/index.html',
    is_featured: false
  },
  {
    name: '中原悌二郎記念旭川市彫刻美術館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/sculpture/',
    is_featured: false
  },
  {
    name: '北海道立旭川美術館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/abj',
    is_featured: false
  },
  {
    name: '三浦綾子記念文学館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.hyouten.com/',
    is_featured: false
  },
  {
    name: '厚岸町海事記念館',
    prefecture: '北海道',
    city: '厚岸町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://edu.town.akkeshi.hokkaido.jp/kaiji/',
    is_featured: false
  },
  {
    name: '網走市立郷土博物館',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.abashiri.hokkaido.jp/site/kyodo/',
    is_featured: false
  },
  {
    name: '網走市立美術館',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.abashiri.hokkaido.jp/site/artmuseum/',
    is_featured: false
  },
  {
    name: '博物館　網走監獄',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kangoku.jp/',
    is_featured: false
  },
  {
    name: '北海道立北方民族博物館',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hoppohm.org/index2.htm',
    is_featured: false
  },
  {
    name: '荒井記念美術館',
    prefecture: '北海道',
    city: '岩内町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.iwanai-h.com/art/',
    is_featured: false
  },
  {
    name: '浦河町立郷土博物館',
    prefecture: '北海道',
    city: '浦河町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.urakawa.hokkaido.jp/gyosei/culture/?category=100',
    is_featured: false
  },
  {
    name: '浦幌町立博物館',
    prefecture: '北海道',
    city: '浦幌町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://museum-urahoro.jp',
    is_featured: false
  },
  {
    name: 'オホーツクミュージアムえさし',
    prefecture: '北海道',
    city: '枝幸郡',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.esashi.jp/tourism/guide/museum.html',
    is_featured: false
  },
  {
    name: '小樽芸術村',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.nitorihd.co.jp/otaru-art-base/',
    is_featured: false
  },
  {
    name: '小樽市総合博物館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.otaru.lg.jp/categories/bunya/shisetsu/bunka_kanko/museum/',
    is_featured: false
  },
  {
    name: 'おたる水族館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://otaru-aq.jp/',
    is_featured: false
  },
  {
    name: '北一ヴェネツィア美術館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://venezia-museum.or.jp/',
    is_featured: false
  },
  {
    name: '市立小樽美術館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.otaru.lg.jp/categories/bunya/shisetsu/bunka_kanko/bijyutsukan/',
    is_featured: false
  },
  {
    name: '市立小樽文学館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://otarubungakusha.com/yakata',
    is_featured: false
  },
  {
    name: '帯広百年記念館',
    prefecture: '北海道',
    city: '帯広市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museum-obihiro.jp/occm/',
    is_featured: false
  },
  {
    name: '北海道立帯広美術館',
    prefecture: '北海道',
    city: '帯広市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/obj/',
    is_featured: false
  },
  {
    name: '標茶町博物館',
    prefecture: '北海道',
    city: '川上郡標茶町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.sip.or.jp/~shibecha-museum/',
    is_featured: false
  },
  {
    name: '北網圏北見文化センター',
    prefecture: '北海道',
    city: '北見市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://hokumouken.com/',
    is_featured: false
  },
  {
    name: '釧路市立博物館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kushiro.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '釧路市立美術館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://k-bijutsukan.net/',
    is_featured: false
  },
  {
    name: '北海道立釧路芸術館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kushiro-artmu.jp/',
    is_featured: false
  },
  {
    name: '札幌市青少年科学館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.ssc.slp.or.jp/',
    is_featured: false
  },
  {
    name: '札幌市円山動物園',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.city.sapporo.jp/zoo/',
    is_featured: false
  },
  {
    name: '北海道立近代美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/knb/',
    is_featured: false
  },
  {
    name: '北海道立文学館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.h-bungaku.or.jp/',
    is_featured: false
  },
  {
    name: '北海道立三岸好太郎美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/mkb/',
    is_featured: false
  },
  {
    name: '士別市立博物館・士別市公会堂展示室',
    prefecture: '北海道',
    city: '士別市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.shibetsu.lg.jp/gyoseisaito/kosodate_bunka_supotsu/shibetsushiritsuhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '斜里町立知床博物館',
    prefecture: '北海道',
    city: '斜里町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://shiretoko-museum.jpn.org/',
    is_featured: false
  },
  {
    name: '新ひだか町博物館',
    prefecture: '北海道',
    city: '新ひだか町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.shinhidaka-hokkaido.jp/hotnews/category/180.html',
    is_featured: false
  },
  {
    name: 'だて歴史文化ミュージアム',
    prefecture: '北海道',
    city: '伊達市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://date-museum.jp/',
    is_featured: false
  },
  {
    name: '苫小牧市科学センター',
    prefecture: '北海道',
    city: '苫小牧市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.tomakomai.hokkaido.jp/kagaku/',
    is_featured: false
  },
  {
    name: '苫小牧市美術博物館',
    prefecture: '北海道',
    city: '苫小牧市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.tomakomai.hokkaido.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '名寄市北国博物館',
    prefecture: '北海道',
    city: '名寄市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.nayoro.lg.jp/section/museum/prkeql000000krpr.html',
    is_featured: false
  },
  {
    name: '市立函館博物館',
    prefecture: '北海道',
    city: '函館市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://hakohaku.com/',
    is_featured: false
  },
  {
    name: '函館市縄文文化交流センター',
    prefecture: '北海道',
    city: '函館市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.hjcc.jp/',
    is_featured: false
  },
  {
    name: '北海道立函館美術館',
    prefecture: '北海道',
    city: '函館市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/hbj',
    is_featured: false
  },
  {
    name: '日高山脈博物館',
    prefecture: '北海道',
    city: '日高町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.town.hidaka.hokkaido.jp/site/hmc/',
    is_featured: false
  },
  {
    name: '安田侃彫刻美術館アルテピアッツァ美唄',
    prefecture: '北海道',
    city: '美唄市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artepiazza.jp/',
    is_featured: false
  },
  {
    name: '美幌博物館',
    prefecture: '北海道',
    city: '美幌町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.bihoro.hokkaido.jp/site/museum/',
    is_featured: false
  },
  {
    name: '平取町立二風谷アイヌ文化博物館',
    prefecture: '北海道',
    city: '平取町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nibutani-ainu-museum.com/',
    is_featured: false
  },
  {
    name: '広尾町海洋博物館　広尾町郷土文化保存伝習館',
    prefecture: '北海道',
    city: '広尾町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.hiroo.lg.jp/kankou/leisurespot/rekishi/',
    is_featured: false
  },
  {
    name: '三笠市立博物館',
    prefecture: '北海道',
    city: '三笠市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.mikasa.hokkaido.jp/museum/',
    is_featured: false
  },
  {
    name: '穂別博物館',
    prefecture: '北海道',
    city: 'むかわ町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.town.mukawa.lg.jp/1908.htm',
    is_featured: false
  },
  {
    name: '紋別市立博物館',
    prefecture: '北海道',
    city: '紋別市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://mombetsu.jp/sisetu/bunkasisetu/hakubutukan/',
    is_featured: false
  },
  {
    name: '利尻町立博物館',
    prefecture: '北海道',
    city: '利尻町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://rishiri-town.jp/%e6%95%99%e8%82%b2/%e5%88%a9%e5%b0%bb%e7%94%ba%e5%8d%9a%e7%89%a9%e9%a4%a8/',
    is_featured: false
  },
  {
    name: '旭川兵村記念館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://asahikawaheison.sakura.ne.jp/',
    is_featured: false
  },
  {
    name: 'ロイズミュージアム',
    prefecture: '北海道',
    city: '石狩郡当別町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.royce.com/cct/',
    is_featured: false
  },
  {
    name: '帯広市動物園',
    prefecture: '北海道',
    city: '帯広市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.obihiro.hokkaido.jp/zoo/',
    is_featured: false
  },
  {
    name: '神田日勝記念美術館',
    prefecture: '北海道',
    city: '河東郡鹿追町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://kandanissho.com/',
    is_featured: false
  },
  {
    name: '福原記念美術館',
    prefecture: '北海道',
    city: '河東郡鹿追町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://art-fukuhara.jp/',
    is_featured: false
  },
  {
    name: '東京大学大学院人文社会系研究科附属北海文化研究常呂実習施設',
    prefecture: '北海道',
    city: '北見市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.l.u-tokyo.ac.jp/tokoro/',
    is_featured: false
  },
  {
    name: '釧路市こども遊学館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://kodomoyugakukan.jp/',
    is_featured: false
  },
  {
    name: '札幌芸術の森美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://artpark.or.jp/shisetsu/sapporo-art-museum/',
    is_featured: false
  },
  {
    name: '北海道開拓の村',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '野外博物館',
    official_website: 'https://www.kaitaku.or.jp/',
    is_featured: false
  },
  {
    name: '北海道大学北方生物圏フィールド科学センター植物園',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.fsc.hokudai.ac.jp/',
    is_featured: false
  },
  {
    name: '本郷新記念札幌彫刻美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.hongoshin-smos.jp/',
    is_featured: false
  },
  {
    name: '国立アイヌ民族博物館',
    prefecture: '北海道',
    city: '白老町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://ainu-upopoy.jp/',
    is_featured: false
  },
  {
    name: '仙台藩白老元陣屋資料館',
    prefecture: '北海道',
    city: '白老町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.shiraoi.hokkaido.jp/docs/2020062800019/',
    is_featured: false
  },
  {
    name: 'サケのふるさと千歳水族館',
    prefecture: '北海道',
    city: '千歳市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://chitose-aq.jp/',
    is_featured: false
  },
  {
    name: 'ウトナイ湖サンクチュアリ「ネイチャーセンター」',
    prefecture: '北海道',
    city: '苫小牧市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://utonai-nc.sakura.ne.jp/index.html',
    is_featured: false
  },
  {
    name: '根室市歴史と自然の資料館',
    prefecture: '北海道',
    city: '根室市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.nemuro.hokkaido.jp/lifeinfo/kakuka/kyoikuiinkai/kyoikushiryokan/index.html',
    is_featured: false
  },
  {
    name: 'のぼりべつクマ牧場ヒグマ博物館',
    prefecture: '北海道',
    city: '登別市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://bearpark.jp/museum_observatory/',
    is_featured: false
  },
  {
    name: '登別マリンパークニクス',
    prefecture: '北海道',
    city: '登別市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.nixe.co.jp/',
    is_featured: false
  },
  {
    name: 'えりも町郷土資料館・水産の館',
    prefecture: '北海道',
    city: '幌泉郡えりも町',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.town.erimo.lg.jp/horoizumi/index.html',
    is_featured: false
  },
  {
    name: '室蘭市民俗資料館',
    prefecture: '北海道',
    city: '室蘭市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.muroran.lg.jp/culture/?content=1516',
    is_featured: false
  },
  {
    name: '夕張市石炭博物館',
    prefecture: '北海道',
    city: '夕張市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://coal-yubari.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 青森県 (7件)
# ================================
puts '青森県のデータを投入中...'

[
  {
    name: '青森県立郷土館',
    prefecture: '青森県',
    city: '青森市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.kyodokan.com/',
    is_featured: false
  },
  {
    name: '八戸市博物館',
    prefecture: '青森県',
    city: '八戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hachinohe-city-museum.jp/',
    is_featured: false
  },
  {
    name: '八戸市美術館',
    prefecture: '青森県',
    city: '八戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hachinohe-art-museum.jp/',
    is_featured: false
  },
  {
    name: '高岡の森弘前藩歴史館',
    prefecture: '青森県',
    city: '弘前市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.hirosaki.aomori.jp/takaoka-rekishikan/',
    is_featured: false
  },
  {
    name: '弘前市立博物館',
    prefecture: '青森県',
    city: '弘前市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.hirosaki.aomori.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '青森県立美術館',
    prefecture: '青森県',
    city: '青森市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.aomori-museum.jp/',
    is_featured: false
  },
  {
    name: '弘前れんが倉庫美術館',
    prefecture: '青森県',
    city: '弘前市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.hirosaki-moca.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 岩手県 (23件)
# ================================
puts '岩手県のデータを投入中...'

[
  {
    name: '一関市博物館',
    prefecture: '岩手県',
    city: '一関市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ichinoseki.iwate.jp/museum/',
    is_featured: false
  },
  {
    name: '石神の丘美術館',
    prefecture: '岩手県',
    city: '岩手郡岩手町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ishigami-iwate.jp/',
    is_featured: false
  },
  {
    name: '牛の博物館',
    prefecture: '岩手県',
    city: '奥州市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.oshu.iwate.jp/section/ushi/index.html',
    is_featured: false
  },
  {
    name: '大船渡市立博物館',
    prefecture: '岩手県',
    city: '大船渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ofunato.iwate.jp/archive/p20250115182916',
    is_featured: false
  },
  {
    name: '北上市立鬼の館',
    prefecture: '岩手県',
    city: '北上市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kitakami.iwate.jp/life/soshikikarasagasu/oninoyakata/index.html',
    is_featured: false
  },
  {
    name: '北上市立博物館',
    prefecture: '岩手県',
    city: '北上市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kitakami.iwate.jp/life/soshikikarasagasu/hakubutsu/1_1/index.html',
    is_featured: false
  },
  {
    name: '遠野市立博物館',
    prefecture: '岩手県',
    city: '遠野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tono.iwate.jp/index.cfm/48,25002,166,html',
    is_featured: false
  },
  {
    name: '碧祥寺博物館',
    prefecture: '岩手県',
    city: '西和賀町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://yamanoideyu.com/spot/article.php?p=74',
    is_featured: false
  },
  {
    name: '御所野縄文博物館',
    prefecture: '岩手県',
    city: '二戸郡一戸町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://goshono-iseki.com/',
    is_featured: false
  },
  {
    name: '花巻市博物館',
    prefecture: '岩手県',
    city: '花巻市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hanamaki.iwate.jp/bunkasports/bunka/1019887/1008981/index.html',
    is_featured: false
  },
  {
    name: '萬鉄五郎記念美術館',
    prefecture: '岩手県',
    city: '花巻市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hanamaki.iwate.jp/bunkasports/bunka/1019887/yorozutetsugoro/1002101.html',
    is_featured: false
  },
  {
    name: '宮古市北上山地民俗資料館',
    prefecture: '岩手県',
    city: '宮古市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://kitakamisanchi.city.miyako.iwate.jp/',
    is_featured: false
  },
  {
    name: '宮古市崎山貝塚縄文の森ミュージアム',
    prefecture: '岩手県',
    city: '宮古市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.miyako.iwate.jp/gyosei/kanko_bunka_sports/rekishi_bunkazai/8498.html',
    is_featured: false
  },
  {
    name: '岩手県立博物館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www2.pref.iwate.jp/~hp0910/',
    is_featured: false
  },
  {
    name: '岩手県立美術館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ima.or.jp/',
    is_featured: false
  },
  {
    name: '深沢紅子野の花美術館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nonohana.hs.plala.or.jp/',
    is_featured: false
  },
  {
    name: '盛岡市遺跡の学び館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.morioka.iwate.jp/kankou/kankou/1037106/rekishi/1009437/1009438.html',
    is_featured: false
  },
  {
    name: '盛岡市子ども科学館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://kodomokagakukan.com/',
    is_featured: false
  },
  {
    name: '盛岡市先人記念館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mfca.jp/senjin/',
    is_featured: false
  },
  {
    name: '陸前高田市立博物館',
    prefecture: '岩手県',
    city: '陸前高市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.rikuzentakata.iwate.jp/soshiki/kyouikusoumuka/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '久慈琥珀博物館',
    prefecture: '岩手県',
    city: '久慈市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.kuji.co.jp/museum',
    is_featured: false
  },
  {
    name: '岩手県立平泉世界遺産ガイダンスセンター',
    prefecture: '岩手県',
    city: '西磐井郡平泉町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.sekaiisan.pref.iwate.jp/information',
    is_featured: false
  },
  {
    name: '宮沢賢治記念館',
    prefecture: '岩手県',
    city: '花巻市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.hanamaki.iwate.jp/miyazawakenji/kinenkan/index.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 宮城県 (17件)
# ================================
puts '宮城県のデータを投入中...'

[
  {
    name: 'リアス・アーク美術館',
    prefecture: '宮城県',
    city: '気仙沼市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://rias-ark.sakura.ne.jp/2/',
    is_featured: false
  },
  {
    name: '塩竃市杉村惇美術館',
    prefecture: '宮城県',
    city: '塩竈市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sugimurajun.shiomo.jp/',
    is_featured: false
  },
  {
    name: '鹽竈神社博物館',
    prefecture: '宮城県',
    city: '塩竈市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.shiogamajinja.jp/museum/',
    is_featured: false
  },
  {
    name: 'カメイ美術館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kameimuseum.or.jp/',
    is_featured: false
  },
  {
    name: 'HOKUSHU仙台市科学館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.kagakukan.sendai-c.ed.jp/',
    is_featured: false
  },
  {
    name: '仙台市天文台',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.sendai-astro.jp/',
    is_featured: false
  },
  {
    name: '仙台市博物館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sendai.jp/museum/',
    is_featured: false
  },
  {
    name: '宮城県美術館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.pref.miyagi.jp/site/mmoa/',
    is_featured: false
  },
  {
    name: '歴史博物館青葉城資料展示館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://honmarukaikan.com/s/docs/tenji/',
    is_featured: false
  },
  {
    name: '東北歴史博物館',
    prefecture: '宮城県',
    city: '多賀城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.thm.pref.miyagi.jp/',
    is_featured: false
  },
  {
    name: '瑞巌寺宝物館',
    prefecture: '宮城県',
    city: '宮城郡松島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://zuiganji.or.jp/museum/',
    is_featured: false
  },
  {
    name: '宮城県慶長使節船ミュージアム（サン・ファン館）',
    prefecture: '宮城県',
    city: '石巻市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.santjuan.or.jp/',
    is_featured: false
  },
  {
    name: '大崎市松山ふるさと歴史館',
    prefecture: '宮城県',
    city: '大崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.osaki.miyagi.jp/shisei/soshikikarasagasu/kyoikuiinkaijimukyoku/matsuyamakominkan/1/1/2682.html',
    is_featured: false
  },
  {
    name: '仙台市八木山動物公園',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.sendai.jp/zoo/',
    is_featured: false
  },
  {
    name: '東北学院大学博物館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tohoku-gakuin.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '東北福祉大学芹沢銈介美術工芸館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tfu.ac.jp/kogeikan/',
    is_featured: false
  },
  {
    name: '奥松島縄文村歴史資料館',
    prefecture: '宮城県',
    city: '東松島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.satohama-jomon.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 秋田県 (14件)
# ================================
puts '秋田県のデータを投入中...'

[
  {
    name: '秋田県立博物館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://akihaku.jp/',
    is_featured: false
  },
  {
    name: '秋田県立美術館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.akita-museum-of-art.jp/index.htm',
    is_featured: false
  },
  {
    name: '秋田市立佐竹史料館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.akita.lg.jp/kanko/kanrenshisetsu/1002685/index.html',
    is_featured: false
  },
  {
    name: '秋田市立千秋美術館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.akita.lg.jp/kanko/kanrenshisetsu/1003643/index.html',
    is_featured: false
  },
  {
    name: '小坂町立総合博物館郷土館',
    prefecture: '秋田県',
    city: '鹿角郡小坂町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.kosaka.akita.jp/machinososhiki/sonotashisetsu/sogouhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '浜辺の歌音楽館',
    prefecture: '秋田県',
    city: '北秋田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kitaakita.akita.jp/archive/p20250430150709',
    is_featured: false
  },
  {
    name: '大潟村干拓博物館',
    prefecture: '秋田県',
    city: '南秋田郡大潟村',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museum.vill.ogata.akita.jp/',
    is_featured: false
  },
  {
    name: '秋田県立近代美術館',
    prefecture: '秋田県',
    city: '横手市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://akita-kinbi.jp/',
    is_featured: false
  },
  {
    name: '秋田県児童会館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://akita-jidoukaikan.com/',
    is_featured: false
  },
  {
    name: '秋田大学国際資源学部附属鉱業博物館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.mus.akita-u.ac.jp/',
    is_featured: false
  },
  {
    name: '秋田県立農業科学館',
    prefecture: '秋田県',
    city: '大仙市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.obako.or.jp/sun-agrin/',
    is_featured: false
  },
  {
    name: '白瀬南極探検隊記念館',
    prefecture: '秋田県',
    city: 'にかほ市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://shirase-kinenkan.jp/index.html',
    is_featured: false
  },
  {
    name: '雄物川郷土資料館',
    prefecture: '秋田県',
    city: '横手市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.yokote.lg.jp/shisetsu/1001528/1005103.html',
    is_featured: false
  },
  {
    name: '横手市増田まんが美術館',
    prefecture: '秋田県',
    city: '横手市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://manga-museum.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 山形県 (18件)
# ================================
puts '山形県のデータを投入中...'

[
  {
    name: '斎藤茂吉記念館',
    prefecture: '山形県',
    city: '上山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mokichi.or.jp/',
    is_featured: false
  },
  {
    name: '本間美術館',
    prefecture: '山形県',
    city: '酒田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.homma-museum.or.jp/',
    is_featured: false
  },
  {
    name: '金峯山博物館',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.gakushubunka.jp/yugakukan/public/facilities0307-2/',
    is_featured: false
  },
  {
    name: '致道博物館',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.chido.jp/',
    is_featured: false
  },
  {
    name: '鶴岡アートフォーラム',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.t-artforum.net/',
    is_featured: false
  },
  {
    name: '出羽三山歴史博物館',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.dewasanzan.jp/publics/index/14/',
    is_featured: false
  },
  {
    name: '出羽桜美術館',
    prefecture: '山形県',
    city: '天童市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.dewazakura.co.jp/museum/',
    is_featured: false
  },
  {
    name: '掬粋巧芸館',
    prefecture: '山形県',
    city: '東置賜郡川西町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.taruhei.co.jp/MuseumFolder/',
    is_featured: false
  },
  {
    name: '山形県立博物館、山形県立博物館教育資料館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.yamagata-museum.jp/',
    is_featured: false
  },
  {
    name: '山形美術館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yamagata-art-museum.or.jp/',
    is_featured: false
  },
  {
    name: '上杉神社稽照殿',
    prefecture: '山形県',
    city: '米沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.uesugi-jinja.or.jp/keishoden/',
    is_featured: false
  },
  {
    name: '公益財団法人宮坂考古館',
    prefecture: '山形県',
    city: '米沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.miyasakakoukokan.com/',
    is_featured: false
  },
  {
    name: '米沢市上杉博物館',
    prefecture: '山形県',
    city: '米沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.denkoku-no-mori.yonezawa.yamagata.jp/uesugi.htm',
    is_featured: false
  },
  {
    name: '天童市美術館',
    prefecture: '山形県',
    city: '天童市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://tendocity-museum.jp/',
    is_featured: false
  },
  {
    name: '最上義光歴史館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://mogamiyoshiaki.jp/',
    is_featured: false
  },
  {
    name: '山形市野草園',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.yasouen.jp/',
    is_featured: false
  },
  {
    name: '山形大学附属博物館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'http://museum.yamagata-u.ac.jp/',
    is_featured: false
  },
  {
    name: '山寺芭蕉記念館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://samidare.jp/basho/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 福島県 (21件)
# ================================
puts '福島県のデータを投入中...'

[
  {
    name: '福島県立博物館',
    prefecture: '福島県',
    city: '会津若松市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://general-museum.fcs.ed.jp/',
    is_featured: false
  },
  {
    name: 'いわき市立美術館',
    prefecture: '福島県',
    city: 'いわき市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.city.iwaki.lg.jp/www/genre/1444022369394/index.html',
    is_featured: false
  },
  {
    name: 'ふくしま海洋科学館',
    prefecture: '福島県',
    city: 'いわき市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.aquamarine.or.jp/',
    is_featured: false
  },
  {
    name: '郡山開成学園生活文化博物館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.koriyama-kgc.ac.jp/campus/lcm',
    is_featured: false
  },
  {
    name: '郡山市立美術館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.koriyama.lg.jp/site/artmuseum/',
    is_featured: false
  },
  {
    name: '郡山市歴史情報博物館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.koriyama.lg.jp/site/historymuseum/',
    is_featured: false
  },
  {
    name: '藤田記念博物館',
    prefecture: '福島県',
    city: '白河市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fujitakinenhakubutsukan.amebaownd.com/',
    is_featured: false
  },
  {
    name: '須賀川市立博物館',
    prefecture: '福島県',
    city: '須賀川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sukagawa.fukushima.jp/bunka_sports/bunka_geijyutsu/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '福島県立美術館',
    prefecture: '福島県',
    city: '福島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://art-museum.fcs.ed.jp/',
    is_featured: false
  },
  {
    name: '奥会津博物館',
    prefecture: '福島県',
    city: '南会津郡南会津町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.minamiaizu.lg.jp/official/bunka_sports_kanko/bunka/okuaizuhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '南相馬市博物館',
    prefecture: '福島県',
    city: '南相馬市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.minamisoma.lg.jp/portal/culture/museum/index.html',
    is_featured: false
  },
  {
    name: '会津民俗館',
    prefecture: '福島県',
    city: '耶麻郡猪苗代町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.aiaiaizu.com/aizuminzokukan/',
    is_featured: false
  },
  {
    name: '野口英世記念館',
    prefecture: '福島県',
    city: '耶麻郡猪苗代町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.noguchihideyo.or.jp/',
    is_featured: false
  },
  {
    name: '諸橋近代美術館',
    prefecture: '福島県',
    city: '耶麻郡北塩原村',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://dali.jp/',
    is_featured: false
  },
  {
    name: '會津藩校日新館',
    prefecture: '福島県',
    city: '会津若松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://nisshinkan.jp/',
    is_featured: false
  },
  {
    name: '会津武家屋敷会津歴史資料館',
    prefecture: '福島県',
    city: '会津若松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://bukeyashiki.com/',
    is_featured: false
  },
  {
    name: 'やないづ町立斎藤清美術館',
    prefecture: '福島県',
    city: '河沼郡柳津町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.town.yanaizu.fukushima.jp/bijutsu/',
    is_featured: false
  },
  {
    name: '喜多方市美術館',
    prefecture: '福島県',
    city: '喜多方市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.kcmofa.com/',
    is_featured: false
  },
  {
    name: '安積歴史博物館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://anrekihaku.or.jp/',
    is_featured: false
  },
  {
    name: 'はじまりの美術館',
    prefecture: '福島県',
    city: '耶麻郡猪苗代町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://hajimari-ac.com/',
    is_featured: false
  },
  {
    name: '磐梯山噴火記念館',
    prefecture: '福島県',
    city: '耶麻郡北塩原村',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.bandaimuse.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 茨城県 (24件)
# ================================
puts '茨城県のデータを投入中...'

[
  {
    name: '茨城県陶芸美術館',
    prefecture: '茨城県',
    city: '笠間市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tougei.museum.ibk.ed.jp/index.html',
    is_featured: false
  },
  {
    name: '笠間日動美術館',
    prefecture: '茨城県',
    city: '笠間市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nichido-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'かすみがうら市歴史博物館',
    prefecture: '茨城県',
    city: 'かすみがうら市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kasumigaura.lg.jp/page/dir003355.html',
    is_featured: false
  },
  {
    name: '古河歴史博物館',
    prefecture: '茨城県',
    city: '古河市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kogakanko.jp/spot/tour/rekihaku',
    is_featured: false
  },
  {
    name: 'しもだて美術館',
    prefecture: '茨城県',
    city: '筑西市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.chikusei.lg.jp/page/dir004549.html',
    is_featured: false
  },
  {
    name: 'つくばエキスポセンター',
    prefecture: '茨城県',
    city: 'つくば市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.expocenter.or.jp/',
    is_featured: false
  },
  {
    name: '上高津貝塚ふるさと歴史の広場',
    prefecture: '茨城県',
    city: '土浦市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tsuchiura.lg.jp/kamitakatsukaizuka/index.html',
    is_featured: false
  },
  {
    name: '土浦市立博物館',
    prefecture: '茨城県',
    city: '土浦市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tsuchiura.lg.jp/tsuchiurashiritsuhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '原子力科学館',
    prefecture: '茨城県',
    city: '那珂郡東海村',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://ibagen.or.jp/',
    is_featured: false
  },
  {
    name: 'ミュージアムパーク茨城県自然博物館',
    prefecture: '茨城県',
    city: '坂東市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.nat.museum.ibk.ed.jp/',
    is_featured: false
  },
  {
    name: '大洗町幕末と明治の博物館',
    prefecture: '茨城県',
    city: '東茨城郡大洗町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bakumatsu-meiji.com/',
    is_featured: false
  },
  {
    name: '常陸太田市郷土資料館',
    prefecture: '茨城県',
    city: '常陸太田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hitachiota.ibaraki.jp/page/dir004387.html',
    is_featured: false
  },
  {
    name: '日立市郷土博物館',
    prefecture: '茨城県',
    city: '日立市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hitachi.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '茨城県近代美術館・つくば分館・天心記念五浦分館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.modernart.museum.ibk.ed.jp/',
    is_featured: false
  },
  {
    name: '茨城県立歴史館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://rekishikan-ibk.jp/',
    is_featured: false
  },
  {
    name: '徳川ミュージアム',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.tokugawa.gr.jp/',
    is_featured: false
  },
  {
    name: '水戸市立博物館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://shihaku1.hs.plala.or.jp/',
    is_featured: false
  },
  {
    name: 'ツムラ漢方記念館',
    prefecture: '茨城県',
    city: '稲敷郡阿見町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tsumura.co.jp/hellotsumura/',
    is_featured: false
  },
  {
    name: '茨城県霞ケ浦環境科学センター',
    prefecture: '茨城県',
    city: '土浦市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.pref.ibaraki.jp/soshiki/seikatsukankyo/kasumigauraesc/',
    is_featured: false
  },
  {
    name: 'アクアワールド茨城県大洗水族館',
    prefecture: '茨城県',
    city: '東茨城郡大洗町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.aquaworld-oarai.com/',
    is_featured: false
  },
  {
    name: '大洗海洋博物館',
    prefecture: '茨城県',
    city: '東茨城郡大洗町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.oarai-isosakijinja.net/hakubutukan/',
    is_featured: false
  },
  {
    name: '日立市かみね動物園',
    prefecture: '茨城県',
    city: '日立市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.hitachi.lg.jp/zoo/',
    is_featured: false
  },
  {
    name: '常磐神社・義烈館（水戸黄門宝物館）',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://komonsan.jp/giretsukan/',
    is_featured: false
  },
  {
    name: '水戸芸術館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.arttowermito.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 栃木県 (26件)
# ================================
puts '栃木県のデータを投入中...'

[
  {
    name: '足利市立美術館',
    prefecture: '栃木県',
    city: '足利市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.watv.ne.jp/ashi-bi/',
    is_featured: false
  },
  {
    name: '大久保分校スタートアップミュージアム',
    prefecture: '栃木県',
    city: '足利市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://okubomuseum.com',
    is_featured: false
  },
  {
    name: '栗田美術館',
    prefecture: '栃木県',
    city: '足利市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kurita.or.jp/',
    is_featured: false
  },
  {
    name: '宇都宮動物園',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://utsunomiya-zoo.com/',
    is_featured: false
  },
  {
    name: '宇都宮美術館',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://u-moa.jp/',
    is_featured: false
  },
  {
    name: '栃木県立博物館',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.muse.pref.tochigi.lg.jp/',
    is_featured: false
  },
  {
    name: '栃木県立美術館',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.art.pref.tochigi.lg.jp/',
    is_featured: false
  },
  {
    name: '小山市立博物館',
    prefecture: '栃木県',
    city: '小山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.oyama.tochigi.jp/site/hakubutu/',
    is_featured: false
  },
  {
    name: 'さくら市ミュージアム-荒井寛方記念館-',
    prefecture: '栃木県',
    city: 'さくら市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tochigi-sakura.lg.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '佐野市郷土博物館',
    prefecture: '栃木県',
    city: '佐野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sano-haku.com/',
    is_featured: false
  },
  {
    name: '佐野市立吉澤記念美術館',
    prefecture: '栃木県',
    city: '佐野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.sano.lg.jp/sp/yoshizawakinembijutsukan/index.html',
    is_featured: false
  },
  {
    name: '和気記念館',
    prefecture: '栃木県',
    city: '塩谷郡塩谷町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://boubou.jp/',
    is_featured: false
  },
  {
    name: '塚田歴史伝説館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.tochigi-kankou.or.jp/spot/tsukadarekishikan',
    is_featured: false
  },
  {
    name: '栃木市立美術館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.tochigi.lg.jp/site/museum-tcam/',
    is_featured: false
  },
  {
    name: '栃木市立文学館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tochigi.lg.jp/site/museum-tclm/',
    is_featured: false
  },
  {
    name: '那珂川町馬頭広重美術館',
    prefecture: '栃木県',
    city: '那須郡那珂川町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hiroshige.bato.tochigi.jp/',
    is_featured: false
  },
  {
    name: '藤城清治美術館那須高原',
    prefecture: '栃木県',
    city: '那須郡那須町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://fujishiro-seiji-museum.jp/',
    is_featured: false
  },
  {
    name: '那須塩原市那須野が原博物館',
    prefecture: '栃木県',
    city: '那須塩原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://nasunogahara-museum.jp/',
    is_featured: false
  },
  {
    name: '小杉放菴記念日光美術館',
    prefecture: '栃木県',
    city: '日光市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.khmoan.jp/',
    is_featured: false
  },
  {
    name: '日光二荒山神社宝物館',
    prefecture: '栃木県',
    city: '日光市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.futarasan.jp/',
    is_featured: false
  },
  {
    name: '益子陶芸美術館',
    prefecture: '栃木県',
    city: '芳賀郡益子町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.mashiko-museum.jp/',
    is_featured: false
  },
  {
    name: '濱田庄司記念益子参考館',
    prefecture: '栃木県',
    city: '芳賀郡益子町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mashiko-sankokan.net/',
    is_featured: false
  },
  {
    name: '山縣有朋記念館',
    prefecture: '栃木県',
    city: '矢板市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.general-yamagata-foundation.or.jp/',
    is_featured: false
  },
  {
    name: '栃木県なかがわ水遊園',
    prefecture: '栃木県',
    city: '大田原市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://tnap.jp/',
    is_featured: false
  },
  {
    name: '国學院大學栃木学園参考館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kokugakuintochigi.ac.jp/sankokan/',
    is_featured: false
  },
  {
    name: '那須ワールドモンキーパーク',
    prefecture: '栃木県',
    city: '那須郡那須町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.nasumonkey.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 群馬県 (26件)
# ================================
puts '群馬県のデータを投入中...'

[
  {
    name: '中之条町歴史と民俗の博物館「ミュゼ」',
    prefecture: '群馬県',
    city: '吾妻郡中之条町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.nakanojo.gunma.jp/site/myuze/',
    is_featured: false
  },
  {
    name: '安中市学習の森ふるさと学習館',
    prefecture: '群馬県',
    city: '安中市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.annaka.lg.jp/site/gakushunomori/',
    is_featured: false
  },
  {
    name: '相川考古館',
    prefecture: '群馬県',
    city: '伊勢崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://aam.or.jp/',
    is_featured: false
  },
  {
    name: '太田市美術館・図書館',
    prefecture: '群馬県',
    city: '太田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.artmuseumlibraryota.jp/',
    is_featured: false
  },
  {
    name: '下仁田町自然史館',
    prefecture: '群馬県',
    city: '甘楽郡下仁田町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.shimonita-geopark.jp/shizenshikan/index.html',
    is_featured: false
  },
  {
    name: '大川美術館',
    prefecture: '群馬県',
    city: '桐生市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://okawamuseum.jp/',
    is_featured: false
  },
  {
    name: '竹久夢二伊香保記念館',
    prefecture: '群馬県',
    city: '渋川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://yumeji.or.jp/',
    is_featured: false
  },
  {
    name: '原美術館 ARC',
    prefecture: '群馬県',
    city: '渋川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.haramuseum.or.jp/jp/arc/',
    is_featured: false
  },
  {
    name: 'かみつけの里博物館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takasaki.gunma.jp/site/cultural-assets/1407.html',
    is_featured: false
  },
  {
    name: '群馬県立近代美術館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mmag.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '群馬県立土屋文明記念文学館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://bungaku.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '群馬県立歴史博物館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://grekisi.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '群馬県立館林美術館',
    prefecture: '群馬県',
    city: '館林市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.gmat.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '天一美術館',
    prefecture: '群馬県',
    city: '利根郡みなかみ町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://tenichi-museum.com/',
    is_featured: false
  },
  {
    name: '群馬県立自然史博物館',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.gmnh.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '富岡市立美術博物館・福沢一郎記念美術館',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.tomioka.lg.jp/www/genre/1387242529968/index.html',
    is_featured: false
  },
  {
    name: '岩宿博物館',
    prefecture: '群馬県',
    city: 'みどり市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.midori.gunma.jp/iwajuku/',
    is_featured: false
  },
  {
    name: '富弘美術館',
    prefecture: '群馬県',
    city: 'みどり市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.midori.gunma.jp/tomihiro/',
    is_featured: false
  },
  {
    name: 'みどり市大間々博物館（コノドント館）',
    prefecture: '群馬県',
    city: 'みどり市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.midori.gunma.jp/conodont/',
    is_featured: false
  },
  {
    name: '高崎市タワー美術館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.takasaki.gunma.jp/site/tower/',
    is_featured: false
  },
  {
    name: '高崎市美術館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.takasaki.gunma.jp/site/art-museum/',
    is_featured: false
  },
  {
    name: '館林市立資料館',
    prefecture: '群馬県',
    city: '館林市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.tatebayashi.gunma.jp/sp004/',
    is_featured: false
  },
  {
    name: '群馬サファリパーク',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.safari.co.jp/',
    is_featured: false
  },
  {
    name: '富岡市立岡部温故館',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.tomioka.lg.jp/www/genre/1387242518888/index.html',
    is_featured: false
  },
  {
    name: 'アーツ前橋',
    prefecture: '群馬県',
    city: '前橋市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.artsmaebashi.jp/',
    is_featured: false
  },
  {
    name: '萩原朔太郎記念・水と緑と詩のまち前橋文学館',
    prefecture: '群馬県',
    city: '前橋市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.maebashibungakukan.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 埼玉県 (30件)
# ================================
puts '埼玉県のデータを投入中...'

[
  {
    name: '朝霞市博物館',
    prefecture: '埼玉県',
    city: '朝霞市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.asaka.lg.jp/soshiki/42/museum.html',
    is_featured: false
  },
  {
    name: '入間市博物館（ＡＬＩＴ）',
    prefecture: '埼玉県',
    city: '入間市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.alit.city.iruma.saitama.jp/',
    is_featured: false
  },
  {
    name: '埼玉県立川の博物館',
    prefecture: '埼玉県',
    city: '大里郡寄居町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.river-museum.jp/',
    is_featured: false
  },
  {
    name: '川越市立博物館',
    prefecture: '埼玉県',
    city: '川越市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kawagoe.saitama.jp/welcome/kankospot/hommarugotenzone/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '川越市立美術館',
    prefecture: '埼玉県',
    city: '川越市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kawagoe.saitama.jp/artmuseum/',
    is_featured: false
  },
  {
    name: '山崎美術館',
    prefecture: '埼玉県',
    city: '川越市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.koedo-kameya.com/sp.html',
    is_featured: false
  },
  {
    name: '行田市郷土博物館',
    prefecture: '埼玉県',
    city: '行田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.gyoda.lg.jp/soshiki/shougaigakusyubu/kyodohakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '埼玉県立さきたま史跡の博物館',
    prefecture: '埼玉県',
    city: '行田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sakitama-muse.spec.ed.jp/',
    is_featured: false
  },
  {
    name: '熊谷市立熊谷図書館美術・郷土資料展示室',
    prefecture: '埼玉県',
    city: '熊谷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kumagayacity.library.ne.jp/kyoudo/',
    is_featured: false
  },
  {
    name: '浦和くらしの博物館民家園',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.saitama.lg.jp/004/005/004/005/003/index.html',
    is_featured: false
  },
  {
    name: '埼玉県立近代美術館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://pref.spec.ed.jp/momas/',
    is_featured: false
  },
  {
    name: '埼玉県立歴史と民俗の博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saitama-rekimin.spec.ed.jp/',
    is_featured: false
  },
  {
    name: 'さいたま市立浦和博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.saitama.lg.jp/004/005/004/005/002/index.html',
    is_featured: false
  },
  {
    name: 'さいたま市立博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.saitama.lg.jp/004/005/004/005/008/index.html',
    is_featured: false
  },
  {
    name: '鉄道博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.railway-museum.jp/',
    is_featured: false
  },
  {
    name: '狭山市立博物館',
    prefecture: '埼玉県',
    city: '狭山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://sayama-city-museum.com',
    is_featured: false
  },
  {
    name: '白岡市立歴史資料館',
    prefecture: '埼玉県',
    city: '白岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.shiraoka.lg.jp/soshiki/kyouikubu/syougaigakusyuuka/36/bunnkazaihogo/1370.html',
    is_featured: false
  },
  {
    name: '埼玉県立自然の博物館',
    prefecture: '埼玉県',
    city: '秩父郡長瀞町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://shizen.spec.ed.jp/',
    is_featured: false
  },
  {
    name: '秩父宮記念三峯山博物館',
    prefecture: '埼玉県',
    city: '秩父市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mitsuminejinja.or.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: 'やまとーあーとみゅーじあむ',
    prefecture: '埼玉県',
    city: '秩父市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.chichibu.ne.jp/~yamato-a-t/',
    is_featured: false
  },
  {
    name: '戸田市立郷土博物館',
    prefecture: '埼玉県',
    city: '戸田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.toda.saitama.jp/soshiki/377/',
    is_featured: false
  },
  {
    name: '角川武蔵野ミュージアム',
    prefecture: '埼玉県',
    city: '所沢市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kadcul.com/',
    is_featured: false
  },
  {
    name: '飯能市立博物館',
    prefecture: '埼玉県',
    city: '飯能市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hanno.lg.jp/kanko_bunka_sports/museum/index.html',
    is_featured: false
  },
  {
    name: '遠山記念館',
    prefecture: '埼玉県',
    city: '比企郡川島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.e-kinenkan.com/',
    is_featured: false
  },
  {
    name: '埼玉県立嵐山史跡の博物館',
    prefecture: '埼玉県',
    city: '比企郡嵐山町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ranzan-shiseki.spec.ed.jp/',
    is_featured: false
  },
  {
    name: '公益財団法人 河鍋暁斎記念美術館',
    prefecture: '埼玉県',
    city: '蕨市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://kyosai-museum.jp/',
    is_featured: false
  },
  {
    name: '立正大学博物館',
    prefecture: '埼玉県',
    city: '熊谷市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.ris.ac.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '白岡市生涯学習センター歴史資料展示室（こもれびの森）',
    prefecture: '埼玉県',
    city: '白岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.shiraoka.lg.jp/soshiki/kyouikubu/syougaigakusyuuka/36/index.html#',
    is_featured: false
  },
  {
    name: '跡見学園女子大学花蹊記念資料館',
    prefecture: '埼玉県',
    city: '新座市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.atomi.ac.jp/univ/museum/',
    is_featured: false
  },
  {
    name: '日本工業大学工業技術博物館',
    prefecture: '埼玉県',
    city: '南埼玉郡宮代町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://museum.nit.ac.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 千葉県 (51件)
# ================================
puts '千葉県のデータを投入中...'

[
  {
    name: '大原幽学記念館',
    prefecture: '千葉県',
    city: '旭市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.asahi.chiba.jp/yugaku/',
    is_featured: false
  },
  {
    name: '我孫子市鳥の博物館',
    prefecture: '千葉県',
    city: '我孫子市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.abiko.chiba.jp/bird-mus/index.html',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館大多喜城分館',
    prefecture: '千葉県',
    city: '夷隅郡大多喜町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.chiba-muse.or.jp/NATURAL/sonan/',
    is_featured: false
  },
  {
    name: '市立市川考古博物館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ichikawa.lg.jp/edu14/',
    is_featured: false
  },
  {
    name: '市立市川自然博物館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.ichikawa.lg.jp/edu16/',
    is_featured: false
  },
  {
    name: '市立市川歴史博物館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ichikawa.lg.jp/edu14/',
    is_featured: false
  },
  {
    name: '千葉県立現代産業科学館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www2.chiba-muse.or.jp/SCIENCE/',
    is_featured: false
  },
  {
    name: '市原歴史博物館',
    prefecture: '千葉県',
    city: '市原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.imuseum.jp/index.html',
    is_featured: false
  },
  {
    name: '千葉県立房総のむら',
    prefecture: '千葉県',
    city: '印旛郡栄町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www2.chiba-muse.or.jp/MURA/',
    is_featured: false
  },
  {
    name: '浦安市郷土博物館',
    prefecture: '千葉県',
    city: '浦安市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://assarikunn.wixsite.com/website',
    is_featured: false
  },
  {
    name: '大網白里市デジタル博物館',
    prefecture: '千葉県',
    city: '大網白里市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://adeac.jp/oamishirasato-city/top/',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館分館海の博物館',
    prefecture: '千葉県',
    city: '勝浦市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www2.chiba-muse.or.jp/UMIHAKU/',
    is_featured: false
  },
  {
    name: '伊能忠敬記念館',
    prefecture: '千葉県',
    city: '香取市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.katori.lg.jp/sightseeing/museum/',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館大利根分館',
    prefecture: '千葉県',
    city: '香取市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.chiba-muse.or.jp/NATURAL/otone/',
    is_featured: false
  },
  {
    name: '木更津市郷土博物館金のすず',
    prefecture: '千葉県',
    city: '木更津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kisarazu.lg.jp/soshiki/kyoikuiinkai/kyodohakubutsukankinnosuzu/1/2742.html',
    is_featured: false
  },
  {
    name: '君津市立久留里城址資料館',
    prefecture: '千葉県',
    city: '君津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kimitsu.lg.jp/soshiki/54/',
    is_featured: false
  },
  {
    name: '佐倉市立美術館',
    prefecture: '千葉県',
    city: '佐倉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.sakura.lg.jp/section/museum/',
    is_featured: false
  },
  {
    name: '塚本美術館',
    prefecture: '千葉県',
    city: '佐倉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.sakura.lg.jp/soshiki/sakuranomiryoku/1/3036.html',
    is_featured: false
  },
  {
    name: '航空科学博物館',
    prefecture: '千葉県',
    city: '山武郡芝山町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.aeromuseum.or.jp/',
    is_featured: false
  },
  {
    name: '歴史の里芝山ミューゼアム',
    prefecture: '千葉県',
    city: '山武郡芝山町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '芝山町立芝山古墳・はにわ博物館',
    prefecture: '千葉県',
    city: '山武郡芝山町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.haniwakan.com/',
    is_featured: false
  },
  {
    name: '袖ケ浦市郷土博物館',
    prefecture: '千葉県',
    city: '袖ケ浦市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sodegaura.lg.jp/soshiki/hakubutsukan/',
    is_featured: false
  },
  {
    name: '館山市立博物館',
    prefecture: '千葉県',
    city: '館山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tateyama.chiba.jp/hakubutukan/page100065.html',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www2.chiba-muse.or.jp/NATURAL/',
    is_featured: false
  },
  {
    name: '千葉県立美術館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www2.chiba-muse.or.jp/ART/',
    is_featured: false
  },
  {
    name: '千葉市動物公園',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.city.chiba.jp/zoo/',
    is_featured: false
  },
  {
    name: '千葉市立加曽利貝塚博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chiba.jp/kasori/',
    is_featured: false
  },
  {
    name: '千葉市立郷土博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.chiba.jp/kyodo/',
    is_featured: false
  },
  {
    name: '流山市立博物館',
    prefecture: '千葉県',
    city: '流山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.nagareyama.chiba.jp/life/1001780/1001785/index.html',
    is_featured: false
  },
  {
    name: '成田山書道美術館',
    prefecture: '千葉県',
    city: '成田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.naritashodo.jp/',
    is_featured: false
  },
  {
    name: '成田山霊光館',
    prefecture: '千葉県',
    city: '成田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '上花輪歴史館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '千葉県立関宿城博物館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www2.chiba-muse.or.jp/SEKIYADO/',
    is_featured: false
  },
  {
    name: '野田市郷土博物館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://noda-muse.jp/',
    is_featured: false
  },
  {
    name: '茂木本家美術館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.momoa.jp/',
    is_featured: false
  },
  {
    name: '鋸山美術館',
    prefecture: '千葉県',
    city: '富津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nokogiriyama.com/',
    is_featured: false
  },
  {
    name: '船橋市郷土資料館',
    prefecture: '千葉県',
    city: '船橋市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.funabashi.lg.jp/shisetsu/bunka/0001/0005/0001/p011081.html',
    is_featured: false
  },
  {
    name: '船橋市飛ノ台史跡公園博物館',
    prefecture: '千葉県',
    city: '船橋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.funabashi.lg.jp/shisetsu/bunka/0001/0006/0001/p036786.html',
    is_featured: false
  },
  {
    name: '松戸市戸定歴史館',
    prefecture: '千葉県',
    city: '松戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.matsudo.chiba.jp/tojo/',
    is_featured: false
  },
  {
    name: '松戸市立博物館',
    prefecture: '千葉県',
    city: '松戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.matsudo.chiba.jp/m_muse/',
    is_featured: false
  },
  {
    name: '茂原市立美術館・郷土資料館',
    prefecture: '千葉県',
    city: '茂原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.mobara.chiba.jp/soshiki/13-10-0-0-0_1.html',
    is_featured: false
  },
  {
    name: '八千代市立郷土博物館',
    prefecture: '千葉県',
    city: '八千代市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.yachiyo.lg.jp/soshiki/81',
    is_featured: false
  },
  {
    name: '和洋女子大学文化資料館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.wayo.ac.jp/facilities_campus/museum',
    is_featured: false
  },
  {
    name: '鴨川シーワールド',
    prefecture: '千葉県',
    city: '鴨川市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.kamogawa-seaworld.jp/',
    is_featured: false
  },
  {
    name: '千葉大学海洋バイオシステム研究センター付属水族館',
    prefecture: '千葉県',
    city: '鴨川市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: '',
    is_featured: false
  },
  {
    name: 'DIC川村記念美術館',
    prefecture: '千葉県',
    city: '佐倉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kawamura-museum.dic.co.jp/',
    is_featured: false
  },
  {
    name: '千葉経済大学　地域経済博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.cku.ac.jp/local/museum/',
    is_featured: false
  },
  {
    name: '千葉市美術館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.ccma-net.jp/',
    is_featured: false
  },
  {
    name: '城西国際大学水田美術館',
    prefecture: '千葉県',
    city: '東金市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.jiu.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '宗吾霊宝殿',
    prefecture: '千葉県',
    city: '成田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.hokuso-4cities.com/spots/detail/215/',
    is_featured: false
  },
  {
    name: '日本大学理工学部科学技術史料センター',
    prefecture: '千葉県',
    city: '船橋市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.museum.cst.nihon-u.ac.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 東京都 (129件)
# ================================
puts '東京都のデータを投入中...'

[
  {
    name: '家具の博物館',
    prefecture: '東京都',
    city: '昭島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kaguhaku.or.jp/',
    is_featured: false
  },
  {
    name: '足立区立郷土博物館',
    prefecture: '東京都',
    city: '足立区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.adachi.tokyo.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '石洞美術館',
    prefecture: '東京都',
    city: '足立区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://sekido-museum.jp/',
    is_featured: false
  },
  {
    name: '日本書道美術館',
    prefecture: '東京都',
    city: '板橋区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://shodo-bijutsukan.or.jp/',
    is_featured: false
  },
  {
    name: '地下鉄博物館',
    prefecture: '東京都',
    city: '江戸川区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.chikahaku.jp/',
    is_featured: false
  },
  {
    name: '青梅市郷土博物館',
    prefecture: '東京都',
    city: '青梅市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ome.tokyo.jp/site/provincial-history-museum/',
    is_featured: false
  },
  {
    name: '青梅市立美術館　青梅市立小島善太郎美術館',
    prefecture: '東京都',
    city: '青梅市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.ome.tokyo.jp/site/art-museum/',
    is_featured: false
  },
  {
    name: '葛飾区郷土と天文の博物館',
    prefecture: '東京都',
    city: '葛飾区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.museum.city.katsushika.lg.jp/',
    is_featured: false
  },
  {
    name: '大谷美術館',
    prefecture: '東京都',
    city: '北区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.otanimuseum.or.jp/kyufurukawatei/',
    is_featured: false
  },
  {
    name: '紙の博物館',
    prefecture: '東京都',
    city: '北区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://papermuseum.jp/ja/',
    is_featured: false
  },
  {
    name: '渋沢史料館',
    prefecture: '東京都',
    city: '北区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shibusawa.or.jp/museum/',
    is_featured: false
  },
  {
    name: '清瀬市郷土博物館',
    prefecture: '東京都',
    city: '清瀬市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museum-kiyose.jp/',
    is_featured: false
  },
  {
    name: 'たましん歴史・美術館',
    prefecture: '東京都',
    city: '国立市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tamashinmuseum.org/',
    is_featured: false
  },
  {
    name: '船の科学館',
    prefecture: '東京都',
    city: '江東区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://funenokagakukan.or.jp/',
    is_featured: false
  },
  {
    name: '太田記念美術館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ukiyoe-ota-muse.jp/',
    is_featured: false
  },
  {
    name: '古賀政男音楽博物館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.koga.or.jp/',
    is_featured: false
  },
  {
    name: '戸栗美術館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.toguri-museum.or.jp/',
    is_featured: false
  },
  {
    name: '山種美術館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yamatane-museum.jp/',
    is_featured: false
  },
  {
    name: 'SOMPO美術館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sompo-museum.org/',
    is_featured: false
  },
  {
    name: '草間彌生美術館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yayoikusamamuseum.jp/',
    is_featured: false
  },
  {
    name: '佐藤美術館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://sato-museum.la.coocan.jp/',
    is_featured: false
  },
  {
    name: '新宿区立新宿歴史博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.regasu-shinjuku.or.jp/rekihaku/',
    is_featured: false
  },
  {
    name: '東京オペラシティアートギャラリー',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.operacity.jp/ag/',
    is_featured: false
  },
  {
    name: '民音音楽博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.min-on.or.jp/',
    is_featured: false
  },
  {
    name: '杉並区立郷土博物館',
    prefecture: '東京都',
    city: '杉並区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.suginami.tokyo.jp/histmus/',
    is_featured: false
  },
  {
    name: '相撲博物館',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.sumo.or.jp/KokugikanSumoMuseum/',
    is_featured: false
  },
  {
    name: '刀剣博物館',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.touken.or.jp/museum/',
    is_featured: false
  },
  {
    name: '賀川豊彦記念松沢資料館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.t-kagawa.or.jp/',
    is_featured: false
  },
  {
    name: '五島美術館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.gotoh-museum.or.jp/',
    is_featured: false
  },
  {
    name: '駒澤大学禅文化歴史博物館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.komazawa-u.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '齋田記念館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saita-museum.jp/',
    is_featured: false
  },
  {
    name: '世田谷区立郷土資料館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.setagaya.lg.jp/bunkasports/shougaigakushuu/category/12536.html',
    is_featured: false
  },
  {
    name: '長谷川町子美術館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hasegawamachiko.jp/',
    is_featured: false
  },
  {
    name: '上野の森美術館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ueno-mori.org/',
    is_featured: false
  },
  {
    name: '大名時計博物館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://ogino.c.ooco.jp/gijutu/tokei.htm',
    is_featured: false
  },
  {
    name: '横山大観記念館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://taikan.tokyo/',
    is_featured: false
  },
  {
    name: '昭和天皇記念館',
    prefecture: '東京都',
    city: '立川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://f-showa.or.jp/museum/',
    is_featured: false
  },
  {
    name: 'アーティゾン美術館',
    prefecture: '東京都',
    city: '中央区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.artizon.museum/',
    is_featured: false
  },
  {
    name: '三井記念美術館',
    prefecture: '東京都',
    city: '中央区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.mitsui-museum.jp/',
    is_featured: false
  },
  {
    name: '調布市郷土博物館',
    prefecture: '東京都',
    city: '調布市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.chofu.lg.jp/100200/p073000.html',
    is_featured: false
  },
  {
    name: '出光美術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://idemitsu-museum.or.jp/',
    is_featured: false
  },
  {
    name: '科学技術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.jsf.or.jp/',
    is_featured: false
  },
  {
    name: '共立女子大学博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kyoritsu-wu.ac.jp/muse/',
    is_featured: false
  },
  {
    name: '静嘉堂文庫美術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.seikado.or.jp/',
    is_featured: false
  },
  {
    name: '東京ステーションギャラリー',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ejrcf.or.jp/gallery/index.html',
    is_featured: false
  },
  {
    name: '日本カメラ博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.jcii-cameramuseum.jp/',
    is_featured: false
  },
  {
    name: '三菱一号館美術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mimt.jp',
    is_featured: false
  },
  {
    name: '明治大学博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.meiji.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '切手の博物館',
    prefecture: '東京都',
    city: '豊島区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kitte-museum.jp/',
    is_featured: false
  },
  {
    name: '古代オリエント博物館',
    prefecture: '東京都',
    city: '豊島区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://aom-tokyo.com/',
    is_featured: false
  },
  {
    name: 'ちひろ美術館・東京',
    prefecture: '東京都',
    city: '練馬区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chihiro.jp/tokyo/',
    is_featured: false
  },
  {
    name: '東京富士美術館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.fujibi.or.jp/',
    is_featured: false
  },
  {
    name: '八王子市郷土資料館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hachioji.tokyo.jp/kankobunka/003/005/p005312.html',
    is_featured: false
  },
  {
    name: '羽村市郷土博物館',
    prefecture: '東京都',
    city: '羽村市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hamura.tokyo.jp/0000005474.html',
    is_featured: false
  },
  {
    name: '東村山ふるさと歴史館',
    prefecture: '東京都',
    city: '東村山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.higashimurayama.tokyo.jp/tanoshimi/rekishi/furusato/index.html',
    is_featured: false
  },
  {
    name: '東大和市立郷土博物館',
    prefecture: '東京都',
    city: '東大和市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.higashiyamato.lg.jp/bunkasports/museum/index.html',
    is_featured: false
  },
  {
    name: '府中市郷土の森博物館',
    prefecture: '東京都',
    city: '府中市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.fuchu-cpf.or.jp/museum/',
    is_featured: false
  },
  {
    name: '府中市美術館',
    prefecture: '東京都',
    city: '府中市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.fuchu.tokyo.jp/art/',
    is_featured: false
  },
  {
    name: '永青文庫',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.eiseibunko.com/',
    is_featured: false
  },
  {
    name: '日本女子大学成瀬記念館',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.jwu.ac.jp/unv/about/naruse_memorial/index.html',
    is_featured: false
  },
  {
    name: '野球殿堂博物館',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://baseball-museum.or.jp/',
    is_featured: false
  },
  {
    name: '中近東文化センター付属博物館',
    prefecture: '東京都',
    city: '三鷹市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.meccj.or.jp/',
    is_featured: false
  },
  {
    name: 'ＮＨＫ放送博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.nhk.or.jp/museum/',
    is_featured: false
  },
  {
    name: '荏原 畠山美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hatakeyama-museum.org',
    is_featured: false
  },
  {
    name: '大倉集古館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shukokan.org/',
    is_featured: false
  },
  {
    name: 'お茶の文化創造博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.ochamuseum.jp/culture/',
    is_featured: false
  },
  {
    name: '菊池寛実記念智美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.musee-tomo.or.jp/',
    is_featured: false
  },
  {
    name: '慶應義塾大学アート・センター',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.art-c.keio.ac.jp/',
    is_featured: false
  },
  {
    name: '泉屋博古館東京',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sen-oku.or.jp/tokyo/',
    is_featured: false
  },
  {
    name: '根津美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.nezu-muse.or.jp/',
    is_featured: false
  },
  {
    name: '物流博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.lmuse.or.jp/',
    is_featured: false
  },
  {
    name: '日本獣医生命科学大学付属博物館',
    prefecture: '東京都',
    city: '武蔵野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.nvlu.ac.jp/universityinstitution/004.html/',
    is_featured: false
  },
  {
    name: '宗教法人長泉院附属現代彫刻美術館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://museum-of-sculpture.org/',
    is_featured: false
  },
  {
    name: '日本民藝館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mingeikan.or.jp/',
    is_featured: false
  },
  {
    name: '目黒寄生虫館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.kiseichu.org/',
    is_featured: false
  },
  {
    name: '東京家政大学博物館',
    prefecture: '東京都',
    city: '板橋区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tokyo-kasei.ac.jp/academics/museum/',
    is_featured: false
  },
  {
    name: '葛西臨海水族園',
    prefecture: '東京都',
    city: '江戸川区',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.tokyo-zoo.net/zoo/kasai/',
    is_featured: false
  },
  {
    name: '東京都現代美術館',
    prefecture: '東京都',
    city: '江東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.mot-art-museum.jp/',
    is_featured: false
  },
  {
    name: '東京農工大学科学博物館',
    prefecture: '東京都',
    city: '小金井市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tuat-museum.org/',
    is_featured: false
  },
  {
    name: '杉野学園衣裳博物館',
    prefecture: '東京都',
    city: '品川区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.costumemuseum.jp/',
    is_featured: false
  },
  {
    name: 'Bunkamuraザ・ミュージアム',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.bunkamura.co.jp/museum/',
    is_featured: false
  },
  {
    name: '國學院大學博物館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://museum.kokugakuin.ac.jp/',
    is_featured: false
  },
  {
    name: '実践女子学園香雪記念資料館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.jissen.ac.jp/kosetsu/',
    is_featured: false
  },
  {
    name: '文化学園服飾博物館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://museum.bunka.ac.jp/',
    is_featured: false
  },
  {
    name: '明治神宮宝物殿（分館　明治神宮ミュージアム）',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.meijijingu.or.jp/museum/houmotsuden/',
    is_featured: false
  },
  {
    name: '秩父宮記念スポーツ博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.jpnsport.go.jp/muse/',
    is_featured: false
  },
  {
    name: '帝国データバンク史料館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tdb-muse.jp/',
    is_featured: false
  },
  {
    name: '東京理科大学近代科学資料館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tus.ac.jp/info/setubi/museum/',
    is_featured: false
  },
  {
    name: '早稲田大学會津八一記念博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.waseda.jp/culture/aizu-museum/',
    is_featured: false
  },
  {
    name: '早稲田大学坪内博士記念演劇博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://enpaku.w.waseda.jp/',
    is_featured: false
  },
  {
    name: 'すみだ郷土文化資料館',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.sumida.lg.jp/sisetu_info/siryou/kyoudobunka/',
    is_featured: false
  },
  {
    name: '東京都江戸東京博物館（分館　江戸東京たてもの園）',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.edo-tokyo-museum.or.jp/',
    is_featured: false
  },
  {
    name: '昭和女子大学光葉博物館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://museum.swu.ac.jp/',
    is_featured: false
  },
  {
    name: '世田谷区立世田谷美術館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.setagayaartmuseum.or.jp/',
    is_featured: false
  },
  {
    name: '世田谷区立世田谷文学館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.setabun.or.jp/',
    is_featured: false
  },
  {
    name: '東京農業大学「食と農」の博物館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.nodai.ac.jp/campus/facilities/syokutonou/',
    is_featured: false
  },
  {
    name: '日本大学文理学部資料館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://chs.nihon-u.ac.jp/campus-life/kyogaku-s/museum/',
    is_featured: false
  },
  {
    name: '恩賜上野動物園',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tokyo-zoo.net/zoo/ueno/',
    is_featured: false
  },
  {
    name: '国立科学博物館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kahaku.go.jp/',
    is_featured: false
  },
  {
    name: '国立西洋美術館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.nmwa.go.jp/jp/',
    is_featured: false
  },
  {
    name: '東京国立博物館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tnm.jp/',
    is_featured: false
  },
  {
    name: '東京都美術館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tobikan.jp/',
    is_featured: false
  },
  {
    name: '多摩美術大学附属美術館',
    prefecture: '東京都',
    city: '多摩市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://museum.tamabi.ac.jp/',
    is_featured: false
  },
  {
    name: '国立映画アーカイブ',
    prefecture: '東京都',
    city: '中央区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.nfaj.go.jp/',
    is_featured: false
  },
  {
    name: '大妻女子大学博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.museum.otsuma.ac.jp/',
    is_featured: false
  },
  {
    name: '皇居三の丸尚蔵館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://shozokan.nich.go.jp/',
    is_featured: false
  },
  {
    name: '東京国立近代美術館本館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.momat.go.jp/',
    is_featured: false
  },
  {
    name: '学習院大学史料館',
    prefecture: '東京都',
    city: '豊島区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.gakushuin.ac.jp/univ/ua/',
    is_featured: false
  },
  {
    name: '東京工芸大学芸術学部写大ギャラリー',
    prefecture: '東京都',
    city: '中野区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.shadai.t-kougei.ac.jp/index.html',
    is_featured: false
  },
  {
    name: '多摩六都科学館',
    prefecture: '東京都',
    city: '西東京市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tamarokuto.or.jp/',
    is_featured: false
  },
  {
    name: '日本大学芸術学部芸術資料館',
    prefecture: '東京都',
    city: '練馬区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.art.nihon-u.ac.jp/facility/attached/archives/',
    is_featured: false
  },
  {
    name: '練馬区立美術館',
    prefecture: '東京都',
    city: '練馬区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.neribun.or.jp/museum.html',
    is_featured: false
  },
  {
    name: '東京造形大学附属美術館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.zokei.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '村内美術館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.murauchi.net/museum/',
    is_featured: false
  },
  {
    name: '多摩動物公園',
    prefecture: '東京都',
    city: '日野市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tokyo-zoo.net/zoo/tama/',
    is_featured: false
  },
  {
    name: '東洋大学井上円了記念博物館',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.toyo.ac.jp/about/founder/iecp/museum/',
    is_featured: false
  },
  {
    name: '玉川大学小原國芳記念教育博物館',
    prefecture: '東京都',
    city: '町田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tamagawa.jp/campus/institutions/museum/',
    is_featured: false
  },
  {
    name: '東京家政学院生活文化博物館',
    prefecture: '東京都',
    city: '町田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kasei-gakuin.ac.jp/campuslife/museum/',
    is_featured: false
  },
  {
    name: '国際基督教大学博物館湯浅八郎記念館',
    prefecture: '東京都',
    city: '三鷹市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://subsites.icu.ac.jp/yuasa_museum/index.html',
    is_featured: false
  },
  {
    name: 'アドミュージアム東京',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.admt.jp/',
    is_featured: false
  },
  {
    name: '北里柴三郎記念博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kitasato.ac.jp/jp/kinen-shitsu/index.html',
    is_featured: false
  },
  {
    name: '東京海洋大学マリンサイエンスミュージアム',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.s.kaiyodai.ac.jp/msm/index.html',
    is_featured: false
  },
  {
    name: '東京都庭園美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.teien-art-museum.ne.jp/',
    is_featured: false
  },
  {
    name: 'パナソニック汐留美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://panasonic.co.jp/ew/museum/',
    is_featured: false
  },
  {
    name: '森美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.mori.art.museum/jp/',
    is_featured: false
  },
  {
    name: '井の頭自然文化園',
    prefecture: '東京都',
    city: '武蔵野市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.tokyo-zoo.net/zoo/ino/',
    is_featured: false
  },
  {
    name: '成蹊学園史料館',
    prefecture: '東京都',
    city: '武蔵野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.seikei.ac.jp/gakuen/archive/',
    is_featured: false
  },
  {
    name: '東京科学大学博物館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.cent.titech.ac.jp/',
    is_featured: false
  },
  {
    name: '東京都写真美術館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://topmuseum.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 神奈川県 (52件)
# ================================
puts '神奈川県のデータを投入中...'

[
  {
    name: '愛川町郷土資料館',
    prefecture: '神奈川県',
    city: '愛甲郡愛川町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.aikawa.kanagawa.jp/soshiki/kyouikuiinkai/spobun/kyodo/index.html',
    is_featured: false
  },
  {
    name: '彫刻の森美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hakone-oam.or.jp/',
    is_featured: false
  },
  {
    name: '箱根町立郷土資料館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.hakone.kanagawa.jp/www/contents/1100000002051/index.html',
    is_featured: false
  },
  {
    name: '箱根美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.moaart.or.jp/hakone/',
    is_featured: false
  },
  {
    name: 'ポーラ美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.polamuseum.or.jp/',
    is_featured: false
  },
  {
    name: '町立湯河原美術館',
    prefecture: '神奈川県',
    city: '足柄下郡湯河原町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.yugawara.kanagawa.jp/site/museum/',
    is_featured: false
  },
  {
    name: 'あつぎ郷土博物館',
    prefecture: '神奈川県',
    city: '厚木市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.atsugi.kanagawa.jp/atsugicitymuseum/index.html',
    is_featured: false
  },
  {
    name: 'ロマンスカーミュージアム',
    prefecture: '神奈川県',
    city: '海老名市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.odakyu.jp/romancecarmuseum/',
    is_featured: false
  },
  {
    name: '小田原文化財団　江之浦測候所',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.odawara-af.com/ja/enoura/',
    is_featured: false
  },
  {
    name: '神奈川県立生命の星・地球博物館',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://nh.kanagawa-museum.jp/',
    is_featured: false
  },
  {
    name: '報徳博物館',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.hotoku.or.jp/',
    is_featured: false
  },
  {
    name: '鎌倉国宝館',
    prefecture: '神奈川県',
    city: '鎌倉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kamakura.kanagawa.jp/kokuhoukan/',
    is_featured: false
  },
  {
    name: '川崎市立日本民家園',
    prefecture: '神奈川県',
    city: '川崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nihonminkaen.jp/',
    is_featured: false
  },
  {
    name: 'かわさき宙と緑の科学館（川崎市青少年科学館）',
    prefecture: '神奈川県',
    city: '川崎市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.nature-kawasaki.jp/',
    is_featured: false
  },
  {
    name: '相模原市立博物館',
    prefecture: '神奈川県',
    city: '相模原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://sagamiharacitymuseum.jp/',
    is_featured: false
  },
  {
    name: '茅ヶ崎市博物館',
    prefecture: '神奈川県',
    city: '茅ヶ崎市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://chigamu.jp/',
    is_featured: false
  },
  {
    name: '大磯町郷土資料館',
    prefecture: '神奈川県',
    city: '中郡大磯町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.town.oiso.kanagawa.jp/oisomuseum/index.html',
    is_featured: false
  },
  {
    name: '徳富蘇峰記念館',
    prefecture: '神奈川県',
    city: '中郡二宮町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.soho-tokutomi.or.jp/',
    is_featured: false
  },
  {
    name: 'はだの歴史博物館',
    prefecture: '神奈川県',
    city: '秦野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hadano.kanagawa.jp/www/contents/1001000004542/index.html',
    is_featured: false
  },
  {
    name: '平塚市博物館',
    prefecture: '神奈川県',
    city: '平塚市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.hirahaku.jp/',
    is_featured: false
  },
  {
    name: '平塚市美術館',
    prefecture: '神奈川県',
    city: '平塚市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hiratsuka.kanagawa.jp/art-muse/index.html',
    is_featured: false
  },
  {
    name: '新江ノ島水族館',
    prefecture: '神奈川県',
    city: '藤沢市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.enosui.com/',
    is_featured: false
  },
  {
    name: '日本大学生物資源科学部博物館',
    prefecture: '神奈川県',
    city: '藤沢市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://hp.brs.nihon-u.ac.jp/~museum/',
    is_featured: false
  },
  {
    name: '神奈川県立近代美術館',
    prefecture: '神奈川県',
    city: '三浦郡葉山町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.moma.pref.kanagawa.jp/',
    is_featured: false
  },
  {
    name: '葉山しおさい博物館',
    prefecture: '神奈川県',
    city: '三浦郡葉山町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.town.hayama.lg.jp/soshiki/shougaigakushuu/2/1701.html',
    is_featured: false
  },
  {
    name: '山口蓬春記念館',
    prefecture: '神奈川県',
    city: '三浦郡葉山町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hoshun.jp/',
    is_featured: false
  },
  {
    name: '横須賀市自然博物館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.museum.yokosuka.kanagawa.jp/',
    is_featured: false
  },
  {
    name: '横須賀市人文博物館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.museum.yokosuka.kanagawa.jp/',
    is_featured: false
  },
  {
    name: '横須賀美術館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yokosuka-moa.jp/',
    is_featured: false
  },
  {
    name: '馬の博物館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bajibunka.or.jp/uma/index.php',
    is_featured: false
  },
  {
    name: '神奈川県立金沢文庫',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pen-kanagawa.ed.jp/kanazawabunko/index.html',
    is_featured: false
  },
  {
    name: '神奈川県立歴史博物館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ch.kanagawa-museum.jp/',
    is_featured: false
  },
  {
    name: 'シルク博物館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.silkcenter-kbkk.jp/museum/',
    is_featured: false
  },
  {
    name: 'そごう美術館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sogo-seibu.jp/common/museum/',
    is_featured: false
  },
  {
    name: '日本新聞博物館（ニュースパーク）',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://newspark.jp/',
    is_featured: false
  },
  {
    name: '日吉の森庭園美術館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://hiyoshinomori.com/',
    is_featured: false
  },
  {
    name: '箱根・芦ノ湖成川美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.narukawamuseum.co.jp/',
    is_featured: false
  },
  {
    name: '箱根神社宝物殿',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://hakonejinja.or.jp/hakone/houmotsuden.html',
    is_featured: false
  },
  {
    name: '箱根ラリック美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.lalique-museum.com/',
    is_featured: false
  },
  {
    name: '松蔭大学資料館',
    prefecture: '神奈川県',
    city: '厚木市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.shoin-u.ac.jp/campus/museum/',
    is_featured: false
  },
  {
    name: '東京農業大学農学部植物園',
    prefecture: '神奈川県',
    city: '厚木市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.nodai.ac.jp/academics/agri/garden/',
    is_featured: false
  },
  {
    name: '小田原市郷土文化館',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.odawara.kanagawa.jp/public-i/facilities/kyodo/',
    is_featured: false
  },
  {
    name: '鎌倉彫資料館',
    prefecture: '神奈川県',
    city: '鎌倉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://kamakuraborikaikan.jp/museum/',
    is_featured: false
  },
  {
    name: '女子美術館大学美術館　女子美アートミュージアム',
    prefecture: '神奈川県',
    city: '相模原市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.joshibi.net/museum/jam/',
    is_featured: false
  },
  {
    name: '茅ケ崎市美術館',
    prefecture: '神奈川県',
    city: '茅ヶ崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.chigasaki-museum.jp/',
    is_featured: false
  },
  {
    name: '東海大学松前記念館（歴史と未来の博物館）',
    prefecture: '神奈川県',
    city: '平塚市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.kinenkan.u-tokai.ac.jp/',
    is_featured: false
  },
  {
    name: '観音崎自然博物館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://kannonzaki-nature-museum.jimdofree.com/',
    is_featured: false
  },
  {
    name: '横浜・八景島シーパラダイスアクアリゾーツ',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'http://www.seaparadise.co.jp/aquaresorts/index.html',
    is_featured: false
  },
  {
    name: '横浜市立金沢動物園',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.hama-midorinokyokai.or.jp/zoo/kanazawa/',
    is_featured: false
  },
  {
    name: '横浜市立野毛山動物園',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.hama-midorinokyokai.or.jp/zoo/nogeyama/',
    is_featured: false
  },
  {
    name: '横浜市立よこはま動物園ズーラシア',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.hama-midorinokyokai.or.jp/zoo/zoorasia/',
    is_featured: false
  },
  {
    name: '横浜美術館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://yokohama.art.museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 新潟県 (36件)
# ================================
puts '新潟県のデータを投入中...'

[
  {
    name: '柏崎市立博物館',
    prefecture: '新潟県',
    city: '柏崎市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kashiwazaki.lg.jp/k_museum/index.html',
    is_featured: false
  },
  {
    name: '木村茶道美術館',
    prefecture: '新潟県',
    city: '柏崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://sadoukan.jp/',
    is_featured: false
  },
  {
    name: '相川郷土博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/60583.html',
    is_featured: false
  },
  {
    name: '佐渡国小木民俗博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/458.html',
    is_featured: false
  },
  {
    name: '佐渡植物園',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/461.html',
    is_featured: false
  },
  {
    name: '佐渡博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/457.html',
    is_featured: false
  },
  {
    name: '両津郷土博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/460.html',
    is_featured: false
  },
  {
    name: '小林古径記念美術館',
    prefecture: '新潟県',
    city: '上越市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.joetsu.niigata.jp/site/kokei/',
    is_featured: false
  },
  {
    name: '上越市立水族博物館',
    prefecture: '新潟県',
    city: '上越市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.umigatari.jp/joetsu/',
    is_featured: false
  },
  {
    name: '上越市立歴史博物館',
    prefecture: '新潟県',
    city: '上越市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.joetsu.niigata.jp/site/museum/',
    is_featured: false
  },
  {
    name: '大棟山美術博物館',
    prefecture: '新潟県',
    city: '十日町市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://daitozan.jimdofree.com/',
    is_featured: false
  },
  {
    name: '十日町市博物館',
    prefecture: '新潟県',
    city: '十日町市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.tokamachi-museum.jp/',
    is_featured: false
  },
  {
    name: '駒形十吉記念美術館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.komagata-museum.com/',
    is_featured: false
  },
  {
    name: '長岡市寺泊水族博物館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://aquarium-teradomari.jp/',
    is_featured: false
  },
  {
    name: '長岡市栃尾美術館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.lib.city.nagaoka.niigata.jp/?page_id=135',
    is_featured: false
  },
  {
    name: '長岡市立科学博物館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.museum.city.nagaoka.niigata.jp/',
    is_featured: false
  },
  {
    name: '新潟県立近代美術館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kinbi.pref.niigata.lg.jp/',
    is_featured: false
  },
  {
    name: '知足美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chisoku.jp/',
    is_featured: false
  },
  {
    name: '敦井美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tsurui.co.jp/museum/',
    is_featured: false
  },
  {
    name: '新潟県立万代島美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://banbi.pref.niigata.lg.jp/',
    is_featured: false
  },
  {
    name: '新潟市北区郷土博物館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.niigata.lg.jp/kita/shisetsu/yoka/bunka/kyodo/index.html',
    is_featured: false
  },
  {
    name: '新津記念館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.marushin-group.co.jp/kinenkan/',
    is_featured: false
  },
  {
    name: '一般財団法人　北方文化博物館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hoppou-bunka.com/',
    is_featured: false
  },
  {
    name: '雪梁舎美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.komeri.bit.or.jp/setsuryosha/',
    is_featured: false
  },
  {
    name: '出雲崎町　良寛記念館',
    prefecture: '新潟県',
    city: '三島郡出雲崎町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.ryokan-kinenkan.jp/',
    is_featured: false
  },
  {
    name: '池田記念美術館',
    prefecture: '新潟県',
    city: '南魚沼市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ikedaart.jp/',
    is_featured: false
  },
  {
    name: '魚沼市宮柊二記念館',
    prefecture: '新潟県',
    city: '魚沼市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.uonuma.lg.jp/site/miyashuji/',
    is_featured: false
  },
  {
    name: '鍛冶ミュージアム',
    prefecture: '新潟県',
    city: '三条市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://sanjo-machiyama.jp/blacksmithmuseum/',
    is_featured: false
  },
  {
    name: '燕市産業史料館',
    prefecture: '新潟県',
    city: '燕市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://tsubame-shiryoukan.jp/index.html',
    is_featured: false
  },
  {
    name: '新潟県立歴史博物館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://nbz.or.jp/',
    is_featured: false
  },
  {
    name: '新潟市會津八一記念館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://aizuyaichi.or.jp/',
    is_featured: false
  },
  {
    name: '新潟市新津美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.niigata.lg.jp/nam/',
    is_featured: false
  },
  {
    name: '新潟市美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.ncam.jp/sp/',
    is_featured: false
  },
  {
    name: '新潟市歴史博物館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.nchm.jp/',
    is_featured: false
  },
  {
    name: '新潟大学旭町学術資料展示館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.lib.niigata-u.ac.jp/tenjikan/',
    is_featured: false
  },
  {
    name: '日本歯科大学新潟生命歯学部「医の博物館」',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.ngt.ndu.ac.jp/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 富山県 (37件)
# ================================
puts '富山県のデータを投入中...'

[
  {
    name: '射水市新湊博物館',
    prefecture: '富山県',
    city: '射水市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shinminato-museum.jp/',
    is_featured: false
  },
  {
    name: '魚津水族博物館',
    prefecture: '富山県',
    city: '魚津市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.uozu-aquarium.jp/',
    is_featured: false
  },
  {
    name: '魚津歴史民俗博物館',
    prefecture: '富山県',
    city: '魚津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.uozu.toyama.jp/hp/svFacHP.aspx?faccd=B080307',
    is_featured: false
  },
  {
    name: '特別天然記念物魚津埋没林博物館',
    prefecture: '富山県',
    city: '魚津市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.uozu.toyama.jp/nekkolnd/',
    is_featured: false
  },
  {
    name: '小矢部市大谷博物館',
    prefecture: '富山県',
    city: '小矢部市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.oyabe.toyama.jp/bunkasports/1003003/1003024/index.html',
    is_featured: false
  },
  {
    name: '黒部市美術館',
    prefecture: '富山県',
    city: '黒部市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kurobe.toyama.jp/category/page.aspx?servno=79',
    is_featured: false
  },
  {
    name: '黒部市吉田科学館',
    prefecture: '富山県',
    city: '黒部市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://kysm.or.jp/',
    is_featured: false
  },
  {
    name: '朝日町立ふるさと美術館',
    prefecture: '富山県',
    city: '下新川郡朝日町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.asahi.toyama.jp/section/buntai/bijyutukanannai.html',
    is_featured: false
  },
  {
    name: '一般財団法人　百河豚美術館',
    prefecture: '富山県',
    city: '下新川郡朝日町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://ippukumuseum.g2.xrea.com//index.html',
    is_featured: false
  },
  {
    name: '宮崎自然博物館',
    prefecture: '富山県',
    city: '下新川郡朝日町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.town.asahi.toyama.jp/soshiki/kyoiku/syougaigakusyuu/bunkazai/1449206358603.html',
    is_featured: false
  },
  {
    name: '入善町下山芸術の森アートスペース（発電所美術館）',
    prefecture: '富山県',
    city: '下新川郡入善町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.nyuzen.toyama.jp/gyosei/bijutsukan/index.html',
    is_featured: false
  },
  {
    name: '高岡市美術館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.e-tam.info/',
    is_featured: false
  },
  {
    name: '高岡市福岡歴史民俗資料館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takaoka.toyama.jp/soshiki/kyoikuiinkai_shogaigakushu_sportska/2/8/1/2276.html',
    is_featured: false
  },
  {
    name: '高岡市万葉歴史館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.manreki.com/',
    is_featured: false
  },
  {
    name: '高岡市立博物館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.e-tmm.info/',
    is_featured: false
  },
  {
    name: 'ミュゼふくおかカメラ館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.camerakan.com/',
    is_featured: false
  },
  {
    name: '砺波郷土資料館',
    prefecture: '富山県',
    city: '砺波市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.tonami.lg.jp/section/1658p/',
    is_featured: false
  },
  {
    name: '砺波市美術館',
    prefecture: '富山県',
    city: '砺波市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tonami-art-museum.jp/',
    is_featured: false
  },
  {
    name: '公益財団法人　秋水美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shusui-museum.jp/',
    is_featured: false
  },
  {
    name: '富山県交通公園交通安全博物館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://safety-toyama.or.jp/museum/',
    is_featured: false
  },
  {
    name: '富山県水墨美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.pref.toyama.jp/1738/miryokukankou/bunka/bunkazai/3044/index.html',
    is_featured: false
  },
  {
    name: '富山県中央植物園',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.bgtym.org/',
    is_featured: false
  },
  {
    name: '富山県美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://tad-toyama.jp/',
    is_featured: false
  },
  {
    name: '富山県埋蔵文化財センター',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.toyama.jp/3041/miryokukankou/bunka/bunkazai/maibun/index.html',
    is_featured: false
  },
  {
    name: '富山県民会館美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.bunka-toyama.jp/kenminkaikan/',
    is_featured: false
  },
  {
    name: '富山市科学博物館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.tsm.toyama.toyama.jp/',
    is_featured: false
  },
  {
    name: '富山市ガラス美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://toyama-glass-art-museum.jp/',
    is_featured: false
  },
  {
    name: '富山市郷土博物館（別館）富山市佐藤記念美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.toyama.toyama.jp/etc/muse/',
    is_featured: false
  },
  {
    name: '富山市民俗民芸村',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.toyama.toyama.jp/etc/minzokumingei/',
    is_featured: false
  },
  {
    name: '富山県　立山カルデラ砂防博物館',
    prefecture: '富山県',
    city: '中新川郡立山町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.tatecal.or.jp/tatecal/index.html',
    is_featured: false
  },
  {
    name: '富山県［立山博物館］',
    prefecture: '富山県',
    city: '中新川郡立山町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.pref.toyama.jp/1739/miryokukankou/bunka/bunkazai/home/index.html',
    is_featured: false
  },
  {
    name: '滑川市立博物館',
    prefecture: '富山県',
    city: '滑川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.namerikawa.toyama.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '南砺市埋蔵文化財センター',
    prefecture: '富山県',
    city: '南砺市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museums.toyamaken.jp/museum/swhm068/',
    is_featured: false
  },
  {
    name: '南砺市立福光美術館',
    prefecture: '富山県',
    city: '南砺市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nanto-museum.com/',
    is_featured: false
  },
  {
    name: '氷見市立博物館',
    prefecture: '富山県',
    city: '氷見市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.himi.toyama.jp/section/museum/index.html',
    is_featured: false
  },
  {
    name: 'ギャルリ・ミレー',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.gmillet.jp/',
    is_featured: false
  },
  {
    name: '富山県教育記念館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.t-hito.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 石川県 (30件)
# ================================
puts '石川県のデータを投入中...'

[
  {
    name: '石川県九谷焼美術館',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kaga.ishikawa.jp/kutani-mus/index.html',
    is_featured: false
  },
  {
    name: '加賀市中谷宇吉郎雪の科学館',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://yukinokagakukan.kagashi-ss.com/',
    is_featured: false
  },
  {
    name: '加賀市美術館',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kagabi.kagashi-ss.com/',
    is_featured: false
  },
  {
    name: '無限庵',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://mugenan.com',
    is_featured: false
  },
  {
    name: '石川県立美術館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ishibi.pref.ishikawa.jp/',
    is_featured: false
  },
  {
    name: '石川県立歴史博物館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ishikawa-rekihaku.jp/',
    is_featured: false
  },
  {
    name: '泉鏡花記念館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanazawa-museum.jp/kyoka/',
    is_featured: false
  },
  {
    name: '金沢くらしの博物館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanazawa-museum.jp/minzoku/',
    is_featured: false
  },
  {
    name: '金沢市立中村記念美術館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/nakamura/',
    is_featured: false
  },
  {
    name: '金沢市立安江金箔工芸館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/kinpaku/',
    is_featured: false
  },
  {
    name: '金沢湯涌夢二館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/yumeji/',
    is_featured: false
  },
  {
    name: '成巽閣',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.seisonkaku.com/',
    is_featured: false
  },
  {
    name: '前田土佐守家資料館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanazawa-museum.jp/maedatosa/',
    is_featured: false
  },
  {
    name: '石川県西田幾多郎記念哲学館',
    prefecture: '石川県',
    city: 'かほく市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.nishidatetsugakukan.org/',
    is_featured: false
  },
  {
    name: '小松市立博物館',
    prefecture: '石川県',
    city: '小松市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://komatsu-museum.jp/',
    is_featured: false
  },
  {
    name: '小松市立本陣記念美術館',
    prefecture: '石川県',
    city: '小松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://komatsu-museum.jp/honjin/',
    is_featured: false
  },
  {
    name: '小松市立宮本三郎美術館／宮本三郎ふるさと館',
    prefecture: '石川県',
    city: '小松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://komatsu-museum.jp/miyamoto/',
    is_featured: false
  },
  {
    name: '石川県立白山ろく民俗資料館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.pref.ishikawa.jp/hakusanminzoku/',
    is_featured: false
  },
  {
    name: '白山市立博物館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.hakusan-museum.jp/hakubutukan/',
    is_featured: false
  },
  {
    name: '白山市立松任中川一政記念美術館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hakusan-museum.jp/nakagawakinen/',
    is_featured: false
  },
  {
    name: '石川県七尾美術館',
    prefecture: '石川県',
    city: '七尾市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nanao-art-museum.jp/',
    is_featured: false
  },
  {
    name: '石川県能登島ガラス美術館',
    prefecture: '石川県',
    city: '七尾市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nanao-af.jp/glass/',
    is_featured: false
  },
  {
    name: 'のとじま臨海公園水族館',
    prefecture: '石川県',
    city: '七尾市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.notoaqua.jp/',
    is_featured: false
  },
  {
    name: '能美ふるさとミュージアム',
    prefecture: '石川県',
    city: '能美市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nomi.ishikawa.jp/www/genre/1000100000265/index.html',
    is_featured: false
  },
  {
    name: '羽咋市歴史民俗資料館',
    prefecture: '石川県',
    city: '羽咋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hakui.lg.jp/rekimin/index.html',
    is_featured: false
  },
  {
    name: '石川県輪島漆芸美術館',
    prefecture: '石川県',
    city: '輪島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.art.city.wajima.ishikawa.jp/',
    is_featured: false
  },
  {
    name: '金沢21世紀美術館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kanazawa21.jp/',
    is_featured: false
  },
  {
    name: '金沢大学資料館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://museum.w3.kanazawa-u.ac.jp/',
    is_featured: false
  },
  {
    name: '谷口吉郎・吉生記念金沢建築館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/architecture/',
    is_featured: false
  },
  {
    name: '石川県ふれあい昆虫館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.furekon.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 福井県 (22件)
# ================================
puts '福井県のデータを投入中...'

[
  {
    name: '金津創作の森美術館アートコア',
    prefecture: '福井県',
    city: 'あわら市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sosaku.jp/',
    is_featured: false
  },
  {
    name: '吉崎御坊蓮如上人記念館',
    prefecture: '福井県',
    city: 'あわら市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://honganjifoundation.org/rennyo/',
    is_featured: false
  },
  {
    name: '越前市武生公会堂記念館',
    prefecture: '福井県',
    city: '越前市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.echizen.lg.jp/office/090/030/bunkasisetu/kokaido-top.html',
    is_featured: false
  },
  {
    name: '大野市歴史博物館',
    prefecture: '福井県',
    city: '大野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ono.fukui.jp/kosodate/bunka-rekishi/hakubutsukan/shisetsu/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '福井県立若狭歴史博物館',
    prefecture: '福井県',
    city: '小浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://wakahaku.pref.fukui.lg.jp/',
    is_featured: false
  },
  {
    name: '勝山城博物館',
    prefecture: '福井県',
    city: '勝山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.katsuyamajyou.com/',
    is_featured: false
  },
  {
    name: '福井県立恐竜博物館',
    prefecture: '福井県',
    city: '勝山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.dinosaur.pref.fukui.jp/',
    is_featured: false
  },
  {
    name: '坂井市龍翔博物館',
    prefecture: '福井県',
    city: '坂井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ryusho-museum.jp/',
    is_featured: false
  },
  {
    name: '鯖江市まなべの館',
    prefecture: '福井県',
    city: '鯖江市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sabae.fukui.jp/kosodate_kyoiku/manabenoyakata/manabenoyakata.html',
    is_featured: false
  },
  {
    name: '敦賀郷土博物館',
    prefecture: '福井県',
    city: '敦賀市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: '',
    is_featured: false
  },
  {
    name: '敦賀市立博物館',
    prefecture: '福井県',
    city: '敦賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://tsuruga-municipal-museum.jp/',
    is_featured: false
  },
  {
    name: '福井県立こども歴史文化館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://info.pref.fukui.jp/koreki/',
    is_featured: false
  },
  {
    name: '福井県立美術館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fukui-kenbi.pref.fukui.lg.jp/',
    is_featured: false
  },
  {
    name: '福井県立歴史博物館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.fukui.lg.jp/muse/Cul-Hist/',
    is_featured: false
  },
  {
    name: '福井市自然史博物館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.nature.museum.city.fukui.fukui.jp/',
    is_featured: false
  },
  {
    name: '福井市美術館（アートラボふくい）',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.art.museum.city.fukui.fukui.jp/',
    is_featured: false
  },
  {
    name: '福井市立郷土歴史博物館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.history.museum.city.fukui.fukui.jp/',
    is_featured: false
  },
  {
    name: 'ふくい藤田美術館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ff-museum.com',
    is_featured: false
  },
  {
    name: '若狭三方縄文博物館',
    prefecture: '福井県',
    city: '三方上中郡若狭町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.fukui-wakasa.lg.jp/soshiki/wakasamikatajomonhakubutsukan/gyomuannai/955.html',
    is_featured: false
  },
  {
    name: '伊藤柏翠俳句記念館',
    prefecture: '福井県',
    city: '鯖江市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '福井県年縞博物館',
    prefecture: '福井県',
    city: '三方上中郡若狭町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://varve-museum.pref.fukui.lg.jp/',
    is_featured: false
  },
  {
    name: '若狭町歴史文化館',
    prefecture: '福井県',
    city: '三方上中郡若狭町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 山梨県 (28件)
# ================================
puts '山梨県のデータを投入中...'

[
  {
    name: '信玄公宝物館',
    prefecture: '山梨県',
    city: '甲州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shingen.iooo.jp/',
    is_featured: false
  },
  {
    name: '山梨県立考古博物館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.yamanashi.jp/kouko-hak/',
    is_featured: false
  },
  {
    name: '山梨県立美術館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.art-museum.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '山梨県立文学館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bungakukan.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '都留市博物館「ミュージアム都留」',
    prefecture: '山梨県',
    city: '都留市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tsuru.yamanashi.jp/soshiki/shougaigakushuu/museum_tsuru/1340.html',
    is_featured: false
  },
  {
    name: '韮崎大村美術館',
    prefecture: '山梨県',
    city: '韮崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://nirasakiomura-artmuseum.com/',
    is_featured: false
  },
  {
    name: '釈迦堂遺跡博物館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.eps4.comlink.ne.jp/~shakado/',
    is_featured: false
  },
  {
    name: '山梨県立博物館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.museum.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '富士山美術館（フジヤマミュージアム）',
    prefecture: '山梨県',
    city: '富士吉田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.fujiyama-museum.com/',
    is_featured: false
  },
  {
    name: '富士吉田市歴史民俗博物館（ふじさんミュージアム）',
    prefecture: '山梨県',
    city: '富士吉田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.fy-museum.jp/',
    is_featured: false
  },
  {
    name: '一般社団法人アフリカンアートミュージアム',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.africanartmuseum.jp/',
    is_featured: false
  },
  {
    name: '清春白樺美術館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kiyoharu-art.com/',
    is_featured: false
  },
  {
    name: '平山郁夫シルクロード美術館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.silkroad-museum.jp/',
    is_featured: false
  },
  {
    name: 'ポール・ラッシュ記念館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.seisenryo.jp/spot_paulrusch1.html',
    is_featured: false
  },
  {
    name: '南アルプス市ふるさと文化伝承館',
    prefecture: '山梨県',
    city: '南アルプス市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.minami-alps.yamanashi.jp/sisetsu/shisetsu/bunkazai-densyokan/',
    is_featured: false
  },
  {
    name: '南アルプス市立美術館',
    prefecture: '山梨県',
    city: '南アルプス市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.minamialps-museum.jp/',
    is_featured: false
  },
  {
    name: '近藤浩一路記念南部町立美術館',
    prefecture: '山梨県',
    city: '南巨摩郡南部町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.nanbu.yamanashi.jp/shisetsu/syakaikyouiku/museum.html',
    is_featured: false
  },
  {
    name: '甲斐黄金村・湯之奥金山博物館',
    prefecture: '山梨県',
    city: '南巨摩郡身延町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.minobu.lg.jp/kinzan/',
    is_featured: false
  },
  {
    name: '美枝きもの資料館',
    prefecture: '山梨県',
    city: '南巨摩郡身延町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://mie-kimonomuseum.or.jp/',
    is_featured: false
  },
  {
    name: '河口湖美術館',
    prefecture: '山梨県',
    city: '南都留郡富士河口湖町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.fkchannel.jp/kgmuse/',
    is_featured: false
  },
  {
    name: '甲府市遊亀公園附属動物園',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.kofu.yamanashi.jp/zoo/',
    is_featured: false
  },
  {
    name: '山梨県立科学館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kagakukan.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '帝京大学やまなし伝統工芸館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.teikyo.jp/crafts-yamanashi/',
    is_featured: false
  },
  {
    name: '笛吹市青楓美術館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.fuefuki.yamanashi.jp/shisetsu/museum/001.html',
    is_featured: false
  },
  {
    name: 'サントリーウイスキー博物館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '清泉寮やまねミュージアム',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.seisenryo.jp/spot_yamane1.html',
    is_featured: false
  },
  {
    name: '身延山宝物館',
    prefecture: '山梨県',
    city: '南巨摩郡身延町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kuonji.jp/precincts/m-muse/',
    is_featured: false
  },
  {
    name: '四季の杜おしの公園　岡田紅陽写真美術館･小池邦夫絵手紙美術館',
    prefecture: '山梨県',
    city: '南都留郡忍野村',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://oshino-artmuseum.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 長野県 (84件)
# ================================
puts '長野県のデータを投入中...'

[
  {
    name: 'TRIAD　IIDA・KAN',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.harmonicito-f.or.jp/iida_kan/',
    is_featured: false
  },
  {
    name: '安曇野市豊科郷土博物館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.azumino.nagano.jp/site/museum/',
    is_featured: false
  },
  {
    name: '安曇野市美術館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.azumino-museum.com/',
    is_featured: false
  },
  {
    name: '安曇野高橋節郎記念美術館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://azumino-bunka.com/facility/setsuro-museum/',
    is_featured: false
  },
  {
    name: '田淵行男記念館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://azumino-bunka.com/facility/tabuchi-museum/',
    is_featured: false
  },
  {
    name: '碌山美術館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://rokuzan.jp/',
    is_featured: false
  },
  {
    name: '飯田市上郷考古博物館',
    prefecture: '長野県',
    city: '飯田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.iida.lg.jp/site/bunkazai/kouko.html',
    is_featured: false
  },
  {
    name: '飯田市美術博物館',
    prefecture: '長野県',
    city: '飯田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.iida-museum.org/',
    is_featured: false
  },
  {
    name: '上田市立信濃国分寺資料館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.umic.jp/kokubunji/',
    is_featured: false
  },
  {
    name: '上田市立博物館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.umic.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '上田市立美術館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.santomyuze.com/museum/',
    is_featured: false
  },
  {
    name: '上田市立丸子郷土博物館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ueda.nagano.jp/soshiki/u-hakubutukan/1253.html',
    is_featured: false
  },
  {
    name: '美ヶ原高原美術館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.utsukushi-oam.jp/',
    is_featured: false
  },
  {
    name: '松山記念館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.matsuyama-museum.or.jp/',
    is_featured: false
  },
  {
    name: '大町エネルギー博物館',
    prefecture: '長野県',
    city: '大町市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.omachi.nagano.jp/00025000/00025100/00025102.html',
    is_featured: false
  },
  {
    name: '市立大町山岳博物館',
    prefecture: '長野県',
    city: '大町市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.omachi-sanpaku.com/',
    is_featured: false
  },
  {
    name: '市立岡谷美術考古館',
    prefecture: '長野県',
    city: '岡谷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.okaya-museum.jp/',
    is_featured: false
  },
  {
    name: '小さな絵本美術館',
    prefecture: '長野県',
    city: '岡谷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ba-ba.net/',
    is_featured: false
  },
  {
    name: '辰野美術館',
    prefecture: '長野県',
    city: '上伊那郡辰野町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://artm.town.tatsuno.nagano.jp/',
    is_featured: false
  },
  {
    name: '箕輪町郷土博物館',
    prefecture: '長野県',
    city: '上伊那郡箕輪町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.minowa.lg.jp/kanko-bunka-sports/minowamachikyodohakubutsukan/index.html',
    is_featured: false
  },
  {
    name: 'おぶせミュージアム・中島千波館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.obuse.nagano.jp/site/obusemuseum/',
    is_featured: false
  },
  {
    name: 'グレイスフル芸術館　おぶせ藤岡牧夫美術館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fujiokamakio.jp/',
    is_featured: false
  },
  {
    name: '日本のあかり博物館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nihonnoakari.or.jp/',
    is_featured: false
  },
  {
    name: '北斎館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hokusai-kan.com/',
    is_featured: false
  },
  {
    name: '歴史公園信州高山一茶ゆかりの里一茶館',
    prefecture: '長野県',
    city: '上高井郡高山村',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kobayashi-issa.jp/',
    is_featured: false
  },
  {
    name: '野尻湖ナウマンゾウ博物館',
    prefecture: '長野県',
    city: '上水内郡信濃町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://nojiriko-museum.com/',
    is_featured: false
  },
  {
    name: '南木曽町博物館',
    prefecture: '長野県',
    city: '木曽郡南木曽町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://nagiso-museum.jp/',
    is_featured: false
  },
  {
    name: '北アルプス展望美術館（池田町立美術館）',
    prefecture: '長野県',
    city: '北安曇郡池田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://navam-ikd.jp',
    is_featured: false
  },
  {
    name: '安曇野ちひろ美術館',
    prefecture: '長野県',
    city: '北安曇郡松川村',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chihiro.jp/azumino/',
    is_featured: false
  },
  {
    name: '軽井沢町追分宿郷土館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.karuizawa.lg.jp/www/contents/1001000000936/index.html',
    is_featured: false
  },
  {
    name: '軽井沢町歴史民俗資料館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.karuizawa.lg.jp/soshiki/21/',
    is_featured: false
  },
  {
    name: 'セゾン現代美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://smma.or.jp/',
    is_featured: false
  },
  {
    name: '田崎美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://tasaki-museum.org/',
    is_featured: false
  },
  {
    name: 'ルヴァン美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.levent.or.jp/',
    is_featured: false
  },
  {
    name: '脇田美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.wakita-museum.com/',
    is_featured: false
  },
  {
    name: '浅間縄文ミュージアム',
    prefecture: '長野県',
    city: '北佐久郡御代田町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://w2.avis.ne.jp/~jomon/',
    is_featured: false
  },
  {
    name: '小諸市立小山敬三美術館',
    prefecture: '長野県',
    city: '小諸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.komoro.lg.jp/soshikikarasagasu/kyoikuiinkaijimukyoku/bunkazai_shogaigakushuka/4/2/2/2084.html',
    is_featured: false
  },
  {
    name: '市立小諸高原美術館・白鳥映雪館',
    prefecture: '長野県',
    city: '小諸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.komoro.lg.jp/soshikikarasagasu/kyoikuiinkaijimukyoku/bunkazai_shogaigakushuka/4/2/4/index.html',
    is_featured: false
  },
  {
    name: '佐久市立近代美術館',
    prefecture: '長野県',
    city: '佐久市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.saku.nagano.jp/museum/',
    is_featured: false
  },
  {
    name: '佐久市立天来記念館',
    prefecture: '長野県',
    city: '佐久市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.saku.nagano.jp/shisetsu/sakubun/tenraikinenkan/index.html',
    is_featured: false
  },
  {
    name: '大鹿村中央構造線博物館',
    prefecture: '長野県',
    city: '下伊那郡大鹿村',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://mtl-muse.com/',
    is_featured: false
  },
  {
    name: '田中本家博物館',
    prefecture: '長野県',
    city: '須坂市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://tanakahonke.org/',
    is_featured: false
  },
  {
    name: '下諏訪町立諏訪湖博物館・赤彦記念館',
    prefecture: '長野県',
    city: '諏訪郡下諏訪町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.town.shimosuwa.lg.jp/www/genre/1474269863762/index.html',
    is_featured: false
  },
  {
    name: 'ハーモ美術館',
    prefecture: '長野県',
    city: '諏訪郡下諏訪町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.harmo-museum.jp/',
    is_featured: false
  },
  {
    name: '富士見町高原のミュージアム',
    prefecture: '長野県',
    city: '諏訪郡富士見町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nagano-museum.com/info/detail.php?fno=123',
    is_featured: false
  },
  {
    name: '伊東近代美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: '',
    is_featured: false
  },
  {
    name: '北澤美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitazawa-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'サンリツ服部美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.sunritz-hattori-museum.or.jp/',
    is_featured: false
  },
  {
    name: '諏訪教育博物館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.suwa-k.or.jp/?page_id=161',
    is_featured: false
  },
  {
    name: '諏訪市博物館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://suwacitymuseum.jp/',
    is_featured: false
  },
  {
    name: '諏訪市原田泰治美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.taizi-artmuseum.jp/',
    is_featured: false
  },
  {
    name: '諏訪市美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.suwa.lg.jp/site/museum/',
    is_featured: false
  },
  {
    name: '黒曜石展示・体験館（星くずの里たかやま　黒耀石体験ミュージアム）',
    prefecture: '長野県',
    city: '小県郡長和町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '千曲市さらしなの里歴史資料館',
    prefecture: '長野県',
    city: '千曲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chikuma.lg.jp/soshiki/rekishibunkazaicenter/sarashinanosato_rekishi/2270.html',
    is_featured: false
  },
  {
    name: '千曲市森将軍塚古墳館',
    prefecture: '長野県',
    city: '千曲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chikuma.lg.jp/soshiki/rekishibunkazaicenter/mori_shogunzuka/index.html',
    is_featured: false
  },
  {
    name: '長野県立歴史館',
    prefecture: '長野県',
    city: '千曲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.npmh.net/',
    is_featured: false
  },
  {
    name: '茅野市神長官守矢史料館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chino.lg.jp/soshiki/bunkazai/1639.html',
    is_featured: false
  },
  {
    name: '茅野市尖石縄文考古館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chino.lg.jp/site/togariishi/',
    is_featured: false
  },
  {
    name: '茅野市八ヶ岳総合博物館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.chino.lg.jp/site/y-hakubutsukan/',
    is_featured: false
  },
  {
    name: '中野市立博物館',
    prefecture: '長野県',
    city: '中野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nakano.nagano.jp/categories/hakubutukan/',
    is_featured: false
  },
  {
    name: '北野美術館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitano-museum.or.jp/',
    is_featured: false
  },
  {
    name: '北野美術館分館北野カルチュラルセンター',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitano-museum.or.jp/cultural/',
    is_featured: false
  },
  {
    name: '信濃教育博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://shinkyo.or.jp/museum/guide',
    is_featured: false
  },
  {
    name: '長野県立美術館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nagano.art.museum/',
    is_featured: false
  },
  {
    name: '長野市立博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nagano.nagano.jp/museum/',
    is_featured: false
  },
  {
    name: '長野市立博物館分館　信州新町美術館　有島生馬記念館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ngn.janis.or.jp/~shinmachi-museum/',
    is_featured: false
  },
  {
    name: '長野市立博物館分館　戸隠地質化石博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.tgk.janis.or.jp/~togakushi-museum/index.html',
    is_featured: false
  },
  {
    name: '水野美術館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mizuno-museum.jp/',
    is_featured: false
  },
  {
    name: '朝日美術館',
    prefecture: '長野県',
    city: '東筑摩郡朝日村',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.vill.asahi.nagano.jp/special/asahibijutsukan/index.html',
    is_featured: false
  },
  {
    name: '日本浮世絵博物館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.japan-ukiyoe-museum.com/',
    is_featured: false
  },
  {
    name: '松本市美術館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://matsumoto-artmuse.jp/',
    is_featured: false
  },
  {
    name: '松本市立博物館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://matsumoto-city-museum.jp/',
    is_featured: false
  },
  {
    name: '松本市立博物館分館　旧制高等学校記念館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-haku.com/koutougakkou/',
    is_featured: false
  },
  {
    name: '松本市立博物館分館　松本市立考古博物館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-haku.com/kouko/',
    is_featured: false
  },
  {
    name: '松本市立博物館分館　松本市歴史の里',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-haku.com/rekishinosato/',
    is_featured: false
  },
  {
    name: '小海町高原美術館',
    prefecture: '長野県',
    city: '南佐久郡小海町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.koumi-museum.com/',
    is_featured: false
  },
  {
    name: '岡谷蚕糸博物館',
    prefecture: '長野県',
    city: '岡谷市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://silkfact.jp/',
    is_featured: false
  },
  {
    name: '一茶記念館',
    prefecture: '長野県',
    city: '上水内郡信濃町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.issakinenkan.com/',
    is_featured: false
  },
  {
    name: '塩尻市立平出博物館',
    prefecture: '長野県',
    city: '塩尻市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://hiraide.shiojiri.com/',
    is_featured: false
  },
  {
    name: '信州大学教育学部附属志賀自然教育研究施設',
    prefecture: '長野県',
    city: '下高井郡山ノ内町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.shinshu-u.ac.jp/faculty/education/shiga/index.html',
    is_featured: false
  },
  {
    name: '京都造形芸術大学附属康耀堂美術館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.koyodo-museum.com/',
    is_featured: false
  },
  {
    name: '古代遺跡徳間博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '善光寺大勧進宝物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://daikanjin.jp/houbutsu/',
    is_featured: false
  },
  {
    name: '坂城町鉄の展示館',
    prefecture: '長野県',
    city: '埴科郡坂城町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tetsu-museum.info/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 岐阜県 (25件)
# ================================
puts '岐阜県のデータを投入中...'

[
  {
    name: '世界淡水魚園水族館',
    prefecture: '岐阜県',
    city: '各務原市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://aquatotto.com/',
    is_featured: false
  },
  {
    name: '内藤記念くすり博物館',
    prefecture: '岐阜県',
    city: '各務原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.eisai.co.jp/museum/information/index.html',
    is_featured: false
  },
  {
    name: '荒川豊蔵資料館',
    prefecture: '岐阜県',
    city: '可児市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kani.lg.jp/10013.htm',
    is_featured: false
  },
  {
    name: '岐阜県美術館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kenbi.pref.gifu.lg.jp/',
    is_featured: false
  },
  {
    name: '岐阜市科学館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.gifu.lg.jp/kankoubunka/kagakukan/index.html',
    is_featured: false
  },
  {
    name: '岐阜市歴史博物館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.rekihaku.gifu.gifu.jp/',
    is_featured: false
  },
  {
    name: '岐阜市歴史博物館分館　加藤栄三・東一記念美術館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.rekihaku.gifu.gifu.jp/katoukinen/',
    is_featured: false
  },
  {
    name: '岐阜市歴史博物館分室　原三渓記念室',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.rekihaku.gifu.gifu.jp/harasankei/',
    is_featured: false
  },
  {
    name: '三甲美術館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sanko-museum.or.jp/',
    is_featured: false
  },
  {
    name: '岐阜県博物館',
    prefecture: '岐阜県',
    city: '関市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.gifu-kenpaku.jp/',
    is_featured: false
  },
  {
    name: '光ミュージアム',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://h-am.jp/',
    is_featured: false
  },
  {
    name: '岐阜県現代陶芸美術館',
    prefecture: '岐阜県',
    city: '多治見市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.cpm-gifu.jp/museum/',
    is_featured: false
  },
  {
    name: '中津川市鉱物博物館',
    prefecture: '岐阜県',
    city: '中津川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.nakatsugawa.lg.jp/museum/m/index.html',
    is_featured: false
  },
  {
    name: '岐阜関ケ原古戦場記念館',
    prefecture: '岐阜県',
    city: '不破郡関ケ原町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sekigahara.pref.gifu.lg.jp',
    is_featured: false
  },
  {
    name: '瑞浪市化石博物館',
    prefecture: '岐阜県',
    city: '瑞浪市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.mizunami.lg.jp/kankou_bunka/1004960/kaseki_museum/index.html',
    is_featured: false
  },
  {
    name: '美濃加茂市民ミュージアム',
    prefecture: '岐阜県',
    city: '美濃加茂市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.forest.minokamo.gifu.jp/',
    is_featured: false
  },
  {
    name: '岐阜かかみがはら航空宇宙博物館',
    prefecture: '岐阜県',
    city: '各務原市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.sorahaku.net/',
    is_featured: false
  },
  {
    name: '下呂市下呂ふるさと歴史記念館',
    prefecture: '岐阜県',
    city: '下呂市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '高山祭屋台会館',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.hidahachimangu.jp/yataikaikan/welcome.html',
    is_featured: false
  },
  {
    name: '飛騨高山茶の湯の森',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.nakada-net.jp/chanoyu/',
    is_featured: false
  },
  {
    name: '飛騨高山まちの博物館',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.takayama.lg.jp/machihaku/',
    is_featured: false
  },
  {
    name: '飛騨高山まつりの森高山祭りミュージアム',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.togeihida.co.jp/',
    is_featured: false
  },
  {
    name: '飛騨高山まつりの森ちょうの館',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.togeihida.co.jp/sizen/',
    is_featured: false
  },
  {
    name: '飛騨民俗村',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://hidanosato.com/',
    is_featured: false
  },
  {
    name: '藤村記念館',
    prefecture: '岐阜県',
    city: '中津川市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://toson.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 静岡県 (46件)
# ================================
puts '静岡県のデータを投入中...'

[
  {
    name: 'ＭＯＡ美術館',
    prefecture: '静岡県',
    city: '熱海市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.moaart.or.jp/',
    is_featured: false
  },
  {
    name: '池田２０世紀美術館',
    prefecture: '静岡県',
    city: '伊東市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ikeda20.or.jp/',
    is_featured: false
  },
  {
    name: '崔如琢美術館',
    prefecture: '静岡県',
    city: '伊東市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yoko.or.jp/about/',
    is_featured: false
  },
  {
    name: '磐田市香りの博物館',
    prefecture: '静岡県',
    city: '磐田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.iwata-kaori.jp/',
    is_featured: false
  },
  {
    name: '掛川市二の丸美術館',
    prefecture: '静岡県',
    city: '掛川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://k-kousya.or.jp/ninomaru/',
    is_featured: false
  },
  {
    name: '一般財団法人　清水港湾博物館（フェルケール博物館）',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.verkehr-museum.jp/',
    is_featured: false
  },
  {
    name: '久能山東照宮博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.toshogu.or.jp/kt_museum/',
    is_featured: false
  },
  {
    name: '公益財団法人　駿府博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.sbs-bunkafukushi.com/museum/',
    is_featured: false
  },
  {
    name: '静岡県立美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://spmoa.shizuoka.shizuoka.jp/',
    is_featured: false
  },
  {
    name: '静岡市立芹沢銈介美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.seribi.jp/',
    is_featured: false
  },
  {
    name: '静岡市立登呂博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shizuoka-toromuseum.jp/',
    is_featured: false
  },
  {
    name: 'ふじのくに地球環境史ミュージアム',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.fujimu100.jp',
    is_featured: false
  },
  {
    name: '島田市博物館',
    prefecture: '静岡県',
    city: '島田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.shimada.shizuoka.jp/shimahaku',
    is_featured: false
  },
  {
    name: '上原美術館',
    prefecture: '静岡県',
    city: '下田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://uehara-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'ベルナール・ビュフェ美術館',
    prefecture: '静岡県',
    city: '駿東郡長泉町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.buffet-museum.jp/',
    is_featured: false
  },
  {
    name: '月光天文台',
    prefecture: '静岡県',
    city: '田方郡函南町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://gekkou.or.jp/',
    is_featured: false
  },
  {
    name: '沼津市戸田造船郷土資料博物館',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.numazu.shizuoka.jp/kurashi/shisetsu/zosen/',
    is_featured: false
  },
  {
    name: '沼津市明治史料館',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.numazu.shizuoka.jp/kurashi/shisetsu/meiji/',
    is_featured: false
  },
  {
    name: '沼津市歴史民俗資料館',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.numazu.shizuoka.jp/kurashi/shisetsu/rekishiminzoku/',
    is_featured: false
  },
  {
    name: '公益財団法人　平野美術館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hirano-museum.jp/index.html',
    is_featured: false
  },
  {
    name: '浜松科学館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.mirai-ra.jp',
    is_featured: false
  },
  {
    name: '浜松市秋野不矩美術館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.akinofuku-museum.jp/',
    is_featured: false
  },
  {
    name: '浜松市博物館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hamamatsu.shizuoka.jp/hamahaku/',
    is_featured: false
  },
  {
    name: '浜松市美術館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hamamatsu.shizuoka.jp/artmuse/',
    is_featured: false
  },
  {
    name: '藤枝市郷土博物館',
    prefecture: '静岡県',
    city: '藤枝市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.fujieda.shizuoka.jp/kyodomuse/index.html',
    is_featured: false
  },
  {
    name: '富士山かぐや姫ミュージアム（富士市立博物館）',
    prefecture: '静岡県',
    city: '富士市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.city.fuji.shizuoka.jp/',
    is_featured: false
  },
  {
    name: '奇石博物館',
    prefecture: '静岡県',
    city: '富士宮市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.kiseki-jp.com/',
    is_featured: false
  },
  {
    name: '公益社団法人佐野美術館',
    prefecture: '静岡県',
    city: '三島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sanobi.or.jp/',
    is_featured: false
  },
  {
    name: '三島市郷土資料館',
    prefecture: '静岡県',
    city: '三島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.mishima.shizuoka.jp/kyoudo/',
    is_featured: false
  },
  {
    name: '伊豆シャボテン公園',
    prefecture: '静岡県',
    city: '伊東市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://izushaboten.com/',
    is_featured: false
  },
  {
    name: '磐田市旧見付学校',
    prefecture: '静岡県',
    city: '磐田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.iwata.shizuoka.jp/shisetsu_guide/toshokan_bunka/tenji/1003509.html',
    is_featured: false
  },
  {
    name: '体感型動物園iZoo',
    prefecture: '静岡県',
    city: '賀茂郡河津町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://izoo.co.jp/',
    is_featured: false
  },
  {
    name: '熱川バナナワニ園',
    prefecture: '静岡県',
    city: '賀茂郡東伊豆町',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'http://bananawani.jp/',
    is_featured: false
  },
  {
    name: '静岡市東海道広重美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://tokaido-hiroshige.jp/',
    is_featured: false
  },
  {
    name: '静岡市美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://shizubi.jp/',
    is_featured: false
  },
  {
    name: '静岡市歴史博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://scmh.jp/',
    is_featured: false
  },
  {
    name: '東海大学海洋科学博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.umi.muse-tokai.jp/',
    is_featured: false
  },
  {
    name: '東海大学自然史博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.sizen.muse-tokai.jp/',
    is_featured: false
  },
  {
    name: '下田海中水族館',
    prefecture: '静岡県',
    city: '下田市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://shimoda-aquarium.com/',
    is_featured: false
  },
  {
    name: '富士自然動物公園　富士サファリパーク',
    prefecture: '静岡県',
    city: '裾野市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.fujisafari.co.jp/',
    is_featured: false
  },
  {
    name: '伊豆三津シーパラダイス',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.mitosea.com/',
    is_featured: false
  },
  {
    name: '浜名湖オルゴールミュージアム',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.hamanako-orgel.jp/',
    is_featured: false
  },
  {
    name: '浜松市楽器博物館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.gakkihaku.jp/',
    is_featured: false
  },
  {
    name: '浜松市動物園',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://hamazoo.net/',
    is_featured: false
  },
  {
    name: '三嶋大社宝物館',
    prefecture: '静岡県',
    city: '三島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://mishimataisha.or.jp/treasure/',
    is_featured: false
  },
  {
    name: '焼津市歴史民俗資料館',
    prefecture: '静岡県',
    city: '焼津市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.yaizu.lg.jp/museum/rekimin/index.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 愛知県 (49件)
# ================================
puts '愛知県のデータを投入中...'

[
  {
    name: '安城市歴史博物館',
    prefecture: '愛知県',
    city: '安城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.ansyobunka.jp/',
    is_featured: false
  },
  {
    name: '一宮市博物館',
    prefecture: '愛知県',
    city: '一宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.icm-jp.com/',
    is_featured: false
  },
  {
    name: '稲沢市荻須記念美術館',
    prefecture: '愛知県',
    city: '稲沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.city.inazawa.aichi.jp/museum/',
    is_featured: false
  },
  {
    name: '公益財団法人日本モンキーセンター',
    prefecture: '愛知県',
    city: '犬山市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.j-monkey.jp/',
    is_featured: false
  },
  {
    name: '博物館明治村',
    prefecture: '愛知県',
    city: '犬山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.meijimura.com/',
    is_featured: false
  },
  {
    name: '岡崎市美術博物館',
    prefecture: '愛知県',
    city: '岡崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.okazaki.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '刈谷市歴史博物館',
    prefecture: '愛知県',
    city: '刈谷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kariya.lg.jp/rekihaku/',
    is_featured: false
  },
  {
    name: '高浜市やきものの里かわら美術館・図書館',
    prefecture: '愛知県',
    city: '高浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.takahama-kawara-museum.com/index.html',
    is_featured: false
  },
  {
    name: '田原市博物館',
    prefecture: '愛知県',
    city: '田原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.taharamuseum.gr.jp/',
    is_featured: false
  },
  {
    name: '豊田市美術館',
    prefecture: '愛知県',
    city: '豊田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.museum.toyota.aichi.jp/',
    is_featured: false
  },
  {
    name: '豊橋市自然史博物館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.toyohaku.gr.jp/sizensi/',
    is_featured: false
  },
  {
    name: '豊橋市地下資源館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.toyohaku.gr.jp/chika/',
    is_featured: false
  },
  {
    name: '豊橋市美術博物館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.toyohashi-bihaku.jp/',
    is_featured: false
  },
  {
    name: '豊橋市二川宿本陣資料館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://futagawa-honjin.jp/',
    is_featured: false
  },
  {
    name: '豊橋総合動植物公園',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '動・水・植物園',
    official_website: 'https://www.nonhoi.jp',
    is_featured: false
  },
  {
    name: '名都美術館',
    prefecture: '愛知県',
    city: '長久手市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.meito.hayatele.co.jp/',
    is_featured: false
  },
  {
    name: '熱田神宮宝物館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.atsutajingu.or.jp/houmotukan_kusanagi/houmotukan/',
    is_featured: false
  },
  {
    name: '荒木集成館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.arakishuseikan.ecweb.jp/',
    is_featured: false
  },
  {
    name: '桑山美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kuwayama-museum.jp/',
    is_featured: false
  },
  {
    name: '昭和美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shouwa-museum.com/index.html',
    is_featured: false
  },
  {
    name: '唐九郎記念館（翠松園陶芸記念館）',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.nagoya.jp/moriyama/page/0000001531.html',
    is_featured: false
  },
  {
    name: '徳川美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tokugawa-art-museum.jp/',
    is_featured: false
  },
  {
    name: '名古屋市科学館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.ncsm.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '名古屋市博物館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.museum.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '名古屋市美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://art-museum.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '名古屋市見晴台考古資料館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.nagoya.jp/kurashi/category/19-15-2-8-0-0-0-0-0-0.html',
    is_featured: false
  },
  {
    name: '古川美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.furukawa-museum.or.jp/',
    is_featured: false
  },
  {
    name: '横山美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yokoyama-art-museum.or.jp/',
    is_featured: false
  },
  {
    name: '楽只美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.mc.ccnw.ne.jp/nagoya-taikan/rakusi.html',
    is_featured: false
  },
  {
    name: '西尾市岩瀬文庫',
    prefecture: '愛知県',
    city: '西尾市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://iwasebunko.jp/',
    is_featured: false
  },
  {
    name: '公益財団法人かみや美術館',
    prefecture: '愛知県',
    city: '半田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kamiya-muse.or.jp/',
    is_featured: false
  },
  {
    name: '半田市立博物館',
    prefecture: '愛知県',
    city: '半田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.handa.lg.jp/bunka/bunkashisetsu/1002704/index.html',
    is_featured: false
  },
  {
    name: '碧南海浜水族館',
    prefecture: '愛知県',
    city: '碧南市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.city.hekinan.lg.jp/aquarium/index.html',
    is_featured: false
  },
  {
    name: '碧南市藤井達吉現代美術館',
    prefecture: '愛知県',
    city: '碧南市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hekinan.lg.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '野外民族博物館リトルワールド',
    prefecture: '愛知県',
    city: '犬山市',
    registration_type: '指定施設',
    museum_type: '野外博物館',
    official_website: 'https://www.littleworld.jp/',
    is_featured: false
  },
  {
    name: '春日井市道風記念館',
    prefecture: '愛知県',
    city: '春日井市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kasugai.lg.jp/shisei/shisetsu/bunka/tofu/index.html',
    is_featured: false
  },
  {
    name: '中部大学民族資料博物館',
    prefecture: '愛知県',
    city: '春日井市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.chubu.ac.jp/student-life/facilities/museum/',
    is_featured: false
  },
  {
    name: '刈谷市美術館',
    prefecture: '愛知県',
    city: '刈谷市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kariya.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '愛知県陶磁美術館',
    prefecture: '愛知県',
    city: '瀬戸市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.pref.aichi.jp/touji/',
    is_featured: false
  },
  {
    name: '瀬戸蔵ミュージアム',
    prefecture: '愛知県',
    city: '瀬戸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.seto.aichi.jp/docs/2011/03/15/00092/',
    is_featured: false
  },
  {
    name: '瀬戸市美術館',
    prefecture: '愛知県',
    city: '瀬戸市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.seto-cul.jp/seto-museum/',
    is_featured: false
  },
  {
    name: '南知多ビーチランド',
    prefecture: '愛知県',
    city: '知多郡美浜町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://beachland.jp/',
    is_featured: false
  },
  {
    name: 'INAXライブミュージアム',
    prefecture: '愛知県',
    city: '常滑市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://livingculture.lixil.com/ilm/',
    is_featured: false
  },
  {
    name: '愛知県立芸術大学芸術資料館・法隆寺金堂壁画模写展示館',
    prefecture: '愛知県',
    city: '長久手市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.aichi-fam-u.ac.jp/#top',
    is_featured: false
  },
  {
    name: '愛知芸術文化センター愛知県美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www-art.aac.pref.aichi.jp/',
    is_featured: false
  },
  {
    name: '戦争と平和の資料館ピースあいち',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://peace-aichi.com/',
    is_featured: false
  },
  {
    name: '名古屋港水族館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://nagoyaaqua.jp/',
    is_featured: false
  },
  {
    name: '名古屋市東山動植物園',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.higashiyama.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '南山大学人類学博物館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://rci.nanzan-u.ac.jp/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 三重県 (20件)
# ================================
puts '三重県のデータを投入中...'

[
  {
    name: '伊賀流忍者博物館',
    prefecture: '三重県',
    city: '伊賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.iganinja.jp/',
    is_featured: false
  },
  {
    name: '神宮徴古館農業館・式年遷宮記念せんぐう館',
    prefecture: '三重県',
    city: '伊勢市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://museum.isejingu.or.jp/index.html',
    is_featured: false
  },
  {
    name: '式年遷宮記念神宮美術館',
    prefecture: '三重県',
    city: '伊勢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://museum.isejingu.or.jp/artmuseum/index.html',
    is_featured: false
  },
  {
    name: '亀山市歴史博物館',
    prefecture: '三重県',
    city: '亀山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://kameyamarekihaku.jp/',
    is_featured: false
  },
  {
    name: '桑名市博物館',
    prefecture: '三重県',
    city: '桑名市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kuwana.lg.jp/shisetsu/bunka/005.html',
    is_featured: false
  },
  {
    name: '鈴鹿市考古博物館',
    prefecture: '三重県',
    city: '鈴鹿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.suzuka.lg.jp/kouko/',
    is_featured: false
  },
  {
    name: '斎宮歴史博物館',
    prefecture: '三重県',
    city: '多気郡明和町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bunka.pref.mie.lg.jp/saiku/',
    is_featured: false
  },
  {
    name: '石水博物館',
    prefecture: '三重県',
    city: '津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sekisui-museum.or.jp/',
    is_featured: false
  },
  {
    name: '三重県総合博物館',
    prefecture: '三重県',
    city: '津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.bunka.pref.mie.lg.jp/MieMu/',
    is_featured: false
  },
  {
    name: '三重県立美術館',
    prefecture: '三重県',
    city: '津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.bunka.pref.mie.lg.jp/art-museum/index.shtm',
    is_featured: false
  },
  {
    name: '鳥羽市立海の博物館',
    prefecture: '三重県',
    city: '鳥羽市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.umihaku.com/',
    is_featured: false
  },
  {
    name: '鳥羽水族館',
    prefecture: '三重県',
    city: '鳥羽市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://aquarium.co.jp/',
    is_featured: false
  },
  {
    name: '松浦武四郎記念館',
    prefecture: '三重県',
    city: '松阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://takeshiro.net/',
    is_featured: false
  },
  {
    name: '松阪市文化財センター',
    prefecture: '三重県',
    city: '松阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.matsusaka.mie.jp/site/bunkazai-center/',
    is_featured: false
  },
  {
    name: '本居宣長記念館',
    prefecture: '三重県',
    city: '松阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.norinagakinenkan.com/',
    is_featured: false
  },
  {
    name: '朝日町歴史博物館',
    prefecture: '三重県',
    city: '三重郡朝日町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://asahitown-museum.com/',
    is_featured: false
  },
  {
    name: 'パラミタ・ミュージアム',
    prefecture: '三重県',
    city: '三重郡菰野町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.paramitamuseum.com/top.html',
    is_featured: false
  },
  {
    name: '澄懐堂美術館',
    prefecture: '三重県',
    city: '四日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chokaido.jp/',
    is_featured: false
  },
  {
    name: '四日市市立博物館',
    prefecture: '三重県',
    city: '四日市市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.yokkaichi.mie.jp/museum/museum.html',
    is_featured: false
  },
  {
    name: '伊勢夫婦岩ふれあい水族館シーパラダイス',
    prefecture: '三重県',
    city: '伊勢市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://ise-seaparadise.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 滋賀県 (20件)
# ================================
puts '滋賀県のデータを投入中...'

[
  {
    name: '愛荘町立歴史文化博物館',
    prefecture: '滋賀県',
    city: '愛知郡愛荘町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.aisho.shiga.jp/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '滋賀県立安土城考古博物館',
    prefecture: '滋賀県',
    city: '近江八幡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://azuchi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '大津市歴史博物館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.rekihaku.otsu.shiga.jp/',
    is_featured: false
  },
  {
    name: '木下美術館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kinoshita-museum.com/',
    is_featured: false
  },
  {
    name: '滋賀県立美術館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shigamuseum.jp/',
    is_featured: false
  },
  {
    name: '膳所焼美術館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://zezeyaki.or.jp/',
    is_featured: false
  },
  {
    name: '滋賀県立琵琶湖博物館',
    prefecture: '滋賀県',
    city: '草津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.biwahaku.jp/',
    is_featured: false
  },
  {
    name: '滋賀県立陶芸の森',
    prefecture: '滋賀県',
    city: '甲賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sccp.jp',
    is_featured: false
  },
  {
    name: 'ＭＩＨＯ　ＭＵＳＥＵＭ',
    prefecture: '滋賀県',
    city: '甲賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miho.jp/',
    is_featured: false
  },
  {
    name: '長浜市長浜城歴史博物館',
    prefecture: '滋賀県',
    city: '長浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nagahama-rekihaku.jp',
    is_featured: false
  },
  {
    name: '観峰館',
    prefecture: '滋賀県',
    city: '東近江市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kampokan.com/',
    is_featured: false
  },
  {
    name: '日登美美術館',
    prefecture: '滋賀県',
    city: '東近江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sam.shiga.jp/%E8%B2%A1%E5%9B%A3%E6%B3%95%E4%BA%BA-%E6%97%A5%E7%99%BB%E7%BE%8E%E7%BE%8E%E8%A1%93%E9%A4%A8/',
    is_featured: false
  },
  {
    name: '彦根城博物館',
    prefecture: '滋賀県',
    city: '彦根市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hikone-castle-museum.jp/',
    is_featured: false
  },
  {
    name: '佐川美術館',
    prefecture: '滋賀県',
    city: '守山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sagawa-artmuseum.or.jp/',
    is_featured: false
  },
  {
    name: '野洲市歴史民俗博物館・銅鐸博物館',
    prefecture: '滋賀県',
    city: '野洲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.yasu.lg.jp/soshiki/rekishiminzoku/museum.html',
    is_featured: false
  },
  {
    name: '栗東歴史民俗博物館',
    prefecture: '滋賀県',
    city: '栗東市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.ritto.lg.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: 'ボーダレス・アートミュージアムＮＯーＭＡ',
    prefecture: '滋賀県',
    city: '近江八幡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.no-ma.jp/',
    is_featured: false
  },
  {
    name: '近江神宮時計館宝物館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://oumijingu.org/pages/98/',
    is_featured: false
  },
  {
    name: '田上鉱物博物館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: '',
    is_featured: false
  },
  {
    name: '滋賀大学経済学部附属史料館',
    prefecture: '滋賀県',
    city: '彦根市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.econ.shiga-u.ac.jp/shiryo/10/1/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 京都府 (54件)
# ================================
puts '京都府のデータを投入中...'

[
  {
    name: ' 平等院ミュージアム鳳翔館',
    prefecture: '京都府',
    city: '宇治市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.byodoin.or.jp/museum/',
    is_featured: false
  },
  {
    name: 'アサヒグループ大山崎山荘美術館',
    prefecture: '京都府',
    city: '乙訓郡大山崎町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.asahigroup-oyamazaki.com/',
    is_featured: false
  },
  {
    name: '京都府立山城郷土資料館',
    prefecture: '京都府',
    city: '木津川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.kyoto-be.ne.jp/yamasiro-m/cms/',
    is_featured: false
  },
  {
    name: '大西清右衛門美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: '',
    is_featured: false
  },
  {
    name: '角屋もてなしの文化美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sumiyaho.sakura.ne.jp/',
    is_featured: false
  },
  {
    name: '漢検　漢字博物館・図書館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanjimuseum.kyoto/',
    is_featured: false
  },
  {
    name: '北村美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitamura-museum.com/',
    is_featured: false
  },
  {
    name: '京都市青少年科学センター',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.edu.city.kyoto.jp/science/',
    is_featured: false
  },
  {
    name: '京都市動物園',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://zoo.city.kyoto.lg.jp/zoo/',
    is_featured: false
  },
  {
    name: '京都府京都文化博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bunpaku.or.jp/',
    is_featured: false
  },
  {
    name: '高麗美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.koryomuseum.or.jp/',
    is_featured: false
  },
  {
    name: '嵯峨嵐山文華館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.samac.jp/',
    is_featured: false
  },
  {
    name: '茶道資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.urasenke.or.jp/textc/kon/gallery.html',
    is_featured: false
  },
  {
    name: '島津製作所 創業記念資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shimadzu.co.jp/memorial-museum/',
    is_featured: false
  },
  {
    name: '白沙村荘　橋本関雪記念館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hakusasonso.jp/',
    is_featured: false
  },
  {
    name: '泉屋博古館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sen-oku.or.jp/',
    is_featured: false
  },
  {
    name: '武田薬品工業株式会社 京都薬用植物園',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.takeda.co.jp/kyoto/',
    is_featured: false
  },
  {
    name: '並河靖之七宝記念館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://namikawa-kyoto.jp',
    is_featured: false
  },
  {
    name: '日図デザイン博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nichizu.or.jp/?cat=5',
    is_featured: false
  },
  {
    name: '野村美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nomura-museum.or.jp/',
    is_featured: false
  },
  {
    name: '博物館さがの人形の家',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://sagano.or.jp/',
    is_featured: false
  },
  {
    name: '風俗博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.iz2.or.jp/',
    is_featured: false
  },
  {
    name: '福田美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fukuda-art-museum.jp/',
    is_featured: false
  },
  {
    name: '細見美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.emuseum.or.jp/',
    is_featured: false
  },
  {
    name: '樂美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.raku-yaki.or.jp/museum/',
    is_featured: false
  },
  {
    name: '霊山歴史館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.ryozen-museum.or.jp/',
    is_featured: false
  },
  {
    name: '京都府立丹後郷土資料館',
    prefecture: '京都府',
    city: '宮津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kyoto-be.ne.jp/tango-m/cms/',
    is_featured: false
  },
  {
    name: '永守コレクションギャラリー',
    prefecture: '京都府',
    city: '向日市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nagamori-gallery.org/',
    is_featured: false
  },
  {
    name: '宇治市歴史資料館',
    prefecture: '京都府',
    city: '宇治市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.uji.kyoto.jp/soshiki/89/',
    is_featured: false
  },
  {
    name: '同志社大学歴史資料館',
    prefecture: '京都府',
    city: '京田辺市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://hmuseum.doshisha.ac.jp/',
    is_featured: false
  },
  {
    name: 'KCIギャラリー',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kci.or.jp/gallery/',
    is_featured: false
  },
  {
    name: '大谷大学博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.otani.ac.jp/kyo_kikan/museum/index.html',
    is_featured: false
  },
  {
    name: '京都芸術大学芸術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kyoto-geijutsu-kan.com/',
    is_featured: false
  },
  {
    name: '京都工芸繊維大学美術工芸資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.museum.kit.ac.jp/',
    is_featured: false
  },
  {
    name: '京都国立近代美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.momak.go.jp/',
    is_featured: false
  },
  {
    name: '京都国立博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.kyohaku.go.jp/jp/',
    is_featured: false
  },
  {
    name: '京都産業大学ギャラリー',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kyoto-su.ac.jp/facilities/musubiwaza/gallery/',
    is_featured: false
  },
  {
    name: '京都産業大学神山天文台',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kyoto-su.ac.jp/observatory/',
    is_featured: false
  },
  {
    name: '京都市学校歴史博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://kyo-gakurehaku.jp/',
    is_featured: false
  },
  {
    name: '京都市京セラ美術館（京都市美術館）',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kyotocity-kyocera.museum/',
    is_featured: false
  },
  {
    name: '京都市立芸術大学芸術資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://libmuse.kcua.ac.jp/muse/',
    is_featured: false
  },
  {
    name: '京都精華大学ギャラリー',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://gallery.kyoto-seika.ac.jp/',
    is_featured: false
  },
  {
    name: '京都大学総合博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.museum.kyoto-u.ac.jp/',
    is_featured: false
  },
  {
    name: '京都鉄道博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kyotorailwaymuseum.jp/',
    is_featured: false
  },
  {
    name: '嵯峨美術大学・嵯峨美術短期大学附属博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kyoto-saga.ac.jp/about/museum/',
    is_featured: false
  },
  {
    name: '醍醐寺霊宝館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.daigoji.or.jp/grounds/reihoukan.html',
    is_featured: false
  },
  {
    name: '花園大学歴史博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.hanazono.ac.jp/about/museum.html',
    is_featured: false
  },
  {
    name: '佛教大学宗教文化ミュージアム',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.bukkyo-u.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '養源院',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://yougenin.jp/',
    is_featured: false
  },
  {
    name: '立命館大学国際平和ミュージアム',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://rwp-museum.jp/',
    is_featured: false
  },
  {
    name: '龍谷大学龍谷ミュージアム',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://museum.ryukoku.ac.jp/',
    is_featured: false
  },
  {
    name: '龍安寺',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.ryoanji.jp/smph/',
    is_featured: false
  },
  {
    name: '京都大学フィールド科学教育研究センター舞鶴水産実験所水産生物標本館',
    prefecture: '京都府',
    city: '舞鶴市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.maizuru.marine.kais.kyoto-u.ac.jp/',
    is_featured: false
  },
  {
    name: '舞鶴引揚記念館',
    prefecture: '京都府',
    city: '舞鶴市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://m-hikiage-museum.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 大阪府 (41件)
# ================================
puts '大阪府のデータを投入中...'

[
  {
    name: '逸翁美術館',
    prefecture: '大阪府',
    city: '池田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hankyu-bunka.or.jp/itsuo-museum/',
    is_featured: false
  },
  {
    name: '和泉市久保惣記念美術館',
    prefecture: '大阪府',
    city: '和泉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ikm-art.jp/',
    is_featured: false
  },
  {
    name: '大阪府立弥生文化博物館',
    prefecture: '大阪府',
    city: '和泉市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://yayoi-bunka.com/',
    is_featured: false
  },
  {
    name: '大阪市立科学館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.sci-museum.jp/',
    is_featured: false
  },
  {
    name: '大阪市立自然史博物館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://omnh.jp/',
    is_featured: false
  },
  {
    name: '大阪市立東洋陶磁美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.moco.or.jp/',
    is_featured: false
  },
  {
    name: '大阪市立美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.osaka-art-museum.jp/',
    is_featured: false
  },
  {
    name: '大阪中之島美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nakka-art.jp/',
    is_featured: false
  },
  {
    name: '大阪歴史博物館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.osakamushis.jp/',
    is_featured: false
  },
  {
    name: '中之島香雪美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kosetsu-museum.or.jp/nakanoshima/',
    is_featured: false
  },
  {
    name: '藤田美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fujita-museum.or.jp/',
    is_featured: false
  },
  {
    name: '湯木美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yuki-museum.or.jp/',
    is_featured: false
  },
  {
    name: '貝塚市立自然遊学館',
    prefecture: '大阪府',
    city: '貝塚市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.kaizuka.lg.jp/shizen/index.html',
    is_featured: false
  },
  {
    name: '小谷城郷土館',
    prefecture: '大阪府',
    city: '堺市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.kotanijo.jp/',
    is_featured: false
  },
  {
    name: '堺市博物館',
    prefecture: '大阪府',
    city: '堺市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sakai.lg.jp/kanko/hakubutsukan/',
    is_featured: false
  },
  {
    name: 'シマノ自転車博物館',
    prefecture: '大阪府',
    city: '堺市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bikemuse.jp/',
    is_featured: false
  },
  {
    name: '吹田市立博物館',
    prefecture: '大阪府',
    city: '吹田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.suita.osaka.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '正木美術館',
    prefecture: '大阪府',
    city: '泉北郡忠岡町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://masaki-art-museum.jp/',
    is_featured: false
  },
  {
    name: '高槻市立今城塚古代歴史館',
    prefecture: '大阪府',
    city: '高槻市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takatsuki.osaka.jp/site/history/list8.html',
    is_featured: false
  },
  {
    name: '高槻市立しろあと歴史館',
    prefecture: '大阪府',
    city: '高槻市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takatsuki.osaka.jp/site/history/4653.html',
    is_featured: false
  },
  {
    name: '奥内陶芸美術館',
    prefecture: '大阪府',
    city: '豊中市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.okuuchi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '日本民家集落博物館',
    prefecture: '大阪府',
    city: '豊中市',
    registration_type: '登録博物館',
    museum_type: '野外博物館',
    official_website: 'https://www.occh.or.jp/minka/',
    is_featured: false
  },
  {
    name: '司馬遼太郎記念館',
    prefecture: '大阪府',
    city: '東大阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shibazaidan.or.jp/',
    is_featured: false
  },
  {
    name: '東大阪市立郷土博物館',
    prefecture: '大阪府',
    city: '東大阪市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.higashiosaka.lg.jp/0000003607.html',
    is_featured: false
  },
  {
    name: '大阪府立近つ飛鳥博物館',
    prefecture: '大阪府',
    city: '南河内郡河南町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.chikatsu-asuka.jp/',
    is_featured: false
  },
  {
    name: '太子町立竹内街道歴史資料館',
    prefecture: '大阪府',
    city: '南河内郡太子町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.taishi.osaka.jp/busyo/kyouiku_jimu/syougaigakusyuuka/ivent3/shiryoukan.html',
    is_featured: false
  },
  {
    name: '泉佐野市立歴史館いずみさの',
    prefecture: '大阪府',
    city: '泉佐野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.occh.or.jp/?s=event/izumisano/',
    is_featured: false
  },
  {
    name: 'あべのハルカス美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.aham.jp/',
    is_featured: false
  },
  {
    name: '海遊館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.kaiyukan.com/',
    is_featured: false
  },
  {
    name: '大阪国際平和センター（ピースおおさか）',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.peace-osaka.or.jp/',
    is_featured: false
  },
  {
    name: '大阪城天守閣',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osakacastle.net/',
    is_featured: false
  },
  {
    name: '大阪市立住まいのミュージアム（大阪くらしの今昔館）',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osaka-angenet.jp/konjyakukan/',
    is_featured: false
  },
  {
    name: '国立国際美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.nmao.go.jp/',
    is_featured: false
  },
  {
    name: '天王寺動物園',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tennojizoo.jp/',
    is_featured: false
  },
  {
    name: 'きしわだ自然資料館',
    prefecture: '大阪府',
    city: '岸和田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.city.kishiwada.osaka.jp/site/shizenshi/',
    is_featured: false
  },
  {
    name: '関西大学博物館',
    prefecture: '大阪府',
    city: '吹田市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.kansai-u.ac.jp/Museum/',
    is_featured: false
  },
  {
    name: '高槻市立自然博物館（あくあぴあ芥川）',
    prefecture: '大阪府',
    city: '高槻市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'http://www.aquapia.net/',
    is_featured: false
  },
  {
    name: '大阪大谷大学博物館',
    prefecture: '大阪府',
    city: '富田林市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osaka-ohtani.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '大阪商業大学商業史博物館',
    prefecture: '大阪府',
    city: '東大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://ouc.daishodai.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '大阪芸術大学博物館',
    prefecture: '大阪府',
    city: '南河内郡河南町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.osaka-geidai.ac.jp/guide/museum',
    is_featured: false
  },
  {
    name: '八尾市立歴史民俗資料館',
    prefecture: '大阪府',
    city: '八尾市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://rekimin-yao.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 兵庫県 (48件)
# ================================
puts '兵庫県のデータを投入中...'

[
  {
    name: '芦屋市立美術博物館',
    prefecture: '兵庫県',
    city: '芦屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ashiya-museum.jp/',
    is_featured: false
  },
  {
    name: '滴翠美術館',
    prefecture: '兵庫県',
    city: '芦屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://tekisui-museum.biz-web.jp/',
    is_featured: false
  },
  {
    name: '俵美術館',
    prefecture: '兵庫県',
    city: '芦屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tawara-museum.or.jp/',
    is_featured: false
  },
  {
    name: '尼崎市立歴史博物館',
    prefecture: '兵庫県',
    city: '尼崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.archives.city.amagasaki.hyogo.jp/museum/',
    is_featured: false
  },
  {
    name: '市立伊丹ミュージアム',
    prefecture: '兵庫県',
    city: '伊丹市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://itami-im.jp/',
    is_featured: false
  },
  {
    name: '兵庫県立考古博物館　兵庫県立考古博物館加西分館（古代鏡展示館）',
    prefecture: '兵庫県',
    city: '加古郡播磨町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.hyogo-koukohaku.jp/',
    is_featured: false
  },
  {
    name: '切手文化博物館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kitte-museum-arima.jp/',
    is_featured: false
  },
  {
    name: '香雪美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kosetsu-museum.or.jp/',
    is_featured: false
  },
  {
    name: '神戸市立小磯記念美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kobe.lg.jp/kanko/bunka/bunkashisetsu/koisogallery/index.html',
    is_featured: false
  },
  {
    name: '神戸市立博物館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kobecitymuseum.jp/',
    is_featured: false
  },
  {
    name: '竹中大工道具館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.dougukan.jp/',
    is_featured: false
  },
  {
    name: '白鶴美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hakutsuru-museum.org/',
    is_featured: false
  },
  {
    name: '兵庫県立美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.artm.pref.hyogo.jp/',
    is_featured: false
  },
  {
    name: '兵庫県立兵庫津ミュージアム',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hyogo-no-tsu.jp',
    is_featured: false
  },
  {
    name: '兵庫県立人と自然の博物館',
    prefecture: '兵庫県',
    city: '三田市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.hitohaku.jp/',
    is_featured: false
  },
  {
    name: '鉄斎美術館',
    prefecture: '兵庫県',
    city: '宝塚市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kiyoshikojin.or.jp/tessai_museum/',
    is_featured: false
  },
  {
    name: 'たつの市立龍野歴史文化資料館',
    prefecture: '兵庫県',
    city: 'たつの市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tatsuno.lg.jp/kanko-bunka-sports/rekishibunkashiryokan/index.html',
    is_featured: false
  },
  {
    name: '玄武洞ミュージアム',
    prefecture: '兵庫県',
    city: '豊岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://genbudo-museum.jp/',
    is_featured: false
  },
  {
    name: '豊岡市立歴史博物館─但馬国府・国分寺館─',
    prefecture: '兵庫県',
    city: '豊岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www3.city.toyooka.lg.jp/kokubunjikan/',
    is_featured: false
  },
  {
    name: '辰馬考古資料館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hakutaka.jp/tatsuuma.html',
    is_featured: false
  },
  {
    name: '公益財団法人　西宮市大谷記念美術館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://otanimuseum.jp/',
    is_featured: false
  },
  {
    name: '西宮市立郷土資料館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nishi.or.jp/bunka/rekishitobunkazai/ritsukyodoshiryokan/index.html',
    is_featured: false
  },
  {
    name: '白鹿記念酒造博物館（酒ミュージアム）',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sake-museum.jp/',
    is_featured: false
  },
  {
    name: '堀江オルゴール博物館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.orgel-horie.or.jp/main/',
    is_featured: false
  },
  {
    name: '武庫川女子大学附属総合ミュージアム',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.mukogawa-u.ac.jp/~museum/',
    is_featured: false
  },
  {
    name: '姫路市立美術館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.himeji.lg.jp/art/',
    is_featured: false
  },
  {
    name: '姫路文学館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.himejibungakukan.jp/',
    is_featured: false
  },
  {
    name: '兵庫県立歴史博物館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://rekihaku.pref.hyogo.lg.jp/',
    is_featured: false
  },
  {
    name: '三木美術館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miki-m.jp',
    is_featured: false
  },
  {
    name: '南あわじ市滝川記念美術館　玉青館',
    prefecture: '兵庫県',
    city: '南あわじ市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.minamiawaji.hyogo.jp/soshiki/gyokuseikan/main.html',
    is_featured: false
  },
  {
    name: '明石市立天文科学館',
    prefecture: '兵庫県',
    city: '明石市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.am12.jp/',
    is_featured: false
  },
  {
    name: '伊丹市昆虫館',
    prefecture: '兵庫県',
    city: '伊丹市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.itakon.com/',
    is_featured: false
  },
  {
    name: '太子町立歴史資料館',
    prefecture: '兵庫県',
    city: '揖保郡太子町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.hyogo-taishi.lg.jp/soshikikarasagasu/rekisisiryo/index.html',
    is_featured: false
  },
  {
    name: '小野市立好古館',
    prefecture: '兵庫県',
    city: '小野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.ono.hyogo.jp/soshikikarasagasu/kokokan/index.html',
    is_featured: false
  },
  {
    name: '大阪青山歴史文学博物館',
    prefecture: '兵庫県',
    city: '川西市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osaka-aoyama.ac.jp/facility/museum/',
    is_featured: false
  },
  {
    name: 'ROKKO森の音ミュージアム',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.rokkosan.com/museum/',
    is_featured: false
  },
  {
    name: '神戸市立王子動物園',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://www.kobe-ojizoo.jp/',
    is_featured: false
  },
  {
    name: '神戸市立森林植物園',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.kobe-park.or.jp/shinrin/',
    is_featured: false
  },
  {
    name: '六甲高山植物園',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.rokkosan.com/hana/',
    is_featured: false
  },
  {
    name: '兵庫陶芸美術館',
    prefecture: '兵庫県',
    city: '丹波篠山市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.mcart.jp/',
    is_featured: false
  },
  {
    name: '城崎マリンワールド',
    prefecture: '兵庫県',
    city: '豊岡市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://marineworld.hiyoriyama.co.jp/',
    is_featured: false
  },
  {
    name: '関西学院大学博物館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.kwansei.ac.jp/museum',
    is_featured: false
  },
  {
    name: '西宮市貝類館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.nishi.or.jp/bunka/bunka/kairuikan/index.html',
    is_featured: false
  },
  {
    name: '日本玩具博物館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://japan-toy-museum.org/',
    is_featured: false
  },
  {
    name: '姫路科学館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.city.himeji.lg.jp/atom/',
    is_featured: false
  },
  {
    name: '姫路市立水族館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.city.himeji.lg.jp/aqua/',
    is_featured: false
  },
  {
    name: '姫路市立動物園',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.himeji.lg.jp/dobutuen/',
    is_featured: false
  },
  {
    name: '但馬牛博物館',
    prefecture: '兵庫県',
    city: '美方郡新温泉町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tajimabokujyo.jp/?page_id=3',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 奈良県 (22件)
# ================================
puts '奈良県のデータを投入中...'

[
  {
    name: '大亀和尚民芸館',
    prefecture: '奈良県',
    city: '宇陀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://daiki-mingeikan.or.jp/',
    is_featured: false
  },
  {
    name: '香芝市二上山博物館',
    prefecture: '奈良県',
    city: '香芝市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kashiba.lg.jp/life/6/39/',
    is_featured: false
  },
  {
    name: '橿原市昆虫館',
    prefecture: '奈良県',
    city: '橿原市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.kashihara.nara.jp/kanko_bunka_sports/konchukan/index.html',
    is_featured: false
  },
  {
    name: '奈良県立橿原考古学研究所附属博物館',
    prefecture: '奈良県',
    city: '橿原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kashikoken.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '歴史に憩う橿原市博物館',
    prefecture: '奈良県',
    city: '橿原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kashihara.nara.jp/soshiki/1059/gyomu/4/2415.html',
    is_featured: false
  },
  {
    name: '葛城市歴史博物館',
    prefecture: '奈良県',
    city: '葛城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.katsuragi.nara.jp/soshiki/rekishihakubutsukan/4/1121.html',
    is_featured: false
  },
  {
    name: '市立五條文化博物館',
    prefecture: '奈良県',
    city: '五條市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.gojo.lg.jp/soshiki/bunka/1/1/1233.html',
    is_featured: false
  },
  {
    name: '水平社博物館',
    prefecture: '奈良県',
    city: '御所市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www1.mahoroba.ne.jp/~suihei/',
    is_featured: false
  },
  {
    name: '喜多美術館',
    prefecture: '奈良県',
    city: '桜井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitamuseum.my.canva.site',
    is_featured: false
  },
  {
    name: '春日大社　萬葉植物園（神苑）',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.kasugataisha.or.jp/manyou-s/',
    is_featured: false
  },
  {
    name: '春日大社国宝殿',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kasugataisha.or.jp/museum/',
    is_featured: false
  },
  {
    name: '中野美術館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nakano-museum.jp/',
    is_featured: false
  },
  {
    name: '松伯美術館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kintetsu-g-hd.co.jp/culture/shohaku/',
    is_featured: false
  },
  {
    name: '寧楽美術館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://isuien.or.jp/museum',
    is_featured: false
  },
  {
    name: '法隆寺大宝蔵殿',
    prefecture: '奈良県',
    city: '生駒郡斑鳩町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.horyuji.or.jp/garan/daihozoin/',
    is_featured: false
  },
  {
    name: '高松塚壁画館',
    prefecture: '奈良県',
    city: '高市郡明日香村',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.asukabito.or.jp/hekigakan.html',
    is_featured: false
  },
  {
    name: '奈良文化財研究所　飛鳥資料館',
    prefecture: '奈良県',
    city: '高市郡明日香村',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.nabunken.go.jp/asuka/',
    is_featured: false
  },
  {
    name: '天理大学附属天理参考館',
    prefecture: '奈良県',
    city: '天理市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.sankokan.jp/',
    is_featured: false
  },
  {
    name: '帝塚山大学附属博物館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tezukayama-u.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '奈良国立博物館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.narahaku.go.jp/',
    is_featured: false
  },
  {
    name: '奈良大学博物館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.nara-u.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '大和文華館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kintetsu-g-hd.co.jp/culture/yamato/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 和歌山県 (15件)
# ================================
puts '和歌山県のデータを投入中...'

[
  {
    name: '有田市郷土資料館',
    prefecture: '和歌山県',
    city: '有田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.arida.lg.jp/shisetsu/bunkashakaikyoiku/1001521.html',
    is_featured: false
  },
  {
    name: 'レプリカをつくる博物館',
    prefecture: '和歌山県',
    city: '海草郡紀美野町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://amphillc.com/',
    is_featured: false
  },
  {
    name: '藤白王子跡ミュージアム',
    prefecture: '和歌山県',
    city: '海南市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fujishiro-jinja.net/',
    is_featured: false
  },
  {
    name: '和歌山県立自然博物館',
    prefecture: '和歌山県',
    city: '海南市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.shizenhaku.wakayama-c.ed.jp/',
    is_featured: false
  },
  {
    name: '太地町立くじらの博物館',
    prefecture: '和歌山県',
    city: '東牟婁郡太地町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.kujirakan.jp/',
    is_featured: false
  },
  {
    name: '和歌山県立紀伊風土記の丘',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kiifudoki.wakayama-c.ed.jp/',
    is_featured: false
  },
  {
    name: '和歌山県立近代美術館',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.momaw.jp/',
    is_featured: false
  },
  {
    name: '和歌山県立博物館',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hakubutu.wakayama.jp/',
    is_featured: false
  },
  {
    name: '和歌山市立博物館',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.wakayama-city-museum.jp/',
    is_featured: false
  },
  {
    name: '高野山霊宝館',
    prefecture: '和歌山県',
    city: '伊都郡高野町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.reihokan.or.jp/',
    is_featured: false
  },
  {
    name: '熊野神宝館',
    prefecture: '和歌山県',
    city: '新宮市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kumanohayatama.jp/?page_id=14',
    is_featured: false
  },
  {
    name: 'アドベンチャーワールド',
    prefecture: '和歌山県',
    city: '西牟婁郡白浜町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.aws-s.com/',
    is_featured: false
  },
  {
    name: '京都大学フィールド科学教育研究センター瀬戸臨海実験所水族館（京都大学白浜水族館）',
    prefecture: '和歌山県',
    city: '西牟婁郡白浜町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.seto.kyoto-u.ac.jp/shirahama_aqua/',
    is_featured: false
  },
  {
    name: '串本海中公園センター水族館',
    prefecture: '和歌山県',
    city: '東牟婁郡串本町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.kushimoto.co.jp/',
    is_featured: false
  },
  {
    name: '和歌山大学紀州経済史文化史研究所',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.wakayama-u.ac.jp/kisyuken/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 鳥取県 (9件)
# ================================
puts '鳥取県のデータを投入中...'

[
  {
    name: '倉吉博物館・倉吉歴史民俗資料館',
    prefecture: '鳥取県',
    city: '倉吉市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kurayoshi.lg.jp/kurahaku/',
    is_featured: false
  },
  {
    name: '鳥取県立博物館',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.pref.tottori.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '鳥取市こども科学館',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://tottori-shinkoukai.or.jp/kodomokagaku/',
    is_featured: false
  },
  {
    name: '鳥取市さじアストロパーク',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.tottori.lg.jp/www/contents/1425466200201/',
    is_featured: false
  },
  {
    name: '鳥取市歴史博物館（やまびこ館）',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tbz.or.jp/yamabikokan/',
    is_featured: false
  },
  {
    name: '鳥取民藝美術舘',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mingei.exblog.jp/',
    is_featured: false
  },
  {
    name: '渡辺美術館',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://watart.jp/',
    is_featured: false
  },
  {
    name: '米子市美術館',
    prefecture: '鳥取県',
    city: '米子市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yonagobunka.net/y-moa/',
    is_featured: false
  },
  {
    name: '米子市立山陰歴史館',
    prefecture: '鳥取県',
    city: '米子市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.yonagobunka.net/rekishi/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 島根県 (25件)
# ================================
puts '島根県のデータを投入中...'

[
  {
    name: '出雲市立平田本陣記念館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.izumo-zaidan.jp/honjin/',
    is_featured: false
  },
  {
    name: '出雲文化伝承館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.izumo-zaidan.jp/izumodenshokan/',
    is_featured: false
  },
  {
    name: '出雲弥生の森博物館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.izumo.shimane.jp/www/contents/1244161923233/index.html',
    is_featured: false
  },
  {
    name: '今岡美術館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.imaoka-museum.jp/',
    is_featured: false
  },
  {
    name: '島根県立古代出雲歴史博物館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.izm.ed.jp/',
    is_featured: false
  },
  {
    name: '手錢美術館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tezenmuseum.com/',
    is_featured: false
  },
  {
    name: '公益財団法人亀井温故館',
    prefecture: '島根県',
    city: '鹿足郡津和野町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kamei-onkokan.jp/page001/entrance.html',
    is_featured: false
  },
  {
    name: '絲原記念館',
    prefecture: '島根県',
    city: '仁多郡奥出雲町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://itoharas.com/',
    is_featured: false
  },
  {
    name: '奥出雲多根自然博物館',
    prefecture: '島根県',
    city: '仁多郡奥出雲町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://tanemuseum.jp/',
    is_featured: false
  },
  {
    name: '可部屋集成館',
    prefecture: '島根県',
    city: '仁多郡奥出雲町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://kabeya-syuseikan.com/',
    is_featured: false
  },
  {
    name: '石見安達美術館',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www2.crosstalk.or.jp/shinmachi/a8/',
    is_featured: false
  },
  {
    name: '浜田市世界こども美術館創作活動館',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hamada-kodomo-art.com/',
    is_featured: false
  },
  {
    name: '浜田市立石正美術館',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.sekisho-art-museum.jp/',
    is_featured: false
  },
  {
    name: '島根県立石見美術館',
    prefecture: '島根県',
    city: '益田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.grandtoit.jp/museum/',
    is_featured: false
  },
  {
    name: '安部榮四郎記念館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://izumomingeishi.com/abeeishirou/',
    is_featured: false
  },
  {
    name: '島根県立美術館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shimane-art-museum.jp/',
    is_featured: false
  },
  {
    name: '田部美術館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tanabe-museum.or.jp/',
    is_featured: false
  },
  {
    name: '松江歴史館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-reki.jp/',
    is_featured: false
  },
  {
    name: '足立美術館',
    prefecture: '島根県',
    city: '安来市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.adachi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '安来市加納美術館',
    prefecture: '島根県',
    city: '安来市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.art-kano.jp/',
    is_featured: false
  },
  {
    name: '和鋼博物館',
    prefecture: '島根県',
    city: '安来市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://wako-museum.jp/',
    is_featured: false
  },
  {
    name: '出雲大社宝物殿',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://izumooyashiro.or.jp/precinct/keidai-index/shinkoden',
    is_featured: false
  },
  {
    name: '島根県立宍道湖自然館（ゴビウス）',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.gobius.jp/',
    is_featured: false
  },
  {
    name: '島根県立三瓶自然館',
    prefecture: '島根県',
    city: '大田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.nature-sanbe.jp/sahimel/',
    is_featured: false
  },
  {
    name: '島根県立しまね海洋館（アクアス）',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://aquas.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 岡山県 (33件)
# ================================
puts '岡山県のデータを投入中...'

[
  {
    name: '井原市立平櫛田中美術館',
    prefecture: '岡山県',
    city: '井原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.ibara.okayama.jp/site/denchu-museum/',
    is_featured: false
  },
  {
    name: '華鴒大塚美術館',
    prefecture: '岡山県',
    city: '井原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hanatori-museum.jp/',
    is_featured: false
  },
  {
    name: '池田動物園',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://ikedazoo.jp',
    is_featured: false
  },
  {
    name: '犬島精錬所美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://benesse-artsite.jp/art/seirensho.html',
    is_featured: false
  },
  {
    name: '岡山県立博物館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.okayama.jp/site/kenhaku/',
    is_featured: false
  },
  {
    name: '岡山県立美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://okayama-kenbi.info/',
    is_featured: false
  },
  {
    name: '岡山シティミュージアム',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.okayama.jp/okayama-city-museum/',
    is_featured: false
  },
  {
    name: '岡山市立オリエント美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.okayama.jp/orientmuseum/',
    is_featured: false
  },
  {
    name: '公益財団法人吉備路文学館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kibiji.or.jp/',
    is_featured: false
  },
  {
    name: '林原美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hayashibara-museumofart.jp/',
    is_featured: false
  },
  {
    name: '夢二郷土美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yumeji-art-museum.com/',
    is_featured: false
  },
  {
    name: 'やかげ郷土美術館',
    prefecture: '岡山県',
    city: '小田郡矢掛町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://museum.yakage-kyouiku.info/',
    is_featured: false
  },
  {
    name: '笠岡市立竹喬美術館',
    prefecture: '岡山県',
    city: '笠岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kasaoka.okayama.jp/site/museum/',
    is_featured: false
  },
  {
    name: '奈義町現代美術館',
    prefecture: '岡山県',
    city: '勝田郡奈義町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.nagi.okayama.jp/moca/',
    is_featured: false
  },
  {
    name: '大原美術館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ohara.or.jp/',
    is_featured: false
  },
  {
    name: '倉敷科学センター',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://kurakagaku.jp/',
    is_featured: false
  },
  {
    name: '倉敷考古館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kurashikikoukokan.com/',
    is_featured: false
  },
  {
    name: '倉敷市立自然史博物館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.kurashiki.okayama.jp/musnat/',
    is_featured: false
  },
  {
    name: '倉敷市立美術館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kurashiki.okayama.jp/kcam/',
    is_featured: false
  },
  {
    name: '倉敷民藝館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://kurashiki-mingeikan.com/',
    is_featured: false
  },
  {
    name: '野﨑家塩業歴史館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nozakike.or.jp/',
    is_featured: false
  },
  {
    name: '瀬戸内市立美術館',
    prefecture: '岡山県',
    city: '瀬戸内市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.setouchi.lg.jp/site/museum/',
    is_featured: false
  },
  {
    name: '備前長船刀剣博物館',
    prefecture: '岡山県',
    city: '瀬戸内市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.setouchi.lg.jp/site/token/',
    is_featured: false
  },
  {
    name: '高梁市成羽美術館',
    prefecture: '岡山県',
    city: '高梁市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nariwa-museum.or.jp/',
    is_featured: false
  },
  {
    name: '高梁市歴史美術館',
    prefecture: '岡山県',
    city: '高梁市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takahashi.lg.jp/site/takahashi-historical-museum/',
    is_featured: false
  },
  {
    name: '市立玉野海洋博物館',
    prefecture: '岡山県',
    city: '玉野市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.city.tamano.lg.jp/site/kaihaku/',
    is_featured: false
  },
  {
    name: '津山郷土博物館',
    prefecture: '岡山県',
    city: '津山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.tsu-haku.jp/',
    is_featured: false
  },
  {
    name: 'つやま自然のふしぎ館（津山科学教育博物館）',
    prefecture: '岡山県',
    city: '津山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.fushigikan.jp/',
    is_featured: false
  },
  {
    name: '津山洋学資料館',
    prefecture: '岡山県',
    city: '津山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tsuyama-yougaku.jp/',
    is_featured: false
  },
  {
    name: '新見美術館',
    prefecture: '岡山県',
    city: '新見市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://niimi-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'BIZEN中南米美術館',
    prefecture: '岡山県',
    city: '備前市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.latinamerica.jp/',
    is_featured: false
  },
  {
    name: '岡山天文博物館',
    prefecture: '岡山県',
    city: '浅口市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://ww1.city.asakuchi.okayama.jp/museum/',
    is_featured: false
  },
  {
    name: '岡山市半田山植物園',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.okayama-park.or.jp/handayama/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 広島県 (37件)
# ================================
puts '広島県のデータを投入中...'

[
  {
    name: '筆の里工房',
    prefecture: '広島県',
    city: '安芸郡熊野町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fude.or.jp/jp/',
    is_featured: false
  },
  {
    name: '安芸高田市歴史民俗博物館',
    prefecture: '広島県',
    city: '安芸高田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.akitakata.jp/ja/hakubutsukan/',
    is_featured: false
  },
  {
    name: '下瀬美術館',
    prefecture: '広島県',
    city: '大竹市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.simose-museum.jp/',
    is_featured: false
  },
  {
    name: '尾道市立美術館',
    prefecture: '広島県',
    city: '尾道市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.onomichi-museum.jp/',
    is_featured: false
  },
  {
    name: '耕三寺博物館',
    prefecture: '広島県',
    city: '尾道市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kousanji.or.jp/',
    is_featured: false
  },
  {
    name: '平山郁夫美術館',
    prefecture: '広島県',
    city: '尾道市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hirayama-museum.or.jp/',
    is_featured: false
  },
  {
    name: '呉市立美術館',
    prefecture: '広島県',
    city: '呉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kure-bi.jp/',
    is_featured: false
  },
  {
    name: '庄原市帝釈峡博物展示施設　時悠館',
    prefecture: '広島県',
    city: '庄原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.shobara.hiroshima.jp/main/education/shisetsu/cat01/cat/index.html',
    is_featured: false
  },
  {
    name: '庄原市立比和自然科学博物館',
    prefecture: '広島県',
    city: '庄原市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.shobara.hiroshima.jp/main/education/shisetsu/cat01/01/',
    is_featured: false
  },
  {
    name: '厳島神社宝物館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: '',
    is_featured: false
  },
  {
    name: '公益財団法人ウッドワン美術館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.woodone-museum.jp/',
    is_featured: false
  },
  {
    name: '海の見える杜美術館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.umam.jp/',
    is_featured: false
  },
  {
    name: '仙石庭園庭石ミュージアム',
    prefecture: '広島県',
    city: '東広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://senseki.org/',
    is_featured: false
  },
  {
    name: '東広島市立美術館',
    prefecture: '広島県',
    city: '東広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hhmoa.jp/',
    is_featured: false
  },
  {
    name: '泉美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.izumi-museum.jp/',
    is_featured: false
  },
  {
    name: '広島県立美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hpam.jp/',
    is_featured: false
  },
  {
    name: '広島市江波山気象館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.ebayama.jp/',
    is_featured: false
  },
  {
    name: '広島市郷土資料館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.cf.city.hiroshima.jp/kyodo/',
    is_featured: false
  },
  {
    name: '広島市交通科学館（ヌマジ交通ミュージアム）',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.vehicle.city.hiroshima.jp/',
    is_featured: false
  },
  {
    name: '広島市こども文化科学館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.pyonta.city.hiroshima.jp/',
    is_featured: false
  },
  {
    name: 'ひろしま美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hiroshima-museum.jp/',
    is_featured: false
  },
  {
    name: '頼山陽史跡資料館（広島県立歴史博物館分館）',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.hiroshima.lg.jp/site/raisanyou/',
    is_featured: false
  },
  {
    name: 'しぶや美術館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://vessel-group.co.jp/shibuya-museum/',
    is_featured: false
  },
  {
    name: '広島県立歴史博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.hiroshima.lg.jp/site/rekishih/',
    is_featured: false
  },
  {
    name: '福山市しんいち歴史民俗博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.fukuyama.hiroshima.jp/soshiki/shinichi-rekimin/',
    is_featured: false
  },
  {
    name: '福山自動車時計博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.facm.net/',
    is_featured: false
  },
  {
    name: '福山市立福山城博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fukuyamajo.jp/',
    is_featured: false
  },
  {
    name: 'ふくやま美術館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.fukuyama.hiroshima.jp/site/fukuyama-museum/',
    is_featured: false
  },
  {
    name: '広島県立歴史民俗資料館',
    prefecture: '広島県',
    city: '三次市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.hiroshima.lg.jp/site/rekimin/',
    is_featured: false
  },
  {
    name: 'アートギャラリーミヤウチ',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://miyauchiaf.or.jp/',
    is_featured: false
  },
  {
    name: '宮島水族館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.miyajima-aqua.jp/',
    is_featured: false
  },
  {
    name: '広島大学総合博物館',
    prefecture: '広島県',
    city: '東広島市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.digital-museum.hiroshima-u.ac.jp/~humuseum/',
    is_featured: false
  },
  {
    name: '広島市安佐動物公園',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://www.asazoo.jp/',
    is_featured: false
  },
  {
    name: '広島市現代美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.hiroshima-moca.jp/',
    is_featured: false
  },
  {
    name: '広島城',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.rijo-castle.jp/',
    is_featured: false
  },
  {
    name: '広島市立大学芸術資料館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://museum.hiroshima-cu.ac.jp/index.cgi/ja',
    is_featured: false
  },
  {
    name: '福山市立動物園',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.fukuyamazoo.jp/index.php',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 山口県 (23件)
# ================================
puts '山口県のデータを投入中...'

[
  {
    name: '岩国徴古館',
    prefecture: '山口県',
    city: '岩国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.iwakuni.lg.jp/site/chokokan/',
    is_featured: false
  },
  {
    name: '柏原美術館',
    prefecture: '山口県',
    city: '岩国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kashiwabara-museum.jp/',
    is_featured: false
  },
  {
    name: '吉川報こう会　吉川史料館',
    prefecture: '山口県',
    city: '岩国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kikkawa7.or.jp/',
    is_featured: false
  },
  {
    name: '宇部市学びの森くすのき',
    prefecture: '山口県',
    city: '宇部市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ube.yamaguchi.jp/koukyouannai/shisetsu_kyouiku/1009905.html',
    is_featured: false
  },
  {
    name: '下関市立考古博物館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shimo-kouko.jp/',
    is_featured: false
  },
  {
    name: '下関市立美術館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.shimonoseki.lg.jp/site/art/',
    is_featured: false
  },
  {
    name: '下関市立歴史博物館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shimohaku.jp/',
    is_featured: false
  },
  {
    name: '周南市美術博物館',
    prefecture: '山口県',
    city: '周南市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://s-bunka.jp/bihaku/',
    is_featured: false
  },
  {
    name: '熊谷美術館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kumaya.art/',
    is_featured: false
  },
  {
    name: '萩陶芸美術館　吉賀大眉記念館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.taibi-hagi.jp/',
    is_featured: false
  },
  {
    name: '萩博物館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://hagimuseum.jp/',
    is_featured: false
  },
  {
    name: '防府市青少年科学館',
    prefecture: '山口県',
    city: '防府市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://solar-hofu.com',
    is_featured: false
  },
  {
    name: '毛利博物館',
    prefecture: '山口県',
    city: '防府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.c-able.ne.jp/~mouri-m/',
    is_featured: false
  },
  {
    name: '美祢市立秋吉台科学博物館',
    prefecture: '山口県',
    city: '美祢市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://akihaku.jimdofree.com/',
    is_featured: false
  },
  {
    name: 'のむら美術館',
    prefecture: '山口県',
    city: '山口市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yamaguchi-tourism.jp/spot/detail_12223.html',
    is_featured: false
  },
  {
    name: '山口県立山口博物館',
    prefecture: '山口県',
    city: '山口市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.yamahaku.pref.yamaguchi.lg.jp/',
    is_featured: false
  },
  {
    name: '緑と花と彫刻の博物館',
    prefecture: '山口県',
    city: '宇部市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.tokiwapark.jp/museum/',
    is_featured: false
  },
  {
    name: '下関市立しものせき水族館海響館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'http://www.kaikyokan.com/',
    is_featured: false
  },
  {
    name: '梅光学院大学博物館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '周南市徳山動物園',
    prefecture: '山口県',
    city: '周南市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://tokuyama-zoo.jp/',
    is_featured: false
  },
  {
    name: '山口県立萩美術館・浦上記念館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://hum-web.jp/',
    is_featured: false
  },
  {
    name: '秋吉台自然動物公園',
    prefecture: '山口県',
    city: '美祢市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.safariland.jp/',
    is_featured: false
  },
  {
    name: '山口県立美術館',
    prefecture: '山口県',
    city: '山口市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://y-pam.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 徳島県 (11件)
# ================================
puts '徳島県のデータを投入中...'

[
  {
    name: '松茂町歴史民俗資料館・人形浄瑠璃芝居資料館',
    prefecture: '徳島県',
    city: '板野郡松茂町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://joruri.jp/',
    is_featured: false
  },
  {
    name: '三木文庫',
    prefecture: '徳島県',
    city: '板野郡松茂町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mikibunko.jp/',
    is_featured: false
  },
  {
    name: '徳島県立近代美術館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://art.bunmori.tokushima.jp/',
    is_featured: false
  },
  {
    name: '徳島県立鳥居龍蔵記念博物館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://torii-museum.bunmori.tokushima.jp/default.htm',
    is_featured: false
  },
  {
    name: '徳島県立博物館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://museum.bunmori.tokushima.jp/',
    is_featured: false
  },
  {
    name: '徳島市立考古資料館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tokushima-kouko.jp/',
    is_featured: false
  },
  {
    name: '徳島市立徳島城博物館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tokushima.tokushima.jp/johaku/',
    is_featured: false
  },
  {
    name: '大塚国際美術館',
    prefecture: '徳島県',
    city: '鳴門市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://o-museum.or.jp/',
    is_featured: false
  },
  {
    name: '美波町日和佐うみがめ博物館',
    prefecture: '徳島県',
    city: '海部郡美波町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://caretta.town.minami.lg.jp/',
    is_featured: false
  },
  {
    name: 'とくしま動物園',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://tokushimazoo.jp/',
    is_featured: false
  },
  {
    name: '阿波和紙伝統産業会館',
    prefecture: '徳島県',
    city: '吉野川市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'http://www.awagami.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 香川県 (17件)
# ================================
puts '香川県のデータを投入中...'

[
  {
    name: '地中美術館',
    prefecture: '香川県',
    city: '香川郡直島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://benesse-artsite.jp/art/chichu.html',
    is_featured: false
  },
  {
    name: '李禹煥美術館',
    prefecture: '香川県',
    city: '香川郡直島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://benesse-artsite.jp/art/lee-ufan.html',
    is_featured: false
  },
  {
    name: '鎌田共済会郷土博物館',
    prefecture: '香川県',
    city: '坂出市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kamahaku.jp/',
    is_featured: false
  },
  {
    name: 'イサム・ノグチ庭園美術館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.isamunoguchi.or.jp/',
    is_featured: false
  },
  {
    name: '香川県立ミュージアム',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.kagawa.lg.jp/kmuseum/kmuseum/index.html',
    is_featured: false
  },
  {
    name: '四国民家博物館（四国村ミウゼアム）',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '野外博物館',
    official_website: 'https://www.shikokumura.or.jp/',
    is_featured: false
  },
  {
    name: '高松市石の民俗資料館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takamatsu.kagawa.jp/kurashi/kosodate/bunka/ishimin/index.html',
    is_featured: false
  },
  {
    name: '高松市美術館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.takamatsu.kagawa.jp/museum/takamatsu/',
    is_featured: false
  },
  {
    name: 'ナガレスタジオ「流政之美術館」',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nagarestudio.jp/#1',
    is_featured: false
  },
  {
    name: '美術館「川島猛アートファクトリー」',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kawashima-af.com/',
    is_featured: false
  },
  {
    name: '琴平海洋博物館',
    prefecture: '香川県',
    city: '仲多度郡琴平町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kotohira.kaiyohakubutukan.or.jp/',
    is_featured: false
  },
  {
    name: '金刀比羅宮博物館',
    prefecture: '香川県',
    city: '仲多度郡琴平町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.konpira.or.jp/',
    is_featured: false
  },
  {
    name: '四国水族館',
    prefecture: '香川県',
    city: '綾歌郡宇多津町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://shikoku-aquarium.jp/',
    is_featured: false
  },
  {
    name: '池川彫刻美術館',
    prefecture: '香川県',
    city: '木田郡三木町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.ikegawa-museum.or.jp',
    is_featured: false
  },
  {
    name: '香川大学博物館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.museum.kagawa-u.ac.jp',
    is_featured: false
  },
  {
    name: '新屋島水族館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://r.goope.jp/new-yashima-aq',
    is_featured: false
  },
  {
    name: '高松市歴史資料館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.city.takamatsu.kagawa.jp/kurashi/kosodate/bunka/rekishi/index.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 愛媛県 (24件)
# ================================
puts '愛媛県のデータを投入中...'

[
  {
    name: '今治市大三島美術館本館　今治市大三島美術館別館　今治市　岩田健　母と子のミュージアム　今治市大三島美術館別館　ところミュージアム大三島',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.imabari.ehime.jp/museum/omishima/',
    is_featured: false
  },
  {
    name: '今治市村上海賊ミュージアム',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.imabari.ehime.jp/museum/suigun/',
    is_featured: false
  },
  {
    name: '愛媛文華館',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ehimebunkakan.jp/',
    is_featured: false
  },
  {
    name: '大三島海事博物館',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.imabari.ehime.jp/kanko/spot/?a=242',
    is_featured: false
  },
  {
    name: '大山祇神社宝物館',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://oomishimagu.jp/treasure/',
    is_featured: false
  },
  {
    name: '宇和島市立伊達博物館',
    prefecture: '愛媛県',
    city: '宇和島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.uwajima.ehime.jp/site/datehaku-top/',
    is_featured: false
  },
  {
    name: '大洲市立博物館',
    prefecture: '愛媛県',
    city: '大洲市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.ozu-museum.com/',
    is_featured: false
  },
  {
    name: '四国中央市歴史考古博物館―高原ミュージアム―',
    prefecture: '愛媛県',
    city: '四国中央市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kaminomachi.or.jp/facility/museum/',
    is_featured: false
  },
  {
    name: '愛媛県歴史文化博物館',
    prefecture: '愛媛県',
    city: '西予市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.i-rekihaku.jp/',
    is_featured: false
  },
  {
    name: '愛媛民芸館',
    prefecture: '愛媛県',
    city: '西条市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ehimemingeikan.jp/',
    is_featured: false
  },
  {
    name: '東温市立歴史民俗資料館',
    prefecture: '愛媛県',
    city: '東温市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.toon.ehime.jp/soshiki/23/2431.html',
    is_featured: false
  },
  {
    name: '愛媛県総合科学博物館',
    prefecture: '愛媛県',
    city: '新居浜市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.i-kahaku.jp/',
    is_featured: false
  },
  {
    name: '新居浜市美術館',
    prefecture: '愛媛県',
    city: '新居浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.niihama.lg.jp/soshiki/bijutu/',
    is_featured: false
  },
  {
    name: '伊方町文化交流施設　佐田岬半島ミュージアム',
    prefecture: '愛媛県',
    city: '西宇和郡伊方町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sadamisakihanto-museum.jp/',
    is_featured: false
  },
  {
    name: '伊丹十三記念館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://itami-kinenkan.jp/',
    is_featured: false
  },
  {
    name: '愛媛県美術館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ehime-art.jp/',
    is_featured: false
  },
  {
    name: '松山市考古館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.cul-spo.or.jp/koukokan/',
    is_featured: false
  },
  {
    name: '松山市立子規記念博物館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shiki-museum.com/',
    is_featured: false
  },
  {
    name: '愛媛県立とべ動物園',
    prefecture: '愛媛県',
    city: '伊予郡砥部町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tobezoo.com/',
    is_featured: false
  },
  {
    name: '久万高原町立久万美術館',
    prefecture: '愛媛県',
    city: '上浮穴郡久万高原町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kumakogen.jp/site/muse/',
    is_featured: false
  },
  {
    name: '西条市立西条郷土博物館',
    prefecture: '愛媛県',
    city: '西条市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.saijo-museum.com/',
    is_featured: false
  },
  {
    name: '高畠華宵大正ロマン館',
    prefecture: '愛媛県',
    city: '東温市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kashomuseum.org/',
    is_featured: false
  },
  {
    name: '新居浜市広瀬歴史記念館',
    prefecture: '愛媛県',
    city: '新居浜市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.niihama.lg.jp/soshiki/hirose/',
    is_featured: false
  },
  {
    name: '松山市坂の上の雲ミュージアム',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.sakanouenokumomuseum.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 高知県 (17件)
# ================================
puts '高知県のデータを投入中...'

[
  {
    name: '安芸市立書道美術館',
    prefecture: '高知県',
    city: '安芸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.aki.kochi.jp/life/dtl.php?hdnKey=49',
    is_featured: false
  },
  {
    name: '桂浜水族館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://katurahama-aq.jp/',
    is_featured: false
  },
  {
    name: '高知県立美術館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://moak.jp/',
    is_featured: false
  },
  {
    name: '佐川町立青山文庫',
    prefecture: '高知県',
    city: '高岡郡佐川町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://seizanbunko.com/',
    is_featured: false
  },
  {
    name: '高知県立歴史民俗資料館',
    prefecture: '高知県',
    city: '南国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kochi-rekimin.jp/index.html',
    is_featured: false
  },
  {
    name: 'むろと廃校水族館（むろと海の学校）',
    prefecture: '高知県',
    city: '室戸市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.city.muroto.kochi.jp/pages/page0343.php',
    is_featured: false
  },
  {
    name: '安芸市立歴史民俗資料館',
    prefecture: '高知県',
    city: '安芸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.aki.kochi.jp/rekimin/',
    is_featured: false
  },
  {
    name: '香美市立美術館',
    prefecture: '高知県',
    city: '香美市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kami.lg.jp/site/bijutukan/',
    is_featured: false
  },
  {
    name: '香美市立やなせたかし記念館アンパンマンミュージアム',
    prefecture: '高知県',
    city: '香美市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://anpanman-museum.net/',
    is_featured: false
  },
  {
    name: '高知県立高知城歴史博物館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kochi-johaku.jp/',
    is_featured: false
  },
  {
    name: '高知県立坂本龍馬記念館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://ryoma-kinenkan.jp/',
    is_featured: false
  },
  {
    name: '高知県立牧野植物園',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.makino.or.jp/',
    is_featured: false
  },
  {
    name: '高知市立自由民権記念館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.i-minken.jp/',
    is_featured: false
  },
  {
    name: '横山隆一記念まんが館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.kfca.jp/mangakan/',
    is_featured: false
  },
  {
    name: 'わんぱーくこうちアニマルランド',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.kochi.kochi.jp/deeps/17/1712/animal/',
    is_featured: false
  },
  {
    name: '高知県立のいち動物公園',
    prefecture: '高知県',
    city: '香南市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://noichizoo.or.jp/',
    is_featured: false
  },
  {
    name: '宿毛市立宿毛歴史館',
    prefecture: '高知県',
    city: '宿毛市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.sukumo.kochi.jp/docs-26/p010804.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 福岡県 (36件)
# ================================
puts '福岡県のデータを投入中...'

[
  {
    name: '朝倉市秋月博物館',
    prefecture: '福岡県',
    city: '朝倉市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.asakura.lg.jp/www/contents/1398210163709/index.html',
    is_featured: false
  },
  {
    name: '糸島市立伊都国歴史博物館',
    prefecture: '福岡県',
    city: '糸島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.itoshima.lg.jp/m043/010/index.html',
    is_featured: false
  },
  {
    name: '古賀政男音楽博物館分館　古賀政男記念館',
    prefecture: '福岡県',
    city: '大川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.okawa.lg.jp/090/050/010/',
    is_featured: false
  },
  {
    name: '大野城心のふるさと館',
    prefecture: '福岡県',
    city: '大野城市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.onojo-occm.jp',
    is_featured: false
  },
  {
    name: '九州歴史資料館',
    prefecture: '福岡県',
    city: '小郡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kyureki.jp/',
    is_featured: false
  },
  {
    name: '出光美術館（門司）',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://s-idemitsu-mm.or.jp/',
    is_featured: false
  },
  {
    name: '北九州市平和のまちミュージアム',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kitakyushu-peacemuseum.jp/',
    is_featured: false
  },
  {
    name: '北九州市漫画ミュージアム',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ktqmm.jp/',
    is_featured: false
  },
  {
    name: '北九州市立自然史・歴史博物館（いのちのたび博物館）',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.kmnh.jp/',
    is_featured: false
  },
  {
    name: '北九州市立長崎街道木屋瀬宿記念館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://koyanose.jp/',
    is_featured: false
  },
  {
    name: '北九州市立美術館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kmma.jp/',
    is_featured: false
  },
  {
    name: '北九州市立文学館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kitakyushucity-bungakukan.jp/',
    is_featured: false
  },
  {
    name: '北九州市立松本清張記念館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.seicho-mm.jp/',
    is_featured: false
  },
  {
    name: '小倉城庭園',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kokura-castle.jp/kokura-garden/',
    is_featured: false
  },
  {
    name: '鞍手町歴史民俗博物館',
    prefecture: '福岡県',
    city: '鞍手郡鞍手町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.kurate.lg.jp/bunka/gyomu.html',
    is_featured: false
  },
  {
    name: '田川市石炭・歴史博物館',
    prefecture: '福岡県',
    city: '田川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.joho.tagawa.fukuoka.jp/list00784.html',
    is_featured: false
  },
  {
    name: '太宰府天満宮宝物殿',
    prefecture: '福岡県',
    city: '太宰府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://keidai.art/houmotsuden',
    is_featured: false
  },
  {
    name: '筑紫野市歴史博物館（ふるさと館ちくしの）',
    prefecture: '福岡県',
    city: '筑紫野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chikushino.fukuoka.jp/soshiki/48/3550.html',
    is_featured: false
  },
  {
    name: '亀陽文庫　能古博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nokonoshima-museum.or.jp/',
    is_featured: false
  },
  {
    name: '福岡アジア美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://faam.city.fukuoka.lg.jp/',
    is_featured: false
  },
  {
    name: '福岡県立美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fukuoka-kenbi.jp/',
    is_featured: false
  },
  {
    name: '福岡市博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://museum.city.fukuoka.jp/',
    is_featured: false
  },
  {
    name: '福岡市美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.fukuoka-art-museum.jp/',
    is_featured: false
  },
  {
    name: '福岡市埋蔵文化財センター',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://bunkazai.city.fukuoka.lg.jp/maibun/',
    is_featured: false
  },
  {
    name: 'マリンワールド海の中道（海の中道海洋生態科学館）',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://marine-world.jp/',
    is_featured: false
  },
  {
    name: 'みやこ町歴史民俗博物館',
    prefecture: '福岡県',
    city: '京都郡みやこ町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.miyako.lg.jp/rekisiminnzoku/kankou/spot/hakubutukan.html',
    is_featured: false
  },
  {
    name: '立花家史料館',
    prefecture: '福岡県',
    city: '柳川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tachibana-museum.jp/',
    is_featured: false
  },
  {
    name: '秋月美術館',
    prefecture: '福岡県',
    city: '朝倉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://akizuki-foundation.or.jp/museum',
    is_featured: false
  },
  {
    name: '福岡県立糸島高等学校郷土博物館',
    prefecture: '福岡県',
    city: '糸島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://itoshima.fku.ed.jp/feature/museum/',
    is_featured: false
  },
  {
    name: '久留米市美術館　石橋正二郎記念館',
    prefecture: '福岡県',
    city: '久留米市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.ishibashi-bunka.jp/kcam/',
    is_featured: false
  },
  {
    name: '福岡県青少年科学館',
    prefecture: '福岡県',
    city: '久留米市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.science.pref.fukuoka.jp/',
    is_featured: false
  },
  {
    name: '九州国立博物館',
    prefecture: '福岡県',
    city: '太宰府市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kyuhaku.jp/',
    is_featured: false
  },
  {
    name: '九州産業大学美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kyusan-u.ac.jp/ksumuseum/',
    is_featured: false
  },
  {
    name: '九州大学総合研究博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'http://www.museum.kyushu-u.ac.jp/',
    is_featured: false
  },
  {
    name: '西南学院大学博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.seinan-gu.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '福岡市動植物園',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://zoo.city.fukuoka.lg.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 佐賀県 (13件)
# ================================
puts '佐賀県のデータを投入中...'

[
  {
    name: '祐徳博物館',
    prefecture: '佐賀県',
    city: '鹿島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.yutokusan.jp/about/museum/',
    is_featured: false
  },
  {
    name: '佐賀県立名護屋城博物館',
    prefecture: '佐賀県',
    city: '唐津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saga-museum.jp/nagoya/',
    is_featured: false
  },
  {
    name: '佐賀県立佐賀城本丸歴史館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saga-museum.jp/sagajou/',
    is_featured: false
  },
  {
    name: '佐賀県立博物館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://saga-museum.jp/museum/',
    is_featured: false
  },
  {
    name: '佐賀県立美術館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://saga-museum.jp/museum/',
    is_featured: false
  },
  {
    name: '徴古館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nabeshima.or.jp/main/',
    is_featured: false
  },
  {
    name: '陽光美術館',
    prefecture: '佐賀県',
    city: '武雄市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yokomuseum.jp/',
    is_featured: false
  },
  {
    name: '中冨記念くすり博物館',
    prefecture: '佐賀県',
    city: '鳥栖市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nakatomi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '有田陶磁美術館',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.arita.lg.jp/kiji0031926/index.html',
    is_featured: false
  },
  {
    name: '今右衛門古陶磁美術館',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.imaemon.co.jp/museum/',
    is_featured: false
  },
  {
    name: '佐賀県立九州陶磁文化館',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://saga-museum.jp/ceramic/',
    is_featured: false
  },
  {
    name: '河村美術館',
    prefecture: '佐賀県',
    city: '唐津市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kawamura.or.jp/',
    is_featured: false
  },
  {
    name: '有田ポーセリンパーク',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.arita-touki.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 長崎県 (18件)
# ================================
puts '長崎県のデータを投入中...'

[
  {
    name: '諫早市美術・歴史館',
    prefecture: '長崎県',
    city: '諫早市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.isahaya.nagasaki.jp/site/bireki/',
    is_featured: false
  },
  {
    name: '大村市歴史資料館',
    prefecture: '長崎県',
    city: '大村市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.omura.nagasaki.jp/rekishi/kyoiku/miraion/rekishishiryoukan.html',
    is_featured: false
  },
  {
    name: '佐世保市博物館島瀬美術センター',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shimabi.com/',
    is_featured: false
  },
  {
    name: 'べネックス恐竜博物館（長崎市恐竜博物館）',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://nd-museum.jp/',
    is_featured: false
  },
  {
    name: '平戸市生月町博物館・島の館',
    prefecture: '長崎県',
    city: '平戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shimanoyakata.hira-shin.jp/',
    is_featured: false
  },
  {
    name: '松浦史料博物館',
    prefecture: '長崎県',
    city: '平戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.matsura.or.jp/',
    is_featured: false
  },
  {
    name: '長崎バイオパーク',
    prefecture: '長崎県',
    city: '西海市',
    registration_type: '登録博物館',
    museum_type: '動・水・植物園',
    official_website: 'https://www.biopark.co.jp/',
    is_featured: false
  },
  {
    name: '壱岐市立一支国博物館',
    prefecture: '長崎県',
    city: '壱岐市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.iki-haku.jp/',
    is_featured: false
  },
  {
    name: '雲仙ビードロ美術館',
    prefecture: '長崎県',
    city: '雲仙市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://unzenvidro.weebly.com/',
    is_featured: false
  },
  {
    name: '西海国立公園九十九島水族館「海きらら」',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://umikirara.jp/',
    is_featured: false
  },
  {
    name: '西海国立公園九十九島動植物園「森きらら」',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://morikirara.jp/',
    is_featured: false
  },
  {
    name: 'ハウステンボス美術館・博物館',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.huistenbosch.co.jp/museum/',
    is_featured: false
  },
  {
    name: '長崎県美術館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.nagasaki-museum.jp/',
    is_featured: false
  },
  {
    name: '長崎孔子廟中国歴代博物館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://nagasaki-koushibyou.com/',
    is_featured: false
  },
  {
    name: '長崎純心大学博物館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.n-junshin.ac.jp/univ/research/museum/',
    is_featured: false
  },
  {
    name: '長崎ペンギン水族館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '動植物園',
    official_website: 'https://penguin-aqua.jp/',
    is_featured: false
  },
  {
    name: '長崎歴史文化博物館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.nmhc.jp/',
    is_featured: false
  },
  {
    name: '新上五島町鯨賓館ミュージアム',
    prefecture: '長崎県',
    city: '南松浦郡新上五島町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.shinkamigoto.nagasaki.jp/geihinkan/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 熊本県 (21件)
# ================================
puts '熊本県のデータを投入中...'

[
  {
    name: '芦北町立星野富弘美術館',
    prefecture: '熊本県',
    city: '葦北郡芦北町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://hoshino-museum.com/',
    is_featured: false
  },
  {
    name: '阿蘇火山博物館',
    prefecture: '熊本県',
    city: '阿蘇市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.asomuse.jp/',
    is_featured: false
  },
  {
    name: '天草市立御所浦恐竜の島博物館',
    prefecture: '熊本県',
    city: '天草市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://goshouramuseum.jp/',
    is_featured: false
  },
  {
    name: '御船町恐竜博物館',
    prefecture: '熊本県',
    city: '上益城郡御船町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://mifunemuseum.jp/',
    is_featured: false
  },
  {
    name: '湯前まんが美術館',
    prefecture: '熊本県',
    city: '球磨郡湯前町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yunomae-manga.com/',
    is_featured: false
  },
  {
    name: '熊本県立美術館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.pref.kumamoto.jp/site/museum/',
    is_featured: false
  },
  {
    name: '熊本博物館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kumamoto-city-museum.jp/',
    is_featured: false
  },
  {
    name: '玉名市立歴史博物館こころピア',
    prefecture: '熊本県',
    city: '玉名市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tamana.lg.jp/q/list/455.html',
    is_featured: false
  },
  {
    name: '松井文庫驥斎',
    prefecture: '熊本県',
    city: '八代市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kinasse-yatsushiro.jp/spots/detail/ea2b5552-e16c-4cf6-b627-5c1e3dfabee1',
    is_featured: false
  },
  {
    name: '八代市立博物館未来の森ミュージアム',
    prefecture: '熊本県',
    city: '八代市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.yatsushiro.kumamoto.jp/museum/index.jsp',
    is_featured: false
  },
  {
    name: '熊本県立装飾古墳館',
    prefecture: '熊本県',
    city: '山鹿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kofunkan.pref.kumamoto.jp/',
    is_featured: false
  },
  {
    name: '山鹿市立博物館',
    prefecture: '熊本県',
    city: '山鹿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://furusato-yamaga.jp/detail/2/',
    is_featured: false
  },
  {
    name: '菊池神社歴史館',
    prefecture: '熊本県',
    city: '菊池市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://xn--btw921c.net/%E6%AD%B4%E5%8F%B2/25/',
    is_featured: false
  },
  {
    name: '熊本国際民藝館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kumamoto-mingeikan.com/',
    is_featured: false
  },
  {
    name: '熊本市塚原歴史民俗資料館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://tsukawara.kumamoto-city-museum.jp/',
    is_featured: false
  },
  {
    name: '熊本市動植物園',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.ezooko.jp/',
    is_featured: false
  },
  {
    name: '熊本大学五高記念館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.goko.kumamoto-u.ac.jp/',
    is_featured: false
  },
  {
    name: '島田美術館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.shimada-museum.net/index.php',
    is_featured: false
  },
  {
    name: '神風連資料館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '肥後の里山ギャラリー',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.higobank.co.jp/aboutus/higonosatoyama/index.html',
    is_featured: false
  },
  {
    name: '本妙寺宝物館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.honmyouji.jp/houmotu.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 大分県 (16件)
# ================================
puts '大分県のデータを投入中...'

[
  {
    name: '大分県立歴史博物館（宇佐風土記の丘）',
    prefecture: '大分県',
    city: '宇佐市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.oita.jp/site/rekishihakubutsukan/',
    is_featured: false
  },
  {
    name: '大分県立美術館',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.opam.jp/',
    is_featured: false
  },
  {
    name: '大分市美術館',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.city.oita.oita.jp/bunkasports/bunka/bijutsukan/',
    is_featured: false
  },
  {
    name: '国東市歴史体験学習館',
    prefecture: '大分県',
    city: '国東市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kunisaki.oita.jp/site/yayoinomura/',
    is_featured: false
  },
  {
    name: '竹田市歴史文化館・由学館',
    prefecture: '大分県',
    city: '竹田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.taketa.oita.jp/bunka_rekishi_kanko/yugakukan/index.html',
    is_featured: false
  },
  {
    name: '中津市歴史博物館',
    prefecture: '大分県',
    city: '中津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://nakahaku.jp/',
    is_featured: false
  },
  {
    name: '二階堂美術館',
    prefecture: '大分県',
    city: '速見郡日出町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nikaidou-bijyutukan.com/',
    is_featured: false
  },
  {
    name: '九州自然動物公園',
    prefecture: '大分県',
    city: '宇佐市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://www.africansafari.co.jp/',
    is_featured: false
  },
  {
    name: '大分県立先哲史料館',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.pref.oita.jp/site/sentetsusiryokan/',
    is_featured: false
  },
  {
    name: '大分マリーンパレス水族館「うみたまご」',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.umitamago.jp/',
    is_featured: false
  },
  {
    name: '久留島武彦記念館',
    prefecture: '大分県',
    city: '玖珠郡玖珠町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://kurushimatakehiko.com/',
    is_featured: false
  },
  {
    name: '耶馬溪風物館',
    prefecture: '大分県',
    city: '中津市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city-nakatsu.jp/doc/2015032000841/',
    is_featured: false
  },
  {
    name: '日田市立博物館',
    prefecture: '大分県',
    city: '日田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.city.hita.oita.jp/shisetsu/hakubutukan/7596.html',
    is_featured: false
  },
  {
    name: '廣瀬資料館',
    prefecture: '大分県',
    city: '日田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://hirose-museum.jp/',
    is_featured: false
  },
  {
    name: '大分香りの博物館',
    prefecture: '大分県',
    city: '別府市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://oita-kaori.jp/',
    is_featured: false
  },
  {
    name: '別府大学附属博物館',
    prefecture: '大分県',
    city: '別府市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.beppu-u.ac.jp/research/institutions/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 宮崎県 (10件)
# ================================
puts '宮崎県のデータを投入中...'

[
  {
    name: '高鍋町美術館',
    prefecture: '宮崎県',
    city: '児湯郡高鍋町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.takanabe.lg.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '宮崎県立西都原考古博物館',
    prefecture: '宮崎県',
    city: '西都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saito-muse.pref.miyazaki.jp/web/index.html',
    is_featured: false
  },
  {
    name: '延岡城・内藤記念博物館',
    prefecture: '宮崎県',
    city: '延岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nobeoka-naito-museum.jp',
    is_featured: false
  },
  {
    name: '都城島津邸',
    prefecture: '宮崎県',
    city: '都城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.miyakonojo.miyazaki.jp/site/shimazu/',
    is_featured: false
  },
  {
    name: '都城市立美術館',
    prefecture: '宮崎県',
    city: '都城市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.miyakonojo.miyazaki.jp/site/artmuseum/',
    is_featured: false
  },
  {
    name: '宮崎県総合博物館',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.miyazaki-archive.jp/museum/',
    is_featured: false
  },
  {
    name: '宮崎県立美術館',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miyazaki-archive.jp/bijutsu/',
    is_featured: false
  },
  {
    name: '椎葉民俗芸能博物館',
    prefecture: '宮崎県',
    city: '東臼杵郡椎葉村',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.shiibakanko.jp/tourism/spot/spot3',
    is_featured: false
  },
  {
    name: '宮崎市フェニックス自然動物園',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.miyazaki-city-zoo.jp/',
    is_featured: false
  },
  {
    name: '宮崎大学農学部附属農業博物館',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.miyazaki-u.ac.jp/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 鹿児島県 (22件)
# ================================
puts '鹿児島県のデータを投入中...'

[
  {
    name: '原野農芸博物館',
    prefecture: '鹿児島県',
    city: '奄美市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://haranoam.synapse-site.jp/',
    is_featured: false
  },
  {
    name: '指宿市考古博物館時遊館ＣＯＣＣＯはしむれ',
    prefecture: '鹿児島県',
    city: '指宿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ibusuki.lg.jp/cocco/',
    is_featured: false
  },
  {
    name: '岩崎美術館',
    prefecture: '鹿児島県',
    city: '指宿市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.iwasaki-zaidan.org/artmuseum/',
    is_featured: false
  },
  {
    name: '鹿児島県立博物館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.pref.kagoshima.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '鹿児島県歴史・美術センター黎明館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.kagoshima.jp/reimeikan/',
    is_featured: false
  },
  {
    name: '示現流兵法所史料館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.jigen-ryu.com/archives/',
    is_featured: false
  },
  {
    name: '長島美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ngp.jp/nagashima-museum/',
    is_featured: false
  },
  {
    name: '中村晋也美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ne.jp/asahi/musee/nakamura/',
    is_featured: false
  },
  {
    name: '三宅美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miyake-art.com/',
    is_featured: false
  },
  {
    name: '陽山美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.musee-yozan.or.jp/',
    is_featured: false
  },
  {
    name: '児玉美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kodama-art-museum.or.jp/',
    is_featured: false
  },
  {
    name: '松下美術館',
    prefecture: '鹿児島県',
    city: '霧島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://matsushita-art.synapse.kagoshima.jp/matushita_index.htm',
    is_featured: false
  },
  {
    name: '吉井淳二美術館',
    prefecture: '鹿児島県',
    city: '南さつま市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nonohanakai.or.jp/museum/',
    is_featured: false
  },
  {
    name: '長崎鼻パーキングガーデン',
    prefecture: '鹿児島県',
    city: '指宿市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'http://nagasakibana.com/',
    is_featured: false
  },
  {
    name: 'かごしま近代文学館・かごしまメルヘン館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.k-kb.or.jp/kinmeru/',
    is_featured: false
  },
  {
    name: '鹿児島国際大学博物館実習施設（鹿児島国際大学ミュージアム）',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://museum.iuk-plus.net/',
    is_featured: false
  },
  {
    name: '鹿児島市平川動物公園',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://hirakawazoo.jp/',
    is_featured: false
  },
  {
    name: '鹿児島市立美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kagoshima.lg.jp/artmuseum/',
    is_featured: false
  },
  {
    name: '鹿児島大学総合研究博物館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.museum.kagoshima-u.ac.jp/',
    is_featured: false
  },
  {
    name: '尚古集成館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.shuseikan.jp/',
    is_featured: false
  },
  {
    name: '南種子町広田遺跡ミュージアム',
    prefecture: '鹿児島県',
    city: '熊毛郡南種子町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.minamitane.kagoshima.jp/institution/hirotasitemuseum.html',
    is_featured: false
  },
  {
    name: '知覧特攻平和会館',
    prefecture: '鹿児島県',
    city: '南九州市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.chiran-tokkou.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 沖縄県 (20件)
# ================================
puts '沖縄県のデータを投入中...'

[
  {
    name: '石垣市立八重山博物館',
    prefecture: '沖縄県',
    city: '石垣市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ishigaki.okinawa.jp/kurashi_gyosei/kanko_bunka_sport/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: 'ひめゆり平和祈念資料館',
    prefecture: '沖縄県',
    city: '糸満市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://himeyuri.or.jp/JP/top.html',
    is_featured: false
  },
  {
    name: '浦添市美術館',
    prefecture: '沖縄県',
    city: '浦添市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.urasoe.lg.jp/category/art/',
    is_featured: false
  },
  {
    name: '沖縄市立郷土博物館',
    prefecture: '沖縄県',
    city: '沖縄市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.okinawa.okinawa.jp/k063/sportsbunka/hakubutsukan/kyoudohakubutsukan/134/index.html',
    is_featured: false
  },
  {
    name: '宜野湾市立博物館',
    prefecture: '沖縄県',
    city: '宜野湾市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ginowan.lg.jp/soshiki/kyoiku/1/2/index.html',
    is_featured: false
  },
  {
    name: '久米島博物館',
    prefecture: '沖縄県',
    city: '久米島町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://sizenbunka.ti-da.net/',
    is_featured: false
  },
  {
    name: '名護博物館',
    prefecture: '沖縄県',
    city: '名護市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nago.okinawa.jp/museum/',
    is_featured: false
  },
  {
    name: '沖縄県立博物館・美術館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://okimu.jp/',
    is_featured: false
  },
  {
    name: '那覇市立壺屋焼物博物館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.edu.city.naha.okinawa.jp/tsuboya/',
    is_featured: false
  },
  {
    name: '宮古島市総合博物館',
    prefecture: '沖縄県',
    city: '宮古島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.miyakojima.lg.jp/soshiki/kyouiku/syougaigakusyu/hakubutsukan/',
    is_featured: false
  },
  {
    name: '沖縄美ら海水族館',
    prefecture: '沖縄県',
    city: '本部町',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://churaumi.okinawa/',
    is_featured: false
  },
  {
    name: '沖縄こどもの国',
    prefecture: '沖縄県',
    city: '沖縄市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.okzm.jp/',
    is_featured: false
  },
  {
    name: '東南植物楽園',
    prefecture: '沖縄県',
    city: '沖縄市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.southeast-botanical.jp/',
    is_featured: false
  },
  {
    name: 'アスムイハイクス(沖縄石の文化博物館)',
    prefecture: '沖縄県',
    city: '国頭郡国頭村',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.asmui.jp',
    is_featured: false
  },
  {
    name: '沖縄空手会館',
    prefecture: '沖縄県',
    city: '豊見城市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://karatekaikan.jp/',
    is_featured: false
  },
  {
    name: '琉球大学博物館（風樹館）',
    prefecture: '沖縄県',
    city: '中頭郡西原町',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://fujukan.skr.u-ryukyu.ac.jp/',
    is_featured: false
  },
  {
    name: '沖縄県立芸術大学附属図書・芸術資料館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www2.lib.okigei.ac.jp/lib/lib.html',
    is_featured: false
  },
  {
    name: '対馬丸記念館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://tsushimamaru.or.jp/',
    is_featured: false
  },
  {
    name: 'おきなわワールド',
    prefecture: '沖縄県',
    city: '南城市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.gyokusendo.co.jp/okinawaworld/',
    is_featured: false
  },
  {
    name: '南風原町立南風原文化センター',
    prefecture: '沖縄県',
    city: '南風原町',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: '',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

puts '================================================'
puts '博物館データの投入が完了しました'
puts '================================================'
puts "新規作成: #{created_count}件"
puts "更新: #{updated_count}件"
puts "エラー: #{error_count}件"
puts "総博物館数: #{Museum.count}件"
puts '================================================'

# 都道府県別統計
puts '\n【都道府県別データ数】'
puts '  北海道: 73件'
puts '  青森県: 7件'
puts '  岩手県: 23件'
puts '  宮城県: 17件'
puts '  秋田県: 14件'
puts '  山形県: 18件'
puts '  福島県: 21件'
puts '  茨城県: 24件'
puts '  栃木県: 26件'
puts '  群馬県: 26件'
puts '  埼玉県: 30件'
puts '  千葉県: 51件'
puts '  東京都: 129件'
puts '  神奈川県: 52件'
puts '  新潟県: 36件'
puts '  富山県: 37件'
puts '  石川県: 30件'
puts '  福井県: 22件'
puts '  山梨県: 28件'
puts '  長野県: 84件'
puts '  岐阜県: 25件'
puts '  静岡県: 46件'
puts '  愛知県: 49件'
puts '  三重県: 20件'
puts '  滋賀県: 20件'
puts '  京都府: 54件'
puts '  大阪府: 41件'
puts '  兵庫県: 48件'
puts '  奈良県: 22件'
puts '  和歌山県: 15件'
puts '  鳥取県: 9件'
puts '  島根県: 25件'
puts '  岡山県: 33件'
puts '  広島県: 37件'
puts '  山口県: 23件'
puts '  徳島県: 11件'
puts '  香川県: 17件'
puts '  愛媛県: 24件'
puts '  高知県: 17件'
puts '  福岡県: 36件'
puts '  佐賀県: 13件'
puts '  長崎県: 18件'
puts '  熊本県: 21件'
puts '  大分県: 16件'
puts '  宮崎県: 10件'
puts '  鹿児島県: 22件'
puts '  沖縄県: 20件'

puts '\n✓ データ投入が完了しました'
# frozen_string_literal: true

# =================================================
# MVSEDAYS museum data
# 総データ数: 1440件
# 都道府県数: 47件
# 生成日時: 2025-12-02 23:17:41
# =================================================

puts '================================================'
puts '博物館データの投入を開始します'
puts '================================================'

created_count = 0
updated_count = 0
error_count = 0

# ================================
# 北海道 (73件)
# ================================
puts '北海道のデータを投入中...'

[
  {
    name: '旭川市旭山動物園',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/asahiyamazoo/',
    is_featured: false
  },
  {
    name: '旭川市科学館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/science/',
    is_featured: false
  },
  {
    name: '旭川市博物館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/hakubutukan/index.html',
    is_featured: false
  },
  {
    name: '中原悌二郎記念旭川市彫刻美術館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.asahikawa.hokkaido.jp/sculpture/',
    is_featured: false
  },
  {
    name: '北海道立旭川美術館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/abj',
    is_featured: false
  },
  {
    name: '三浦綾子記念文学館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.hyouten.com/',
    is_featured: false
  },
  {
    name: '厚岸町海事記念館',
    prefecture: '北海道',
    city: '厚岸町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://edu.town.akkeshi.hokkaido.jp/kaiji/',
    is_featured: false
  },
  {
    name: '網走市立郷土博物館',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.abashiri.hokkaido.jp/site/kyodo/',
    is_featured: false
  },
  {
    name: '網走市立美術館',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.abashiri.hokkaido.jp/site/artmuseum/',
    is_featured: false
  },
  {
    name: '博物館　網走監獄',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kangoku.jp/',
    is_featured: false
  },
  {
    name: '北海道立北方民族博物館',
    prefecture: '北海道',
    city: '網走市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hoppohm.org/index2.htm',
    is_featured: false
  },
  {
    name: '荒井記念美術館',
    prefecture: '北海道',
    city: '岩内町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.iwanai-h.com/art/',
    is_featured: false
  },
  {
    name: '浦河町立郷土博物館',
    prefecture: '北海道',
    city: '浦河町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.urakawa.hokkaido.jp/gyosei/culture/?category=100',
    is_featured: false
  },
  {
    name: '浦幌町立博物館',
    prefecture: '北海道',
    city: '浦幌町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://museum-urahoro.jp',
    is_featured: false
  },
  {
    name: 'オホーツクミュージアムえさし',
    prefecture: '北海道',
    city: '枝幸郡',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.esashi.jp/tourism/guide/museum.html',
    is_featured: false
  },
  {
    name: '小樽芸術村',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.nitorihd.co.jp/otaru-art-base/',
    is_featured: false
  },
  {
    name: '小樽市総合博物館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.otaru.lg.jp/categories/bunya/shisetsu/bunka_kanko/museum/',
    is_featured: false
  },
  {
    name: 'おたる水族館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://otaru-aq.jp/',
    is_featured: false
  },
  {
    name: '北一ヴェネツィア美術館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://venezia-museum.or.jp/',
    is_featured: false
  },
  {
    name: '市立小樽美術館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.otaru.lg.jp/categories/bunya/shisetsu/bunka_kanko/bijyutsukan/',
    is_featured: false
  },
  {
    name: '市立小樽文学館',
    prefecture: '北海道',
    city: '小樽市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://otarubungakusha.com/yakata',
    is_featured: false
  },
  {
    name: '帯広百年記念館',
    prefecture: '北海道',
    city: '帯広市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museum-obihiro.jp/occm/',
    is_featured: false
  },
  {
    name: '北海道立帯広美術館',
    prefecture: '北海道',
    city: '帯広市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/obj/',
    is_featured: false
  },
  {
    name: '標茶町博物館',
    prefecture: '北海道',
    city: '川上郡標茶町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.sip.or.jp/~shibecha-museum/',
    is_featured: false
  },
  {
    name: '北網圏北見文化センター',
    prefecture: '北海道',
    city: '北見市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://hokumouken.com/',
    is_featured: false
  },
  {
    name: '釧路市立博物館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kushiro.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '釧路市立美術館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://k-bijutsukan.net/',
    is_featured: false
  },
  {
    name: '北海道立釧路芸術館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kushiro-artmu.jp/',
    is_featured: false
  },
  {
    name: '札幌市青少年科学館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.ssc.slp.or.jp/',
    is_featured: false
  },
  {
    name: '札幌市円山動物園',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.city.sapporo.jp/zoo/',
    is_featured: false
  },
  {
    name: '北海道立近代美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/knb/',
    is_featured: false
  },
  {
    name: '北海道立文学館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.h-bungaku.or.jp/',
    is_featured: false
  },
  {
    name: '北海道立三岸好太郎美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/mkb/',
    is_featured: false
  },
  {
    name: '士別市立博物館・士別市公会堂展示室',
    prefecture: '北海道',
    city: '士別市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.shibetsu.lg.jp/gyoseisaito/kosodate_bunka_supotsu/shibetsushiritsuhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '斜里町立知床博物館',
    prefecture: '北海道',
    city: '斜里町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://shiretoko-museum.jpn.org/',
    is_featured: false
  },
  {
    name: '新ひだか町博物館',
    prefecture: '北海道',
    city: '新ひだか町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.shinhidaka-hokkaido.jp/hotnews/category/180.html',
    is_featured: false
  },
  {
    name: 'だて歴史文化ミュージアム',
    prefecture: '北海道',
    city: '伊達市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://date-museum.jp/',
    is_featured: false
  },
  {
    name: '苫小牧市科学センター',
    prefecture: '北海道',
    city: '苫小牧市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.tomakomai.hokkaido.jp/kagaku/',
    is_featured: false
  },
  {
    name: '苫小牧市美術博物館',
    prefecture: '北海道',
    city: '苫小牧市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.tomakomai.hokkaido.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '名寄市北国博物館',
    prefecture: '北海道',
    city: '名寄市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.nayoro.lg.jp/section/museum/prkeql000000krpr.html',
    is_featured: false
  },
  {
    name: '市立函館博物館',
    prefecture: '北海道',
    city: '函館市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://hakohaku.com/',
    is_featured: false
  },
  {
    name: '函館市縄文文化交流センター',
    prefecture: '北海道',
    city: '函館市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.hjcc.jp/',
    is_featured: false
  },
  {
    name: '北海道立函館美術館',
    prefecture: '北海道',
    city: '函館市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artmuseum.pref.hokkaido.lg.jp/hbj',
    is_featured: false
  },
  {
    name: '日高山脈博物館',
    prefecture: '北海道',
    city: '日高町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.town.hidaka.hokkaido.jp/site/hmc/',
    is_featured: false
  },
  {
    name: '安田侃彫刻美術館アルテピアッツァ美唄',
    prefecture: '北海道',
    city: '美唄市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://artepiazza.jp/',
    is_featured: false
  },
  {
    name: '美幌博物館',
    prefecture: '北海道',
    city: '美幌町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.bihoro.hokkaido.jp/site/museum/',
    is_featured: false
  },
  {
    name: '平取町立二風谷アイヌ文化博物館',
    prefecture: '北海道',
    city: '平取町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nibutani-ainu-museum.com/',
    is_featured: false
  },
  {
    name: '広尾町海洋博物館　広尾町郷土文化保存伝習館',
    prefecture: '北海道',
    city: '広尾町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.hiroo.lg.jp/kankou/leisurespot/rekishi/',
    is_featured: false
  },
  {
    name: '三笠市立博物館',
    prefecture: '北海道',
    city: '三笠市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.mikasa.hokkaido.jp/museum/',
    is_featured: false
  },
  {
    name: '穂別博物館',
    prefecture: '北海道',
    city: 'むかわ町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.town.mukawa.lg.jp/1908.htm',
    is_featured: false
  },
  {
    name: '紋別市立博物館',
    prefecture: '北海道',
    city: '紋別市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://mombetsu.jp/sisetu/bunkasisetu/hakubutukan/',
    is_featured: false
  },
  {
    name: '利尻町立博物館',
    prefecture: '北海道',
    city: '利尻町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://rishiri-town.jp/%e6%95%99%e8%82%b2/%e5%88%a9%e5%b0%bb%e7%94%ba%e5%8d%9a%e7%89%a9%e9%a4%a8/',
    is_featured: false
  },
  {
    name: '旭川兵村記念館',
    prefecture: '北海道',
    city: '旭川市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://asahikawaheison.sakura.ne.jp/',
    is_featured: false
  },
  {
    name: 'ロイズミュージアム',
    prefecture: '北海道',
    city: '石狩郡当別町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.royce.com/cct/',
    is_featured: false
  },
  {
    name: '帯広市動物園',
    prefecture: '北海道',
    city: '帯広市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.obihiro.hokkaido.jp/zoo/',
    is_featured: false
  },
  {
    name: '神田日勝記念美術館',
    prefecture: '北海道',
    city: '河東郡鹿追町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://kandanissho.com/',
    is_featured: false
  },
  {
    name: '福原記念美術館',
    prefecture: '北海道',
    city: '河東郡鹿追町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://art-fukuhara.jp/',
    is_featured: false
  },
  {
    name: '東京大学大学院人文社会系研究科附属北海文化研究常呂実習施設',
    prefecture: '北海道',
    city: '北見市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.l.u-tokyo.ac.jp/tokoro/',
    is_featured: false
  },
  {
    name: '釧路市こども遊学館',
    prefecture: '北海道',
    city: '釧路市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://kodomoyugakukan.jp/',
    is_featured: false
  },
  {
    name: '札幌芸術の森美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://artpark.or.jp/shisetsu/sapporo-art-museum/',
    is_featured: false
  },
  {
    name: '北海道開拓の村',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '野外博物館',
    official_website: 'https://www.kaitaku.or.jp/',
    is_featured: false
  },
  {
    name: '北海道大学北方生物圏フィールド科学センター植物園',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.fsc.hokudai.ac.jp/',
    is_featured: false
  },
  {
    name: '本郷新記念札幌彫刻美術館',
    prefecture: '北海道',
    city: '札幌市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.hongoshin-smos.jp/',
    is_featured: false
  },
  {
    name: '国立アイヌ民族博物館',
    prefecture: '北海道',
    city: '白老町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://ainu-upopoy.jp/',
    is_featured: false
  },
  {
    name: '仙台藩白老元陣屋資料館',
    prefecture: '北海道',
    city: '白老町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.shiraoi.hokkaido.jp/docs/2020062800019/',
    is_featured: false
  },
  {
    name: 'サケのふるさと千歳水族館',
    prefecture: '北海道',
    city: '千歳市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://chitose-aq.jp/',
    is_featured: false
  },
  {
    name: 'ウトナイ湖サンクチュアリ「ネイチャーセンター」',
    prefecture: '北海道',
    city: '苫小牧市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://utonai-nc.sakura.ne.jp/index.html',
    is_featured: false
  },
  {
    name: '根室市歴史と自然の資料館',
    prefecture: '北海道',
    city: '根室市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.nemuro.hokkaido.jp/lifeinfo/kakuka/kyoikuiinkai/kyoikushiryokan/index.html',
    is_featured: false
  },
  {
    name: 'のぼりべつクマ牧場ヒグマ博物館',
    prefecture: '北海道',
    city: '登別市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://bearpark.jp/museum_observatory/',
    is_featured: false
  },
  {
    name: '登別マリンパークニクス',
    prefecture: '北海道',
    city: '登別市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.nixe.co.jp/',
    is_featured: false
  },
  {
    name: 'えりも町郷土資料館・水産の館',
    prefecture: '北海道',
    city: '幌泉郡えりも町',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.town.erimo.lg.jp/horoizumi/index.html',
    is_featured: false
  },
  {
    name: '室蘭市民俗資料館',
    prefecture: '北海道',
    city: '室蘭市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.muroran.lg.jp/culture/?content=1516',
    is_featured: false
  },
  {
    name: '夕張市石炭博物館',
    prefecture: '北海道',
    city: '夕張市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://coal-yubari.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 青森県 (7件)
# ================================
puts '青森県のデータを投入中...'

[
  {
    name: '青森県立郷土館',
    prefecture: '青森県',
    city: '青森市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.kyodokan.com/',
    is_featured: false
  },
  {
    name: '八戸市博物館',
    prefecture: '青森県',
    city: '八戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hachinohe-city-museum.jp/',
    is_featured: false
  },
  {
    name: '八戸市美術館',
    prefecture: '青森県',
    city: '八戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hachinohe-art-museum.jp/',
    is_featured: false
  },
  {
    name: '高岡の森弘前藩歴史館',
    prefecture: '青森県',
    city: '弘前市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.hirosaki.aomori.jp/takaoka-rekishikan/',
    is_featured: false
  },
  {
    name: '弘前市立博物館',
    prefecture: '青森県',
    city: '弘前市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.hirosaki.aomori.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '青森県立美術館',
    prefecture: '青森県',
    city: '青森市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.aomori-museum.jp/',
    is_featured: false
  },
  {
    name: '弘前れんが倉庫美術館',
    prefecture: '青森県',
    city: '弘前市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.hirosaki-moca.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 岩手県 (23件)
# ================================
puts '岩手県のデータを投入中...'

[
  {
    name: '一関市博物館',
    prefecture: '岩手県',
    city: '一関市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ichinoseki.iwate.jp/museum/',
    is_featured: false
  },
  {
    name: '石神の丘美術館',
    prefecture: '岩手県',
    city: '岩手郡岩手町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ishigami-iwate.jp/',
    is_featured: false
  },
  {
    name: '牛の博物館',
    prefecture: '岩手県',
    city: '奥州市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.oshu.iwate.jp/section/ushi/index.html',
    is_featured: false
  },
  {
    name: '大船渡市立博物館',
    prefecture: '岩手県',
    city: '大船渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ofunato.iwate.jp/archive/p20250115182916',
    is_featured: false
  },
  {
    name: '北上市立鬼の館',
    prefecture: '岩手県',
    city: '北上市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kitakami.iwate.jp/life/soshikikarasagasu/oninoyakata/index.html',
    is_featured: false
  },
  {
    name: '北上市立博物館',
    prefecture: '岩手県',
    city: '北上市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kitakami.iwate.jp/life/soshikikarasagasu/hakubutsu/1_1/index.html',
    is_featured: false
  },
  {
    name: '遠野市立博物館',
    prefecture: '岩手県',
    city: '遠野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tono.iwate.jp/index.cfm/48,25002,166,html',
    is_featured: false
  },
  {
    name: '碧祥寺博物館',
    prefecture: '岩手県',
    city: '西和賀町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://yamanoideyu.com/spot/article.php?p=74',
    is_featured: false
  },
  {
    name: '御所野縄文博物館',
    prefecture: '岩手県',
    city: '二戸郡一戸町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://goshono-iseki.com/',
    is_featured: false
  },
  {
    name: '花巻市博物館',
    prefecture: '岩手県',
    city: '花巻市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hanamaki.iwate.jp/bunkasports/bunka/1019887/1008981/index.html',
    is_featured: false
  },
  {
    name: '萬鉄五郎記念美術館',
    prefecture: '岩手県',
    city: '花巻市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hanamaki.iwate.jp/bunkasports/bunka/1019887/yorozutetsugoro/1002101.html',
    is_featured: false
  },
  {
    name: '宮古市北上山地民俗資料館',
    prefecture: '岩手県',
    city: '宮古市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://kitakamisanchi.city.miyako.iwate.jp/',
    is_featured: false
  },
  {
    name: '宮古市崎山貝塚縄文の森ミュージアム',
    prefecture: '岩手県',
    city: '宮古市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.miyako.iwate.jp/gyosei/kanko_bunka_sports/rekishi_bunkazai/8498.html',
    is_featured: false
  },
  {
    name: '岩手県立博物館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www2.pref.iwate.jp/~hp0910/',
    is_featured: false
  },
  {
    name: '岩手県立美術館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ima.or.jp/',
    is_featured: false
  },
  {
    name: '深沢紅子野の花美術館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nonohana.hs.plala.or.jp/',
    is_featured: false
  },
  {
    name: '盛岡市遺跡の学び館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.morioka.iwate.jp/kankou/kankou/1037106/rekishi/1009437/1009438.html',
    is_featured: false
  },
  {
    name: '盛岡市子ども科学館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://kodomokagakukan.com/',
    is_featured: false
  },
  {
    name: '盛岡市先人記念館',
    prefecture: '岩手県',
    city: '盛岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mfca.jp/senjin/',
    is_featured: false
  },
  {
    name: '陸前高田市立博物館',
    prefecture: '岩手県',
    city: '陸前高市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.rikuzentakata.iwate.jp/soshiki/kyouikusoumuka/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '久慈琥珀博物館',
    prefecture: '岩手県',
    city: '久慈市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.kuji.co.jp/museum',
    is_featured: false
  },
  {
    name: '岩手県立平泉世界遺産ガイダンスセンター',
    prefecture: '岩手県',
    city: '西磐井郡平泉町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.sekaiisan.pref.iwate.jp/information',
    is_featured: false
  },
  {
    name: '宮沢賢治記念館',
    prefecture: '岩手県',
    city: '花巻市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.hanamaki.iwate.jp/miyazawakenji/kinenkan/index.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 宮城県 (17件)
# ================================
puts '宮城県のデータを投入中...'

[
  {
    name: 'リアス・アーク美術館',
    prefecture: '宮城県',
    city: '気仙沼市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://rias-ark.sakura.ne.jp/2/',
    is_featured: false
  },
  {
    name: '塩竃市杉村惇美術館',
    prefecture: '宮城県',
    city: '塩竈市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sugimurajun.shiomo.jp/',
    is_featured: false
  },
  {
    name: '鹽竈神社博物館',
    prefecture: '宮城県',
    city: '塩竈市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.shiogamajinja.jp/museum/',
    is_featured: false
  },
  {
    name: 'カメイ美術館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kameimuseum.or.jp/',
    is_featured: false
  },
  {
    name: 'HOKUSHU仙台市科学館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.kagakukan.sendai-c.ed.jp/',
    is_featured: false
  },
  {
    name: '仙台市天文台',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.sendai-astro.jp/',
    is_featured: false
  },
  {
    name: '仙台市博物館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sendai.jp/museum/',
    is_featured: false
  },
  {
    name: '宮城県美術館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.pref.miyagi.jp/site/mmoa/',
    is_featured: false
  },
  {
    name: '歴史博物館青葉城資料展示館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://honmarukaikan.com/s/docs/tenji/',
    is_featured: false
  },
  {
    name: '東北歴史博物館',
    prefecture: '宮城県',
    city: '多賀城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.thm.pref.miyagi.jp/',
    is_featured: false
  },
  {
    name: '瑞巌寺宝物館',
    prefecture: '宮城県',
    city: '宮城郡松島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://zuiganji.or.jp/museum/',
    is_featured: false
  },
  {
    name: '宮城県慶長使節船ミュージアム（サン・ファン館）',
    prefecture: '宮城県',
    city: '石巻市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.santjuan.or.jp/',
    is_featured: false
  },
  {
    name: '大崎市松山ふるさと歴史館',
    prefecture: '宮城県',
    city: '大崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.osaki.miyagi.jp/shisei/soshikikarasagasu/kyoikuiinkaijimukyoku/matsuyamakominkan/1/1/2682.html',
    is_featured: false
  },
  {
    name: '仙台市八木山動物公園',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.sendai.jp/zoo/',
    is_featured: false
  },
  {
    name: '東北学院大学博物館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tohoku-gakuin.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '東北福祉大学芹沢銈介美術工芸館',
    prefecture: '宮城県',
    city: '仙台市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tfu.ac.jp/kogeikan/',
    is_featured: false
  },
  {
    name: '奥松島縄文村歴史資料館',
    prefecture: '宮城県',
    city: '東松島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.satohama-jomon.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 秋田県 (14件)
# ================================
puts '秋田県のデータを投入中...'

[
  {
    name: '秋田県立博物館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://akihaku.jp/',
    is_featured: false
  },
  {
    name: '秋田県立美術館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.akita-museum-of-art.jp/index.htm',
    is_featured: false
  },
  {
    name: '秋田市立佐竹史料館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.akita.lg.jp/kanko/kanrenshisetsu/1002685/index.html',
    is_featured: false
  },
  {
    name: '秋田市立千秋美術館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.akita.lg.jp/kanko/kanrenshisetsu/1003643/index.html',
    is_featured: false
  },
  {
    name: '小坂町立総合博物館郷土館',
    prefecture: '秋田県',
    city: '鹿角郡小坂町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.kosaka.akita.jp/machinososhiki/sonotashisetsu/sogouhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '浜辺の歌音楽館',
    prefecture: '秋田県',
    city: '北秋田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kitaakita.akita.jp/archive/p20250430150709',
    is_featured: false
  },
  {
    name: '大潟村干拓博物館',
    prefecture: '秋田県',
    city: '南秋田郡大潟村',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museum.vill.ogata.akita.jp/',
    is_featured: false
  },
  {
    name: '秋田県立近代美術館',
    prefecture: '秋田県',
    city: '横手市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://akita-kinbi.jp/',
    is_featured: false
  },
  {
    name: '秋田県児童会館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://akita-jidoukaikan.com/',
    is_featured: false
  },
  {
    name: '秋田大学国際資源学部附属鉱業博物館',
    prefecture: '秋田県',
    city: '秋田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.mus.akita-u.ac.jp/',
    is_featured: false
  },
  {
    name: '秋田県立農業科学館',
    prefecture: '秋田県',
    city: '大仙市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.obako.or.jp/sun-agrin/',
    is_featured: false
  },
  {
    name: '白瀬南極探検隊記念館',
    prefecture: '秋田県',
    city: 'にかほ市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://shirase-kinenkan.jp/index.html',
    is_featured: false
  },
  {
    name: '雄物川郷土資料館',
    prefecture: '秋田県',
    city: '横手市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.yokote.lg.jp/shisetsu/1001528/1005103.html',
    is_featured: false
  },
  {
    name: '横手市増田まんが美術館',
    prefecture: '秋田県',
    city: '横手市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://manga-museum.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 山形県 (18件)
# ================================
puts '山形県のデータを投入中...'

[
  {
    name: '斎藤茂吉記念館',
    prefecture: '山形県',
    city: '上山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mokichi.or.jp/',
    is_featured: false
  },
  {
    name: '本間美術館',
    prefecture: '山形県',
    city: '酒田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.homma-museum.or.jp/',
    is_featured: false
  },
  {
    name: '金峯山博物館',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.gakushubunka.jp/yugakukan/public/facilities0307-2/',
    is_featured: false
  },
  {
    name: '致道博物館',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.chido.jp/',
    is_featured: false
  },
  {
    name: '鶴岡アートフォーラム',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.t-artforum.net/',
    is_featured: false
  },
  {
    name: '出羽三山歴史博物館',
    prefecture: '山形県',
    city: '鶴岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.dewasanzan.jp/publics/index/14/',
    is_featured: false
  },
  {
    name: '出羽桜美術館',
    prefecture: '山形県',
    city: '天童市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.dewazakura.co.jp/museum/',
    is_featured: false
  },
  {
    name: '掬粋巧芸館',
    prefecture: '山形県',
    city: '東置賜郡川西町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.taruhei.co.jp/MuseumFolder/',
    is_featured: false
  },
  {
    name: '山形県立博物館、山形県立博物館教育資料館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.yamagata-museum.jp/',
    is_featured: false
  },
  {
    name: '山形美術館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yamagata-art-museum.or.jp/',
    is_featured: false
  },
  {
    name: '上杉神社稽照殿',
    prefecture: '山形県',
    city: '米沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.uesugi-jinja.or.jp/keishoden/',
    is_featured: false
  },
  {
    name: '公益財団法人宮坂考古館',
    prefecture: '山形県',
    city: '米沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.miyasakakoukokan.com/',
    is_featured: false
  },
  {
    name: '米沢市上杉博物館',
    prefecture: '山形県',
    city: '米沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.denkoku-no-mori.yonezawa.yamagata.jp/uesugi.htm',
    is_featured: false
  },
  {
    name: '天童市美術館',
    prefecture: '山形県',
    city: '天童市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://tendocity-museum.jp/',
    is_featured: false
  },
  {
    name: '最上義光歴史館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://mogamiyoshiaki.jp/',
    is_featured: false
  },
  {
    name: '山形市野草園',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.yasouen.jp/',
    is_featured: false
  },
  {
    name: '山形大学附属博物館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'http://museum.yamagata-u.ac.jp/',
    is_featured: false
  },
  {
    name: '山寺芭蕉記念館',
    prefecture: '山形県',
    city: '山形市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://samidare.jp/basho/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 福島県 (21件)
# ================================
puts '福島県のデータを投入中...'

[
  {
    name: '福島県立博物館',
    prefecture: '福島県',
    city: '会津若松市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://general-museum.fcs.ed.jp/',
    is_featured: false
  },
  {
    name: 'いわき市立美術館',
    prefecture: '福島県',
    city: 'いわき市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.city.iwaki.lg.jp/www/genre/1444022369394/index.html',
    is_featured: false
  },
  {
    name: 'ふくしま海洋科学館',
    prefecture: '福島県',
    city: 'いわき市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.aquamarine.or.jp/',
    is_featured: false
  },
  {
    name: '郡山開成学園生活文化博物館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.koriyama-kgc.ac.jp/campus/lcm',
    is_featured: false
  },
  {
    name: '郡山市立美術館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.koriyama.lg.jp/site/artmuseum/',
    is_featured: false
  },
  {
    name: '郡山市歴史情報博物館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.koriyama.lg.jp/site/historymuseum/',
    is_featured: false
  },
  {
    name: '藤田記念博物館',
    prefecture: '福島県',
    city: '白河市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fujitakinenhakubutsukan.amebaownd.com/',
    is_featured: false
  },
  {
    name: '須賀川市立博物館',
    prefecture: '福島県',
    city: '須賀川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sukagawa.fukushima.jp/bunka_sports/bunka_geijyutsu/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '福島県立美術館',
    prefecture: '福島県',
    city: '福島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://art-museum.fcs.ed.jp/',
    is_featured: false
  },
  {
    name: '奥会津博物館',
    prefecture: '福島県',
    city: '南会津郡南会津町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.minamiaizu.lg.jp/official/bunka_sports_kanko/bunka/okuaizuhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '南相馬市博物館',
    prefecture: '福島県',
    city: '南相馬市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.minamisoma.lg.jp/portal/culture/museum/index.html',
    is_featured: false
  },
  {
    name: '会津民俗館',
    prefecture: '福島県',
    city: '耶麻郡猪苗代町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.aiaiaizu.com/aizuminzokukan/',
    is_featured: false
  },
  {
    name: '野口英世記念館',
    prefecture: '福島県',
    city: '耶麻郡猪苗代町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.noguchihideyo.or.jp/',
    is_featured: false
  },
  {
    name: '諸橋近代美術館',
    prefecture: '福島県',
    city: '耶麻郡北塩原村',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://dali.jp/',
    is_featured: false
  },
  {
    name: '會津藩校日新館',
    prefecture: '福島県',
    city: '会津若松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://nisshinkan.jp/',
    is_featured: false
  },
  {
    name: '会津武家屋敷会津歴史資料館',
    prefecture: '福島県',
    city: '会津若松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://bukeyashiki.com/',
    is_featured: false
  },
  {
    name: 'やないづ町立斎藤清美術館',
    prefecture: '福島県',
    city: '河沼郡柳津町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.town.yanaizu.fukushima.jp/bijutsu/',
    is_featured: false
  },
  {
    name: '喜多方市美術館',
    prefecture: '福島県',
    city: '喜多方市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.kcmofa.com/',
    is_featured: false
  },
  {
    name: '安積歴史博物館',
    prefecture: '福島県',
    city: '郡山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://anrekihaku.or.jp/',
    is_featured: false
  },
  {
    name: 'はじまりの美術館',
    prefecture: '福島県',
    city: '耶麻郡猪苗代町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://hajimari-ac.com/',
    is_featured: false
  },
  {
    name: '磐梯山噴火記念館',
    prefecture: '福島県',
    city: '耶麻郡北塩原村',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.bandaimuse.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 茨城県 (24件)
# ================================
puts '茨城県のデータを投入中...'

[
  {
    name: '茨城県陶芸美術館',
    prefecture: '茨城県',
    city: '笠間市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tougei.museum.ibk.ed.jp/index.html',
    is_featured: false
  },
  {
    name: '笠間日動美術館',
    prefecture: '茨城県',
    city: '笠間市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nichido-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'かすみがうら市歴史博物館',
    prefecture: '茨城県',
    city: 'かすみがうら市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kasumigaura.lg.jp/page/dir003355.html',
    is_featured: false
  },
  {
    name: '古河歴史博物館',
    prefecture: '茨城県',
    city: '古河市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kogakanko.jp/spot/tour/rekihaku',
    is_featured: false
  },
  {
    name: 'しもだて美術館',
    prefecture: '茨城県',
    city: '筑西市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.chikusei.lg.jp/page/dir004549.html',
    is_featured: false
  },
  {
    name: 'つくばエキスポセンター',
    prefecture: '茨城県',
    city: 'つくば市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.expocenter.or.jp/',
    is_featured: false
  },
  {
    name: '上高津貝塚ふるさと歴史の広場',
    prefecture: '茨城県',
    city: '土浦市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tsuchiura.lg.jp/kamitakatsukaizuka/index.html',
    is_featured: false
  },
  {
    name: '土浦市立博物館',
    prefecture: '茨城県',
    city: '土浦市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tsuchiura.lg.jp/tsuchiurashiritsuhakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '原子力科学館',
    prefecture: '茨城県',
    city: '那珂郡東海村',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://ibagen.or.jp/',
    is_featured: false
  },
  {
    name: 'ミュージアムパーク茨城県自然博物館',
    prefecture: '茨城県',
    city: '坂東市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.nat.museum.ibk.ed.jp/',
    is_featured: false
  },
  {
    name: '大洗町幕末と明治の博物館',
    prefecture: '茨城県',
    city: '東茨城郡大洗町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bakumatsu-meiji.com/',
    is_featured: false
  },
  {
    name: '常陸太田市郷土資料館',
    prefecture: '茨城県',
    city: '常陸太田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hitachiota.ibaraki.jp/page/dir004387.html',
    is_featured: false
  },
  {
    name: '日立市郷土博物館',
    prefecture: '茨城県',
    city: '日立市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hitachi.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '茨城県近代美術館・つくば分館・天心記念五浦分館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.modernart.museum.ibk.ed.jp/',
    is_featured: false
  },
  {
    name: '茨城県立歴史館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://rekishikan-ibk.jp/',
    is_featured: false
  },
  {
    name: '徳川ミュージアム',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.tokugawa.gr.jp/',
    is_featured: false
  },
  {
    name: '水戸市立博物館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://shihaku1.hs.plala.or.jp/',
    is_featured: false
  },
  {
    name: 'ツムラ漢方記念館',
    prefecture: '茨城県',
    city: '稲敷郡阿見町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tsumura.co.jp/hellotsumura/',
    is_featured: false
  },
  {
    name: '茨城県霞ケ浦環境科学センター',
    prefecture: '茨城県',
    city: '土浦市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.pref.ibaraki.jp/soshiki/seikatsukankyo/kasumigauraesc/',
    is_featured: false
  },
  {
    name: 'アクアワールド茨城県大洗水族館',
    prefecture: '茨城県',
    city: '東茨城郡大洗町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.aquaworld-oarai.com/',
    is_featured: false
  },
  {
    name: '大洗海洋博物館',
    prefecture: '茨城県',
    city: '東茨城郡大洗町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.oarai-isosakijinja.net/hakubutukan/',
    is_featured: false
  },
  {
    name: '日立市かみね動物園',
    prefecture: '茨城県',
    city: '日立市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.hitachi.lg.jp/zoo/',
    is_featured: false
  },
  {
    name: '常磐神社・義烈館（水戸黄門宝物館）',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://komonsan.jp/giretsukan/',
    is_featured: false
  },
  {
    name: '水戸芸術館',
    prefecture: '茨城県',
    city: '水戸市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.arttowermito.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 栃木県 (26件)
# ================================
puts '栃木県のデータを投入中...'

[
  {
    name: '足利市立美術館',
    prefecture: '栃木県',
    city: '足利市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.watv.ne.jp/ashi-bi/',
    is_featured: false
  },
  {
    name: '大久保分校スタートアップミュージアム',
    prefecture: '栃木県',
    city: '足利市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://okubomuseum.com',
    is_featured: false
  },
  {
    name: '栗田美術館',
    prefecture: '栃木県',
    city: '足利市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kurita.or.jp/',
    is_featured: false
  },
  {
    name: '宇都宮動物園',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://utsunomiya-zoo.com/',
    is_featured: false
  },
  {
    name: '宇都宮美術館',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://u-moa.jp/',
    is_featured: false
  },
  {
    name: '栃木県立博物館',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.muse.pref.tochigi.lg.jp/',
    is_featured: false
  },
  {
    name: '栃木県立美術館',
    prefecture: '栃木県',
    city: '宇都宮市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.art.pref.tochigi.lg.jp/',
    is_featured: false
  },
  {
    name: '小山市立博物館',
    prefecture: '栃木県',
    city: '小山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.oyama.tochigi.jp/site/hakubutu/',
    is_featured: false
  },
  {
    name: 'さくら市ミュージアム-荒井寛方記念館-',
    prefecture: '栃木県',
    city: 'さくら市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tochigi-sakura.lg.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '佐野市郷土博物館',
    prefecture: '栃木県',
    city: '佐野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sano-haku.com/',
    is_featured: false
  },
  {
    name: '佐野市立吉澤記念美術館',
    prefecture: '栃木県',
    city: '佐野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.sano.lg.jp/sp/yoshizawakinembijutsukan/index.html',
    is_featured: false
  },
  {
    name: '和気記念館',
    prefecture: '栃木県',
    city: '塩谷郡塩谷町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://boubou.jp/',
    is_featured: false
  },
  {
    name: '塚田歴史伝説館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.tochigi-kankou.or.jp/spot/tsukadarekishikan',
    is_featured: false
  },
  {
    name: '栃木市立美術館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.tochigi.lg.jp/site/museum-tcam/',
    is_featured: false
  },
  {
    name: '栃木市立文学館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tochigi.lg.jp/site/museum-tclm/',
    is_featured: false
  },
  {
    name: '那珂川町馬頭広重美術館',
    prefecture: '栃木県',
    city: '那須郡那珂川町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hiroshige.bato.tochigi.jp/',
    is_featured: false
  },
  {
    name: '藤城清治美術館那須高原',
    prefecture: '栃木県',
    city: '那須郡那須町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://fujishiro-seiji-museum.jp/',
    is_featured: false
  },
  {
    name: '那須塩原市那須野が原博物館',
    prefecture: '栃木県',
    city: '那須塩原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://nasunogahara-museum.jp/',
    is_featured: false
  },
  {
    name: '小杉放菴記念日光美術館',
    prefecture: '栃木県',
    city: '日光市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.khmoan.jp/',
    is_featured: false
  },
  {
    name: '日光二荒山神社宝物館',
    prefecture: '栃木県',
    city: '日光市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.futarasan.jp/',
    is_featured: false
  },
  {
    name: '益子陶芸美術館',
    prefecture: '栃木県',
    city: '芳賀郡益子町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.mashiko-museum.jp/',
    is_featured: false
  },
  {
    name: '濱田庄司記念益子参考館',
    prefecture: '栃木県',
    city: '芳賀郡益子町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mashiko-sankokan.net/',
    is_featured: false
  },
  {
    name: '山縣有朋記念館',
    prefecture: '栃木県',
    city: '矢板市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.general-yamagata-foundation.or.jp/',
    is_featured: false
  },
  {
    name: '栃木県なかがわ水遊園',
    prefecture: '栃木県',
    city: '大田原市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://tnap.jp/',
    is_featured: false
  },
  {
    name: '国學院大學栃木学園参考館',
    prefecture: '栃木県',
    city: '栃木市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kokugakuintochigi.ac.jp/sankokan/',
    is_featured: false
  },
  {
    name: '那須ワールドモンキーパーク',
    prefecture: '栃木県',
    city: '那須郡那須町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.nasumonkey.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 群馬県 (26件)
# ================================
puts '群馬県のデータを投入中...'

[
  {
    name: '中之条町歴史と民俗の博物館「ミュゼ」',
    prefecture: '群馬県',
    city: '吾妻郡中之条町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.nakanojo.gunma.jp/site/myuze/',
    is_featured: false
  },
  {
    name: '安中市学習の森ふるさと学習館',
    prefecture: '群馬県',
    city: '安中市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.annaka.lg.jp/site/gakushunomori/',
    is_featured: false
  },
  {
    name: '相川考古館',
    prefecture: '群馬県',
    city: '伊勢崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://aam.or.jp/',
    is_featured: false
  },
  {
    name: '太田市美術館・図書館',
    prefecture: '群馬県',
    city: '太田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.artmuseumlibraryota.jp/',
    is_featured: false
  },
  {
    name: '下仁田町自然史館',
    prefecture: '群馬県',
    city: '甘楽郡下仁田町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.shimonita-geopark.jp/shizenshikan/index.html',
    is_featured: false
  },
  {
    name: '大川美術館',
    prefecture: '群馬県',
    city: '桐生市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://okawamuseum.jp/',
    is_featured: false
  },
  {
    name: '竹久夢二伊香保記念館',
    prefecture: '群馬県',
    city: '渋川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://yumeji.or.jp/',
    is_featured: false
  },
  {
    name: '原美術館 ARC',
    prefecture: '群馬県',
    city: '渋川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.haramuseum.or.jp/jp/arc/',
    is_featured: false
  },
  {
    name: 'かみつけの里博物館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takasaki.gunma.jp/site/cultural-assets/1407.html',
    is_featured: false
  },
  {
    name: '群馬県立近代美術館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mmag.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '群馬県立土屋文明記念文学館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://bungaku.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '群馬県立歴史博物館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://grekisi.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '群馬県立館林美術館',
    prefecture: '群馬県',
    city: '館林市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.gmat.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '天一美術館',
    prefecture: '群馬県',
    city: '利根郡みなかみ町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://tenichi-museum.com/',
    is_featured: false
  },
  {
    name: '群馬県立自然史博物館',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.gmnh.pref.gunma.jp/',
    is_featured: false
  },
  {
    name: '富岡市立美術博物館・福沢一郎記念美術館',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.tomioka.lg.jp/www/genre/1387242529968/index.html',
    is_featured: false
  },
  {
    name: '岩宿博物館',
    prefecture: '群馬県',
    city: 'みどり市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.midori.gunma.jp/iwajuku/',
    is_featured: false
  },
  {
    name: '富弘美術館',
    prefecture: '群馬県',
    city: 'みどり市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.midori.gunma.jp/tomihiro/',
    is_featured: false
  },
  {
    name: 'みどり市大間々博物館（コノドント館）',
    prefecture: '群馬県',
    city: 'みどり市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.midori.gunma.jp/conodont/',
    is_featured: false
  },
  {
    name: '高崎市タワー美術館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.takasaki.gunma.jp/site/tower/',
    is_featured: false
  },
  {
    name: '高崎市美術館',
    prefecture: '群馬県',
    city: '高崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.takasaki.gunma.jp/site/art-museum/',
    is_featured: false
  },
  {
    name: '館林市立資料館',
    prefecture: '群馬県',
    city: '館林市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.tatebayashi.gunma.jp/sp004/',
    is_featured: false
  },
  {
    name: '群馬サファリパーク',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.safari.co.jp/',
    is_featured: false
  },
  {
    name: '富岡市立岡部温故館',
    prefecture: '群馬県',
    city: '富岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.tomioka.lg.jp/www/genre/1387242518888/index.html',
    is_featured: false
  },
  {
    name: 'アーツ前橋',
    prefecture: '群馬県',
    city: '前橋市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.artsmaebashi.jp/',
    is_featured: false
  },
  {
    name: '萩原朔太郎記念・水と緑と詩のまち前橋文学館',
    prefecture: '群馬県',
    city: '前橋市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.maebashibungakukan.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 埼玉県 (30件)
# ================================
puts '埼玉県のデータを投入中...'

[
  {
    name: '朝霞市博物館',
    prefecture: '埼玉県',
    city: '朝霞市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.asaka.lg.jp/soshiki/42/museum.html',
    is_featured: false
  },
  {
    name: '入間市博物館（ＡＬＩＴ）',
    prefecture: '埼玉県',
    city: '入間市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.alit.city.iruma.saitama.jp/',
    is_featured: false
  },
  {
    name: '埼玉県立川の博物館',
    prefecture: '埼玉県',
    city: '大里郡寄居町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.river-museum.jp/',
    is_featured: false
  },
  {
    name: '川越市立博物館',
    prefecture: '埼玉県',
    city: '川越市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kawagoe.saitama.jp/welcome/kankospot/hommarugotenzone/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '川越市立美術館',
    prefecture: '埼玉県',
    city: '川越市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kawagoe.saitama.jp/artmuseum/',
    is_featured: false
  },
  {
    name: '山崎美術館',
    prefecture: '埼玉県',
    city: '川越市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.koedo-kameya.com/sp.html',
    is_featured: false
  },
  {
    name: '行田市郷土博物館',
    prefecture: '埼玉県',
    city: '行田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.gyoda.lg.jp/soshiki/shougaigakusyubu/kyodohakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '埼玉県立さきたま史跡の博物館',
    prefecture: '埼玉県',
    city: '行田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sakitama-muse.spec.ed.jp/',
    is_featured: false
  },
  {
    name: '熊谷市立熊谷図書館美術・郷土資料展示室',
    prefecture: '埼玉県',
    city: '熊谷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kumagayacity.library.ne.jp/kyoudo/',
    is_featured: false
  },
  {
    name: '浦和くらしの博物館民家園',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.saitama.lg.jp/004/005/004/005/003/index.html',
    is_featured: false
  },
  {
    name: '埼玉県立近代美術館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://pref.spec.ed.jp/momas/',
    is_featured: false
  },
  {
    name: '埼玉県立歴史と民俗の博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saitama-rekimin.spec.ed.jp/',
    is_featured: false
  },
  {
    name: 'さいたま市立浦和博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.saitama.lg.jp/004/005/004/005/002/index.html',
    is_featured: false
  },
  {
    name: 'さいたま市立博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.saitama.lg.jp/004/005/004/005/008/index.html',
    is_featured: false
  },
  {
    name: '鉄道博物館',
    prefecture: '埼玉県',
    city: 'さいたま市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.railway-museum.jp/',
    is_featured: false
  },
  {
    name: '狭山市立博物館',
    prefecture: '埼玉県',
    city: '狭山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://sayama-city-museum.com',
    is_featured: false
  },
  {
    name: '白岡市立歴史資料館',
    prefecture: '埼玉県',
    city: '白岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.shiraoka.lg.jp/soshiki/kyouikubu/syougaigakusyuuka/36/bunnkazaihogo/1370.html',
    is_featured: false
  },
  {
    name: '埼玉県立自然の博物館',
    prefecture: '埼玉県',
    city: '秩父郡長瀞町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://shizen.spec.ed.jp/',
    is_featured: false
  },
  {
    name: '秩父宮記念三峯山博物館',
    prefecture: '埼玉県',
    city: '秩父市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mitsuminejinja.or.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: 'やまとーあーとみゅーじあむ',
    prefecture: '埼玉県',
    city: '秩父市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.chichibu.ne.jp/~yamato-a-t/',
    is_featured: false
  },
  {
    name: '戸田市立郷土博物館',
    prefecture: '埼玉県',
    city: '戸田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.toda.saitama.jp/soshiki/377/',
    is_featured: false
  },
  {
    name: '角川武蔵野ミュージアム',
    prefecture: '埼玉県',
    city: '所沢市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kadcul.com/',
    is_featured: false
  },
  {
    name: '飯能市立博物館',
    prefecture: '埼玉県',
    city: '飯能市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hanno.lg.jp/kanko_bunka_sports/museum/index.html',
    is_featured: false
  },
  {
    name: '遠山記念館',
    prefecture: '埼玉県',
    city: '比企郡川島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.e-kinenkan.com/',
    is_featured: false
  },
  {
    name: '埼玉県立嵐山史跡の博物館',
    prefecture: '埼玉県',
    city: '比企郡嵐山町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ranzan-shiseki.spec.ed.jp/',
    is_featured: false
  },
  {
    name: '公益財団法人 河鍋暁斎記念美術館',
    prefecture: '埼玉県',
    city: '蕨市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://kyosai-museum.jp/',
    is_featured: false
  },
  {
    name: '立正大学博物館',
    prefecture: '埼玉県',
    city: '熊谷市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.ris.ac.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '白岡市生涯学習センター歴史資料展示室（こもれびの森）',
    prefecture: '埼玉県',
    city: '白岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.shiraoka.lg.jp/soshiki/kyouikubu/syougaigakusyuuka/36/index.html#',
    is_featured: false
  },
  {
    name: '跡見学園女子大学花蹊記念資料館',
    prefecture: '埼玉県',
    city: '新座市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.atomi.ac.jp/univ/museum/',
    is_featured: false
  },
  {
    name: '日本工業大学工業技術博物館',
    prefecture: '埼玉県',
    city: '南埼玉郡宮代町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://museum.nit.ac.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 千葉県 (51件)
# ================================
puts '千葉県のデータを投入中...'

[
  {
    name: '大原幽学記念館',
    prefecture: '千葉県',
    city: '旭市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.asahi.chiba.jp/yugaku/',
    is_featured: false
  },
  {
    name: '我孫子市鳥の博物館',
    prefecture: '千葉県',
    city: '我孫子市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.abiko.chiba.jp/bird-mus/index.html',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館大多喜城分館',
    prefecture: '千葉県',
    city: '夷隅郡大多喜町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.chiba-muse.or.jp/NATURAL/sonan/',
    is_featured: false
  },
  {
    name: '市立市川考古博物館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ichikawa.lg.jp/edu14/',
    is_featured: false
  },
  {
    name: '市立市川自然博物館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.ichikawa.lg.jp/edu16/',
    is_featured: false
  },
  {
    name: '市立市川歴史博物館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ichikawa.lg.jp/edu14/',
    is_featured: false
  },
  {
    name: '千葉県立現代産業科学館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www2.chiba-muse.or.jp/SCIENCE/',
    is_featured: false
  },
  {
    name: '市原歴史博物館',
    prefecture: '千葉県',
    city: '市原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.imuseum.jp/index.html',
    is_featured: false
  },
  {
    name: '千葉県立房総のむら',
    prefecture: '千葉県',
    city: '印旛郡栄町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www2.chiba-muse.or.jp/MURA/',
    is_featured: false
  },
  {
    name: '浦安市郷土博物館',
    prefecture: '千葉県',
    city: '浦安市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://assarikunn.wixsite.com/website',
    is_featured: false
  },
  {
    name: '大網白里市デジタル博物館',
    prefecture: '千葉県',
    city: '大網白里市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://adeac.jp/oamishirasato-city/top/',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館分館海の博物館',
    prefecture: '千葉県',
    city: '勝浦市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www2.chiba-muse.or.jp/UMIHAKU/',
    is_featured: false
  },
  {
    name: '伊能忠敬記念館',
    prefecture: '千葉県',
    city: '香取市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.katori.lg.jp/sightseeing/museum/',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館大利根分館',
    prefecture: '千葉県',
    city: '香取市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.chiba-muse.or.jp/NATURAL/otone/',
    is_featured: false
  },
  {
    name: '木更津市郷土博物館金のすず',
    prefecture: '千葉県',
    city: '木更津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kisarazu.lg.jp/soshiki/kyoikuiinkai/kyodohakubutsukankinnosuzu/1/2742.html',
    is_featured: false
  },
  {
    name: '君津市立久留里城址資料館',
    prefecture: '千葉県',
    city: '君津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kimitsu.lg.jp/soshiki/54/',
    is_featured: false
  },
  {
    name: '佐倉市立美術館',
    prefecture: '千葉県',
    city: '佐倉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.sakura.lg.jp/section/museum/',
    is_featured: false
  },
  {
    name: '塚本美術館',
    prefecture: '千葉県',
    city: '佐倉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.sakura.lg.jp/soshiki/sakuranomiryoku/1/3036.html',
    is_featured: false
  },
  {
    name: '航空科学博物館',
    prefecture: '千葉県',
    city: '山武郡芝山町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.aeromuseum.or.jp/',
    is_featured: false
  },
  {
    name: '歴史の里芝山ミューゼアム',
    prefecture: '千葉県',
    city: '山武郡芝山町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '芝山町立芝山古墳・はにわ博物館',
    prefecture: '千葉県',
    city: '山武郡芝山町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.haniwakan.com/',
    is_featured: false
  },
  {
    name: '袖ケ浦市郷土博物館',
    prefecture: '千葉県',
    city: '袖ケ浦市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sodegaura.lg.jp/soshiki/hakubutsukan/',
    is_featured: false
  },
  {
    name: '館山市立博物館',
    prefecture: '千葉県',
    city: '館山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tateyama.chiba.jp/hakubutukan/page100065.html',
    is_featured: false
  },
  {
    name: '千葉県立中央博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www2.chiba-muse.or.jp/NATURAL/',
    is_featured: false
  },
  {
    name: '千葉県立美術館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www2.chiba-muse.or.jp/ART/',
    is_featured: false
  },
  {
    name: '千葉市動物公園',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.city.chiba.jp/zoo/',
    is_featured: false
  },
  {
    name: '千葉市立加曽利貝塚博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chiba.jp/kasori/',
    is_featured: false
  },
  {
    name: '千葉市立郷土博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.chiba.jp/kyodo/',
    is_featured: false
  },
  {
    name: '流山市立博物館',
    prefecture: '千葉県',
    city: '流山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.nagareyama.chiba.jp/life/1001780/1001785/index.html',
    is_featured: false
  },
  {
    name: '成田山書道美術館',
    prefecture: '千葉県',
    city: '成田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.naritashodo.jp/',
    is_featured: false
  },
  {
    name: '成田山霊光館',
    prefecture: '千葉県',
    city: '成田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '上花輪歴史館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '千葉県立関宿城博物館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www2.chiba-muse.or.jp/SEKIYADO/',
    is_featured: false
  },
  {
    name: '野田市郷土博物館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://noda-muse.jp/',
    is_featured: false
  },
  {
    name: '茂木本家美術館',
    prefecture: '千葉県',
    city: '野田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.momoa.jp/',
    is_featured: false
  },
  {
    name: '鋸山美術館',
    prefecture: '千葉県',
    city: '富津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nokogiriyama.com/',
    is_featured: false
  },
  {
    name: '船橋市郷土資料館',
    prefecture: '千葉県',
    city: '船橋市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.funabashi.lg.jp/shisetsu/bunka/0001/0005/0001/p011081.html',
    is_featured: false
  },
  {
    name: '船橋市飛ノ台史跡公園博物館',
    prefecture: '千葉県',
    city: '船橋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.funabashi.lg.jp/shisetsu/bunka/0001/0006/0001/p036786.html',
    is_featured: false
  },
  {
    name: '松戸市戸定歴史館',
    prefecture: '千葉県',
    city: '松戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.matsudo.chiba.jp/tojo/',
    is_featured: false
  },
  {
    name: '松戸市立博物館',
    prefecture: '千葉県',
    city: '松戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.matsudo.chiba.jp/m_muse/',
    is_featured: false
  },
  {
    name: '茂原市立美術館・郷土資料館',
    prefecture: '千葉県',
    city: '茂原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.mobara.chiba.jp/soshiki/13-10-0-0-0_1.html',
    is_featured: false
  },
  {
    name: '八千代市立郷土博物館',
    prefecture: '千葉県',
    city: '八千代市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.yachiyo.lg.jp/soshiki/81',
    is_featured: false
  },
  {
    name: '和洋女子大学文化資料館',
    prefecture: '千葉県',
    city: '市川市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.wayo.ac.jp/facilities_campus/museum',
    is_featured: false
  },
  {
    name: '鴨川シーワールド',
    prefecture: '千葉県',
    city: '鴨川市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.kamogawa-seaworld.jp/',
    is_featured: false
  },
  {
    name: '千葉大学海洋バイオシステム研究センター付属水族館',
    prefecture: '千葉県',
    city: '鴨川市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: '',
    is_featured: false
  },
  {
    name: 'DIC川村記念美術館',
    prefecture: '千葉県',
    city: '佐倉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kawamura-museum.dic.co.jp/',
    is_featured: false
  },
  {
    name: '千葉経済大学　地域経済博物館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.cku.ac.jp/local/museum/',
    is_featured: false
  },
  {
    name: '千葉市美術館',
    prefecture: '千葉県',
    city: '千葉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.ccma-net.jp/',
    is_featured: false
  },
  {
    name: '城西国際大学水田美術館',
    prefecture: '千葉県',
    city: '東金市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.jiu.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '宗吾霊宝殿',
    prefecture: '千葉県',
    city: '成田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.hokuso-4cities.com/spots/detail/215/',
    is_featured: false
  },
  {
    name: '日本大学理工学部科学技術史料センター',
    prefecture: '千葉県',
    city: '船橋市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.museum.cst.nihon-u.ac.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 東京都 (129件)
# ================================
puts '東京都のデータを投入中...'

[
  {
    name: '家具の博物館',
    prefecture: '東京都',
    city: '昭島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kaguhaku.or.jp/',
    is_featured: false
  },
  {
    name: '足立区立郷土博物館',
    prefecture: '東京都',
    city: '足立区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.adachi.tokyo.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '石洞美術館',
    prefecture: '東京都',
    city: '足立区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://sekido-museum.jp/',
    is_featured: false
  },
  {
    name: '日本書道美術館',
    prefecture: '東京都',
    city: '板橋区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://shodo-bijutsukan.or.jp/',
    is_featured: false
  },
  {
    name: '地下鉄博物館',
    prefecture: '東京都',
    city: '江戸川区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.chikahaku.jp/',
    is_featured: false
  },
  {
    name: '青梅市郷土博物館',
    prefecture: '東京都',
    city: '青梅市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ome.tokyo.jp/site/provincial-history-museum/',
    is_featured: false
  },
  {
    name: '青梅市立美術館　青梅市立小島善太郎美術館',
    prefecture: '東京都',
    city: '青梅市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.ome.tokyo.jp/site/art-museum/',
    is_featured: false
  },
  {
    name: '葛飾区郷土と天文の博物館',
    prefecture: '東京都',
    city: '葛飾区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.museum.city.katsushika.lg.jp/',
    is_featured: false
  },
  {
    name: '大谷美術館',
    prefecture: '東京都',
    city: '北区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.otanimuseum.or.jp/kyufurukawatei/',
    is_featured: false
  },
  {
    name: '紙の博物館',
    prefecture: '東京都',
    city: '北区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://papermuseum.jp/ja/',
    is_featured: false
  },
  {
    name: '渋沢史料館',
    prefecture: '東京都',
    city: '北区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shibusawa.or.jp/museum/',
    is_featured: false
  },
  {
    name: '清瀬市郷土博物館',
    prefecture: '東京都',
    city: '清瀬市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museum-kiyose.jp/',
    is_featured: false
  },
  {
    name: 'たましん歴史・美術館',
    prefecture: '東京都',
    city: '国立市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tamashinmuseum.org/',
    is_featured: false
  },
  {
    name: '船の科学館',
    prefecture: '東京都',
    city: '江東区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://funenokagakukan.or.jp/',
    is_featured: false
  },
  {
    name: '太田記念美術館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ukiyoe-ota-muse.jp/',
    is_featured: false
  },
  {
    name: '古賀政男音楽博物館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.koga.or.jp/',
    is_featured: false
  },
  {
    name: '戸栗美術館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.toguri-museum.or.jp/',
    is_featured: false
  },
  {
    name: '山種美術館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yamatane-museum.jp/',
    is_featured: false
  },
  {
    name: 'SOMPO美術館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sompo-museum.org/',
    is_featured: false
  },
  {
    name: '草間彌生美術館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yayoikusamamuseum.jp/',
    is_featured: false
  },
  {
    name: '佐藤美術館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://sato-museum.la.coocan.jp/',
    is_featured: false
  },
  {
    name: '新宿区立新宿歴史博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.regasu-shinjuku.or.jp/rekihaku/',
    is_featured: false
  },
  {
    name: '東京オペラシティアートギャラリー',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.operacity.jp/ag/',
    is_featured: false
  },
  {
    name: '民音音楽博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.min-on.or.jp/',
    is_featured: false
  },
  {
    name: '杉並区立郷土博物館',
    prefecture: '東京都',
    city: '杉並区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.suginami.tokyo.jp/histmus/',
    is_featured: false
  },
  {
    name: '相撲博物館',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.sumo.or.jp/KokugikanSumoMuseum/',
    is_featured: false
  },
  {
    name: '刀剣博物館',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.touken.or.jp/museum/',
    is_featured: false
  },
  {
    name: '賀川豊彦記念松沢資料館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.t-kagawa.or.jp/',
    is_featured: false
  },
  {
    name: '五島美術館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.gotoh-museum.or.jp/',
    is_featured: false
  },
  {
    name: '駒澤大学禅文化歴史博物館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.komazawa-u.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '齋田記念館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saita-museum.jp/',
    is_featured: false
  },
  {
    name: '世田谷区立郷土資料館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.setagaya.lg.jp/bunkasports/shougaigakushuu/category/12536.html',
    is_featured: false
  },
  {
    name: '長谷川町子美術館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hasegawamachiko.jp/',
    is_featured: false
  },
  {
    name: '上野の森美術館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ueno-mori.org/',
    is_featured: false
  },
  {
    name: '大名時計博物館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://ogino.c.ooco.jp/gijutu/tokei.htm',
    is_featured: false
  },
  {
    name: '横山大観記念館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://taikan.tokyo/',
    is_featured: false
  },
  {
    name: '昭和天皇記念館',
    prefecture: '東京都',
    city: '立川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://f-showa.or.jp/museum/',
    is_featured: false
  },
  {
    name: 'アーティゾン美術館',
    prefecture: '東京都',
    city: '中央区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.artizon.museum/',
    is_featured: false
  },
  {
    name: '三井記念美術館',
    prefecture: '東京都',
    city: '中央区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.mitsui-museum.jp/',
    is_featured: false
  },
  {
    name: '調布市郷土博物館',
    prefecture: '東京都',
    city: '調布市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.chofu.lg.jp/100200/p073000.html',
    is_featured: false
  },
  {
    name: '出光美術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://idemitsu-museum.or.jp/',
    is_featured: false
  },
  {
    name: '科学技術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.jsf.or.jp/',
    is_featured: false
  },
  {
    name: '共立女子大学博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kyoritsu-wu.ac.jp/muse/',
    is_featured: false
  },
  {
    name: '静嘉堂文庫美術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.seikado.or.jp/',
    is_featured: false
  },
  {
    name: '東京ステーションギャラリー',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ejrcf.or.jp/gallery/index.html',
    is_featured: false
  },
  {
    name: '日本カメラ博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.jcii-cameramuseum.jp/',
    is_featured: false
  },
  {
    name: '三菱一号館美術館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mimt.jp',
    is_featured: false
  },
  {
    name: '明治大学博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.meiji.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '切手の博物館',
    prefecture: '東京都',
    city: '豊島区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kitte-museum.jp/',
    is_featured: false
  },
  {
    name: '古代オリエント博物館',
    prefecture: '東京都',
    city: '豊島区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://aom-tokyo.com/',
    is_featured: false
  },
  {
    name: 'ちひろ美術館・東京',
    prefecture: '東京都',
    city: '練馬区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chihiro.jp/tokyo/',
    is_featured: false
  },
  {
    name: '東京富士美術館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.fujibi.or.jp/',
    is_featured: false
  },
  {
    name: '八王子市郷土資料館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hachioji.tokyo.jp/kankobunka/003/005/p005312.html',
    is_featured: false
  },
  {
    name: '羽村市郷土博物館',
    prefecture: '東京都',
    city: '羽村市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.hamura.tokyo.jp/0000005474.html',
    is_featured: false
  },
  {
    name: '東村山ふるさと歴史館',
    prefecture: '東京都',
    city: '東村山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.higashimurayama.tokyo.jp/tanoshimi/rekishi/furusato/index.html',
    is_featured: false
  },
  {
    name: '東大和市立郷土博物館',
    prefecture: '東京都',
    city: '東大和市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.higashiyamato.lg.jp/bunkasports/museum/index.html',
    is_featured: false
  },
  {
    name: '府中市郷土の森博物館',
    prefecture: '東京都',
    city: '府中市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.fuchu-cpf.or.jp/museum/',
    is_featured: false
  },
  {
    name: '府中市美術館',
    prefecture: '東京都',
    city: '府中市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.fuchu.tokyo.jp/art/',
    is_featured: false
  },
  {
    name: '永青文庫',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.eiseibunko.com/',
    is_featured: false
  },
  {
    name: '日本女子大学成瀬記念館',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.jwu.ac.jp/unv/about/naruse_memorial/index.html',
    is_featured: false
  },
  {
    name: '野球殿堂博物館',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://baseball-museum.or.jp/',
    is_featured: false
  },
  {
    name: '中近東文化センター付属博物館',
    prefecture: '東京都',
    city: '三鷹市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.meccj.or.jp/',
    is_featured: false
  },
  {
    name: 'ＮＨＫ放送博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.nhk.or.jp/museum/',
    is_featured: false
  },
  {
    name: '荏原 畠山美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hatakeyama-museum.org',
    is_featured: false
  },
  {
    name: '大倉集古館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shukokan.org/',
    is_featured: false
  },
  {
    name: 'お茶の文化創造博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.ochamuseum.jp/culture/',
    is_featured: false
  },
  {
    name: '菊池寛実記念智美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.musee-tomo.or.jp/',
    is_featured: false
  },
  {
    name: '慶應義塾大学アート・センター',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.art-c.keio.ac.jp/',
    is_featured: false
  },
  {
    name: '泉屋博古館東京',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sen-oku.or.jp/tokyo/',
    is_featured: false
  },
  {
    name: '根津美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.nezu-muse.or.jp/',
    is_featured: false
  },
  {
    name: '物流博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.lmuse.or.jp/',
    is_featured: false
  },
  {
    name: '日本獣医生命科学大学付属博物館',
    prefecture: '東京都',
    city: '武蔵野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.nvlu.ac.jp/universityinstitution/004.html/',
    is_featured: false
  },
  {
    name: '宗教法人長泉院附属現代彫刻美術館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://museum-of-sculpture.org/',
    is_featured: false
  },
  {
    name: '日本民藝館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mingeikan.or.jp/',
    is_featured: false
  },
  {
    name: '目黒寄生虫館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.kiseichu.org/',
    is_featured: false
  },
  {
    name: '東京家政大学博物館',
    prefecture: '東京都',
    city: '板橋区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tokyo-kasei.ac.jp/academics/museum/',
    is_featured: false
  },
  {
    name: '葛西臨海水族園',
    prefecture: '東京都',
    city: '江戸川区',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.tokyo-zoo.net/zoo/kasai/',
    is_featured: false
  },
  {
    name: '東京都現代美術館',
    prefecture: '東京都',
    city: '江東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.mot-art-museum.jp/',
    is_featured: false
  },
  {
    name: '東京農工大学科学博物館',
    prefecture: '東京都',
    city: '小金井市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tuat-museum.org/',
    is_featured: false
  },
  {
    name: '杉野学園衣裳博物館',
    prefecture: '東京都',
    city: '品川区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.costumemuseum.jp/',
    is_featured: false
  },
  {
    name: 'Bunkamuraザ・ミュージアム',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.bunkamura.co.jp/museum/',
    is_featured: false
  },
  {
    name: '國學院大學博物館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://museum.kokugakuin.ac.jp/',
    is_featured: false
  },
  {
    name: '実践女子学園香雪記念資料館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.jissen.ac.jp/kosetsu/',
    is_featured: false
  },
  {
    name: '文化学園服飾博物館',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://museum.bunka.ac.jp/',
    is_featured: false
  },
  {
    name: '明治神宮宝物殿（分館　明治神宮ミュージアム）',
    prefecture: '東京都',
    city: '渋谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.meijijingu.or.jp/museum/houmotsuden/',
    is_featured: false
  },
  {
    name: '秩父宮記念スポーツ博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.jpnsport.go.jp/muse/',
    is_featured: false
  },
  {
    name: '帝国データバンク史料館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tdb-muse.jp/',
    is_featured: false
  },
  {
    name: '東京理科大学近代科学資料館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tus.ac.jp/info/setubi/museum/',
    is_featured: false
  },
  {
    name: '早稲田大学會津八一記念博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.waseda.jp/culture/aizu-museum/',
    is_featured: false
  },
  {
    name: '早稲田大学坪内博士記念演劇博物館',
    prefecture: '東京都',
    city: '新宿区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://enpaku.w.waseda.jp/',
    is_featured: false
  },
  {
    name: 'すみだ郷土文化資料館',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.sumida.lg.jp/sisetu_info/siryou/kyoudobunka/',
    is_featured: false
  },
  {
    name: '東京都江戸東京博物館（分館　江戸東京たてもの園）',
    prefecture: '東京都',
    city: '墨田区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.edo-tokyo-museum.or.jp/',
    is_featured: false
  },
  {
    name: '昭和女子大学光葉博物館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://museum.swu.ac.jp/',
    is_featured: false
  },
  {
    name: '世田谷区立世田谷美術館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.setagayaartmuseum.or.jp/',
    is_featured: false
  },
  {
    name: '世田谷区立世田谷文学館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.setabun.or.jp/',
    is_featured: false
  },
  {
    name: '東京農業大学「食と農」の博物館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.nodai.ac.jp/campus/facilities/syokutonou/',
    is_featured: false
  },
  {
    name: '日本大学文理学部資料館',
    prefecture: '東京都',
    city: '世田谷区',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://chs.nihon-u.ac.jp/campus-life/kyogaku-s/museum/',
    is_featured: false
  },
  {
    name: '恩賜上野動物園',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tokyo-zoo.net/zoo/ueno/',
    is_featured: false
  },
  {
    name: '国立科学博物館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kahaku.go.jp/',
    is_featured: false
  },
  {
    name: '国立西洋美術館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.nmwa.go.jp/jp/',
    is_featured: false
  },
  {
    name: '東京国立博物館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tnm.jp/',
    is_featured: false
  },
  {
    name: '東京都美術館',
    prefecture: '東京都',
    city: '台東区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tobikan.jp/',
    is_featured: false
  },
  {
    name: '多摩美術大学附属美術館',
    prefecture: '東京都',
    city: '多摩市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://museum.tamabi.ac.jp/',
    is_featured: false
  },
  {
    name: '国立映画アーカイブ',
    prefecture: '東京都',
    city: '中央区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.nfaj.go.jp/',
    is_featured: false
  },
  {
    name: '大妻女子大学博物館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.museum.otsuma.ac.jp/',
    is_featured: false
  },
  {
    name: '皇居三の丸尚蔵館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://shozokan.nich.go.jp/',
    is_featured: false
  },
  {
    name: '東京国立近代美術館本館',
    prefecture: '東京都',
    city: '千代田区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.momat.go.jp/',
    is_featured: false
  },
  {
    name: '学習院大学史料館',
    prefecture: '東京都',
    city: '豊島区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.gakushuin.ac.jp/univ/ua/',
    is_featured: false
  },
  {
    name: '東京工芸大学芸術学部写大ギャラリー',
    prefecture: '東京都',
    city: '中野区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.shadai.t-kougei.ac.jp/index.html',
    is_featured: false
  },
  {
    name: '多摩六都科学館',
    prefecture: '東京都',
    city: '西東京市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.tamarokuto.or.jp/',
    is_featured: false
  },
  {
    name: '日本大学芸術学部芸術資料館',
    prefecture: '東京都',
    city: '練馬区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.art.nihon-u.ac.jp/facility/attached/archives/',
    is_featured: false
  },
  {
    name: '練馬区立美術館',
    prefecture: '東京都',
    city: '練馬区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.neribun.or.jp/museum.html',
    is_featured: false
  },
  {
    name: '東京造形大学附属美術館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.zokei.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '村内美術館',
    prefecture: '東京都',
    city: '八王子市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.murauchi.net/museum/',
    is_featured: false
  },
  {
    name: '多摩動物公園',
    prefecture: '東京都',
    city: '日野市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tokyo-zoo.net/zoo/tama/',
    is_featured: false
  },
  {
    name: '東洋大学井上円了記念博物館',
    prefecture: '東京都',
    city: '文京区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.toyo.ac.jp/about/founder/iecp/museum/',
    is_featured: false
  },
  {
    name: '玉川大学小原國芳記念教育博物館',
    prefecture: '東京都',
    city: '町田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tamagawa.jp/campus/institutions/museum/',
    is_featured: false
  },
  {
    name: '東京家政学院生活文化博物館',
    prefecture: '東京都',
    city: '町田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kasei-gakuin.ac.jp/campuslife/museum/',
    is_featured: false
  },
  {
    name: '国際基督教大学博物館湯浅八郎記念館',
    prefecture: '東京都',
    city: '三鷹市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://subsites.icu.ac.jp/yuasa_museum/index.html',
    is_featured: false
  },
  {
    name: 'アドミュージアム東京',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.admt.jp/',
    is_featured: false
  },
  {
    name: '北里柴三郎記念博物館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kitasato.ac.jp/jp/kinen-shitsu/index.html',
    is_featured: false
  },
  {
    name: '東京海洋大学マリンサイエンスミュージアム',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.s.kaiyodai.ac.jp/msm/index.html',
    is_featured: false
  },
  {
    name: '東京都庭園美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.teien-art-museum.ne.jp/',
    is_featured: false
  },
  {
    name: 'パナソニック汐留美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://panasonic.co.jp/ew/museum/',
    is_featured: false
  },
  {
    name: '森美術館',
    prefecture: '東京都',
    city: '港区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.mori.art.museum/jp/',
    is_featured: false
  },
  {
    name: '井の頭自然文化園',
    prefecture: '東京都',
    city: '武蔵野市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.tokyo-zoo.net/zoo/ino/',
    is_featured: false
  },
  {
    name: '成蹊学園史料館',
    prefecture: '東京都',
    city: '武蔵野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.seikei.ac.jp/gakuen/archive/',
    is_featured: false
  },
  {
    name: '東京科学大学博物館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.cent.titech.ac.jp/',
    is_featured: false
  },
  {
    name: '東京都写真美術館',
    prefecture: '東京都',
    city: '目黒区',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://topmuseum.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 神奈川県 (52件)
# ================================
puts '神奈川県のデータを投入中...'

[
  {
    name: '愛川町郷土資料館',
    prefecture: '神奈川県',
    city: '愛甲郡愛川町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.aikawa.kanagawa.jp/soshiki/kyouikuiinkai/spobun/kyodo/index.html',
    is_featured: false
  },
  {
    name: '彫刻の森美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hakone-oam.or.jp/',
    is_featured: false
  },
  {
    name: '箱根町立郷土資料館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.hakone.kanagawa.jp/www/contents/1100000002051/index.html',
    is_featured: false
  },
  {
    name: '箱根美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.moaart.or.jp/hakone/',
    is_featured: false
  },
  {
    name: 'ポーラ美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.polamuseum.or.jp/',
    is_featured: false
  },
  {
    name: '町立湯河原美術館',
    prefecture: '神奈川県',
    city: '足柄下郡湯河原町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.yugawara.kanagawa.jp/site/museum/',
    is_featured: false
  },
  {
    name: 'あつぎ郷土博物館',
    prefecture: '神奈川県',
    city: '厚木市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.atsugi.kanagawa.jp/atsugicitymuseum/index.html',
    is_featured: false
  },
  {
    name: 'ロマンスカーミュージアム',
    prefecture: '神奈川県',
    city: '海老名市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.odakyu.jp/romancecarmuseum/',
    is_featured: false
  },
  {
    name: '小田原文化財団　江之浦測候所',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.odawara-af.com/ja/enoura/',
    is_featured: false
  },
  {
    name: '神奈川県立生命の星・地球博物館',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://nh.kanagawa-museum.jp/',
    is_featured: false
  },
  {
    name: '報徳博物館',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.hotoku.or.jp/',
    is_featured: false
  },
  {
    name: '鎌倉国宝館',
    prefecture: '神奈川県',
    city: '鎌倉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kamakura.kanagawa.jp/kokuhoukan/',
    is_featured: false
  },
  {
    name: '川崎市立日本民家園',
    prefecture: '神奈川県',
    city: '川崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nihonminkaen.jp/',
    is_featured: false
  },
  {
    name: 'かわさき宙と緑の科学館（川崎市青少年科学館）',
    prefecture: '神奈川県',
    city: '川崎市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.nature-kawasaki.jp/',
    is_featured: false
  },
  {
    name: '相模原市立博物館',
    prefecture: '神奈川県',
    city: '相模原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://sagamiharacitymuseum.jp/',
    is_featured: false
  },
  {
    name: '茅ヶ崎市博物館',
    prefecture: '神奈川県',
    city: '茅ヶ崎市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://chigamu.jp/',
    is_featured: false
  },
  {
    name: '大磯町郷土資料館',
    prefecture: '神奈川県',
    city: '中郡大磯町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.town.oiso.kanagawa.jp/oisomuseum/index.html',
    is_featured: false
  },
  {
    name: '徳富蘇峰記念館',
    prefecture: '神奈川県',
    city: '中郡二宮町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.soho-tokutomi.or.jp/',
    is_featured: false
  },
  {
    name: 'はだの歴史博物館',
    prefecture: '神奈川県',
    city: '秦野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hadano.kanagawa.jp/www/contents/1001000004542/index.html',
    is_featured: false
  },
  {
    name: '平塚市博物館',
    prefecture: '神奈川県',
    city: '平塚市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.hirahaku.jp/',
    is_featured: false
  },
  {
    name: '平塚市美術館',
    prefecture: '神奈川県',
    city: '平塚市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hiratsuka.kanagawa.jp/art-muse/index.html',
    is_featured: false
  },
  {
    name: '新江ノ島水族館',
    prefecture: '神奈川県',
    city: '藤沢市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.enosui.com/',
    is_featured: false
  },
  {
    name: '日本大学生物資源科学部博物館',
    prefecture: '神奈川県',
    city: '藤沢市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://hp.brs.nihon-u.ac.jp/~museum/',
    is_featured: false
  },
  {
    name: '神奈川県立近代美術館',
    prefecture: '神奈川県',
    city: '三浦郡葉山町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.moma.pref.kanagawa.jp/',
    is_featured: false
  },
  {
    name: '葉山しおさい博物館',
    prefecture: '神奈川県',
    city: '三浦郡葉山町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.town.hayama.lg.jp/soshiki/shougaigakushuu/2/1701.html',
    is_featured: false
  },
  {
    name: '山口蓬春記念館',
    prefecture: '神奈川県',
    city: '三浦郡葉山町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hoshun.jp/',
    is_featured: false
  },
  {
    name: '横須賀市自然博物館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.museum.yokosuka.kanagawa.jp/',
    is_featured: false
  },
  {
    name: '横須賀市人文博物館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.museum.yokosuka.kanagawa.jp/',
    is_featured: false
  },
  {
    name: '横須賀美術館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yokosuka-moa.jp/',
    is_featured: false
  },
  {
    name: '馬の博物館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bajibunka.or.jp/uma/index.php',
    is_featured: false
  },
  {
    name: '神奈川県立金沢文庫',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pen-kanagawa.ed.jp/kanazawabunko/index.html',
    is_featured: false
  },
  {
    name: '神奈川県立歴史博物館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ch.kanagawa-museum.jp/',
    is_featured: false
  },
  {
    name: 'シルク博物館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.silkcenter-kbkk.jp/museum/',
    is_featured: false
  },
  {
    name: 'そごう美術館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sogo-seibu.jp/common/museum/',
    is_featured: false
  },
  {
    name: '日本新聞博物館（ニュースパーク）',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://newspark.jp/',
    is_featured: false
  },
  {
    name: '日吉の森庭園美術館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://hiyoshinomori.com/',
    is_featured: false
  },
  {
    name: '箱根・芦ノ湖成川美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.narukawamuseum.co.jp/',
    is_featured: false
  },
  {
    name: '箱根神社宝物殿',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://hakonejinja.or.jp/hakone/houmotsuden.html',
    is_featured: false
  },
  {
    name: '箱根ラリック美術館',
    prefecture: '神奈川県',
    city: '足柄下郡箱根町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.lalique-museum.com/',
    is_featured: false
  },
  {
    name: '松蔭大学資料館',
    prefecture: '神奈川県',
    city: '厚木市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.shoin-u.ac.jp/campus/museum/',
    is_featured: false
  },
  {
    name: '東京農業大学農学部植物園',
    prefecture: '神奈川県',
    city: '厚木市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.nodai.ac.jp/academics/agri/garden/',
    is_featured: false
  },
  {
    name: '小田原市郷土文化館',
    prefecture: '神奈川県',
    city: '小田原市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.odawara.kanagawa.jp/public-i/facilities/kyodo/',
    is_featured: false
  },
  {
    name: '鎌倉彫資料館',
    prefecture: '神奈川県',
    city: '鎌倉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://kamakuraborikaikan.jp/museum/',
    is_featured: false
  },
  {
    name: '女子美術館大学美術館　女子美アートミュージアム',
    prefecture: '神奈川県',
    city: '相模原市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.joshibi.net/museum/jam/',
    is_featured: false
  },
  {
    name: '茅ケ崎市美術館',
    prefecture: '神奈川県',
    city: '茅ヶ崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.chigasaki-museum.jp/',
    is_featured: false
  },
  {
    name: '東海大学松前記念館（歴史と未来の博物館）',
    prefecture: '神奈川県',
    city: '平塚市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.kinenkan.u-tokai.ac.jp/',
    is_featured: false
  },
  {
    name: '観音崎自然博物館',
    prefecture: '神奈川県',
    city: '横須賀市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://kannonzaki-nature-museum.jimdofree.com/',
    is_featured: false
  },
  {
    name: '横浜・八景島シーパラダイスアクアリゾーツ',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'http://www.seaparadise.co.jp/aquaresorts/index.html',
    is_featured: false
  },
  {
    name: '横浜市立金沢動物園',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.hama-midorinokyokai.or.jp/zoo/kanazawa/',
    is_featured: false
  },
  {
    name: '横浜市立野毛山動物園',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.hama-midorinokyokai.or.jp/zoo/nogeyama/',
    is_featured: false
  },
  {
    name: '横浜市立よこはま動物園ズーラシア',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.hama-midorinokyokai.or.jp/zoo/zoorasia/',
    is_featured: false
  },
  {
    name: '横浜美術館',
    prefecture: '神奈川県',
    city: '横浜市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://yokohama.art.museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 新潟県 (36件)
# ================================
puts '新潟県のデータを投入中...'

[
  {
    name: '柏崎市立博物館',
    prefecture: '新潟県',
    city: '柏崎市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kashiwazaki.lg.jp/k_museum/index.html',
    is_featured: false
  },
  {
    name: '木村茶道美術館',
    prefecture: '新潟県',
    city: '柏崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://sadoukan.jp/',
    is_featured: false
  },
  {
    name: '相川郷土博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/60583.html',
    is_featured: false
  },
  {
    name: '佐渡国小木民俗博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/458.html',
    is_featured: false
  },
  {
    name: '佐渡植物園',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/461.html',
    is_featured: false
  },
  {
    name: '佐渡博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/457.html',
    is_featured: false
  },
  {
    name: '両津郷土博物館',
    prefecture: '新潟県',
    city: '佐渡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sado.niigata.jp/site/museum/460.html',
    is_featured: false
  },
  {
    name: '小林古径記念美術館',
    prefecture: '新潟県',
    city: '上越市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.joetsu.niigata.jp/site/kokei/',
    is_featured: false
  },
  {
    name: '上越市立水族博物館',
    prefecture: '新潟県',
    city: '上越市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.umigatari.jp/joetsu/',
    is_featured: false
  },
  {
    name: '上越市立歴史博物館',
    prefecture: '新潟県',
    city: '上越市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.joetsu.niigata.jp/site/museum/',
    is_featured: false
  },
  {
    name: '大棟山美術博物館',
    prefecture: '新潟県',
    city: '十日町市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://daitozan.jimdofree.com/',
    is_featured: false
  },
  {
    name: '十日町市博物館',
    prefecture: '新潟県',
    city: '十日町市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.tokamachi-museum.jp/',
    is_featured: false
  },
  {
    name: '駒形十吉記念美術館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.komagata-museum.com/',
    is_featured: false
  },
  {
    name: '長岡市寺泊水族博物館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://aquarium-teradomari.jp/',
    is_featured: false
  },
  {
    name: '長岡市栃尾美術館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.lib.city.nagaoka.niigata.jp/?page_id=135',
    is_featured: false
  },
  {
    name: '長岡市立科学博物館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.museum.city.nagaoka.niigata.jp/',
    is_featured: false
  },
  {
    name: '新潟県立近代美術館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kinbi.pref.niigata.lg.jp/',
    is_featured: false
  },
  {
    name: '知足美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chisoku.jp/',
    is_featured: false
  },
  {
    name: '敦井美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tsurui.co.jp/museum/',
    is_featured: false
  },
  {
    name: '新潟県立万代島美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://banbi.pref.niigata.lg.jp/',
    is_featured: false
  },
  {
    name: '新潟市北区郷土博物館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.niigata.lg.jp/kita/shisetsu/yoka/bunka/kyodo/index.html',
    is_featured: false
  },
  {
    name: '新津記念館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.marushin-group.co.jp/kinenkan/',
    is_featured: false
  },
  {
    name: '一般財団法人　北方文化博物館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hoppou-bunka.com/',
    is_featured: false
  },
  {
    name: '雪梁舎美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.komeri.bit.or.jp/setsuryosha/',
    is_featured: false
  },
  {
    name: '出雲崎町　良寛記念館',
    prefecture: '新潟県',
    city: '三島郡出雲崎町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.ryokan-kinenkan.jp/',
    is_featured: false
  },
  {
    name: '池田記念美術館',
    prefecture: '新潟県',
    city: '南魚沼市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ikedaart.jp/',
    is_featured: false
  },
  {
    name: '魚沼市宮柊二記念館',
    prefecture: '新潟県',
    city: '魚沼市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.uonuma.lg.jp/site/miyashuji/',
    is_featured: false
  },
  {
    name: '鍛冶ミュージアム',
    prefecture: '新潟県',
    city: '三条市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://sanjo-machiyama.jp/blacksmithmuseum/',
    is_featured: false
  },
  {
    name: '燕市産業史料館',
    prefecture: '新潟県',
    city: '燕市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://tsubame-shiryoukan.jp/index.html',
    is_featured: false
  },
  {
    name: '新潟県立歴史博物館',
    prefecture: '新潟県',
    city: '長岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://nbz.or.jp/',
    is_featured: false
  },
  {
    name: '新潟市會津八一記念館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://aizuyaichi.or.jp/',
    is_featured: false
  },
  {
    name: '新潟市新津美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.niigata.lg.jp/nam/',
    is_featured: false
  },
  {
    name: '新潟市美術館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.ncam.jp/sp/',
    is_featured: false
  },
  {
    name: '新潟市歴史博物館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.nchm.jp/',
    is_featured: false
  },
  {
    name: '新潟大学旭町学術資料展示館',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.lib.niigata-u.ac.jp/tenjikan/',
    is_featured: false
  },
  {
    name: '日本歯科大学新潟生命歯学部「医の博物館」',
    prefecture: '新潟県',
    city: '新潟市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.ngt.ndu.ac.jp/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 富山県 (37件)
# ================================
puts '富山県のデータを投入中...'

[
  {
    name: '射水市新湊博物館',
    prefecture: '富山県',
    city: '射水市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shinminato-museum.jp/',
    is_featured: false
  },
  {
    name: '魚津水族博物館',
    prefecture: '富山県',
    city: '魚津市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.uozu-aquarium.jp/',
    is_featured: false
  },
  {
    name: '魚津歴史民俗博物館',
    prefecture: '富山県',
    city: '魚津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.uozu.toyama.jp/hp/svFacHP.aspx?faccd=B080307',
    is_featured: false
  },
  {
    name: '特別天然記念物魚津埋没林博物館',
    prefecture: '富山県',
    city: '魚津市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.uozu.toyama.jp/nekkolnd/',
    is_featured: false
  },
  {
    name: '小矢部市大谷博物館',
    prefecture: '富山県',
    city: '小矢部市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.oyabe.toyama.jp/bunkasports/1003003/1003024/index.html',
    is_featured: false
  },
  {
    name: '黒部市美術館',
    prefecture: '富山県',
    city: '黒部市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kurobe.toyama.jp/category/page.aspx?servno=79',
    is_featured: false
  },
  {
    name: '黒部市吉田科学館',
    prefecture: '富山県',
    city: '黒部市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://kysm.or.jp/',
    is_featured: false
  },
  {
    name: '朝日町立ふるさと美術館',
    prefecture: '富山県',
    city: '下新川郡朝日町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.asahi.toyama.jp/section/buntai/bijyutukanannai.html',
    is_featured: false
  },
  {
    name: '一般財団法人　百河豚美術館',
    prefecture: '富山県',
    city: '下新川郡朝日町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://ippukumuseum.g2.xrea.com//index.html',
    is_featured: false
  },
  {
    name: '宮崎自然博物館',
    prefecture: '富山県',
    city: '下新川郡朝日町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.town.asahi.toyama.jp/soshiki/kyoiku/syougaigakusyuu/bunkazai/1449206358603.html',
    is_featured: false
  },
  {
    name: '入善町下山芸術の森アートスペース（発電所美術館）',
    prefecture: '富山県',
    city: '下新川郡入善町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.nyuzen.toyama.jp/gyosei/bijutsukan/index.html',
    is_featured: false
  },
  {
    name: '高岡市美術館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.e-tam.info/',
    is_featured: false
  },
  {
    name: '高岡市福岡歴史民俗資料館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takaoka.toyama.jp/soshiki/kyoikuiinkai_shogaigakushu_sportska/2/8/1/2276.html',
    is_featured: false
  },
  {
    name: '高岡市万葉歴史館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.manreki.com/',
    is_featured: false
  },
  {
    name: '高岡市立博物館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.e-tmm.info/',
    is_featured: false
  },
  {
    name: 'ミュゼふくおかカメラ館',
    prefecture: '富山県',
    city: '高岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.camerakan.com/',
    is_featured: false
  },
  {
    name: '砺波郷土資料館',
    prefecture: '富山県',
    city: '砺波市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.tonami.lg.jp/section/1658p/',
    is_featured: false
  },
  {
    name: '砺波市美術館',
    prefecture: '富山県',
    city: '砺波市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tonami-art-museum.jp/',
    is_featured: false
  },
  {
    name: '公益財団法人　秋水美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shusui-museum.jp/',
    is_featured: false
  },
  {
    name: '富山県交通公園交通安全博物館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://safety-toyama.or.jp/museum/',
    is_featured: false
  },
  {
    name: '富山県水墨美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.pref.toyama.jp/1738/miryokukankou/bunka/bunkazai/3044/index.html',
    is_featured: false
  },
  {
    name: '富山県中央植物園',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.bgtym.org/',
    is_featured: false
  },
  {
    name: '富山県美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://tad-toyama.jp/',
    is_featured: false
  },
  {
    name: '富山県埋蔵文化財センター',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.toyama.jp/3041/miryokukankou/bunka/bunkazai/maibun/index.html',
    is_featured: false
  },
  {
    name: '富山県民会館美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.bunka-toyama.jp/kenminkaikan/',
    is_featured: false
  },
  {
    name: '富山市科学博物館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.tsm.toyama.toyama.jp/',
    is_featured: false
  },
  {
    name: '富山市ガラス美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://toyama-glass-art-museum.jp/',
    is_featured: false
  },
  {
    name: '富山市郷土博物館（別館）富山市佐藤記念美術館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.toyama.toyama.jp/etc/muse/',
    is_featured: false
  },
  {
    name: '富山市民俗民芸村',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.toyama.toyama.jp/etc/minzokumingei/',
    is_featured: false
  },
  {
    name: '富山県　立山カルデラ砂防博物館',
    prefecture: '富山県',
    city: '中新川郡立山町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.tatecal.or.jp/tatecal/index.html',
    is_featured: false
  },
  {
    name: '富山県［立山博物館］',
    prefecture: '富山県',
    city: '中新川郡立山町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.pref.toyama.jp/1739/miryokukankou/bunka/bunkazai/home/index.html',
    is_featured: false
  },
  {
    name: '滑川市立博物館',
    prefecture: '富山県',
    city: '滑川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.namerikawa.toyama.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '南砺市埋蔵文化財センター',
    prefecture: '富山県',
    city: '南砺市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://museums.toyamaken.jp/museum/swhm068/',
    is_featured: false
  },
  {
    name: '南砺市立福光美術館',
    prefecture: '富山県',
    city: '南砺市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nanto-museum.com/',
    is_featured: false
  },
  {
    name: '氷見市立博物館',
    prefecture: '富山県',
    city: '氷見市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.himi.toyama.jp/section/museum/index.html',
    is_featured: false
  },
  {
    name: 'ギャルリ・ミレー',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.gmillet.jp/',
    is_featured: false
  },
  {
    name: '富山県教育記念館',
    prefecture: '富山県',
    city: '富山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.t-hito.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 石川県 (30件)
# ================================
puts '石川県のデータを投入中...'

[
  {
    name: '石川県九谷焼美術館',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kaga.ishikawa.jp/kutani-mus/index.html',
    is_featured: false
  },
  {
    name: '加賀市中谷宇吉郎雪の科学館',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://yukinokagakukan.kagashi-ss.com/',
    is_featured: false
  },
  {
    name: '加賀市美術館',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kagabi.kagashi-ss.com/',
    is_featured: false
  },
  {
    name: '無限庵',
    prefecture: '石川県',
    city: '加賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://mugenan.com',
    is_featured: false
  },
  {
    name: '石川県立美術館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ishibi.pref.ishikawa.jp/',
    is_featured: false
  },
  {
    name: '石川県立歴史博物館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ishikawa-rekihaku.jp/',
    is_featured: false
  },
  {
    name: '泉鏡花記念館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanazawa-museum.jp/kyoka/',
    is_featured: false
  },
  {
    name: '金沢くらしの博物館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanazawa-museum.jp/minzoku/',
    is_featured: false
  },
  {
    name: '金沢市立中村記念美術館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/nakamura/',
    is_featured: false
  },
  {
    name: '金沢市立安江金箔工芸館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/kinpaku/',
    is_featured: false
  },
  {
    name: '金沢湯涌夢二館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/yumeji/',
    is_featured: false
  },
  {
    name: '成巽閣',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.seisonkaku.com/',
    is_featured: false
  },
  {
    name: '前田土佐守家資料館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanazawa-museum.jp/maedatosa/',
    is_featured: false
  },
  {
    name: '石川県西田幾多郎記念哲学館',
    prefecture: '石川県',
    city: 'かほく市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.nishidatetsugakukan.org/',
    is_featured: false
  },
  {
    name: '小松市立博物館',
    prefecture: '石川県',
    city: '小松市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://komatsu-museum.jp/',
    is_featured: false
  },
  {
    name: '小松市立本陣記念美術館',
    prefecture: '石川県',
    city: '小松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://komatsu-museum.jp/honjin/',
    is_featured: false
  },
  {
    name: '小松市立宮本三郎美術館／宮本三郎ふるさと館',
    prefecture: '石川県',
    city: '小松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://komatsu-museum.jp/miyamoto/',
    is_featured: false
  },
  {
    name: '石川県立白山ろく民俗資料館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.pref.ishikawa.jp/hakusanminzoku/',
    is_featured: false
  },
  {
    name: '白山市立博物館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.hakusan-museum.jp/hakubutukan/',
    is_featured: false
  },
  {
    name: '白山市立松任中川一政記念美術館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hakusan-museum.jp/nakagawakinen/',
    is_featured: false
  },
  {
    name: '石川県七尾美術館',
    prefecture: '石川県',
    city: '七尾市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nanao-art-museum.jp/',
    is_featured: false
  },
  {
    name: '石川県能登島ガラス美術館',
    prefecture: '石川県',
    city: '七尾市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nanao-af.jp/glass/',
    is_featured: false
  },
  {
    name: 'のとじま臨海公園水族館',
    prefecture: '石川県',
    city: '七尾市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.notoaqua.jp/',
    is_featured: false
  },
  {
    name: '能美ふるさとミュージアム',
    prefecture: '石川県',
    city: '能美市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nomi.ishikawa.jp/www/genre/1000100000265/index.html',
    is_featured: false
  },
  {
    name: '羽咋市歴史民俗資料館',
    prefecture: '石川県',
    city: '羽咋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hakui.lg.jp/rekimin/index.html',
    is_featured: false
  },
  {
    name: '石川県輪島漆芸美術館',
    prefecture: '石川県',
    city: '輪島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.art.city.wajima.ishikawa.jp/',
    is_featured: false
  },
  {
    name: '金沢21世紀美術館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kanazawa21.jp/',
    is_featured: false
  },
  {
    name: '金沢大学資料館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://museum.w3.kanazawa-u.ac.jp/',
    is_featured: false
  },
  {
    name: '谷口吉郎・吉生記念金沢建築館',
    prefecture: '石川県',
    city: '金沢市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kanazawa-museum.jp/architecture/',
    is_featured: false
  },
  {
    name: '石川県ふれあい昆虫館',
    prefecture: '石川県',
    city: '白山市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.furekon.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 福井県 (22件)
# ================================
puts '福井県のデータを投入中...'

[
  {
    name: '金津創作の森美術館アートコア',
    prefecture: '福井県',
    city: 'あわら市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sosaku.jp/',
    is_featured: false
  },
  {
    name: '吉崎御坊蓮如上人記念館',
    prefecture: '福井県',
    city: 'あわら市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://honganjifoundation.org/rennyo/',
    is_featured: false
  },
  {
    name: '越前市武生公会堂記念館',
    prefecture: '福井県',
    city: '越前市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.echizen.lg.jp/office/090/030/bunkasisetu/kokaido-top.html',
    is_featured: false
  },
  {
    name: '大野市歴史博物館',
    prefecture: '福井県',
    city: '大野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ono.fukui.jp/kosodate/bunka-rekishi/hakubutsukan/shisetsu/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '福井県立若狭歴史博物館',
    prefecture: '福井県',
    city: '小浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://wakahaku.pref.fukui.lg.jp/',
    is_featured: false
  },
  {
    name: '勝山城博物館',
    prefecture: '福井県',
    city: '勝山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.katsuyamajyou.com/',
    is_featured: false
  },
  {
    name: '福井県立恐竜博物館',
    prefecture: '福井県',
    city: '勝山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.dinosaur.pref.fukui.jp/',
    is_featured: false
  },
  {
    name: '坂井市龍翔博物館',
    prefecture: '福井県',
    city: '坂井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://ryusho-museum.jp/',
    is_featured: false
  },
  {
    name: '鯖江市まなべの館',
    prefecture: '福井県',
    city: '鯖江市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.sabae.fukui.jp/kosodate_kyoiku/manabenoyakata/manabenoyakata.html',
    is_featured: false
  },
  {
    name: '敦賀郷土博物館',
    prefecture: '福井県',
    city: '敦賀市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: '',
    is_featured: false
  },
  {
    name: '敦賀市立博物館',
    prefecture: '福井県',
    city: '敦賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://tsuruga-municipal-museum.jp/',
    is_featured: false
  },
  {
    name: '福井県立こども歴史文化館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://info.pref.fukui.jp/koreki/',
    is_featured: false
  },
  {
    name: '福井県立美術館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fukui-kenbi.pref.fukui.lg.jp/',
    is_featured: false
  },
  {
    name: '福井県立歴史博物館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.fukui.lg.jp/muse/Cul-Hist/',
    is_featured: false
  },
  {
    name: '福井市自然史博物館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.nature.museum.city.fukui.fukui.jp/',
    is_featured: false
  },
  {
    name: '福井市美術館（アートラボふくい）',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.art.museum.city.fukui.fukui.jp/',
    is_featured: false
  },
  {
    name: '福井市立郷土歴史博物館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.history.museum.city.fukui.fukui.jp/',
    is_featured: false
  },
  {
    name: 'ふくい藤田美術館',
    prefecture: '福井県',
    city: '福井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ff-museum.com',
    is_featured: false
  },
  {
    name: '若狭三方縄文博物館',
    prefecture: '福井県',
    city: '三方上中郡若狭町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.fukui-wakasa.lg.jp/soshiki/wakasamikatajomonhakubutsukan/gyomuannai/955.html',
    is_featured: false
  },
  {
    name: '伊藤柏翠俳句記念館',
    prefecture: '福井県',
    city: '鯖江市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '福井県年縞博物館',
    prefecture: '福井県',
    city: '三方上中郡若狭町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://varve-museum.pref.fukui.lg.jp/',
    is_featured: false
  },
  {
    name: '若狭町歴史文化館',
    prefecture: '福井県',
    city: '三方上中郡若狭町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 山梨県 (28件)
# ================================
puts '山梨県のデータを投入中...'

[
  {
    name: '信玄公宝物館',
    prefecture: '山梨県',
    city: '甲州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shingen.iooo.jp/',
    is_featured: false
  },
  {
    name: '山梨県立考古博物館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.yamanashi.jp/kouko-hak/',
    is_featured: false
  },
  {
    name: '山梨県立美術館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.art-museum.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '山梨県立文学館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bungakukan.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '都留市博物館「ミュージアム都留」',
    prefecture: '山梨県',
    city: '都留市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tsuru.yamanashi.jp/soshiki/shougaigakushuu/museum_tsuru/1340.html',
    is_featured: false
  },
  {
    name: '韮崎大村美術館',
    prefecture: '山梨県',
    city: '韮崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://nirasakiomura-artmuseum.com/',
    is_featured: false
  },
  {
    name: '釈迦堂遺跡博物館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.eps4.comlink.ne.jp/~shakado/',
    is_featured: false
  },
  {
    name: '山梨県立博物館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.museum.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '富士山美術館（フジヤマミュージアム）',
    prefecture: '山梨県',
    city: '富士吉田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.fujiyama-museum.com/',
    is_featured: false
  },
  {
    name: '富士吉田市歴史民俗博物館（ふじさんミュージアム）',
    prefecture: '山梨県',
    city: '富士吉田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.fy-museum.jp/',
    is_featured: false
  },
  {
    name: '一般社団法人アフリカンアートミュージアム',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.africanartmuseum.jp/',
    is_featured: false
  },
  {
    name: '清春白樺美術館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kiyoharu-art.com/',
    is_featured: false
  },
  {
    name: '平山郁夫シルクロード美術館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.silkroad-museum.jp/',
    is_featured: false
  },
  {
    name: 'ポール・ラッシュ記念館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.seisenryo.jp/spot_paulrusch1.html',
    is_featured: false
  },
  {
    name: '南アルプス市ふるさと文化伝承館',
    prefecture: '山梨県',
    city: '南アルプス市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.minami-alps.yamanashi.jp/sisetsu/shisetsu/bunkazai-densyokan/',
    is_featured: false
  },
  {
    name: '南アルプス市立美術館',
    prefecture: '山梨県',
    city: '南アルプス市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.minamialps-museum.jp/',
    is_featured: false
  },
  {
    name: '近藤浩一路記念南部町立美術館',
    prefecture: '山梨県',
    city: '南巨摩郡南部町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.nanbu.yamanashi.jp/shisetsu/syakaikyouiku/museum.html',
    is_featured: false
  },
  {
    name: '甲斐黄金村・湯之奥金山博物館',
    prefecture: '山梨県',
    city: '南巨摩郡身延町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.minobu.lg.jp/kinzan/',
    is_featured: false
  },
  {
    name: '美枝きもの資料館',
    prefecture: '山梨県',
    city: '南巨摩郡身延町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://mie-kimonomuseum.or.jp/',
    is_featured: false
  },
  {
    name: '河口湖美術館',
    prefecture: '山梨県',
    city: '南都留郡富士河口湖町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.fkchannel.jp/kgmuse/',
    is_featured: false
  },
  {
    name: '甲府市遊亀公園附属動物園',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.kofu.yamanashi.jp/zoo/',
    is_featured: false
  },
  {
    name: '山梨県立科学館',
    prefecture: '山梨県',
    city: '甲府市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kagakukan.pref.yamanashi.jp/',
    is_featured: false
  },
  {
    name: '帝京大学やまなし伝統工芸館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.teikyo.jp/crafts-yamanashi/',
    is_featured: false
  },
  {
    name: '笛吹市青楓美術館',
    prefecture: '山梨県',
    city: '笛吹市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.fuefuki.yamanashi.jp/shisetsu/museum/001.html',
    is_featured: false
  },
  {
    name: 'サントリーウイスキー博物館',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '清泉寮やまねミュージアム',
    prefecture: '山梨県',
    city: '北杜市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.seisenryo.jp/spot_yamane1.html',
    is_featured: false
  },
  {
    name: '身延山宝物館',
    prefecture: '山梨県',
    city: '南巨摩郡身延町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kuonji.jp/precincts/m-muse/',
    is_featured: false
  },
  {
    name: '四季の杜おしの公園　岡田紅陽写真美術館･小池邦夫絵手紙美術館',
    prefecture: '山梨県',
    city: '南都留郡忍野村',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://oshino-artmuseum.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 長野県 (84件)
# ================================
puts '長野県のデータを投入中...'

[
  {
    name: 'TRIAD　IIDA・KAN',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.harmonicito-f.or.jp/iida_kan/',
    is_featured: false
  },
  {
    name: '安曇野市豊科郷土博物館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.azumino.nagano.jp/site/museum/',
    is_featured: false
  },
  {
    name: '安曇野市美術館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.azumino-museum.com/',
    is_featured: false
  },
  {
    name: '安曇野高橋節郎記念美術館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://azumino-bunka.com/facility/setsuro-museum/',
    is_featured: false
  },
  {
    name: '田淵行男記念館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://azumino-bunka.com/facility/tabuchi-museum/',
    is_featured: false
  },
  {
    name: '碌山美術館',
    prefecture: '長野県',
    city: '安曇野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://rokuzan.jp/',
    is_featured: false
  },
  {
    name: '飯田市上郷考古博物館',
    prefecture: '長野県',
    city: '飯田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.iida.lg.jp/site/bunkazai/kouko.html',
    is_featured: false
  },
  {
    name: '飯田市美術博物館',
    prefecture: '長野県',
    city: '飯田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.iida-museum.org/',
    is_featured: false
  },
  {
    name: '上田市立信濃国分寺資料館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.umic.jp/kokubunji/',
    is_featured: false
  },
  {
    name: '上田市立博物館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.umic.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '上田市立美術館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.santomyuze.com/museum/',
    is_featured: false
  },
  {
    name: '上田市立丸子郷土博物館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ueda.nagano.jp/soshiki/u-hakubutukan/1253.html',
    is_featured: false
  },
  {
    name: '美ヶ原高原美術館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.utsukushi-oam.jp/',
    is_featured: false
  },
  {
    name: '松山記念館',
    prefecture: '長野県',
    city: '上田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.matsuyama-museum.or.jp/',
    is_featured: false
  },
  {
    name: '大町エネルギー博物館',
    prefecture: '長野県',
    city: '大町市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.omachi.nagano.jp/00025000/00025100/00025102.html',
    is_featured: false
  },
  {
    name: '市立大町山岳博物館',
    prefecture: '長野県',
    city: '大町市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.omachi-sanpaku.com/',
    is_featured: false
  },
  {
    name: '市立岡谷美術考古館',
    prefecture: '長野県',
    city: '岡谷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.okaya-museum.jp/',
    is_featured: false
  },
  {
    name: '小さな絵本美術館',
    prefecture: '長野県',
    city: '岡谷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ba-ba.net/',
    is_featured: false
  },
  {
    name: '辰野美術館',
    prefecture: '長野県',
    city: '上伊那郡辰野町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://artm.town.tatsuno.nagano.jp/',
    is_featured: false
  },
  {
    name: '箕輪町郷土博物館',
    prefecture: '長野県',
    city: '上伊那郡箕輪町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.minowa.lg.jp/kanko-bunka-sports/minowamachikyodohakubutsukan/index.html',
    is_featured: false
  },
  {
    name: 'おぶせミュージアム・中島千波館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.obuse.nagano.jp/site/obusemuseum/',
    is_featured: false
  },
  {
    name: 'グレイスフル芸術館　おぶせ藤岡牧夫美術館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fujiokamakio.jp/',
    is_featured: false
  },
  {
    name: '日本のあかり博物館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nihonnoakari.or.jp/',
    is_featured: false
  },
  {
    name: '北斎館',
    prefecture: '長野県',
    city: '上高井郡小布施町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hokusai-kan.com/',
    is_featured: false
  },
  {
    name: '歴史公園信州高山一茶ゆかりの里一茶館',
    prefecture: '長野県',
    city: '上高井郡高山村',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kobayashi-issa.jp/',
    is_featured: false
  },
  {
    name: '野尻湖ナウマンゾウ博物館',
    prefecture: '長野県',
    city: '上水内郡信濃町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://nojiriko-museum.com/',
    is_featured: false
  },
  {
    name: '南木曽町博物館',
    prefecture: '長野県',
    city: '木曽郡南木曽町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://nagiso-museum.jp/',
    is_featured: false
  },
  {
    name: '北アルプス展望美術館（池田町立美術館）',
    prefecture: '長野県',
    city: '北安曇郡池田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://navam-ikd.jp',
    is_featured: false
  },
  {
    name: '安曇野ちひろ美術館',
    prefecture: '長野県',
    city: '北安曇郡松川村',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chihiro.jp/azumino/',
    is_featured: false
  },
  {
    name: '軽井沢町追分宿郷土館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.karuizawa.lg.jp/www/contents/1001000000936/index.html',
    is_featured: false
  },
  {
    name: '軽井沢町歴史民俗資料館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.town.karuizawa.lg.jp/soshiki/21/',
    is_featured: false
  },
  {
    name: 'セゾン現代美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://smma.or.jp/',
    is_featured: false
  },
  {
    name: '田崎美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://tasaki-museum.org/',
    is_featured: false
  },
  {
    name: 'ルヴァン美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.levent.or.jp/',
    is_featured: false
  },
  {
    name: '脇田美術館',
    prefecture: '長野県',
    city: '北佐久郡軽井沢町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.wakita-museum.com/',
    is_featured: false
  },
  {
    name: '浅間縄文ミュージアム',
    prefecture: '長野県',
    city: '北佐久郡御代田町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://w2.avis.ne.jp/~jomon/',
    is_featured: false
  },
  {
    name: '小諸市立小山敬三美術館',
    prefecture: '長野県',
    city: '小諸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.komoro.lg.jp/soshikikarasagasu/kyoikuiinkaijimukyoku/bunkazai_shogaigakushuka/4/2/2/2084.html',
    is_featured: false
  },
  {
    name: '市立小諸高原美術館・白鳥映雪館',
    prefecture: '長野県',
    city: '小諸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.komoro.lg.jp/soshikikarasagasu/kyoikuiinkaijimukyoku/bunkazai_shogaigakushuka/4/2/4/index.html',
    is_featured: false
  },
  {
    name: '佐久市立近代美術館',
    prefecture: '長野県',
    city: '佐久市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.saku.nagano.jp/museum/',
    is_featured: false
  },
  {
    name: '佐久市立天来記念館',
    prefecture: '長野県',
    city: '佐久市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.saku.nagano.jp/shisetsu/sakubun/tenraikinenkan/index.html',
    is_featured: false
  },
  {
    name: '大鹿村中央構造線博物館',
    prefecture: '長野県',
    city: '下伊那郡大鹿村',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://mtl-muse.com/',
    is_featured: false
  },
  {
    name: '田中本家博物館',
    prefecture: '長野県',
    city: '須坂市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://tanakahonke.org/',
    is_featured: false
  },
  {
    name: '下諏訪町立諏訪湖博物館・赤彦記念館',
    prefecture: '長野県',
    city: '諏訪郡下諏訪町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.town.shimosuwa.lg.jp/www/genre/1474269863762/index.html',
    is_featured: false
  },
  {
    name: 'ハーモ美術館',
    prefecture: '長野県',
    city: '諏訪郡下諏訪町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.harmo-museum.jp/',
    is_featured: false
  },
  {
    name: '富士見町高原のミュージアム',
    prefecture: '長野県',
    city: '諏訪郡富士見町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nagano-museum.com/info/detail.php?fno=123',
    is_featured: false
  },
  {
    name: '伊東近代美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: '',
    is_featured: false
  },
  {
    name: '北澤美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitazawa-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'サンリツ服部美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.sunritz-hattori-museum.or.jp/',
    is_featured: false
  },
  {
    name: '諏訪教育博物館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.suwa-k.or.jp/?page_id=161',
    is_featured: false
  },
  {
    name: '諏訪市博物館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://suwacitymuseum.jp/',
    is_featured: false
  },
  {
    name: '諏訪市原田泰治美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.taizi-artmuseum.jp/',
    is_featured: false
  },
  {
    name: '諏訪市美術館',
    prefecture: '長野県',
    city: '諏訪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.suwa.lg.jp/site/museum/',
    is_featured: false
  },
  {
    name: '黒曜石展示・体験館（星くずの里たかやま　黒耀石体験ミュージアム）',
    prefecture: '長野県',
    city: '小県郡長和町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '千曲市さらしなの里歴史資料館',
    prefecture: '長野県',
    city: '千曲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chikuma.lg.jp/soshiki/rekishibunkazaicenter/sarashinanosato_rekishi/2270.html',
    is_featured: false
  },
  {
    name: '千曲市森将軍塚古墳館',
    prefecture: '長野県',
    city: '千曲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chikuma.lg.jp/soshiki/rekishibunkazaicenter/mori_shogunzuka/index.html',
    is_featured: false
  },
  {
    name: '長野県立歴史館',
    prefecture: '長野県',
    city: '千曲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.npmh.net/',
    is_featured: false
  },
  {
    name: '茅野市神長官守矢史料館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chino.lg.jp/soshiki/bunkazai/1639.html',
    is_featured: false
  },
  {
    name: '茅野市尖石縄文考古館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chino.lg.jp/site/togariishi/',
    is_featured: false
  },
  {
    name: '茅野市八ヶ岳総合博物館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.chino.lg.jp/site/y-hakubutsukan/',
    is_featured: false
  },
  {
    name: '中野市立博物館',
    prefecture: '長野県',
    city: '中野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nakano.nagano.jp/categories/hakubutukan/',
    is_featured: false
  },
  {
    name: '北野美術館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitano-museum.or.jp/',
    is_featured: false
  },
  {
    name: '北野美術館分館北野カルチュラルセンター',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitano-museum.or.jp/cultural/',
    is_featured: false
  },
  {
    name: '信濃教育博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://shinkyo.or.jp/museum/guide',
    is_featured: false
  },
  {
    name: '長野県立美術館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nagano.art.museum/',
    is_featured: false
  },
  {
    name: '長野市立博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nagano.nagano.jp/museum/',
    is_featured: false
  },
  {
    name: '長野市立博物館分館　信州新町美術館　有島生馬記念館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ngn.janis.or.jp/~shinmachi-museum/',
    is_featured: false
  },
  {
    name: '長野市立博物館分館　戸隠地質化石博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.tgk.janis.or.jp/~togakushi-museum/index.html',
    is_featured: false
  },
  {
    name: '水野美術館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mizuno-museum.jp/',
    is_featured: false
  },
  {
    name: '朝日美術館',
    prefecture: '長野県',
    city: '東筑摩郡朝日村',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.vill.asahi.nagano.jp/special/asahibijutsukan/index.html',
    is_featured: false
  },
  {
    name: '日本浮世絵博物館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.japan-ukiyoe-museum.com/',
    is_featured: false
  },
  {
    name: '松本市美術館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://matsumoto-artmuse.jp/',
    is_featured: false
  },
  {
    name: '松本市立博物館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://matsumoto-city-museum.jp/',
    is_featured: false
  },
  {
    name: '松本市立博物館分館　旧制高等学校記念館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-haku.com/koutougakkou/',
    is_featured: false
  },
  {
    name: '松本市立博物館分館　松本市立考古博物館',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-haku.com/kouko/',
    is_featured: false
  },
  {
    name: '松本市立博物館分館　松本市歴史の里',
    prefecture: '長野県',
    city: '松本市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-haku.com/rekishinosato/',
    is_featured: false
  },
  {
    name: '小海町高原美術館',
    prefecture: '長野県',
    city: '南佐久郡小海町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.koumi-museum.com/',
    is_featured: false
  },
  {
    name: '岡谷蚕糸博物館',
    prefecture: '長野県',
    city: '岡谷市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://silkfact.jp/',
    is_featured: false
  },
  {
    name: '一茶記念館',
    prefecture: '長野県',
    city: '上水内郡信濃町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.issakinenkan.com/',
    is_featured: false
  },
  {
    name: '塩尻市立平出博物館',
    prefecture: '長野県',
    city: '塩尻市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://hiraide.shiojiri.com/',
    is_featured: false
  },
  {
    name: '信州大学教育学部附属志賀自然教育研究施設',
    prefecture: '長野県',
    city: '下高井郡山ノ内町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.shinshu-u.ac.jp/faculty/education/shiga/index.html',
    is_featured: false
  },
  {
    name: '京都造形芸術大学附属康耀堂美術館',
    prefecture: '長野県',
    city: '茅野市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.koyodo-museum.com/',
    is_featured: false
  },
  {
    name: '古代遺跡徳間博物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '善光寺大勧進宝物館',
    prefecture: '長野県',
    city: '長野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://daikanjin.jp/houbutsu/',
    is_featured: false
  },
  {
    name: '坂城町鉄の展示館',
    prefecture: '長野県',
    city: '埴科郡坂城町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.tetsu-museum.info/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 岐阜県 (25件)
# ================================
puts '岐阜県のデータを投入中...'

[
  {
    name: '世界淡水魚園水族館',
    prefecture: '岐阜県',
    city: '各務原市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://aquatotto.com/',
    is_featured: false
  },
  {
    name: '内藤記念くすり博物館',
    prefecture: '岐阜県',
    city: '各務原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.eisai.co.jp/museum/information/index.html',
    is_featured: false
  },
  {
    name: '荒川豊蔵資料館',
    prefecture: '岐阜県',
    city: '可児市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kani.lg.jp/10013.htm',
    is_featured: false
  },
  {
    name: '岐阜県美術館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kenbi.pref.gifu.lg.jp/',
    is_featured: false
  },
  {
    name: '岐阜市科学館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.gifu.lg.jp/kankoubunka/kagakukan/index.html',
    is_featured: false
  },
  {
    name: '岐阜市歴史博物館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.rekihaku.gifu.gifu.jp/',
    is_featured: false
  },
  {
    name: '岐阜市歴史博物館分館　加藤栄三・東一記念美術館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.rekihaku.gifu.gifu.jp/katoukinen/',
    is_featured: false
  },
  {
    name: '岐阜市歴史博物館分室　原三渓記念室',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.rekihaku.gifu.gifu.jp/harasankei/',
    is_featured: false
  },
  {
    name: '三甲美術館',
    prefecture: '岐阜県',
    city: '岐阜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sanko-museum.or.jp/',
    is_featured: false
  },
  {
    name: '岐阜県博物館',
    prefecture: '岐阜県',
    city: '関市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.gifu-kenpaku.jp/',
    is_featured: false
  },
  {
    name: '光ミュージアム',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://h-am.jp/',
    is_featured: false
  },
  {
    name: '岐阜県現代陶芸美術館',
    prefecture: '岐阜県',
    city: '多治見市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.cpm-gifu.jp/museum/',
    is_featured: false
  },
  {
    name: '中津川市鉱物博物館',
    prefecture: '岐阜県',
    city: '中津川市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.nakatsugawa.lg.jp/museum/m/index.html',
    is_featured: false
  },
  {
    name: '岐阜関ケ原古戦場記念館',
    prefecture: '岐阜県',
    city: '不破郡関ケ原町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sekigahara.pref.gifu.lg.jp',
    is_featured: false
  },
  {
    name: '瑞浪市化石博物館',
    prefecture: '岐阜県',
    city: '瑞浪市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.mizunami.lg.jp/kankou_bunka/1004960/kaseki_museum/index.html',
    is_featured: false
  },
  {
    name: '美濃加茂市民ミュージアム',
    prefecture: '岐阜県',
    city: '美濃加茂市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.forest.minokamo.gifu.jp/',
    is_featured: false
  },
  {
    name: '岐阜かかみがはら航空宇宙博物館',
    prefecture: '岐阜県',
    city: '各務原市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.sorahaku.net/',
    is_featured: false
  },
  {
    name: '下呂市下呂ふるさと歴史記念館',
    prefecture: '岐阜県',
    city: '下呂市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '高山祭屋台会館',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.hidahachimangu.jp/yataikaikan/welcome.html',
    is_featured: false
  },
  {
    name: '飛騨高山茶の湯の森',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.nakada-net.jp/chanoyu/',
    is_featured: false
  },
  {
    name: '飛騨高山まちの博物館',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.city.takayama.lg.jp/machihaku/',
    is_featured: false
  },
  {
    name: '飛騨高山まつりの森高山祭りミュージアム',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.togeihida.co.jp/',
    is_featured: false
  },
  {
    name: '飛騨高山まつりの森ちょうの館',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.togeihida.co.jp/sizen/',
    is_featured: false
  },
  {
    name: '飛騨民俗村',
    prefecture: '岐阜県',
    city: '高山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://hidanosato.com/',
    is_featured: false
  },
  {
    name: '藤村記念館',
    prefecture: '岐阜県',
    city: '中津川市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://toson.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 静岡県 (46件)
# ================================
puts '静岡県のデータを投入中...'

[
  {
    name: 'ＭＯＡ美術館',
    prefecture: '静岡県',
    city: '熱海市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.moaart.or.jp/',
    is_featured: false
  },
  {
    name: '池田２０世紀美術館',
    prefecture: '静岡県',
    city: '伊東市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ikeda20.or.jp/',
    is_featured: false
  },
  {
    name: '崔如琢美術館',
    prefecture: '静岡県',
    city: '伊東市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yoko.or.jp/about/',
    is_featured: false
  },
  {
    name: '磐田市香りの博物館',
    prefecture: '静岡県',
    city: '磐田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.iwata-kaori.jp/',
    is_featured: false
  },
  {
    name: '掛川市二の丸美術館',
    prefecture: '静岡県',
    city: '掛川市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://k-kousya.or.jp/ninomaru/',
    is_featured: false
  },
  {
    name: '一般財団法人　清水港湾博物館（フェルケール博物館）',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.verkehr-museum.jp/',
    is_featured: false
  },
  {
    name: '久能山東照宮博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.toshogu.or.jp/kt_museum/',
    is_featured: false
  },
  {
    name: '公益財団法人　駿府博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.sbs-bunkafukushi.com/museum/',
    is_featured: false
  },
  {
    name: '静岡県立美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://spmoa.shizuoka.shizuoka.jp/',
    is_featured: false
  },
  {
    name: '静岡市立芹沢銈介美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.seribi.jp/',
    is_featured: false
  },
  {
    name: '静岡市立登呂博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shizuoka-toromuseum.jp/',
    is_featured: false
  },
  {
    name: 'ふじのくに地球環境史ミュージアム',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.fujimu100.jp',
    is_featured: false
  },
  {
    name: '島田市博物館',
    prefecture: '静岡県',
    city: '島田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.shimada.shizuoka.jp/shimahaku',
    is_featured: false
  },
  {
    name: '上原美術館',
    prefecture: '静岡県',
    city: '下田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://uehara-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'ベルナール・ビュフェ美術館',
    prefecture: '静岡県',
    city: '駿東郡長泉町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.buffet-museum.jp/',
    is_featured: false
  },
  {
    name: '月光天文台',
    prefecture: '静岡県',
    city: '田方郡函南町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://gekkou.or.jp/',
    is_featured: false
  },
  {
    name: '沼津市戸田造船郷土資料博物館',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.numazu.shizuoka.jp/kurashi/shisetsu/zosen/',
    is_featured: false
  },
  {
    name: '沼津市明治史料館',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.numazu.shizuoka.jp/kurashi/shisetsu/meiji/',
    is_featured: false
  },
  {
    name: '沼津市歴史民俗資料館',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.numazu.shizuoka.jp/kurashi/shisetsu/rekishiminzoku/',
    is_featured: false
  },
  {
    name: '公益財団法人　平野美術館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hirano-museum.jp/index.html',
    is_featured: false
  },
  {
    name: '浜松科学館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.mirai-ra.jp',
    is_featured: false
  },
  {
    name: '浜松市秋野不矩美術館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.akinofuku-museum.jp/',
    is_featured: false
  },
  {
    name: '浜松市博物館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.hamamatsu.shizuoka.jp/hamahaku/',
    is_featured: false
  },
  {
    name: '浜松市美術館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hamamatsu.shizuoka.jp/artmuse/',
    is_featured: false
  },
  {
    name: '藤枝市郷土博物館',
    prefecture: '静岡県',
    city: '藤枝市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.fujieda.shizuoka.jp/kyodomuse/index.html',
    is_featured: false
  },
  {
    name: '富士山かぐや姫ミュージアム（富士市立博物館）',
    prefecture: '静岡県',
    city: '富士市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://museum.city.fuji.shizuoka.jp/',
    is_featured: false
  },
  {
    name: '奇石博物館',
    prefecture: '静岡県',
    city: '富士宮市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.kiseki-jp.com/',
    is_featured: false
  },
  {
    name: '公益社団法人佐野美術館',
    prefecture: '静岡県',
    city: '三島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sanobi.or.jp/',
    is_featured: false
  },
  {
    name: '三島市郷土資料館',
    prefecture: '静岡県',
    city: '三島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.mishima.shizuoka.jp/kyoudo/',
    is_featured: false
  },
  {
    name: '伊豆シャボテン公園',
    prefecture: '静岡県',
    city: '伊東市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://izushaboten.com/',
    is_featured: false
  },
  {
    name: '磐田市旧見付学校',
    prefecture: '静岡県',
    city: '磐田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.iwata.shizuoka.jp/shisetsu_guide/toshokan_bunka/tenji/1003509.html',
    is_featured: false
  },
  {
    name: '体感型動物園iZoo',
    prefecture: '静岡県',
    city: '賀茂郡河津町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://izoo.co.jp/',
    is_featured: false
  },
  {
    name: '熱川バナナワニ園',
    prefecture: '静岡県',
    city: '賀茂郡東伊豆町',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'http://bananawani.jp/',
    is_featured: false
  },
  {
    name: '静岡市東海道広重美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://tokaido-hiroshige.jp/',
    is_featured: false
  },
  {
    name: '静岡市美術館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://shizubi.jp/',
    is_featured: false
  },
  {
    name: '静岡市歴史博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://scmh.jp/',
    is_featured: false
  },
  {
    name: '東海大学海洋科学博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.umi.muse-tokai.jp/',
    is_featured: false
  },
  {
    name: '東海大学自然史博物館',
    prefecture: '静岡県',
    city: '静岡市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.sizen.muse-tokai.jp/',
    is_featured: false
  },
  {
    name: '下田海中水族館',
    prefecture: '静岡県',
    city: '下田市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://shimoda-aquarium.com/',
    is_featured: false
  },
  {
    name: '富士自然動物公園　富士サファリパーク',
    prefecture: '静岡県',
    city: '裾野市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.fujisafari.co.jp/',
    is_featured: false
  },
  {
    name: '伊豆三津シーパラダイス',
    prefecture: '静岡県',
    city: '沼津市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.mitosea.com/',
    is_featured: false
  },
  {
    name: '浜名湖オルゴールミュージアム',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.hamanako-orgel.jp/',
    is_featured: false
  },
  {
    name: '浜松市楽器博物館',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.gakkihaku.jp/',
    is_featured: false
  },
  {
    name: '浜松市動物園',
    prefecture: '静岡県',
    city: '浜松市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://hamazoo.net/',
    is_featured: false
  },
  {
    name: '三嶋大社宝物館',
    prefecture: '静岡県',
    city: '三島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://mishimataisha.or.jp/treasure/',
    is_featured: false
  },
  {
    name: '焼津市歴史民俗資料館',
    prefecture: '静岡県',
    city: '焼津市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.yaizu.lg.jp/museum/rekimin/index.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 愛知県 (49件)
# ================================
puts '愛知県のデータを投入中...'

[
  {
    name: '安城市歴史博物館',
    prefecture: '愛知県',
    city: '安城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.ansyobunka.jp/',
    is_featured: false
  },
  {
    name: '一宮市博物館',
    prefecture: '愛知県',
    city: '一宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.icm-jp.com/',
    is_featured: false
  },
  {
    name: '稲沢市荻須記念美術館',
    prefecture: '愛知県',
    city: '稲沢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.city.inazawa.aichi.jp/museum/',
    is_featured: false
  },
  {
    name: '公益財団法人日本モンキーセンター',
    prefecture: '愛知県',
    city: '犬山市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://www.j-monkey.jp/',
    is_featured: false
  },
  {
    name: '博物館明治村',
    prefecture: '愛知県',
    city: '犬山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.meijimura.com/',
    is_featured: false
  },
  {
    name: '岡崎市美術博物館',
    prefecture: '愛知県',
    city: '岡崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.okazaki.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '刈谷市歴史博物館',
    prefecture: '愛知県',
    city: '刈谷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kariya.lg.jp/rekihaku/',
    is_featured: false
  },
  {
    name: '高浜市やきものの里かわら美術館・図書館',
    prefecture: '愛知県',
    city: '高浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.takahama-kawara-museum.com/index.html',
    is_featured: false
  },
  {
    name: '田原市博物館',
    prefecture: '愛知県',
    city: '田原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.taharamuseum.gr.jp/',
    is_featured: false
  },
  {
    name: '豊田市美術館',
    prefecture: '愛知県',
    city: '豊田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.museum.toyota.aichi.jp/',
    is_featured: false
  },
  {
    name: '豊橋市自然史博物館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.toyohaku.gr.jp/sizensi/',
    is_featured: false
  },
  {
    name: '豊橋市地下資源館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.toyohaku.gr.jp/chika/',
    is_featured: false
  },
  {
    name: '豊橋市美術博物館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.toyohashi-bihaku.jp/',
    is_featured: false
  },
  {
    name: '豊橋市二川宿本陣資料館',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://futagawa-honjin.jp/',
    is_featured: false
  },
  {
    name: '豊橋総合動植物公園',
    prefecture: '愛知県',
    city: '豊橋市',
    registration_type: '登録博物館',
    museum_type: '動・水・植物園',
    official_website: 'https://www.nonhoi.jp',
    is_featured: false
  },
  {
    name: '名都美術館',
    prefecture: '愛知県',
    city: '長久手市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.meito.hayatele.co.jp/',
    is_featured: false
  },
  {
    name: '熱田神宮宝物館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.atsutajingu.or.jp/houmotukan_kusanagi/houmotukan/',
    is_featured: false
  },
  {
    name: '荒木集成館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.arakishuseikan.ecweb.jp/',
    is_featured: false
  },
  {
    name: '桑山美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kuwayama-museum.jp/',
    is_featured: false
  },
  {
    name: '昭和美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shouwa-museum.com/index.html',
    is_featured: false
  },
  {
    name: '唐九郎記念館（翠松園陶芸記念館）',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.nagoya.jp/moriyama/page/0000001531.html',
    is_featured: false
  },
  {
    name: '徳川美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tokugawa-art-museum.jp/',
    is_featured: false
  },
  {
    name: '名古屋市科学館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.ncsm.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '名古屋市博物館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.museum.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '名古屋市美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://art-museum.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '名古屋市見晴台考古資料館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.nagoya.jp/kurashi/category/19-15-2-8-0-0-0-0-0-0.html',
    is_featured: false
  },
  {
    name: '古川美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.furukawa-museum.or.jp/',
    is_featured: false
  },
  {
    name: '横山美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yokoyama-art-museum.or.jp/',
    is_featured: false
  },
  {
    name: '楽只美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.mc.ccnw.ne.jp/nagoya-taikan/rakusi.html',
    is_featured: false
  },
  {
    name: '西尾市岩瀬文庫',
    prefecture: '愛知県',
    city: '西尾市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://iwasebunko.jp/',
    is_featured: false
  },
  {
    name: '公益財団法人かみや美術館',
    prefecture: '愛知県',
    city: '半田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kamiya-muse.or.jp/',
    is_featured: false
  },
  {
    name: '半田市立博物館',
    prefecture: '愛知県',
    city: '半田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.handa.lg.jp/bunka/bunkashisetsu/1002704/index.html',
    is_featured: false
  },
  {
    name: '碧南海浜水族館',
    prefecture: '愛知県',
    city: '碧南市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.city.hekinan.lg.jp/aquarium/index.html',
    is_featured: false
  },
  {
    name: '碧南市藤井達吉現代美術館',
    prefecture: '愛知県',
    city: '碧南市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.hekinan.lg.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '野外民族博物館リトルワールド',
    prefecture: '愛知県',
    city: '犬山市',
    registration_type: '指定施設',
    museum_type: '野外博物館',
    official_website: 'https://www.littleworld.jp/',
    is_featured: false
  },
  {
    name: '春日井市道風記念館',
    prefecture: '愛知県',
    city: '春日井市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kasugai.lg.jp/shisei/shisetsu/bunka/tofu/index.html',
    is_featured: false
  },
  {
    name: '中部大学民族資料博物館',
    prefecture: '愛知県',
    city: '春日井市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.chubu.ac.jp/student-life/facilities/museum/',
    is_featured: false
  },
  {
    name: '刈谷市美術館',
    prefecture: '愛知県',
    city: '刈谷市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kariya.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '愛知県陶磁美術館',
    prefecture: '愛知県',
    city: '瀬戸市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.pref.aichi.jp/touji/',
    is_featured: false
  },
  {
    name: '瀬戸蔵ミュージアム',
    prefecture: '愛知県',
    city: '瀬戸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.seto.aichi.jp/docs/2011/03/15/00092/',
    is_featured: false
  },
  {
    name: '瀬戸市美術館',
    prefecture: '愛知県',
    city: '瀬戸市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.seto-cul.jp/seto-museum/',
    is_featured: false
  },
  {
    name: '南知多ビーチランド',
    prefecture: '愛知県',
    city: '知多郡美浜町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://beachland.jp/',
    is_featured: false
  },
  {
    name: 'INAXライブミュージアム',
    prefecture: '愛知県',
    city: '常滑市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://livingculture.lixil.com/ilm/',
    is_featured: false
  },
  {
    name: '愛知県立芸術大学芸術資料館・法隆寺金堂壁画模写展示館',
    prefecture: '愛知県',
    city: '長久手市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.aichi-fam-u.ac.jp/#top',
    is_featured: false
  },
  {
    name: '愛知芸術文化センター愛知県美術館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www-art.aac.pref.aichi.jp/',
    is_featured: false
  },
  {
    name: '戦争と平和の資料館ピースあいち',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://peace-aichi.com/',
    is_featured: false
  },
  {
    name: '名古屋港水族館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://nagoyaaqua.jp/',
    is_featured: false
  },
  {
    name: '名古屋市東山動植物園',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.higashiyama.city.nagoya.jp/',
    is_featured: false
  },
  {
    name: '南山大学人類学博物館',
    prefecture: '愛知県',
    city: '名古屋市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://rci.nanzan-u.ac.jp/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 三重県 (20件)
# ================================
puts '三重県のデータを投入中...'

[
  {
    name: '伊賀流忍者博物館',
    prefecture: '三重県',
    city: '伊賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.iganinja.jp/',
    is_featured: false
  },
  {
    name: '神宮徴古館農業館・式年遷宮記念せんぐう館',
    prefecture: '三重県',
    city: '伊勢市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://museum.isejingu.or.jp/index.html',
    is_featured: false
  },
  {
    name: '式年遷宮記念神宮美術館',
    prefecture: '三重県',
    city: '伊勢市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://museum.isejingu.or.jp/artmuseum/index.html',
    is_featured: false
  },
  {
    name: '亀山市歴史博物館',
    prefecture: '三重県',
    city: '亀山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://kameyamarekihaku.jp/',
    is_featured: false
  },
  {
    name: '桑名市博物館',
    prefecture: '三重県',
    city: '桑名市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kuwana.lg.jp/shisetsu/bunka/005.html',
    is_featured: false
  },
  {
    name: '鈴鹿市考古博物館',
    prefecture: '三重県',
    city: '鈴鹿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.suzuka.lg.jp/kouko/',
    is_featured: false
  },
  {
    name: '斎宮歴史博物館',
    prefecture: '三重県',
    city: '多気郡明和町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bunka.pref.mie.lg.jp/saiku/',
    is_featured: false
  },
  {
    name: '石水博物館',
    prefecture: '三重県',
    city: '津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sekisui-museum.or.jp/',
    is_featured: false
  },
  {
    name: '三重県総合博物館',
    prefecture: '三重県',
    city: '津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.bunka.pref.mie.lg.jp/MieMu/',
    is_featured: false
  },
  {
    name: '三重県立美術館',
    prefecture: '三重県',
    city: '津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.bunka.pref.mie.lg.jp/art-museum/index.shtm',
    is_featured: false
  },
  {
    name: '鳥羽市立海の博物館',
    prefecture: '三重県',
    city: '鳥羽市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.umihaku.com/',
    is_featured: false
  },
  {
    name: '鳥羽水族館',
    prefecture: '三重県',
    city: '鳥羽市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://aquarium.co.jp/',
    is_featured: false
  },
  {
    name: '松浦武四郎記念館',
    prefecture: '三重県',
    city: '松阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://takeshiro.net/',
    is_featured: false
  },
  {
    name: '松阪市文化財センター',
    prefecture: '三重県',
    city: '松阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.matsusaka.mie.jp/site/bunkazai-center/',
    is_featured: false
  },
  {
    name: '本居宣長記念館',
    prefecture: '三重県',
    city: '松阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.norinagakinenkan.com/',
    is_featured: false
  },
  {
    name: '朝日町歴史博物館',
    prefecture: '三重県',
    city: '三重郡朝日町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://asahitown-museum.com/',
    is_featured: false
  },
  {
    name: 'パラミタ・ミュージアム',
    prefecture: '三重県',
    city: '三重郡菰野町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.paramitamuseum.com/top.html',
    is_featured: false
  },
  {
    name: '澄懐堂美術館',
    prefecture: '三重県',
    city: '四日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://chokaido.jp/',
    is_featured: false
  },
  {
    name: '四日市市立博物館',
    prefecture: '三重県',
    city: '四日市市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.yokkaichi.mie.jp/museum/museum.html',
    is_featured: false
  },
  {
    name: '伊勢夫婦岩ふれあい水族館シーパラダイス',
    prefecture: '三重県',
    city: '伊勢市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://ise-seaparadise.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 滋賀県 (20件)
# ================================
puts '滋賀県のデータを投入中...'

[
  {
    name: '愛荘町立歴史文化博物館',
    prefecture: '滋賀県',
    city: '愛知郡愛荘町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.aisho.shiga.jp/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: '滋賀県立安土城考古博物館',
    prefecture: '滋賀県',
    city: '近江八幡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://azuchi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '大津市歴史博物館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.rekihaku.otsu.shiga.jp/',
    is_featured: false
  },
  {
    name: '木下美術館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kinoshita-museum.com/',
    is_featured: false
  },
  {
    name: '滋賀県立美術館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shigamuseum.jp/',
    is_featured: false
  },
  {
    name: '膳所焼美術館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://zezeyaki.or.jp/',
    is_featured: false
  },
  {
    name: '滋賀県立琵琶湖博物館',
    prefecture: '滋賀県',
    city: '草津市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.biwahaku.jp/',
    is_featured: false
  },
  {
    name: '滋賀県立陶芸の森',
    prefecture: '滋賀県',
    city: '甲賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sccp.jp',
    is_featured: false
  },
  {
    name: 'ＭＩＨＯ　ＭＵＳＥＵＭ',
    prefecture: '滋賀県',
    city: '甲賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miho.jp/',
    is_featured: false
  },
  {
    name: '長浜市長浜城歴史博物館',
    prefecture: '滋賀県',
    city: '長浜市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nagahama-rekihaku.jp',
    is_featured: false
  },
  {
    name: '観峰館',
    prefecture: '滋賀県',
    city: '東近江市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kampokan.com/',
    is_featured: false
  },
  {
    name: '日登美美術館',
    prefecture: '滋賀県',
    city: '東近江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sam.shiga.jp/%E8%B2%A1%E5%9B%A3%E6%B3%95%E4%BA%BA-%E6%97%A5%E7%99%BB%E7%BE%8E%E7%BE%8E%E8%A1%93%E9%A4%A8/',
    is_featured: false
  },
  {
    name: '彦根城博物館',
    prefecture: '滋賀県',
    city: '彦根市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hikone-castle-museum.jp/',
    is_featured: false
  },
  {
    name: '佐川美術館',
    prefecture: '滋賀県',
    city: '守山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.sagawa-artmuseum.or.jp/',
    is_featured: false
  },
  {
    name: '野洲市歴史民俗博物館・銅鐸博物館',
    prefecture: '滋賀県',
    city: '野洲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.yasu.lg.jp/soshiki/rekishiminzoku/museum.html',
    is_featured: false
  },
  {
    name: '栗東歴史民俗博物館',
    prefecture: '滋賀県',
    city: '栗東市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.ritto.lg.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: 'ボーダレス・アートミュージアムＮＯーＭＡ',
    prefecture: '滋賀県',
    city: '近江八幡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.no-ma.jp/',
    is_featured: false
  },
  {
    name: '近江神宮時計館宝物館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://oumijingu.org/pages/98/',
    is_featured: false
  },
  {
    name: '田上鉱物博物館',
    prefecture: '滋賀県',
    city: '大津市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: '',
    is_featured: false
  },
  {
    name: '滋賀大学経済学部附属史料館',
    prefecture: '滋賀県',
    city: '彦根市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.econ.shiga-u.ac.jp/shiryo/10/1/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 京都府 (54件)
# ================================
puts '京都府のデータを投入中...'

[
  {
    name: ' 平等院ミュージアム鳳翔館',
    prefecture: '京都府',
    city: '宇治市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.byodoin.or.jp/museum/',
    is_featured: false
  },
  {
    name: 'アサヒグループ大山崎山荘美術館',
    prefecture: '京都府',
    city: '乙訓郡大山崎町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.asahigroup-oyamazaki.com/',
    is_featured: false
  },
  {
    name: '京都府立山城郷土資料館',
    prefecture: '京都府',
    city: '木津川市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.kyoto-be.ne.jp/yamasiro-m/cms/',
    is_featured: false
  },
  {
    name: '大西清右衛門美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: '',
    is_featured: false
  },
  {
    name: '角屋もてなしの文化美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sumiyaho.sakura.ne.jp/',
    is_featured: false
  },
  {
    name: '漢検　漢字博物館・図書館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kanjimuseum.kyoto/',
    is_featured: false
  },
  {
    name: '北村美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitamura-museum.com/',
    is_featured: false
  },
  {
    name: '京都市青少年科学センター',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.edu.city.kyoto.jp/science/',
    is_featured: false
  },
  {
    name: '京都市動物園',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://zoo.city.kyoto.lg.jp/zoo/',
    is_featured: false
  },
  {
    name: '京都府京都文化博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bunpaku.or.jp/',
    is_featured: false
  },
  {
    name: '高麗美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.koryomuseum.or.jp/',
    is_featured: false
  },
  {
    name: '嵯峨嵐山文華館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.samac.jp/',
    is_featured: false
  },
  {
    name: '茶道資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.urasenke.or.jp/textc/kon/gallery.html',
    is_featured: false
  },
  {
    name: '島津製作所 創業記念資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shimadzu.co.jp/memorial-museum/',
    is_featured: false
  },
  {
    name: '白沙村荘　橋本関雪記念館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hakusasonso.jp/',
    is_featured: false
  },
  {
    name: '泉屋博古館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://sen-oku.or.jp/',
    is_featured: false
  },
  {
    name: '武田薬品工業株式会社 京都薬用植物園',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.takeda.co.jp/kyoto/',
    is_featured: false
  },
  {
    name: '並河靖之七宝記念館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://namikawa-kyoto.jp',
    is_featured: false
  },
  {
    name: '日図デザイン博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nichizu.or.jp/?cat=5',
    is_featured: false
  },
  {
    name: '野村美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nomura-museum.or.jp/',
    is_featured: false
  },
  {
    name: '博物館さがの人形の家',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://sagano.or.jp/',
    is_featured: false
  },
  {
    name: '風俗博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.iz2.or.jp/',
    is_featured: false
  },
  {
    name: '福田美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fukuda-art-museum.jp/',
    is_featured: false
  },
  {
    name: '細見美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.emuseum.or.jp/',
    is_featured: false
  },
  {
    name: '樂美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.raku-yaki.or.jp/museum/',
    is_featured: false
  },
  {
    name: '霊山歴史館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.ryozen-museum.or.jp/',
    is_featured: false
  },
  {
    name: '京都府立丹後郷土資料館',
    prefecture: '京都府',
    city: '宮津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kyoto-be.ne.jp/tango-m/cms/',
    is_featured: false
  },
  {
    name: '永守コレクションギャラリー',
    prefecture: '京都府',
    city: '向日市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nagamori-gallery.org/',
    is_featured: false
  },
  {
    name: '宇治市歴史資料館',
    prefecture: '京都府',
    city: '宇治市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.uji.kyoto.jp/soshiki/89/',
    is_featured: false
  },
  {
    name: '同志社大学歴史資料館',
    prefecture: '京都府',
    city: '京田辺市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://hmuseum.doshisha.ac.jp/',
    is_featured: false
  },
  {
    name: 'KCIギャラリー',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kci.or.jp/gallery/',
    is_featured: false
  },
  {
    name: '大谷大学博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.otani.ac.jp/kyo_kikan/museum/index.html',
    is_featured: false
  },
  {
    name: '京都芸術大学芸術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kyoto-geijutsu-kan.com/',
    is_featured: false
  },
  {
    name: '京都工芸繊維大学美術工芸資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.museum.kit.ac.jp/',
    is_featured: false
  },
  {
    name: '京都国立近代美術館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.momak.go.jp/',
    is_featured: false
  },
  {
    name: '京都国立博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.kyohaku.go.jp/jp/',
    is_featured: false
  },
  {
    name: '京都産業大学ギャラリー',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kyoto-su.ac.jp/facilities/musubiwaza/gallery/',
    is_featured: false
  },
  {
    name: '京都産業大学神山天文台',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kyoto-su.ac.jp/observatory/',
    is_featured: false
  },
  {
    name: '京都市学校歴史博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://kyo-gakurehaku.jp/',
    is_featured: false
  },
  {
    name: '京都市京セラ美術館（京都市美術館）',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kyotocity-kyocera.museum/',
    is_featured: false
  },
  {
    name: '京都市立芸術大学芸術資料館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://libmuse.kcua.ac.jp/muse/',
    is_featured: false
  },
  {
    name: '京都精華大学ギャラリー',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://gallery.kyoto-seika.ac.jp/',
    is_featured: false
  },
  {
    name: '京都大学総合博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.museum.kyoto-u.ac.jp/',
    is_featured: false
  },
  {
    name: '京都鉄道博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.kyotorailwaymuseum.jp/',
    is_featured: false
  },
  {
    name: '嵯峨美術大学・嵯峨美術短期大学附属博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kyoto-saga.ac.jp/about/museum/',
    is_featured: false
  },
  {
    name: '醍醐寺霊宝館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.daigoji.or.jp/grounds/reihoukan.html',
    is_featured: false
  },
  {
    name: '花園大学歴史博物館',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.hanazono.ac.jp/about/museum.html',
    is_featured: false
  },
  {
    name: '佛教大学宗教文化ミュージアム',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.bukkyo-u.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '養源院',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://yougenin.jp/',
    is_featured: false
  },
  {
    name: '立命館大学国際平和ミュージアム',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://rwp-museum.jp/',
    is_featured: false
  },
  {
    name: '龍谷大学龍谷ミュージアム',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://museum.ryukoku.ac.jp/',
    is_featured: false
  },
  {
    name: '龍安寺',
    prefecture: '京都府',
    city: '京都市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.ryoanji.jp/smph/',
    is_featured: false
  },
  {
    name: '京都大学フィールド科学教育研究センター舞鶴水産実験所水産生物標本館',
    prefecture: '京都府',
    city: '舞鶴市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.maizuru.marine.kais.kyoto-u.ac.jp/',
    is_featured: false
  },
  {
    name: '舞鶴引揚記念館',
    prefecture: '京都府',
    city: '舞鶴市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://m-hikiage-museum.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 大阪府 (41件)
# ================================
puts '大阪府のデータを投入中...'

[
  {
    name: '逸翁美術館',
    prefecture: '大阪府',
    city: '池田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hankyu-bunka.or.jp/itsuo-museum/',
    is_featured: false
  },
  {
    name: '和泉市久保惣記念美術館',
    prefecture: '大阪府',
    city: '和泉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ikm-art.jp/',
    is_featured: false
  },
  {
    name: '大阪府立弥生文化博物館',
    prefecture: '大阪府',
    city: '和泉市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://yayoi-bunka.com/',
    is_featured: false
  },
  {
    name: '大阪市立科学館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.sci-museum.jp/',
    is_featured: false
  },
  {
    name: '大阪市立自然史博物館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://omnh.jp/',
    is_featured: false
  },
  {
    name: '大阪市立東洋陶磁美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.moco.or.jp/',
    is_featured: false
  },
  {
    name: '大阪市立美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.osaka-art-museum.jp/',
    is_featured: false
  },
  {
    name: '大阪中之島美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nakka-art.jp/',
    is_featured: false
  },
  {
    name: '大阪歴史博物館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.osakamushis.jp/',
    is_featured: false
  },
  {
    name: '中之島香雪美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kosetsu-museum.or.jp/nakanoshima/',
    is_featured: false
  },
  {
    name: '藤田美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fujita-museum.or.jp/',
    is_featured: false
  },
  {
    name: '湯木美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yuki-museum.or.jp/',
    is_featured: false
  },
  {
    name: '貝塚市立自然遊学館',
    prefecture: '大阪府',
    city: '貝塚市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.kaizuka.lg.jp/shizen/index.html',
    is_featured: false
  },
  {
    name: '小谷城郷土館',
    prefecture: '大阪府',
    city: '堺市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.kotanijo.jp/',
    is_featured: false
  },
  {
    name: '堺市博物館',
    prefecture: '大阪府',
    city: '堺市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.sakai.lg.jp/kanko/hakubutsukan/',
    is_featured: false
  },
  {
    name: 'シマノ自転車博物館',
    prefecture: '大阪府',
    city: '堺市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.bikemuse.jp/',
    is_featured: false
  },
  {
    name: '吹田市立博物館',
    prefecture: '大阪府',
    city: '吹田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.suita.osaka.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '正木美術館',
    prefecture: '大阪府',
    city: '泉北郡忠岡町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://masaki-art-museum.jp/',
    is_featured: false
  },
  {
    name: '高槻市立今城塚古代歴史館',
    prefecture: '大阪府',
    city: '高槻市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takatsuki.osaka.jp/site/history/list8.html',
    is_featured: false
  },
  {
    name: '高槻市立しろあと歴史館',
    prefecture: '大阪府',
    city: '高槻市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takatsuki.osaka.jp/site/history/4653.html',
    is_featured: false
  },
  {
    name: '奥内陶芸美術館',
    prefecture: '大阪府',
    city: '豊中市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.okuuchi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '日本民家集落博物館',
    prefecture: '大阪府',
    city: '豊中市',
    registration_type: '登録博物館',
    museum_type: '野外博物館',
    official_website: 'https://www.occh.or.jp/minka/',
    is_featured: false
  },
  {
    name: '司馬遼太郎記念館',
    prefecture: '大阪府',
    city: '東大阪市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shibazaidan.or.jp/',
    is_featured: false
  },
  {
    name: '東大阪市立郷土博物館',
    prefecture: '大阪府',
    city: '東大阪市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.higashiosaka.lg.jp/0000003607.html',
    is_featured: false
  },
  {
    name: '大阪府立近つ飛鳥博物館',
    prefecture: '大阪府',
    city: '南河内郡河南町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.chikatsu-asuka.jp/',
    is_featured: false
  },
  {
    name: '太子町立竹内街道歴史資料館',
    prefecture: '大阪府',
    city: '南河内郡太子町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.taishi.osaka.jp/busyo/kyouiku_jimu/syougaigakusyuuka/ivent3/shiryoukan.html',
    is_featured: false
  },
  {
    name: '泉佐野市立歴史館いずみさの',
    prefecture: '大阪府',
    city: '泉佐野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.occh.or.jp/?s=event/izumisano/',
    is_featured: false
  },
  {
    name: 'あべのハルカス美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.aham.jp/',
    is_featured: false
  },
  {
    name: '海遊館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.kaiyukan.com/',
    is_featured: false
  },
  {
    name: '大阪国際平和センター（ピースおおさか）',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.peace-osaka.or.jp/',
    is_featured: false
  },
  {
    name: '大阪城天守閣',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osakacastle.net/',
    is_featured: false
  },
  {
    name: '大阪市立住まいのミュージアム（大阪くらしの今昔館）',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osaka-angenet.jp/konjyakukan/',
    is_featured: false
  },
  {
    name: '国立国際美術館',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.nmao.go.jp/',
    is_featured: false
  },
  {
    name: '天王寺動物園',
    prefecture: '大阪府',
    city: '大阪市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tennojizoo.jp/',
    is_featured: false
  },
  {
    name: 'きしわだ自然資料館',
    prefecture: '大阪府',
    city: '岸和田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.city.kishiwada.osaka.jp/site/shizenshi/',
    is_featured: false
  },
  {
    name: '関西大学博物館',
    prefecture: '大阪府',
    city: '吹田市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.kansai-u.ac.jp/Museum/',
    is_featured: false
  },
  {
    name: '高槻市立自然博物館（あくあぴあ芥川）',
    prefecture: '大阪府',
    city: '高槻市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'http://www.aquapia.net/',
    is_featured: false
  },
  {
    name: '大阪大谷大学博物館',
    prefecture: '大阪府',
    city: '富田林市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osaka-ohtani.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '大阪商業大学商業史博物館',
    prefecture: '大阪府',
    city: '東大阪市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://ouc.daishodai.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '大阪芸術大学博物館',
    prefecture: '大阪府',
    city: '南河内郡河南町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.osaka-geidai.ac.jp/guide/museum',
    is_featured: false
  },
  {
    name: '八尾市立歴史民俗資料館',
    prefecture: '大阪府',
    city: '八尾市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://rekimin-yao.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 兵庫県 (48件)
# ================================
puts '兵庫県のデータを投入中...'

[
  {
    name: '芦屋市立美術博物館',
    prefecture: '兵庫県',
    city: '芦屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ashiya-museum.jp/',
    is_featured: false
  },
  {
    name: '滴翠美術館',
    prefecture: '兵庫県',
    city: '芦屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://tekisui-museum.biz-web.jp/',
    is_featured: false
  },
  {
    name: '俵美術館',
    prefecture: '兵庫県',
    city: '芦屋市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tawara-museum.or.jp/',
    is_featured: false
  },
  {
    name: '尼崎市立歴史博物館',
    prefecture: '兵庫県',
    city: '尼崎市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.archives.city.amagasaki.hyogo.jp/museum/',
    is_featured: false
  },
  {
    name: '市立伊丹ミュージアム',
    prefecture: '兵庫県',
    city: '伊丹市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://itami-im.jp/',
    is_featured: false
  },
  {
    name: '兵庫県立考古博物館　兵庫県立考古博物館加西分館（古代鏡展示館）',
    prefecture: '兵庫県',
    city: '加古郡播磨町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.hyogo-koukohaku.jp/',
    is_featured: false
  },
  {
    name: '切手文化博物館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kitte-museum-arima.jp/',
    is_featured: false
  },
  {
    name: '香雪美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kosetsu-museum.or.jp/',
    is_featured: false
  },
  {
    name: '神戸市立小磯記念美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kobe.lg.jp/kanko/bunka/bunkashisetsu/koisogallery/index.html',
    is_featured: false
  },
  {
    name: '神戸市立博物館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kobecitymuseum.jp/',
    is_featured: false
  },
  {
    name: '竹中大工道具館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.dougukan.jp/',
    is_featured: false
  },
  {
    name: '白鶴美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hakutsuru-museum.org/',
    is_featured: false
  },
  {
    name: '兵庫県立美術館',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.artm.pref.hyogo.jp/',
    is_featured: false
  },
  {
    name: '兵庫県立兵庫津ミュージアム',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hyogo-no-tsu.jp',
    is_featured: false
  },
  {
    name: '兵庫県立人と自然の博物館',
    prefecture: '兵庫県',
    city: '三田市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.hitohaku.jp/',
    is_featured: false
  },
  {
    name: '鉄斎美術館',
    prefecture: '兵庫県',
    city: '宝塚市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.kiyoshikojin.or.jp/tessai_museum/',
    is_featured: false
  },
  {
    name: 'たつの市立龍野歴史文化資料館',
    prefecture: '兵庫県',
    city: 'たつの市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tatsuno.lg.jp/kanko-bunka-sports/rekishibunkashiryokan/index.html',
    is_featured: false
  },
  {
    name: '玄武洞ミュージアム',
    prefecture: '兵庫県',
    city: '豊岡市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://genbudo-museum.jp/',
    is_featured: false
  },
  {
    name: '豊岡市立歴史博物館─但馬国府・国分寺館─',
    prefecture: '兵庫県',
    city: '豊岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www3.city.toyooka.lg.jp/kokubunjikan/',
    is_featured: false
  },
  {
    name: '辰馬考古資料館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hakutaka.jp/tatsuuma.html',
    is_featured: false
  },
  {
    name: '公益財団法人　西宮市大谷記念美術館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://otanimuseum.jp/',
    is_featured: false
  },
  {
    name: '西宮市立郷土資料館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nishi.or.jp/bunka/rekishitobunkazai/ritsukyodoshiryokan/index.html',
    is_featured: false
  },
  {
    name: '白鹿記念酒造博物館（酒ミュージアム）',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sake-museum.jp/',
    is_featured: false
  },
  {
    name: '堀江オルゴール博物館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.orgel-horie.or.jp/main/',
    is_featured: false
  },
  {
    name: '武庫川女子大学附属総合ミュージアム',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.mukogawa-u.ac.jp/~museum/',
    is_featured: false
  },
  {
    name: '姫路市立美術館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.himeji.lg.jp/art/',
    is_featured: false
  },
  {
    name: '姫路文学館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.himejibungakukan.jp/',
    is_featured: false
  },
  {
    name: '兵庫県立歴史博物館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://rekihaku.pref.hyogo.lg.jp/',
    is_featured: false
  },
  {
    name: '三木美術館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miki-m.jp',
    is_featured: false
  },
  {
    name: '南あわじ市滝川記念美術館　玉青館',
    prefecture: '兵庫県',
    city: '南あわじ市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.minamiawaji.hyogo.jp/soshiki/gyokuseikan/main.html',
    is_featured: false
  },
  {
    name: '明石市立天文科学館',
    prefecture: '兵庫県',
    city: '明石市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.am12.jp/',
    is_featured: false
  },
  {
    name: '伊丹市昆虫館',
    prefecture: '兵庫県',
    city: '伊丹市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.itakon.com/',
    is_featured: false
  },
  {
    name: '太子町立歴史資料館',
    prefecture: '兵庫県',
    city: '揖保郡太子町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.hyogo-taishi.lg.jp/soshikikarasagasu/rekisisiryo/index.html',
    is_featured: false
  },
  {
    name: '小野市立好古館',
    prefecture: '兵庫県',
    city: '小野市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.ono.hyogo.jp/soshikikarasagasu/kokokan/index.html',
    is_featured: false
  },
  {
    name: '大阪青山歴史文学博物館',
    prefecture: '兵庫県',
    city: '川西市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.osaka-aoyama.ac.jp/facility/museum/',
    is_featured: false
  },
  {
    name: 'ROKKO森の音ミュージアム',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.rokkosan.com/museum/',
    is_featured: false
  },
  {
    name: '神戸市立王子動物園',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://www.kobe-ojizoo.jp/',
    is_featured: false
  },
  {
    name: '神戸市立森林植物園',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.kobe-park.or.jp/shinrin/',
    is_featured: false
  },
  {
    name: '六甲高山植物園',
    prefecture: '兵庫県',
    city: '神戸市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.rokkosan.com/hana/',
    is_featured: false
  },
  {
    name: '兵庫陶芸美術館',
    prefecture: '兵庫県',
    city: '丹波篠山市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.mcart.jp/',
    is_featured: false
  },
  {
    name: '城崎マリンワールド',
    prefecture: '兵庫県',
    city: '豊岡市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://marineworld.hiyoriyama.co.jp/',
    is_featured: false
  },
  {
    name: '関西学院大学博物館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.kwansei.ac.jp/museum',
    is_featured: false
  },
  {
    name: '西宮市貝類館',
    prefecture: '兵庫県',
    city: '西宮市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.nishi.or.jp/bunka/bunka/kairuikan/index.html',
    is_featured: false
  },
  {
    name: '日本玩具博物館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://japan-toy-museum.org/',
    is_featured: false
  },
  {
    name: '姫路科学館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.city.himeji.lg.jp/atom/',
    is_featured: false
  },
  {
    name: '姫路市立水族館',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.city.himeji.lg.jp/aqua/',
    is_featured: false
  },
  {
    name: '姫路市立動物園',
    prefecture: '兵庫県',
    city: '姫路市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.himeji.lg.jp/dobutuen/',
    is_featured: false
  },
  {
    name: '但馬牛博物館',
    prefecture: '兵庫県',
    city: '美方郡新温泉町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tajimabokujyo.jp/?page_id=3',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 奈良県 (22件)
# ================================
puts '奈良県のデータを投入中...'

[
  {
    name: '大亀和尚民芸館',
    prefecture: '奈良県',
    city: '宇陀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://daiki-mingeikan.or.jp/',
    is_featured: false
  },
  {
    name: '香芝市二上山博物館',
    prefecture: '奈良県',
    city: '香芝市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kashiba.lg.jp/life/6/39/',
    is_featured: false
  },
  {
    name: '橿原市昆虫館',
    prefecture: '奈良県',
    city: '橿原市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.kashihara.nara.jp/kanko_bunka_sports/konchukan/index.html',
    is_featured: false
  },
  {
    name: '奈良県立橿原考古学研究所附属博物館',
    prefecture: '奈良県',
    city: '橿原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kashikoken.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '歴史に憩う橿原市博物館',
    prefecture: '奈良県',
    city: '橿原市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kashihara.nara.jp/soshiki/1059/gyomu/4/2415.html',
    is_featured: false
  },
  {
    name: '葛城市歴史博物館',
    prefecture: '奈良県',
    city: '葛城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.katsuragi.nara.jp/soshiki/rekishihakubutsukan/4/1121.html',
    is_featured: false
  },
  {
    name: '市立五條文化博物館',
    prefecture: '奈良県',
    city: '五條市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.gojo.lg.jp/soshiki/bunka/1/1/1233.html',
    is_featured: false
  },
  {
    name: '水平社博物館',
    prefecture: '奈良県',
    city: '御所市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www1.mahoroba.ne.jp/~suihei/',
    is_featured: false
  },
  {
    name: '喜多美術館',
    prefecture: '奈良県',
    city: '桜井市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kitamuseum.my.canva.site',
    is_featured: false
  },
  {
    name: '春日大社　萬葉植物園（神苑）',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '植物園',
    official_website: 'https://www.kasugataisha.or.jp/manyou-s/',
    is_featured: false
  },
  {
    name: '春日大社国宝殿',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kasugataisha.or.jp/museum/',
    is_featured: false
  },
  {
    name: '中野美術館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nakano-museum.jp/',
    is_featured: false
  },
  {
    name: '松伯美術館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kintetsu-g-hd.co.jp/culture/shohaku/',
    is_featured: false
  },
  {
    name: '寧楽美術館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://isuien.or.jp/museum',
    is_featured: false
  },
  {
    name: '法隆寺大宝蔵殿',
    prefecture: '奈良県',
    city: '生駒郡斑鳩町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.horyuji.or.jp/garan/daihozoin/',
    is_featured: false
  },
  {
    name: '高松塚壁画館',
    prefecture: '奈良県',
    city: '高市郡明日香村',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.asukabito.or.jp/hekigakan.html',
    is_featured: false
  },
  {
    name: '奈良文化財研究所　飛鳥資料館',
    prefecture: '奈良県',
    city: '高市郡明日香村',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.nabunken.go.jp/asuka/',
    is_featured: false
  },
  {
    name: '天理大学附属天理参考館',
    prefecture: '奈良県',
    city: '天理市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.sankokan.jp/',
    is_featured: false
  },
  {
    name: '帝塚山大学附属博物館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.tezukayama-u.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '奈良国立博物館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.narahaku.go.jp/',
    is_featured: false
  },
  {
    name: '奈良大学博物館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.nara-u.ac.jp/facilities/museum/',
    is_featured: false
  },
  {
    name: '大和文華館',
    prefecture: '奈良県',
    city: '奈良市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kintetsu-g-hd.co.jp/culture/yamato/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 和歌山県 (15件)
# ================================
puts '和歌山県のデータを投入中...'

[
  {
    name: '有田市郷土資料館',
    prefecture: '和歌山県',
    city: '有田市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.arida.lg.jp/shisetsu/bunkashakaikyoiku/1001521.html',
    is_featured: false
  },
  {
    name: 'レプリカをつくる博物館',
    prefecture: '和歌山県',
    city: '海草郡紀美野町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://amphillc.com/',
    is_featured: false
  },
  {
    name: '藤白王子跡ミュージアム',
    prefecture: '和歌山県',
    city: '海南市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fujishiro-jinja.net/',
    is_featured: false
  },
  {
    name: '和歌山県立自然博物館',
    prefecture: '和歌山県',
    city: '海南市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.shizenhaku.wakayama-c.ed.jp/',
    is_featured: false
  },
  {
    name: '太地町立くじらの博物館',
    prefecture: '和歌山県',
    city: '東牟婁郡太地町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.kujirakan.jp/',
    is_featured: false
  },
  {
    name: '和歌山県立紀伊風土記の丘',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kiifudoki.wakayama-c.ed.jp/',
    is_featured: false
  },
  {
    name: '和歌山県立近代美術館',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.momaw.jp/',
    is_featured: false
  },
  {
    name: '和歌山県立博物館',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://hakubutu.wakayama.jp/',
    is_featured: false
  },
  {
    name: '和歌山市立博物館',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.wakayama-city-museum.jp/',
    is_featured: false
  },
  {
    name: '高野山霊宝館',
    prefecture: '和歌山県',
    city: '伊都郡高野町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.reihokan.or.jp/',
    is_featured: false
  },
  {
    name: '熊野神宝館',
    prefecture: '和歌山県',
    city: '新宮市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kumanohayatama.jp/?page_id=14',
    is_featured: false
  },
  {
    name: 'アドベンチャーワールド',
    prefecture: '和歌山県',
    city: '西牟婁郡白浜町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.aws-s.com/',
    is_featured: false
  },
  {
    name: '京都大学フィールド科学教育研究センター瀬戸臨海実験所水族館（京都大学白浜水族館）',
    prefecture: '和歌山県',
    city: '西牟婁郡白浜町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.seto.kyoto-u.ac.jp/shirahama_aqua/',
    is_featured: false
  },
  {
    name: '串本海中公園センター水族館',
    prefecture: '和歌山県',
    city: '東牟婁郡串本町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.kushimoto.co.jp/',
    is_featured: false
  },
  {
    name: '和歌山大学紀州経済史文化史研究所',
    prefecture: '和歌山県',
    city: '和歌山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.wakayama-u.ac.jp/kisyuken/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 鳥取県 (9件)
# ================================
puts '鳥取県のデータを投入中...'

[
  {
    name: '倉吉博物館・倉吉歴史民俗資料館',
    prefecture: '鳥取県',
    city: '倉吉市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.kurayoshi.lg.jp/kurahaku/',
    is_featured: false
  },
  {
    name: '鳥取県立博物館',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.pref.tottori.lg.jp/museum/',
    is_featured: false
  },
  {
    name: '鳥取市こども科学館',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://tottori-shinkoukai.or.jp/kodomokagaku/',
    is_featured: false
  },
  {
    name: '鳥取市さじアストロパーク',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.tottori.lg.jp/www/contents/1425466200201/',
    is_featured: false
  },
  {
    name: '鳥取市歴史博物館（やまびこ館）',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tbz.or.jp/yamabikokan/',
    is_featured: false
  },
  {
    name: '鳥取民藝美術舘',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://mingei.exblog.jp/',
    is_featured: false
  },
  {
    name: '渡辺美術館',
    prefecture: '鳥取県',
    city: '鳥取市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://watart.jp/',
    is_featured: false
  },
  {
    name: '米子市美術館',
    prefecture: '鳥取県',
    city: '米子市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.yonagobunka.net/y-moa/',
    is_featured: false
  },
  {
    name: '米子市立山陰歴史館',
    prefecture: '鳥取県',
    city: '米子市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.yonagobunka.net/rekishi/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 島根県 (25件)
# ================================
puts '島根県のデータを投入中...'

[
  {
    name: '出雲市立平田本陣記念館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.izumo-zaidan.jp/honjin/',
    is_featured: false
  },
  {
    name: '出雲文化伝承館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.izumo-zaidan.jp/izumodenshokan/',
    is_featured: false
  },
  {
    name: '出雲弥生の森博物館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.izumo.shimane.jp/www/contents/1244161923233/index.html',
    is_featured: false
  },
  {
    name: '今岡美術館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.imaoka-museum.jp/',
    is_featured: false
  },
  {
    name: '島根県立古代出雲歴史博物館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.izm.ed.jp/',
    is_featured: false
  },
  {
    name: '手錢美術館',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tezenmuseum.com/',
    is_featured: false
  },
  {
    name: '公益財団法人亀井温故館',
    prefecture: '島根県',
    city: '鹿足郡津和野町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kamei-onkokan.jp/page001/entrance.html',
    is_featured: false
  },
  {
    name: '絲原記念館',
    prefecture: '島根県',
    city: '仁多郡奥出雲町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://itoharas.com/',
    is_featured: false
  },
  {
    name: '奥出雲多根自然博物館',
    prefecture: '島根県',
    city: '仁多郡奥出雲町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://tanemuseum.jp/',
    is_featured: false
  },
  {
    name: '可部屋集成館',
    prefecture: '島根県',
    city: '仁多郡奥出雲町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://kabeya-syuseikan.com/',
    is_featured: false
  },
  {
    name: '石見安達美術館',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www2.crosstalk.or.jp/shinmachi/a8/',
    is_featured: false
  },
  {
    name: '浜田市世界こども美術館創作活動館',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hamada-kodomo-art.com/',
    is_featured: false
  },
  {
    name: '浜田市立石正美術館',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.sekisho-art-museum.jp/',
    is_featured: false
  },
  {
    name: '島根県立石見美術館',
    prefecture: '島根県',
    city: '益田市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.grandtoit.jp/museum/',
    is_featured: false
  },
  {
    name: '安部榮四郎記念館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://izumomingeishi.com/abeeishirou/',
    is_featured: false
  },
  {
    name: '島根県立美術館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.shimane-art-museum.jp/',
    is_featured: false
  },
  {
    name: '田部美術館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.tanabe-museum.or.jp/',
    is_featured: false
  },
  {
    name: '松江歴史館',
    prefecture: '島根県',
    city: '松江市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://matsu-reki.jp/',
    is_featured: false
  },
  {
    name: '足立美術館',
    prefecture: '島根県',
    city: '安来市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.adachi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '安来市加納美術館',
    prefecture: '島根県',
    city: '安来市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.art-kano.jp/',
    is_featured: false
  },
  {
    name: '和鋼博物館',
    prefecture: '島根県',
    city: '安来市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://wako-museum.jp/',
    is_featured: false
  },
  {
    name: '出雲大社宝物殿',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://izumooyashiro.or.jp/precinct/keidai-index/shinkoden',
    is_featured: false
  },
  {
    name: '島根県立宍道湖自然館（ゴビウス）',
    prefecture: '島根県',
    city: '出雲市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.gobius.jp/',
    is_featured: false
  },
  {
    name: '島根県立三瓶自然館',
    prefecture: '島根県',
    city: '大田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.nature-sanbe.jp/sahimel/',
    is_featured: false
  },
  {
    name: '島根県立しまね海洋館（アクアス）',
    prefecture: '島根県',
    city: '浜田市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://aquas.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 岡山県 (33件)
# ================================
puts '岡山県のデータを投入中...'

[
  {
    name: '井原市立平櫛田中美術館',
    prefecture: '岡山県',
    city: '井原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.ibara.okayama.jp/site/denchu-museum/',
    is_featured: false
  },
  {
    name: '華鴒大塚美術館',
    prefecture: '岡山県',
    city: '井原市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hanatori-museum.jp/',
    is_featured: false
  },
  {
    name: '池田動物園',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '動物園',
    official_website: 'https://ikedazoo.jp',
    is_featured: false
  },
  {
    name: '犬島精錬所美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://benesse-artsite.jp/art/seirensho.html',
    is_featured: false
  },
  {
    name: '岡山県立博物館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.okayama.jp/site/kenhaku/',
    is_featured: false
  },
  {
    name: '岡山県立美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://okayama-kenbi.info/',
    is_featured: false
  },
  {
    name: '岡山シティミュージアム',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.okayama.jp/okayama-city-museum/',
    is_featured: false
  },
  {
    name: '岡山市立オリエント美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.okayama.jp/orientmuseum/',
    is_featured: false
  },
  {
    name: '公益財団法人吉備路文学館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kibiji.or.jp/',
    is_featured: false
  },
  {
    name: '林原美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.hayashibara-museumofart.jp/',
    is_featured: false
  },
  {
    name: '夢二郷土美術館',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yumeji-art-museum.com/',
    is_featured: false
  },
  {
    name: 'やかげ郷土美術館',
    prefecture: '岡山県',
    city: '小田郡矢掛町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://museum.yakage-kyouiku.info/',
    is_featured: false
  },
  {
    name: '笠岡市立竹喬美術館',
    prefecture: '岡山県',
    city: '笠岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kasaoka.okayama.jp/site/museum/',
    is_featured: false
  },
  {
    name: '奈義町現代美術館',
    prefecture: '岡山県',
    city: '勝田郡奈義町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.nagi.okayama.jp/moca/',
    is_featured: false
  },
  {
    name: '大原美術館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ohara.or.jp/',
    is_featured: false
  },
  {
    name: '倉敷科学センター',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://kurakagaku.jp/',
    is_featured: false
  },
  {
    name: '倉敷考古館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.kurashikikoukokan.com/',
    is_featured: false
  },
  {
    name: '倉敷市立自然史博物館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.kurashiki.okayama.jp/musnat/',
    is_featured: false
  },
  {
    name: '倉敷市立美術館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.kurashiki.okayama.jp/kcam/',
    is_featured: false
  },
  {
    name: '倉敷民藝館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://kurashiki-mingeikan.com/',
    is_featured: false
  },
  {
    name: '野﨑家塩業歴史館',
    prefecture: '岡山県',
    city: '倉敷市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nozakike.or.jp/',
    is_featured: false
  },
  {
    name: '瀬戸内市立美術館',
    prefecture: '岡山県',
    city: '瀬戸内市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.setouchi.lg.jp/site/museum/',
    is_featured: false
  },
  {
    name: '備前長船刀剣博物館',
    prefecture: '岡山県',
    city: '瀬戸内市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.setouchi.lg.jp/site/token/',
    is_featured: false
  },
  {
    name: '高梁市成羽美術館',
    prefecture: '岡山県',
    city: '高梁市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nariwa-museum.or.jp/',
    is_featured: false
  },
  {
    name: '高梁市歴史美術館',
    prefecture: '岡山県',
    city: '高梁市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takahashi.lg.jp/site/takahashi-historical-museum/',
    is_featured: false
  },
  {
    name: '市立玉野海洋博物館',
    prefecture: '岡山県',
    city: '玉野市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.city.tamano.lg.jp/site/kaihaku/',
    is_featured: false
  },
  {
    name: '津山郷土博物館',
    prefecture: '岡山県',
    city: '津山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.tsu-haku.jp/',
    is_featured: false
  },
  {
    name: 'つやま自然のふしぎ館（津山科学教育博物館）',
    prefecture: '岡山県',
    city: '津山市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.fushigikan.jp/',
    is_featured: false
  },
  {
    name: '津山洋学資料館',
    prefecture: '岡山県',
    city: '津山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tsuyama-yougaku.jp/',
    is_featured: false
  },
  {
    name: '新見美術館',
    prefecture: '岡山県',
    city: '新見市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://niimi-museum.or.jp/',
    is_featured: false
  },
  {
    name: 'BIZEN中南米美術館',
    prefecture: '岡山県',
    city: '備前市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.latinamerica.jp/',
    is_featured: false
  },
  {
    name: '岡山天文博物館',
    prefecture: '岡山県',
    city: '浅口市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://ww1.city.asakuchi.okayama.jp/museum/',
    is_featured: false
  },
  {
    name: '岡山市半田山植物園',
    prefecture: '岡山県',
    city: '岡山市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.okayama-park.or.jp/handayama/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 広島県 (37件)
# ================================
puts '広島県のデータを投入中...'

[
  {
    name: '筆の里工房',
    prefecture: '広島県',
    city: '安芸郡熊野町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fude.or.jp/jp/',
    is_featured: false
  },
  {
    name: '安芸高田市歴史民俗博物館',
    prefecture: '広島県',
    city: '安芸高田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.akitakata.jp/ja/hakubutsukan/',
    is_featured: false
  },
  {
    name: '下瀬美術館',
    prefecture: '広島県',
    city: '大竹市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.simose-museum.jp/',
    is_featured: false
  },
  {
    name: '尾道市立美術館',
    prefecture: '広島県',
    city: '尾道市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.onomichi-museum.jp/',
    is_featured: false
  },
  {
    name: '耕三寺博物館',
    prefecture: '広島県',
    city: '尾道市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kousanji.or.jp/',
    is_featured: false
  },
  {
    name: '平山郁夫美術館',
    prefecture: '広島県',
    city: '尾道市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hirayama-museum.or.jp/',
    is_featured: false
  },
  {
    name: '呉市立美術館',
    prefecture: '広島県',
    city: '呉市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kure-bi.jp/',
    is_featured: false
  },
  {
    name: '庄原市帝釈峡博物展示施設　時悠館',
    prefecture: '広島県',
    city: '庄原市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.shobara.hiroshima.jp/main/education/shisetsu/cat01/cat/index.html',
    is_featured: false
  },
  {
    name: '庄原市立比和自然科学博物館',
    prefecture: '広島県',
    city: '庄原市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.city.shobara.hiroshima.jp/main/education/shisetsu/cat01/01/',
    is_featured: false
  },
  {
    name: '厳島神社宝物館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: '',
    is_featured: false
  },
  {
    name: '公益財団法人ウッドワン美術館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.woodone-museum.jp/',
    is_featured: false
  },
  {
    name: '海の見える杜美術館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.umam.jp/',
    is_featured: false
  },
  {
    name: '仙石庭園庭石ミュージアム',
    prefecture: '広島県',
    city: '東広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://senseki.org/',
    is_featured: false
  },
  {
    name: '東広島市立美術館',
    prefecture: '広島県',
    city: '東広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://hhmoa.jp/',
    is_featured: false
  },
  {
    name: '泉美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.izumi-museum.jp/',
    is_featured: false
  },
  {
    name: '広島県立美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hpam.jp/',
    is_featured: false
  },
  {
    name: '広島市江波山気象館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.ebayama.jp/',
    is_featured: false
  },
  {
    name: '広島市郷土資料館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.cf.city.hiroshima.jp/kyodo/',
    is_featured: false
  },
  {
    name: '広島市交通科学館（ヌマジ交通ミュージアム）',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.vehicle.city.hiroshima.jp/',
    is_featured: false
  },
  {
    name: '広島市こども文化科学館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.pyonta.city.hiroshima.jp/',
    is_featured: false
  },
  {
    name: 'ひろしま美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.hiroshima-museum.jp/',
    is_featured: false
  },
  {
    name: '頼山陽史跡資料館（広島県立歴史博物館分館）',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.hiroshima.lg.jp/site/raisanyou/',
    is_featured: false
  },
  {
    name: 'しぶや美術館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://vessel-group.co.jp/shibuya-museum/',
    is_featured: false
  },
  {
    name: '広島県立歴史博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.hiroshima.lg.jp/site/rekishih/',
    is_featured: false
  },
  {
    name: '福山市しんいち歴史民俗博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.fukuyama.hiroshima.jp/soshiki/shinichi-rekimin/',
    is_featured: false
  },
  {
    name: '福山自動車時計博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.facm.net/',
    is_featured: false
  },
  {
    name: '福山市立福山城博物館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://fukuyamajo.jp/',
    is_featured: false
  },
  {
    name: 'ふくやま美術館',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.fukuyama.hiroshima.jp/site/fukuyama-museum/',
    is_featured: false
  },
  {
    name: '広島県立歴史民俗資料館',
    prefecture: '広島県',
    city: '三次市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.hiroshima.lg.jp/site/rekimin/',
    is_featured: false
  },
  {
    name: 'アートギャラリーミヤウチ',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://miyauchiaf.or.jp/',
    is_featured: false
  },
  {
    name: '宮島水族館',
    prefecture: '広島県',
    city: '廿日市市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.miyajima-aqua.jp/',
    is_featured: false
  },
  {
    name: '広島大学総合博物館',
    prefecture: '広島県',
    city: '東広島市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.digital-museum.hiroshima-u.ac.jp/~humuseum/',
    is_featured: false
  },
  {
    name: '広島市安佐動物公園',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://www.asazoo.jp/',
    is_featured: false
  },
  {
    name: '広島市現代美術館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.hiroshima-moca.jp/',
    is_featured: false
  },
  {
    name: '広島城',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.rijo-castle.jp/',
    is_featured: false
  },
  {
    name: '広島市立大学芸術資料館',
    prefecture: '広島県',
    city: '広島市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://museum.hiroshima-cu.ac.jp/index.cgi/ja',
    is_featured: false
  },
  {
    name: '福山市立動物園',
    prefecture: '広島県',
    city: '福山市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.fukuyamazoo.jp/index.php',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 山口県 (23件)
# ================================
puts '山口県のデータを投入中...'

[
  {
    name: '岩国徴古館',
    prefecture: '山口県',
    city: '岩国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.iwakuni.lg.jp/site/chokokan/',
    is_featured: false
  },
  {
    name: '柏原美術館',
    prefecture: '山口県',
    city: '岩国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kashiwabara-museum.jp/',
    is_featured: false
  },
  {
    name: '吉川報こう会　吉川史料館',
    prefecture: '山口県',
    city: '岩国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kikkawa7.or.jp/',
    is_featured: false
  },
  {
    name: '宇部市学びの森くすのき',
    prefecture: '山口県',
    city: '宇部市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.ube.yamaguchi.jp/koukyouannai/shisetsu_kyouiku/1009905.html',
    is_featured: false
  },
  {
    name: '下関市立考古博物館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shimo-kouko.jp/',
    is_featured: false
  },
  {
    name: '下関市立美術館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.shimonoseki.lg.jp/site/art/',
    is_featured: false
  },
  {
    name: '下関市立歴史博物館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.shimohaku.jp/',
    is_featured: false
  },
  {
    name: '周南市美術博物館',
    prefecture: '山口県',
    city: '周南市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://s-bunka.jp/bihaku/',
    is_featured: false
  },
  {
    name: '熊谷美術館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kumaya.art/',
    is_featured: false
  },
  {
    name: '萩陶芸美術館　吉賀大眉記念館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.taibi-hagi.jp/',
    is_featured: false
  },
  {
    name: '萩博物館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://hagimuseum.jp/',
    is_featured: false
  },
  {
    name: '防府市青少年科学館',
    prefecture: '山口県',
    city: '防府市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://solar-hofu.com',
    is_featured: false
  },
  {
    name: '毛利博物館',
    prefecture: '山口県',
    city: '防府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.c-able.ne.jp/~mouri-m/',
    is_featured: false
  },
  {
    name: '美祢市立秋吉台科学博物館',
    prefecture: '山口県',
    city: '美祢市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://akihaku.jimdofree.com/',
    is_featured: false
  },
  {
    name: 'のむら美術館',
    prefecture: '山口県',
    city: '山口市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yamaguchi-tourism.jp/spot/detail_12223.html',
    is_featured: false
  },
  {
    name: '山口県立山口博物館',
    prefecture: '山口県',
    city: '山口市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.yamahaku.pref.yamaguchi.lg.jp/',
    is_featured: false
  },
  {
    name: '緑と花と彫刻の博物館',
    prefecture: '山口県',
    city: '宇部市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.tokiwapark.jp/museum/',
    is_featured: false
  },
  {
    name: '下関市立しものせき水族館海響館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'http://www.kaikyokan.com/',
    is_featured: false
  },
  {
    name: '梅光学院大学博物館',
    prefecture: '山口県',
    city: '下関市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '周南市徳山動物園',
    prefecture: '山口県',
    city: '周南市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://tokuyama-zoo.jp/',
    is_featured: false
  },
  {
    name: '山口県立萩美術館・浦上記念館',
    prefecture: '山口県',
    city: '萩市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://hum-web.jp/',
    is_featured: false
  },
  {
    name: '秋吉台自然動物公園',
    prefecture: '山口県',
    city: '美祢市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.safariland.jp/',
    is_featured: false
  },
  {
    name: '山口県立美術館',
    prefecture: '山口県',
    city: '山口市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://y-pam.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 徳島県 (11件)
# ================================
puts '徳島県のデータを投入中...'

[
  {
    name: '松茂町歴史民俗資料館・人形浄瑠璃芝居資料館',
    prefecture: '徳島県',
    city: '板野郡松茂町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://joruri.jp/',
    is_featured: false
  },
  {
    name: '三木文庫',
    prefecture: '徳島県',
    city: '板野郡松茂町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.mikibunko.jp/',
    is_featured: false
  },
  {
    name: '徳島県立近代美術館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://art.bunmori.tokushima.jp/',
    is_featured: false
  },
  {
    name: '徳島県立鳥居龍蔵記念博物館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://torii-museum.bunmori.tokushima.jp/default.htm',
    is_featured: false
  },
  {
    name: '徳島県立博物館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://museum.bunmori.tokushima.jp/',
    is_featured: false
  },
  {
    name: '徳島市立考古資料館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tokushima-kouko.jp/',
    is_featured: false
  },
  {
    name: '徳島市立徳島城博物館',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tokushima.tokushima.jp/johaku/',
    is_featured: false
  },
  {
    name: '大塚国際美術館',
    prefecture: '徳島県',
    city: '鳴門市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://o-museum.or.jp/',
    is_featured: false
  },
  {
    name: '美波町日和佐うみがめ博物館',
    prefecture: '徳島県',
    city: '海部郡美波町',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://caretta.town.minami.lg.jp/',
    is_featured: false
  },
  {
    name: 'とくしま動物園',
    prefecture: '徳島県',
    city: '徳島市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://tokushimazoo.jp/',
    is_featured: false
  },
  {
    name: '阿波和紙伝統産業会館',
    prefecture: '徳島県',
    city: '吉野川市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'http://www.awagami.or.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 香川県 (17件)
# ================================
puts '香川県のデータを投入中...'

[
  {
    name: '地中美術館',
    prefecture: '香川県',
    city: '香川郡直島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://benesse-artsite.jp/art/chichu.html',
    is_featured: false
  },
  {
    name: '李禹煥美術館',
    prefecture: '香川県',
    city: '香川郡直島町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://benesse-artsite.jp/art/lee-ufan.html',
    is_featured: false
  },
  {
    name: '鎌田共済会郷土博物館',
    prefecture: '香川県',
    city: '坂出市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kamahaku.jp/',
    is_featured: false
  },
  {
    name: 'イサム・ノグチ庭園美術館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.isamunoguchi.or.jp/',
    is_featured: false
  },
  {
    name: '香川県立ミュージアム',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.kagawa.lg.jp/kmuseum/kmuseum/index.html',
    is_featured: false
  },
  {
    name: '四国民家博物館（四国村ミウゼアム）',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '野外博物館',
    official_website: 'https://www.shikokumura.or.jp/',
    is_featured: false
  },
  {
    name: '高松市石の民俗資料館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.takamatsu.kagawa.jp/kurashi/kosodate/bunka/ishimin/index.html',
    is_featured: false
  },
  {
    name: '高松市美術館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.takamatsu.kagawa.jp/museum/takamatsu/',
    is_featured: false
  },
  {
    name: 'ナガレスタジオ「流政之美術館」',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nagarestudio.jp/#1',
    is_featured: false
  },
  {
    name: '美術館「川島猛アートファクトリー」',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kawashima-af.com/',
    is_featured: false
  },
  {
    name: '琴平海洋博物館',
    prefecture: '香川県',
    city: '仲多度郡琴平町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kotohira.kaiyohakubutukan.or.jp/',
    is_featured: false
  },
  {
    name: '金刀比羅宮博物館',
    prefecture: '香川県',
    city: '仲多度郡琴平町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'http://www.konpira.or.jp/',
    is_featured: false
  },
  {
    name: '四国水族館',
    prefecture: '香川県',
    city: '綾歌郡宇多津町',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://shikoku-aquarium.jp/',
    is_featured: false
  },
  {
    name: '池川彫刻美術館',
    prefecture: '香川県',
    city: '木田郡三木町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.ikegawa-museum.or.jp',
    is_featured: false
  },
  {
    name: '香川大学博物館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.museum.kagawa-u.ac.jp',
    is_featured: false
  },
  {
    name: '新屋島水族館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://r.goope.jp/new-yashima-aq',
    is_featured: false
  },
  {
    name: '高松市歴史資料館',
    prefecture: '香川県',
    city: '高松市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.city.takamatsu.kagawa.jp/kurashi/kosodate/bunka/rekishi/index.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 愛媛県 (24件)
# ================================
puts '愛媛県のデータを投入中...'

[
  {
    name: '今治市大三島美術館本館　今治市大三島美術館別館　今治市　岩田健　母と子のミュージアム　今治市大三島美術館別館　ところミュージアム大三島',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.imabari.ehime.jp/museum/omishima/',
    is_featured: false
  },
  {
    name: '今治市村上海賊ミュージアム',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.imabari.ehime.jp/museum/suigun/',
    is_featured: false
  },
  {
    name: '愛媛文華館',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ehimebunkakan.jp/',
    is_featured: false
  },
  {
    name: '大三島海事博物館',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.imabari.ehime.jp/kanko/spot/?a=242',
    is_featured: false
  },
  {
    name: '大山祇神社宝物館',
    prefecture: '愛媛県',
    city: '今治市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://oomishimagu.jp/treasure/',
    is_featured: false
  },
  {
    name: '宇和島市立伊達博物館',
    prefecture: '愛媛県',
    city: '宇和島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.uwajima.ehime.jp/site/datehaku-top/',
    is_featured: false
  },
  {
    name: '大洲市立博物館',
    prefecture: '愛媛県',
    city: '大洲市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.ozu-museum.com/',
    is_featured: false
  },
  {
    name: '四国中央市歴史考古博物館―高原ミュージアム―',
    prefecture: '愛媛県',
    city: '四国中央市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kaminomachi.or.jp/facility/museum/',
    is_featured: false
  },
  {
    name: '愛媛県歴史文化博物館',
    prefecture: '愛媛県',
    city: '西予市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.i-rekihaku.jp/',
    is_featured: false
  },
  {
    name: '愛媛民芸館',
    prefecture: '愛媛県',
    city: '西条市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ehimemingeikan.jp/',
    is_featured: false
  },
  {
    name: '東温市立歴史民俗資料館',
    prefecture: '愛媛県',
    city: '東温市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.toon.ehime.jp/soshiki/23/2431.html',
    is_featured: false
  },
  {
    name: '愛媛県総合科学博物館',
    prefecture: '愛媛県',
    city: '新居浜市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.i-kahaku.jp/',
    is_featured: false
  },
  {
    name: '新居浜市美術館',
    prefecture: '愛媛県',
    city: '新居浜市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.niihama.lg.jp/soshiki/bijutu/',
    is_featured: false
  },
  {
    name: '伊方町文化交流施設　佐田岬半島ミュージアム',
    prefecture: '愛媛県',
    city: '西宇和郡伊方町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://sadamisakihanto-museum.jp/',
    is_featured: false
  },
  {
    name: '伊丹十三記念館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://itami-kinenkan.jp/',
    is_featured: false
  },
  {
    name: '愛媛県美術館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ehime-art.jp/',
    is_featured: false
  },
  {
    name: '松山市考古館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.cul-spo.or.jp/koukokan/',
    is_featured: false
  },
  {
    name: '松山市立子規記念博物館',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shiki-museum.com/',
    is_featured: false
  },
  {
    name: '愛媛県立とべ動物園',
    prefecture: '愛媛県',
    city: '伊予郡砥部町',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.tobezoo.com/',
    is_featured: false
  },
  {
    name: '久万高原町立久万美術館',
    prefecture: '愛媛県',
    city: '上浮穴郡久万高原町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kumakogen.jp/site/muse/',
    is_featured: false
  },
  {
    name: '西条市立西条郷土博物館',
    prefecture: '愛媛県',
    city: '西条市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.saijo-museum.com/',
    is_featured: false
  },
  {
    name: '高畠華宵大正ロマン館',
    prefecture: '愛媛県',
    city: '東温市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kashomuseum.org/',
    is_featured: false
  },
  {
    name: '新居浜市広瀬歴史記念館',
    prefecture: '愛媛県',
    city: '新居浜市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.niihama.lg.jp/soshiki/hirose/',
    is_featured: false
  },
  {
    name: '松山市坂の上の雲ミュージアム',
    prefecture: '愛媛県',
    city: '松山市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.sakanouenokumomuseum.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 高知県 (17件)
# ================================
puts '高知県のデータを投入中...'

[
  {
    name: '安芸市立書道美術館',
    prefecture: '高知県',
    city: '安芸市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.aki.kochi.jp/life/dtl.php?hdnKey=49',
    is_featured: false
  },
  {
    name: '桂浜水族館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://katurahama-aq.jp/',
    is_featured: false
  },
  {
    name: '高知県立美術館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://moak.jp/',
    is_featured: false
  },
  {
    name: '佐川町立青山文庫',
    prefecture: '高知県',
    city: '高岡郡佐川町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://seizanbunko.com/',
    is_featured: false
  },
  {
    name: '高知県立歴史民俗資料館',
    prefecture: '高知県',
    city: '南国市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kochi-rekimin.jp/index.html',
    is_featured: false
  },
  {
    name: 'むろと廃校水族館（むろと海の学校）',
    prefecture: '高知県',
    city: '室戸市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://www.city.muroto.kochi.jp/pages/page0343.php',
    is_featured: false
  },
  {
    name: '安芸市立歴史民俗資料館',
    prefecture: '高知県',
    city: '安芸市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.aki.kochi.jp/rekimin/',
    is_featured: false
  },
  {
    name: '香美市立美術館',
    prefecture: '高知県',
    city: '香美市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kami.lg.jp/site/bijutukan/',
    is_featured: false
  },
  {
    name: '香美市立やなせたかし記念館アンパンマンミュージアム',
    prefecture: '高知県',
    city: '香美市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://anpanman-museum.net/',
    is_featured: false
  },
  {
    name: '高知県立高知城歴史博物館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kochi-johaku.jp/',
    is_featured: false
  },
  {
    name: '高知県立坂本龍馬記念館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://ryoma-kinenkan.jp/',
    is_featured: false
  },
  {
    name: '高知県立牧野植物園',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '植物園',
    official_website: 'https://www.makino.or.jp/',
    is_featured: false
  },
  {
    name: '高知市立自由民権記念館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.i-minken.jp/',
    is_featured: false
  },
  {
    name: '横山隆一記念まんが館',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.kfca.jp/mangakan/',
    is_featured: false
  },
  {
    name: 'わんぱーくこうちアニマルランド',
    prefecture: '高知県',
    city: '高知市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.city.kochi.kochi.jp/deeps/17/1712/animal/',
    is_featured: false
  },
  {
    name: '高知県立のいち動物公園',
    prefecture: '高知県',
    city: '香南市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://noichizoo.or.jp/',
    is_featured: false
  },
  {
    name: '宿毛市立宿毛歴史館',
    prefecture: '高知県',
    city: '宿毛市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city.sukumo.kochi.jp/docs-26/p010804.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 福岡県 (36件)
# ================================
puts '福岡県のデータを投入中...'

[
  {
    name: '朝倉市秋月博物館',
    prefecture: '福岡県',
    city: '朝倉市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.asakura.lg.jp/www/contents/1398210163709/index.html',
    is_featured: false
  },
  {
    name: '糸島市立伊都国歴史博物館',
    prefecture: '福岡県',
    city: '糸島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.itoshima.lg.jp/m043/010/index.html',
    is_featured: false
  },
  {
    name: '古賀政男音楽博物館分館　古賀政男記念館',
    prefecture: '福岡県',
    city: '大川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.okawa.lg.jp/090/050/010/',
    is_featured: false
  },
  {
    name: '大野城心のふるさと館',
    prefecture: '福岡県',
    city: '大野城市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.onojo-occm.jp',
    is_featured: false
  },
  {
    name: '九州歴史資料館',
    prefecture: '福岡県',
    city: '小郡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kyureki.jp/',
    is_featured: false
  },
  {
    name: '出光美術館（門司）',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://s-idemitsu-mm.or.jp/',
    is_featured: false
  },
  {
    name: '北九州市平和のまちミュージアム',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kitakyushu-peacemuseum.jp/',
    is_featured: false
  },
  {
    name: '北九州市漫画ミュージアム',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.ktqmm.jp/',
    is_featured: false
  },
  {
    name: '北九州市立自然史・歴史博物館（いのちのたび博物館）',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.kmnh.jp/',
    is_featured: false
  },
  {
    name: '北九州市立長崎街道木屋瀬宿記念館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://koyanose.jp/',
    is_featured: false
  },
  {
    name: '北九州市立美術館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://kmma.jp/',
    is_featured: false
  },
  {
    name: '北九州市立文学館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kitakyushucity-bungakukan.jp/',
    is_featured: false
  },
  {
    name: '北九州市立松本清張記念館',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.seicho-mm.jp/',
    is_featured: false
  },
  {
    name: '小倉城庭園',
    prefecture: '福岡県',
    city: '北九州市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kokura-castle.jp/kokura-garden/',
    is_featured: false
  },
  {
    name: '鞍手町歴史民俗博物館',
    prefecture: '福岡県',
    city: '鞍手郡鞍手町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.kurate.lg.jp/bunka/gyomu.html',
    is_featured: false
  },
  {
    name: '田川市石炭・歴史博物館',
    prefecture: '福岡県',
    city: '田川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.joho.tagawa.fukuoka.jp/list00784.html',
    is_featured: false
  },
  {
    name: '太宰府天満宮宝物殿',
    prefecture: '福岡県',
    city: '太宰府市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://keidai.art/houmotsuden',
    is_featured: false
  },
  {
    name: '筑紫野市歴史博物館（ふるさと館ちくしの）',
    prefecture: '福岡県',
    city: '筑紫野市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.chikushino.fukuoka.jp/soshiki/48/3550.html',
    is_featured: false
  },
  {
    name: '亀陽文庫　能古博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nokonoshima-museum.or.jp/',
    is_featured: false
  },
  {
    name: '福岡アジア美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://faam.city.fukuoka.lg.jp/',
    is_featured: false
  },
  {
    name: '福岡県立美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://fukuoka-kenbi.jp/',
    is_featured: false
  },
  {
    name: '福岡市博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://museum.city.fukuoka.jp/',
    is_featured: false
  },
  {
    name: '福岡市美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.fukuoka-art-museum.jp/',
    is_featured: false
  },
  {
    name: '福岡市埋蔵文化財センター',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://bunkazai.city.fukuoka.lg.jp/maibun/',
    is_featured: false
  },
  {
    name: 'マリンワールド海の中道（海の中道海洋生態科学館）',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://marine-world.jp/',
    is_featured: false
  },
  {
    name: 'みやこ町歴史民俗博物館',
    prefecture: '福岡県',
    city: '京都郡みやこ町',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.town.miyako.lg.jp/rekisiminnzoku/kankou/spot/hakubutukan.html',
    is_featured: false
  },
  {
    name: '立花家史料館',
    prefecture: '福岡県',
    city: '柳川市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.tachibana-museum.jp/',
    is_featured: false
  },
  {
    name: '秋月美術館',
    prefecture: '福岡県',
    city: '朝倉市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://akizuki-foundation.or.jp/museum',
    is_featured: false
  },
  {
    name: '福岡県立糸島高等学校郷土博物館',
    prefecture: '福岡県',
    city: '糸島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://itoshima.fku.ed.jp/feature/museum/',
    is_featured: false
  },
  {
    name: '久留米市美術館　石橋正二郎記念館',
    prefecture: '福岡県',
    city: '久留米市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.ishibashi-bunka.jp/kcam/',
    is_featured: false
  },
  {
    name: '福岡県青少年科学館',
    prefecture: '福岡県',
    city: '久留米市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'http://www.science.pref.fukuoka.jp/',
    is_featured: false
  },
  {
    name: '九州国立博物館',
    prefecture: '福岡県',
    city: '太宰府市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.kyuhaku.jp/',
    is_featured: false
  },
  {
    name: '九州産業大学美術館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.kyusan-u.ac.jp/ksumuseum/',
    is_featured: false
  },
  {
    name: '九州大学総合研究博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'http://www.museum.kyushu-u.ac.jp/',
    is_featured: false
  },
  {
    name: '西南学院大学博物館',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.seinan-gu.ac.jp/museum/',
    is_featured: false
  },
  {
    name: '福岡市動植物園',
    prefecture: '福岡県',
    city: '福岡市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://zoo.city.fukuoka.lg.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 佐賀県 (13件)
# ================================
puts '佐賀県のデータを投入中...'

[
  {
    name: '祐徳博物館',
    prefecture: '佐賀県',
    city: '鹿島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.yutokusan.jp/about/museum/',
    is_featured: false
  },
  {
    name: '佐賀県立名護屋城博物館',
    prefecture: '佐賀県',
    city: '唐津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saga-museum.jp/nagoya/',
    is_featured: false
  },
  {
    name: '佐賀県立佐賀城本丸歴史館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saga-museum.jp/sagajou/',
    is_featured: false
  },
  {
    name: '佐賀県立博物館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://saga-museum.jp/museum/',
    is_featured: false
  },
  {
    name: '佐賀県立美術館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://saga-museum.jp/museum/',
    is_featured: false
  },
  {
    name: '徴古館',
    prefecture: '佐賀県',
    city: '佐賀市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.nabeshima.or.jp/main/',
    is_featured: false
  },
  {
    name: '陽光美術館',
    prefecture: '佐賀県',
    city: '武雄市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.yokomuseum.jp/',
    is_featured: false
  },
  {
    name: '中冨記念くすり博物館',
    prefecture: '佐賀県',
    city: '鳥栖市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nakatomi-museum.or.jp/',
    is_featured: false
  },
  {
    name: '有田陶磁美術館',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.arita.lg.jp/kiji0031926/index.html',
    is_featured: false
  },
  {
    name: '今右衛門古陶磁美術館',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.imaemon.co.jp/museum/',
    is_featured: false
  },
  {
    name: '佐賀県立九州陶磁文化館',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://saga-museum.jp/ceramic/',
    is_featured: false
  },
  {
    name: '河村美術館',
    prefecture: '佐賀県',
    city: '唐津市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kawamura.or.jp/',
    is_featured: false
  },
  {
    name: '有田ポーセリンパーク',
    prefecture: '佐賀県',
    city: '西松浦郡有田町',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.arita-touki.com/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 長崎県 (18件)
# ================================
puts '長崎県のデータを投入中...'

[
  {
    name: '諫早市美術・歴史館',
    prefecture: '長崎県',
    city: '諫早市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.isahaya.nagasaki.jp/site/bireki/',
    is_featured: false
  },
  {
    name: '大村市歴史資料館',
    prefecture: '長崎県',
    city: '大村市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.omura.nagasaki.jp/rekishi/kyoiku/miraion/rekishishiryoukan.html',
    is_featured: false
  },
  {
    name: '佐世保市博物館島瀬美術センター',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shimabi.com/',
    is_featured: false
  },
  {
    name: 'べネックス恐竜博物館（長崎市恐竜博物館）',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://nd-museum.jp/',
    is_featured: false
  },
  {
    name: '平戸市生月町博物館・島の館',
    prefecture: '長崎県',
    city: '平戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://shimanoyakata.hira-shin.jp/',
    is_featured: false
  },
  {
    name: '松浦史料博物館',
    prefecture: '長崎県',
    city: '平戸市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.matsura.or.jp/',
    is_featured: false
  },
  {
    name: '長崎バイオパーク',
    prefecture: '長崎県',
    city: '西海市',
    registration_type: '登録博物館',
    museum_type: '動・水・植物園',
    official_website: 'https://www.biopark.co.jp/',
    is_featured: false
  },
  {
    name: '壱岐市立一支国博物館',
    prefecture: '長崎県',
    city: '壱岐市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.iki-haku.jp/',
    is_featured: false
  },
  {
    name: '雲仙ビードロ美術館',
    prefecture: '長崎県',
    city: '雲仙市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://unzenvidro.weebly.com/',
    is_featured: false
  },
  {
    name: '西海国立公園九十九島水族館「海きらら」',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://umikirara.jp/',
    is_featured: false
  },
  {
    name: '西海国立公園九十九島動植物園「森きらら」',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://morikirara.jp/',
    is_featured: false
  },
  {
    name: 'ハウステンボス美術館・博物館',
    prefecture: '長崎県',
    city: '佐世保市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.huistenbosch.co.jp/museum/',
    is_featured: false
  },
  {
    name: '長崎県美術館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'http://www.nagasaki-museum.jp/',
    is_featured: false
  },
  {
    name: '長崎孔子廟中国歴代博物館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://nagasaki-koushibyou.com/',
    is_featured: false
  },
  {
    name: '長崎純心大学博物館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.n-junshin.ac.jp/univ/research/museum/',
    is_featured: false
  },
  {
    name: '長崎ペンギン水族館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '動植物園',
    official_website: 'https://penguin-aqua.jp/',
    is_featured: false
  },
  {
    name: '長崎歴史文化博物館',
    prefecture: '長崎県',
    city: '長崎市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.nmhc.jp/',
    is_featured: false
  },
  {
    name: '新上五島町鯨賓館ミュージアム',
    prefecture: '長崎県',
    city: '南松浦郡新上五島町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.shinkamigoto.nagasaki.jp/geihinkan/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 熊本県 (21件)
# ================================
puts '熊本県のデータを投入中...'

[
  {
    name: '芦北町立星野富弘美術館',
    prefecture: '熊本県',
    city: '葦北郡芦北町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://hoshino-museum.com/',
    is_featured: false
  },
  {
    name: '阿蘇火山博物館',
    prefecture: '熊本県',
    city: '阿蘇市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'http://www.asomuse.jp/',
    is_featured: false
  },
  {
    name: '天草市立御所浦恐竜の島博物館',
    prefecture: '熊本県',
    city: '天草市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://goshouramuseum.jp/',
    is_featured: false
  },
  {
    name: '御船町恐竜博物館',
    prefecture: '熊本県',
    city: '上益城郡御船町',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://mifunemuseum.jp/',
    is_featured: false
  },
  {
    name: '湯前まんが美術館',
    prefecture: '熊本県',
    city: '球磨郡湯前町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://yunomae-manga.com/',
    is_featured: false
  },
  {
    name: '熊本県立美術館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.pref.kumamoto.jp/site/museum/',
    is_featured: false
  },
  {
    name: '熊本博物館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://kumamoto-city-museum.jp/',
    is_featured: false
  },
  {
    name: '玉名市立歴史博物館こころピア',
    prefecture: '熊本県',
    city: '玉名市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.tamana.lg.jp/q/list/455.html',
    is_featured: false
  },
  {
    name: '松井文庫驥斎',
    prefecture: '熊本県',
    city: '八代市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.kinasse-yatsushiro.jp/spots/detail/ea2b5552-e16c-4cf6-b627-5c1e3dfabee1',
    is_featured: false
  },
  {
    name: '八代市立博物館未来の森ミュージアム',
    prefecture: '熊本県',
    city: '八代市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.city.yatsushiro.kumamoto.jp/museum/index.jsp',
    is_featured: false
  },
  {
    name: '熊本県立装飾古墳館',
    prefecture: '熊本県',
    city: '山鹿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://kofunkan.pref.kumamoto.jp/',
    is_featured: false
  },
  {
    name: '山鹿市立博物館',
    prefecture: '熊本県',
    city: '山鹿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://furusato-yamaga.jp/detail/2/',
    is_featured: false
  },
  {
    name: '菊池神社歴史館',
    prefecture: '熊本県',
    city: '菊池市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://xn--btw921c.net/%E6%AD%B4%E5%8F%B2/25/',
    is_featured: false
  },
  {
    name: '熊本国際民藝館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://kumamoto-mingeikan.com/',
    is_featured: false
  },
  {
    name: '熊本市塚原歴史民俗資料館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://tsukawara.kumamoto-city-museum.jp/',
    is_featured: false
  },
  {
    name: '熊本市動植物園',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.ezooko.jp/',
    is_featured: false
  },
  {
    name: '熊本大学五高記念館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.goko.kumamoto-u.ac.jp/',
    is_featured: false
  },
  {
    name: '島田美術館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.shimada-museum.net/index.php',
    is_featured: false
  },
  {
    name: '神風連資料館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: '',
    is_featured: false
  },
  {
    name: '肥後の里山ギャラリー',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.higobank.co.jp/aboutus/higonosatoyama/index.html',
    is_featured: false
  },
  {
    name: '本妙寺宝物館',
    prefecture: '熊本県',
    city: '熊本市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.honmyouji.jp/houmotu.html',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 大分県 (16件)
# ================================
puts '大分県のデータを投入中...'

[
  {
    name: '大分県立歴史博物館（宇佐風土記の丘）',
    prefecture: '大分県',
    city: '宇佐市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.oita.jp/site/rekishihakubutsukan/',
    is_featured: false
  },
  {
    name: '大分県立美術館',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.opam.jp/',
    is_featured: false
  },
  {
    name: '大分市美術館',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.city.oita.oita.jp/bunkasports/bunka/bijutsukan/',
    is_featured: false
  },
  {
    name: '国東市歴史体験学習館',
    prefecture: '大分県',
    city: '国東市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.kunisaki.oita.jp/site/yayoinomura/',
    is_featured: false
  },
  {
    name: '竹田市歴史文化館・由学館',
    prefecture: '大分県',
    city: '竹田市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.taketa.oita.jp/bunka_rekishi_kanko/yugakukan/index.html',
    is_featured: false
  },
  {
    name: '中津市歴史博物館',
    prefecture: '大分県',
    city: '中津市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://nakahaku.jp/',
    is_featured: false
  },
  {
    name: '二階堂美術館',
    prefecture: '大分県',
    city: '速見郡日出町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://nikaidou-bijyutukan.com/',
    is_featured: false
  },
  {
    name: '九州自然動物公園',
    prefecture: '大分県',
    city: '宇佐市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'http://www.africansafari.co.jp/',
    is_featured: false
  },
  {
    name: '大分県立先哲史料館',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.pref.oita.jp/site/sentetsusiryokan/',
    is_featured: false
  },
  {
    name: '大分マリーンパレス水族館「うみたまご」',
    prefecture: '大分県',
    city: '大分市',
    registration_type: '指定施設',
    museum_type: '水族館',
    official_website: 'https://www.umitamago.jp/',
    is_featured: false
  },
  {
    name: '久留島武彦記念館',
    prefecture: '大分県',
    city: '玖珠郡玖珠町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://kurushimatakehiko.com/',
    is_featured: false
  },
  {
    name: '耶馬溪風物館',
    prefecture: '大分県',
    city: '中津市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.city-nakatsu.jp/doc/2015032000841/',
    is_featured: false
  },
  {
    name: '日田市立博物館',
    prefecture: '大分県',
    city: '日田市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.city.hita.oita.jp/shisetsu/hakubutukan/7596.html',
    is_featured: false
  },
  {
    name: '廣瀬資料館',
    prefecture: '大分県',
    city: '日田市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://hirose-museum.jp/',
    is_featured: false
  },
  {
    name: '大分香りの博物館',
    prefecture: '大分県',
    city: '別府市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://oita-kaori.jp/',
    is_featured: false
  },
  {
    name: '別府大学附属博物館',
    prefecture: '大分県',
    city: '別府市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.beppu-u.ac.jp/research/institutions/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 宮崎県 (10件)
# ================================
puts '宮崎県のデータを投入中...'

[
  {
    name: '高鍋町美術館',
    prefecture: '宮崎県',
    city: '児湯郡高鍋町',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.town.takanabe.lg.jp/museum/index.html',
    is_featured: false
  },
  {
    name: '宮崎県立西都原考古博物館',
    prefecture: '宮崎県',
    city: '西都市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://saito-muse.pref.miyazaki.jp/web/index.html',
    is_featured: false
  },
  {
    name: '延岡城・内藤記念博物館',
    prefecture: '宮崎県',
    city: '延岡市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://nobeoka-naito-museum.jp',
    is_featured: false
  },
  {
    name: '都城島津邸',
    prefecture: '宮崎県',
    city: '都城市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.miyakonojo.miyazaki.jp/site/shimazu/',
    is_featured: false
  },
  {
    name: '都城市立美術館',
    prefecture: '宮崎県',
    city: '都城市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.miyakonojo.miyazaki.jp/site/artmuseum/',
    is_featured: false
  },
  {
    name: '宮崎県総合博物館',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.miyazaki-archive.jp/museum/',
    is_featured: false
  },
  {
    name: '宮崎県立美術館',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miyazaki-archive.jp/bijutsu/',
    is_featured: false
  },
  {
    name: '椎葉民俗芸能博物館',
    prefecture: '宮崎県',
    city: '東臼杵郡椎葉村',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.shiibakanko.jp/tourism/spot/spot3',
    is_featured: false
  },
  {
    name: '宮崎市フェニックス自然動物園',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.miyazaki-city-zoo.jp/',
    is_featured: false
  },
  {
    name: '宮崎大学農学部附属農業博物館',
    prefecture: '宮崎県',
    city: '宮崎市',
    registration_type: '指定施設',
    museum_type: '科学',
    official_website: 'https://www.miyazaki-u.ac.jp/museum/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 鹿児島県 (22件)
# ================================
puts '鹿児島県のデータを投入中...'

[
  {
    name: '原野農芸博物館',
    prefecture: '鹿児島県',
    city: '奄美市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://haranoam.synapse-site.jp/',
    is_featured: false
  },
  {
    name: '指宿市考古博物館時遊館ＣＯＣＣＯはしむれ',
    prefecture: '鹿児島県',
    city: '指宿市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ibusuki.lg.jp/cocco/',
    is_featured: false
  },
  {
    name: '岩崎美術館',
    prefecture: '鹿児島県',
    city: '指宿市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.iwasaki-zaidan.org/artmuseum/',
    is_featured: false
  },
  {
    name: '鹿児島県立博物館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '科学',
    official_website: 'https://www.pref.kagoshima.jp/hakubutsukan/',
    is_featured: false
  },
  {
    name: '鹿児島県歴史・美術センター黎明館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.pref.kagoshima.jp/reimeikan/',
    is_featured: false
  },
  {
    name: '示現流兵法所史料館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.jigen-ryu.com/archives/',
    is_featured: false
  },
  {
    name: '長島美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://ngp.jp/nagashima-museum/',
    is_featured: false
  },
  {
    name: '中村晋也美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.ne.jp/asahi/musee/nakamura/',
    is_featured: false
  },
  {
    name: '三宅美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.miyake-art.com/',
    is_featured: false
  },
  {
    name: '陽山美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.musee-yozan.or.jp/',
    is_featured: false
  },
  {
    name: '児玉美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.kodama-art-museum.or.jp/',
    is_featured: false
  },
  {
    name: '松下美術館',
    prefecture: '鹿児島県',
    city: '霧島市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://matsushita-art.synapse.kagoshima.jp/matushita_index.htm',
    is_featured: false
  },
  {
    name: '吉井淳二美術館',
    prefecture: '鹿児島県',
    city: '南さつま市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'http://www.nonohanakai.or.jp/museum/',
    is_featured: false
  },
  {
    name: '長崎鼻パーキングガーデン',
    prefecture: '鹿児島県',
    city: '指宿市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'http://nagasakibana.com/',
    is_featured: false
  },
  {
    name: 'かごしま近代文学館・かごしまメルヘン館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.k-kb.or.jp/kinmeru/',
    is_featured: false
  },
  {
    name: '鹿児島国際大学博物館実習施設（鹿児島国際大学ミュージアム）',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://museum.iuk-plus.net/',
    is_featured: false
  },
  {
    name: '鹿児島市平川動物公園',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://hirakawazoo.jp/',
    is_featured: false
  },
  {
    name: '鹿児島市立美術館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www.city.kagoshima.lg.jp/artmuseum/',
    is_featured: false
  },
  {
    name: '鹿児島大学総合研究博物館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.museum.kagoshima-u.ac.jp/',
    is_featured: false
  },
  {
    name: '尚古集成館',
    prefecture: '鹿児島県',
    city: '鹿児島市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.shuseikan.jp/',
    is_featured: false
  },
  {
    name: '南種子町広田遺跡ミュージアム',
    prefecture: '鹿児島県',
    city: '熊毛郡南種子町',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://www.town.minamitane.kagoshima.jp/institution/hirotasitemuseum.html',
    is_featured: false
  },
  {
    name: '知覧特攻平和会館',
    prefecture: '鹿児島県',
    city: '南九州市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://www.chiran-tokkou.jp/',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

# ================================
# 沖縄県 (20件)
# ================================
puts '沖縄県のデータを投入中...'

[
  {
    name: '石垣市立八重山博物館',
    prefecture: '沖縄県',
    city: '石垣市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ishigaki.okinawa.jp/kurashi_gyosei/kanko_bunka_sport/hakubutsukan/index.html',
    is_featured: false
  },
  {
    name: 'ひめゆり平和祈念資料館',
    prefecture: '沖縄県',
    city: '糸満市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://himeyuri.or.jp/JP/top.html',
    is_featured: false
  },
  {
    name: '浦添市美術館',
    prefecture: '沖縄県',
    city: '浦添市',
    registration_type: '登録博物館',
    museum_type: '美術',
    official_website: 'https://www.city.urasoe.lg.jp/category/art/',
    is_featured: false
  },
  {
    name: '沖縄市立郷土博物館',
    prefecture: '沖縄県',
    city: '沖縄市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.okinawa.okinawa.jp/k063/sportsbunka/hakubutsukan/kyoudohakubutsukan/134/index.html',
    is_featured: false
  },
  {
    name: '宜野湾市立博物館',
    prefecture: '沖縄県',
    city: '宜野湾市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'https://www.city.ginowan.lg.jp/soshiki/kyoiku/1/2/index.html',
    is_featured: false
  },
  {
    name: '久米島博物館',
    prefecture: '沖縄県',
    city: '久米島町',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://sizenbunka.ti-da.net/',
    is_featured: false
  },
  {
    name: '名護博物館',
    prefecture: '沖縄県',
    city: '名護市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.nago.okinawa.jp/museum/',
    is_featured: false
  },
  {
    name: '沖縄県立博物館・美術館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://okimu.jp/',
    is_featured: false
  },
  {
    name: '那覇市立壺屋焼物博物館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '登録博物館',
    museum_type: '歴史',
    official_website: 'http://www.edu.city.naha.okinawa.jp/tsuboya/',
    is_featured: false
  },
  {
    name: '宮古島市総合博物館',
    prefecture: '沖縄県',
    city: '宮古島市',
    registration_type: '登録博物館',
    museum_type: '総合',
    official_website: 'https://www.city.miyakojima.lg.jp/soshiki/kyouiku/syougaigakusyu/hakubutsukan/',
    is_featured: false
  },
  {
    name: '沖縄美ら海水族館',
    prefecture: '沖縄県',
    city: '本部町',
    registration_type: '登録博物館',
    museum_type: '水族館',
    official_website: 'https://churaumi.okinawa/',
    is_featured: false
  },
  {
    name: '沖縄こどもの国',
    prefecture: '沖縄県',
    city: '沖縄市',
    registration_type: '指定施設',
    museum_type: '動物園',
    official_website: 'https://www.okzm.jp/',
    is_featured: false
  },
  {
    name: '東南植物楽園',
    prefecture: '沖縄県',
    city: '沖縄市',
    registration_type: '指定施設',
    museum_type: '動・水・植物園',
    official_website: 'https://www.southeast-botanical.jp/',
    is_featured: false
  },
  {
    name: 'アスムイハイクス(沖縄石の文化博物館)',
    prefecture: '沖縄県',
    city: '国頭郡国頭村',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.asmui.jp',
    is_featured: false
  },
  {
    name: '沖縄空手会館',
    prefecture: '沖縄県',
    city: '豊見城市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'https://karatekaikan.jp/',
    is_featured: false
  },
  {
    name: '琉球大学博物館（風樹館）',
    prefecture: '沖縄県',
    city: '中頭郡西原町',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://fujukan.skr.u-ryukyu.ac.jp/',
    is_featured: false
  },
  {
    name: '沖縄県立芸術大学附属図書・芸術資料館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '指定施設',
    museum_type: '美術',
    official_website: 'https://www2.lib.okigei.ac.jp/lib/lib.html',
    is_featured: false
  },
  {
    name: '対馬丸記念館',
    prefecture: '沖縄県',
    city: '那覇市',
    registration_type: '指定施設',
    museum_type: '歴史',
    official_website: 'http://tsushimamaru.or.jp/',
    is_featured: false
  },
  {
    name: 'おきなわワールド',
    prefecture: '沖縄県',
    city: '南城市',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: 'https://www.gyokusendo.co.jp/okinawaworld/',
    is_featured: false
  },
  {
    name: '南風原町立南風原文化センター',
    prefecture: '沖縄県',
    city: '南風原町',
    registration_type: '指定施設',
    museum_type: '総合',
    official_website: '',
    is_featured: false
  }
].each do |museum_data|
  begin
    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])
    museum.assign_attributes(museum_data)
    if museum.new_record?
      museum.save!
      created_count += 1
    elsif museum.changed?
      museum.save!
      updated_count += 1
    end
  rescue => e
    puts "エラー: #{museum_data[:name]} - #{e.message}"
    error_count += 1
  end
end

puts '================================================'
puts '博物館データの投入が完了しました'
puts '================================================'
puts "新規作成: #{created_count}件"
puts "更新: #{updated_count}件"
puts "エラー: #{error_count}件"
puts "総博物館数: #{Museum.count}件"
puts '================================================'

# 都道府県別統計
puts '\n【都道府県別データ数】'
puts '  北海道: 73件'
puts '  青森県: 7件'
puts '  岩手県: 23件'
puts '  宮城県: 17件'
puts '  秋田県: 14件'
puts '  山形県: 18件'
puts '  福島県: 21件'
puts '  茨城県: 24件'
puts '  栃木県: 26件'
puts '  群馬県: 26件'
puts '  埼玉県: 30件'
puts '  千葉県: 51件'
puts '  東京都: 129件'
puts '  神奈川県: 52件'
puts '  新潟県: 36件'
puts '  富山県: 37件'
puts '  石川県: 30件'
puts '  福井県: 22件'
puts '  山梨県: 28件'
puts '  長野県: 84件'
puts '  岐阜県: 25件'
puts '  静岡県: 46件'
puts '  愛知県: 49件'
puts '  三重県: 20件'
puts '  滋賀県: 20件'
puts '  京都府: 54件'
puts '  大阪府: 41件'
puts '  兵庫県: 48件'
puts '  奈良県: 22件'
puts '  和歌山県: 15件'
puts '  鳥取県: 9件'
puts '  島根県: 25件'
puts '  岡山県: 33件'
puts '  広島県: 37件'
puts '  山口県: 23件'
puts '  徳島県: 11件'
puts '  香川県: 17件'
puts '  愛媛県: 24件'
puts '  高知県: 17件'
puts '  福岡県: 36件'
puts '  佐賀県: 13件'
puts '  長崎県: 18件'
puts '  熊本県: 21件'
puts '  大分県: 16件'
puts '  宮崎県: 10件'
puts '  鹿児島県: 22件'
puts '  沖縄県: 20件'

puts '\n✓ データ投入が完了しました'
