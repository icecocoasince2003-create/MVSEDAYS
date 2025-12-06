class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin, except: [:my_page]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.all.order(created_at: :desc)
  end

  def show
    @journals = @user.journals.order(created_at: :desc)
  end
  
  def edit
  end

  # ユーザー管理
  def update
    if @user.update(user_params)
      redirect_to users_path, notice: 'ユーザー情報を更新しました'
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: 'ユーザーを削除しました'
    else
      redirect_to users_path, alert: 'ユーザーの削除に失敗しました'
    end
  end

  # マイページ
  def my_page
    @user = current_user
    @journals = @user.journals.includes(:museum, :tags).order(visit_date: :desc)

    # カレンダー用の日付設定
    if params[:year] && params[:month]
      @current_date = Date.new(params[:year].to_i, params[:month].to_i, 1)
    elsif params[:month]
      @current_date = Date.parse(params[:month])
    else
      @current_date = Date.today
    end

    # 前月・次月の計算
    @prev_month = @current_date - 1.month
    @next_month = @current_date + 1.month

    # カレンダーの開始日と終了日（日曜始まり）
    @start_date = @current_date.beginning_of_month.beginning_of_week(:sunday)
    @end_date = @current_date.end_of_month.end_of_week(:sunday)

    # 訪問日データ
    @visit_dates = @user.journals.where.not(visit_date: nil).pluck(:visit_date, :id)
    @visit_dates_hash = @visit_dates.group_by { |date, id| date.beginning_of_month }
  end

  private

  def set_user
    @user = User.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to users_path, alert: 'ユーザーが見つかりません'
  end
  
  # 管理者
  def admin_only
    unless current_user&.admin?
      redirect_to root_path, alert: '管理者権限が必要です'
    end
  end
  
  def user_params
    params.require(:user).permit(:email, :admin)
  end

  def require_admin
    unless current_user.admin?
      redirect_to root_path, alert: '管理者権限が必要です'
    end
  end
end