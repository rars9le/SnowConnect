class CommentsController < ApplicationController
  def create
    comment = current_user.comments.build(comment_params)
    if comment.save
      redirect_to root_path
    else
      redirect_to root_path, flash: {
        comment: comment,
        danger: comment.errors.full_messages
      }
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    comment.destroy
    flash[:success] = 'コメントが削除されました'
    redirect_to root_path
  end

  private

  def comment_params
    params.require(:comment).permit(:comment, :post_id, :user_id)
  end
end
