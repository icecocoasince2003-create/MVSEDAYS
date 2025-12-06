class ImproveMuseumsTable < ActiveRecord::Migration[7.2]
  def change
    # visit_count にデフォルト値を設定
    change_column_default :museums, :visit_count, from: nil, to: 0
    
    # registration_type にインデックス追加 (登録種別での検索を高速化)
    add_index :museums, :registration_type unless index_exists?(:museums, :registration_type)
    
    # is_featured にインデックス追加 (注目館の検索を高速化)
    add_index :museums, :is_featured unless index_exists?(:museums, :is_featured)
  end
end
