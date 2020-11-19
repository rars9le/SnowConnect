class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    flash[:danger] = comment.errors.full_messages unless comment.save
    redirect_back(fallback_location: root_path)
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success] = 'コメントが削除されました'
    redirect_back(fallback_location: root_path)
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :user_id)
  end
end
