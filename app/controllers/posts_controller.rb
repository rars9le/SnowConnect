class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :correct_user, only: [:destroy]

  def index
    @posts = Post.page(params[:page]).per(PER)
    @posts = @posts.includes(:user)
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = '投稿が完了しました。'
      redirect_to root_url
    else
      @posts = current_user.feed_posts.order(id: :desc).page(params[:page])
      flash.now[:danger] = '投稿に失敗しました。'
      render root_url
    end
  end

  def destroy
    @post.destroy
    flash[:success] = 'メッセージを削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def feed
    return unless user_signed_in?

    @feed_posts = current_user.feed_posts.page(params[:page]).per(PER)
    @feed_posts = @feed_posts.includes(:user)
  end

  def popular   
    #@popular_posts = Post.all.order('count(favorites.user_id) desc').page(params[:page]).per(PER)
    @popular_posts = Post.unscoped.joins(:favorites).group(:post_id).order('count(favorites.user_id) desc').page(params[:page]).per(PER)
    @popular_posts = @popular_posts.includes(:user)
  end

  def search
    @posts = Post.search(params[:search]).page(params[:page])
  end

  private

  def post_params
    params.permit(:content)
  end

  def correct_user
    redirect_to(root_url) unless (@post.user == current_user)
  end

end
