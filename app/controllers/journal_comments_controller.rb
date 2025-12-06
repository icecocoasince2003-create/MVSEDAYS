class JournalCommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_journal
  before_action :set_comment, only: [:destroy]

  def create
    @comment = @journal.journal_comments.build(comment_params)
    @comment.user = current_user
    
    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @journal, notice: 'コメントを投稿しました' }
      end
    else
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("comments-list", partial: "journal_comments/error", locals: { errors: @comment.errors.full_messages }) }
        format.html { redirect_to @journal, alert: 'コメントの投稿に失敗しました' }
      end
    end
  end

  def destroy
    if @comment.user == current_user && @comment.destroy
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @journal, notice: 'コメントを削除しました' }
      end
    else
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @journal, alert: 'コメントを削除できませんでした' }
      end
    end
  end

  private

  def set_journal
    @journal = Journal.find(params[:journal_id])
  end

  def set_comment
    @comment = @journal.journal_comments.find(params[:id])
  end

  def comment_params
    params.require(:journal_comment).permit(:body)
  end
end