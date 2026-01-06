# ✅ 追加: タグ専用コントローラー（オプション）
# タグ一覧、タグで絞り込み機能を実装する場合に使用

class TagsController < ApplicationController
  def index
    @tags = Tag.popular.limit(50)
  end

  def show
    @tag = Tag.find(params[:id])
    @journals = @tag.journals.where(is_public: true).recent.page(params[:page])
  rescue ActiveRecord::RecordNotFound
    redirect_to tags_path, alert: 'タグが見つかりませんでした。'
  end

  # タグ検索（AJAX用）
  def search
    keyword = params[:keyword]
    @tags = Tag.search(keyword).limit(20)
    
    render json: @tags.map { |tag| 
      { 
        id: tag.id, 
        name: tag.name, 
        count: tag.usage_count 
      } 
    }
  end
end