class PostsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :destroy]
  before_action :set_target_post, only: [:destroy]
  before_action :correct_user, only: [:destroy]

  def index
    @posts = Post.page(params[:page]).per(PER)
    @posts = @posts.includes(:user, :comments)
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
    flash[:success] = '投稿を削除しました。'
    redirect_back(fallback_location: root_path)
  end

  def feed
    return unless user_signed_in?
    @post = Post.new(flash[:post])
    @comment = Comment.new(flash[:comment])
    @feed_posts = current_user.feed_posts.page(params[:page]).per(PER)
    @feed_posts = @feed_posts.includes(:user, :comments)
  end

  def popular
    @comment = Comment.new(flash[:comment])
    @popular_posts = Post.unscoped.joins(:favorites).group(:post_id).order('count(favorites.user_id) desc').page(params[:page]).per(PER)
    @popular_posts = @popular_posts.includes(:user, :comments)
  end

  private

  def post_params
    params.require(:post).permit(:content, :image)
  end

  def correct_user
    redirect_to(root_url) unless (@post.user == current_user) || current_user.admin?
  end

  def set_target_post
    @post = Post.find(params[:id])
  end
end
