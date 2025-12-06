#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
MVSEDAYS museum csv data converter
"""

import csv
import sys
import os
from collections import defaultdict
from datetime import datetime

def clean_text(text):
    if not text:
        return ""
    text = text.strip()
    # 不必要な記号を博物館名から削除
    text = text.replace('◎', '').replace('○', '')
    return text

def escape_ruby_string(text):
    """Ruby文字列用のエスケープ処理"""
    if not text:
        return ""
    # バックスラッシュとシングルクォートをエスケープ
    text = text.replace('\\', '\\\\')
    text = text.replace("'", "\\'")
    return text

def normalize_url(url):
    """URLの正規化"""
    if not url:
        return ""
    url = url.strip()
    # httpまたはhttpsで始まらないURLは空文字列に
    if not url.startswith('http'):
        return ""
    return url

def convert_csv_to_seeds(input_csv, output_rb):
    museums_by_prefecture = defaultdict(list)
    total_count = 0
    error_count = 0
    skipped_count = 0

    print("=" * 70)
    print("MVSEDAYS museum csv data converter")
    print("=" * 70)
    print(f"Input CSV: {input_csv}")
    print(f"Output Ruby: {output_rb}\n")

    # CSVファイルの存在確認
    if not os.path.exists(input_csv):
        print(f"Error: csvファイルが見つかりません: {input_csv}")
        return False
    
    print("CSVファイルを読み込み中...")

    try:
        # 複数のエンコーディングで試行
        encodings = ['utf-8-sig', 'utf-8', 'shift-jis', 'cp932']
        file_content = None
        used_encoding = None
        
        for encoding in encodings:
            try:
                with open(input_csv, 'r', encoding=encoding) as f:
                    file_content = f.read()
                    used_encoding = encoding
                    print(f"✓ エンコーディング: {encoding}")
                    break
            except:
                continue
        
        if file_content is None:
            print("ファイルの読み込みに失敗しました")
            return False
        
        # CSVをパース
        lines = file_content.strip().split('\n')
        
        # 最初の数行を確認してヘッダーを見つける
        header_line_index = -1
        for i, line in enumerate(lines[:5]):  # 最初の5行をチェック
            if '名称' in line and '都道府県' in line:
                header_line_index = i
                print(f"ヘッダー行を発見: {i+1}行目")
                break
        
        if header_line_index == -1:
            print("ヘッダー行が見つかりません")
            print("先頭5行:")
            for i, line in enumerate(lines[:5]):
                print(f"  {i+1}: {line[:100]}")
            return False
        
        # ヘッダー行以降をCSVとして解析
        csv_lines = lines[header_line_index:]
        reader = csv.DictReader(csv_lines)
        
        print(f"カラム: {reader.fieldnames}\n")
        print("データ処理中...")

        for row_num, row in enumerate(reader, start=header_line_index + 2):
            try:
                # フィールド名の正規化
                row = {k.strip() if k else '': v for k, v in row.items()}
                
                # フィールドの取得
                name = clean_text(row.get('名称', ''))
                prefecture = clean_text(row.get('都道府県', ''))
                city = clean_text(row.get('市区町村', ''))
                registration_type = clean_text(row.get('登録状況', ''))
                museum_type = clean_text(row.get('館種', ''))
                official_website = normalize_url(row.get('公式HP', ''))

                # 空行をスキップ
                if not name and not prefecture and not city:
                    skipped_count += 1
                    continue
                
                # 必須フィールドの確認
                if not name or not prefecture:
                    if name or prefecture:  # どちらか片方だけある場合のみ警告
                        print(f"⚠ Warning: 必須フィールドが欠落 (行 {row_num}): name='{name}', pref='{prefecture}'")
                        error_count += 1
                    else:
                        skipped_count += 1
                    continue
                
                museum_data = {
                    'name': escape_ruby_string(name),
                    'prefecture': escape_ruby_string(prefecture),
                    'city': escape_ruby_string(city),
                    'registration_type': escape_ruby_string(registration_type),
                    'museum_type': escape_ruby_string(museum_type),
                    'official_website': escape_ruby_string(official_website)
                }

                museums_by_prefecture[prefecture].append(museum_data)
                total_count += 1

                # 進捗表示
                if total_count % 100 == 0:
                    print(f"  処理中... {total_count}件")
                
            except Exception as e:
                print(f"Error: 行{row_num}の処理中にエラー: {e}")
                error_count += 1
                continue
        
        print(f"\n読み込み完了")
        print(f"  - 有効データ: {total_count}件")
        print(f"  - エラー: {error_count}件")
        print(f"  - スキップ: {skipped_count}件")
        print(f"  - 都道府県数: {len(museums_by_prefecture)}件\n")

        if total_count == 0:
            print("有効なデータが0件です。CSVファイルの形式を確認してください。")
            return False

        # 出力ディレクトリの作成
        output_dir = os.path.dirname(output_rb)
        if output_dir and not os.path.exists(output_dir):
            os.makedirs(output_dir)
            print(f"ディレクトリを作成しました: {output_dir}")

        print("Rubyファイルを生成中...")

        with open(output_rb, 'w', encoding='utf-8') as rbfile:
            # ヘッダー
            rbfile.write("# frozen_string_literal: true\n\n")
            rbfile.write("# =================================================\n")
            rbfile.write("# MVSEDAYS museum data\n")
            rbfile.write(f"# 総データ数: {total_count}件\n")
            rbfile.write(f"# 都道府県数: {len(museums_by_prefecture)}件\n")
            rbfile.write("# 生成日時: " + datetime.now().strftime('%Y-%m-%d %H:%M:%S') + "\n")
            rbfile.write("# =================================================\n\n")

            rbfile.write("puts '================================================'\n")
            rbfile.write("puts '博物館データの投入を開始します'\n")
            rbfile.write("puts '================================================'\n\n")

            rbfile.write("created_count = 0\n")
            rbfile.write("updated_count = 0\n")
            rbfile.write("error_count = 0\n\n")

            # 都道府県の順序定義
            prefecture_order = [
                "北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県",
                "茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県",
                "新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県",
                "岐阜県", "静岡県", "愛知県", "三重県",
                "滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県",
                "鳥取県", "島根県", "岡山県", "広島県", "山口県",
                "徳島県", "香川県", "愛媛県", "高知県",
                "福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県",
                "沖縄県"
            ]

            # 都道府県ごとにデータを書き込み
            for prefecture in prefecture_order:
                museums = museums_by_prefecture.get(prefecture, [])
                if not museums:
                    continue
                
                rbfile.write(f"# ================================\n")
                rbfile.write(f"# {prefecture} ({len(museums)}件)\n")
                rbfile.write(f"# ================================\n")
                rbfile.write(f"puts '{prefecture}のデータを投入中...'\n\n")
                rbfile.write("[\n")

                for i, museum in enumerate(museums):
                    rbfile.write("  {\n")
                    rbfile.write(f"    name: '{museum['name']}',\n")
                    rbfile.write(f"    prefecture: '{museum['prefecture']}',\n")
                    rbfile.write(f"    city: '{museum['city']}',\n")
                    rbfile.write(f"    registration_type: '{museum['registration_type']}',\n")
                    rbfile.write(f"    museum_type: '{museum['museum_type']}',\n")
                    rbfile.write(f"    official_website: '{museum['official_website']}',\n")
                    rbfile.write(f"    is_featured: false\n")

                    if i < len(museums) - 1:
                        rbfile.write("  },\n")
                    else:
                        rbfile.write("  }\n")
                
                rbfile.write("].each do |museum_data|\n")
                rbfile.write("  begin\n")
                rbfile.write("    museum = Museum.find_or_initialize_by(name: museum_data[:name], prefecture: museum_data[:prefecture])\n")
                rbfile.write("    museum.assign_attributes(museum_data)\n")
                rbfile.write("    if museum.new_record?\n")
                rbfile.write("      museum.save!\n")
                rbfile.write("      created_count += 1\n")
                rbfile.write("    elsif museum.changed?\n")
                rbfile.write("      museum.save!\n")
                rbfile.write("      updated_count += 1\n")
                rbfile.write("    end\n")
                rbfile.write("  rescue => e\n")
                rbfile.write("    puts \"エラー: #{museum_data[:name]} - #{e.message}\"\n")
                rbfile.write("    error_count += 1\n")
                rbfile.write("  end\n")
                rbfile.write("end\n\n")

            # フッター
            rbfile.write("puts '================================================'\n")
            rbfile.write("puts '博物館データの投入が完了しました'\n")
            rbfile.write("puts '================================================'\n")
            rbfile.write("puts \"新規作成: #{created_count}件\"\n")
            rbfile.write("puts \"更新: #{updated_count}件\"\n")
            rbfile.write("puts \"エラー: #{error_count}件\"\n")
            rbfile.write("puts \"総博物館数: #{Museum.count}件\"\n")
            rbfile.write("puts '================================================'\n\n")

            # 統計情報
            rbfile.write("# 都道府県別統計\n")
            rbfile.write("puts '\\n【都道府県別データ数】'\n")
            for prefecture in prefecture_order:
                count = len(museums_by_prefecture.get(prefecture, []))
                if count > 0:
                    rbfile.write(f"puts '  {prefecture}: {count}件'\n")
            
            rbfile.write("\nputs '\\n✓ データ投入が完了しました'\n")
        
        print(f"Rubyファイルを生成しました: {output_rb}\n")

        # 統計情報表示
        print("=" * 70)
        print("【都道府県別データ件数】")
        print("=" * 70)
        for prefecture in prefecture_order:
            count = len(museums_by_prefecture.get(prefecture, []))
            if count > 0:
                print(f"  {prefecture:8s}: {count:4d}件")

        print("\n" + "=" * 70)
        print(f"変換完了: 合計 {total_count}件の博物館データ")
        print("=" * 70)

        return True

    except Exception as e:
        print(f"\nエラー: 処理中に予期しないエラーが発生しました")
        print(f"エラー詳細: {e}")
        import traceback
        traceback.print_exc()
        return False

def main():
    print("\n")

    # デフォルトのファイルパス
    default_input = "MuseumList_20251106.csv"
    default_output = "db/seeds_museums_all.rb"

    # コマンドライン引数
    if len(sys.argv) >= 2:
        input_csv = sys.argv[1]
    else:
        input_csv = default_input
    
    if len(sys.argv) >= 3:
        output_rb = sys.argv[2]
    else:
        output_rb = default_output
    
    print("使用するファイル:")
    print(f"  入力CSV: {input_csv}")
    print(f"  出力Ruby: {output_rb}\n")

    # 変換実行
    success = convert_csv_to_seeds(input_csv, output_rb)

    if success:
        print("\n" + "=" * 70)
        print("変換が完了しました！")
        print("=" * 70)
        print("\n【次のステップ】")
        print("1. 生成されたファイルを確認:")
        print(f"   type {output_rb}")
        print("\n2. db/seeds.rbに統合:")
        print(f"   type {output_rb} >> db\\seeds.rb")
        print("\n3. データベースに投入:")
        print("   rails db:seed")
        print("\n4. 確認:")
        print("   rails console")
        print("   > Museum.count")
        print("   > Museum.group(:prefecture).count")
        print("=" * 70 + "\n")
    else:
        print("\n" + "=" * 70)
        print("変換に失敗しました")
        print("=" * 70)
        print("\n【デバッグ方法】")
        print("1. デバッグスクリプトを実行:")
        print("   python scripts\\debug_csv.py")
        print("\n2. CSVファイルの先頭を確認:")
        print(f"   type {input_csv} | more")
        print("=" * 70 + "\n")
        sys.exit(1)

if __name__ == "__main__":
    main()