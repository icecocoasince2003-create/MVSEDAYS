class JournalLikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal

  def create
    @journal.journal_likes.create(user: current_user)
    
    respond_to do |format|
      format.html { redirect_to @journal, notice: 'いいねしました' }
      format.turbo_stream
    end
  end

  def destroy
    @journal.journal_likes.find_by(user: current_user)&.destroy
    
    respond_to do |format|
      format.html { redirect_to @journal, notice: 'いいねを取り消しました' }
      format.turbo_stream
    end
  end

  private

  def set_journal
    @journal = Journal.find(params[:id])
  end
end