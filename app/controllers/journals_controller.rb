class JournalsController < ApplicationController
    before_action :authenticate_user!, except: [:index, :show]
    before_action :set_journal, only: [:show, :edit, :update, :destroy]
    before_action :authorize_user!, only: [:edit, :update, :destroy]

    def index
        @journals = Journal.all
        search = params[:search]
        @journals = @journals.joins(:user).where("tag LIKE ?", "%#{search}%") if search.present?

        # 博物館でフィルタ
        if params[:museum_id].present?
            @journals = @journals.by_museum(params[:museum_id])
            @museum = Museum.find_by(id: params[:museum_id])
        end

        # 評価でフィルタ
        if params[:rating].present?
            @journals = @journals.by_rating(params[:rating])
        end 
    end

    def new
        @journal = Journal.new
        # 博物館を設定
        if params[:museum_id].present?
            @museum = Museum.find_by(id: params[:museum_id])
            @journal.museum = @museum
        end
    end

    def create
        @journal = Journal.new(journal_params)
        @journal.user_id = current_user.id
        
        if @journal.save
            redirect_to @journal, notice: '日記を作成しました。'
        else
            render :new, status: :unprocessable_entity
        end
    end

    def show
        # @journal は before_action で設定済み
        @museum = @journal.museum
        @related_journals = if @museum
            @museum.journals.where.not(id: @journal.id).recent.limit(5)
        else
            []
        end                
    end

    def edit
        # @journal は before_action で設定済み
    end

    def update
        # 画像削除処理
        if params[:journal] && params[:journal][:remove_image] == '1'
            @journal.remove_image! if @journal.image.present?
            @journal.image = nil
        end

        if @journal.update(journal_params)
            redirect_to @journal, notice: '日記を更新しました。'
        else
            render :edit, status: :unprocessable_entity
        end
    end

    def destroy
        # @journal は before_action で設定済み
        @journal.destroy
        redirect_to journals_path, notice: '日記を削除しました。'
    end

    private

    def set_journal
        @journal = Journal.find(params[:id])
    rescue ActiveRecord::RecordNotFound
        redirect_to journals_path, alert: '日記が見つかりませんでした。'
    end
    
    def authorize_user!
        unless @journal.user == current_user || current_user.admin?
            redirect_to journals_path, alert: '権限がありません。'
        end
    end
    
    def journal_params
        params.require(:journal).permit(
            :body,
            :visit_date,
            :museum_id,
            :tag_list,
            :overall,
            :rate,
            :image
        )
    end
end