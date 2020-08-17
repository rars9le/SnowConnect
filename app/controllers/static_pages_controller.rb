class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      redirect_to feed_posts_path
    else
      redirect_to posts_path
    end
    #@post = current_user.posts.build
    #@posts = current_user.feed_posts.order(id: :desc).page(params[:page])
  end
end

