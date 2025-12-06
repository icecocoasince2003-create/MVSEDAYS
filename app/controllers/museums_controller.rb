class MuseumsController < ApplicationController
    before_action :set_museum, only: [:show]

    # 博物館一覧・検索ページ
    def index
        @museums = Museum.search(search_params).page(params[:page]).per(20)

        # 検索フォーム用データ
        @prefectures = Museum.prefectures_list
        @museum_types = Museum.museum_type_list
        @registration_types = Museum.registration_type_list

        # 統計情報
        @total_count = Museum.count
        @featured_count = Museum.featured.count

        respond_to do |format|
            format.html
            format.json { render json: @museums}
        end
    end

    # 博物館詳細ページ
    def show
        @related_journals = @museum.journals.recent.limit(10)
        @journals_count = @museum.journals_count
    end

    # Ajax検索
    def search
        @museums = Museum.search(search_params).limit(50)

        render json: @museums.map { |m|
            {
                id: m.id,
                name: m.name,
                prefecture: m.prefecture,
                city: m.city,
                museum_type: m.museum_type,
                full_address: m.full_address,
                official_website: m.official_website
            }
        }
    end

    # オートコンプリート
    def autocomplete
        keyword = params[:keyword]
        museums = Museum.search_by_keyword(keyword).limit(10)

        render json: museums.map { |m|
            {
                id: m.id,
                label: "#{m.name}(#{m.prefecture})",
                prefecture: m.prefecture,
                city: m.city
            }
        }
    end

    private

    def set_museum
        @museum = Museum.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to museums_path, alert: '博物館が見つかりませんでした'
    end

    def search_params
        params.permit(:prefecture, :museum_type, :registration_type, :keyword)
    end
end