class FavoritesController < ApplicationController
  def create
    post = Post.find(params[:post_id])
    current_user.favorite(post)
    flash[:success] = 'お気に入りしました'
    redirect_back(fallback_location: root_path)
  end

  def destroy
    post = Post.find(params[:post_id])
    current_user.unfavorite(post)

    respond_to do |format|
      format.html { redirect_to request.referer || root_url }
      format.js
    end

    # flash[:success] = 'お気に入りを解除しました。'
    # redirect_back(fallback_location: root_path)
  end
end
