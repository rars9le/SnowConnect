class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :set_snowstyle, :set_playstyle, only: %i[edit]
  before_action :admin_user, only: :destroy

  def index
    @users = User.order(id: :desc).page(params[:page]).per(PER)
  end
  
  def show
    @user = User.find(params[:id])
    @posts = @user.posts.includes(:user).order(id: :desc).page(params[:page])
    @followings = @user.followings.page(params[:page])
    @followers = @user.followers.page(params[:page])
    @like_posts = @user.like_posts.includes(:user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = 'ユーザを登録しました。'
      redirect_to :login
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end

  def edit
    @user = User.find(params[:id])
    unless @user.snow_style.nil?
      @user_snow_style = User.where(id: @user.snow_style.split(','))
    end
    unless @user.play_style.nil?
      @user_play_style = User.where(id: @user.play_style.split(','))
    end
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      flash[:success] = 'プロフィールが更新されました'
      redirect_to @user
    else
      flash.now[:danger] = 'プロフィールは更新されませんでした'
      redirect_to @user
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "ユーザー「#{@user.name}」は正常に削除されました"
    redirect_to users_path
  end

  def confirmWithdrawal
    @user = User.find(params[:id])
  end

  def withdrawal
    @user = User.find(params[:id])
    @user.destroy
    flash[:success] = "退会しました"
    redirect_to root_path
  end

  def followings
    @user = User.find(params[:id])
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end
  
  def followers
    @user = User.find(params[:id])
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def likes
    @user = User.find(params[:id])
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end
  
  def favoriters
    @user = User.find(params[:id])
    @favoriters = @user.favoriters.page(params[:page])
    counts(@user)
  end

  def set_snowstyle
    @snowstyle = SNOWSTYLE
  end

  def set_playstyle
    @playstyle = PLAYSTYLE
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :password_confirmation, :sex, :age, :home_gelande, :age_open_range, :sex_open_range, :avator, snow_style:[], play_style:[])
  end
  
  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

end
