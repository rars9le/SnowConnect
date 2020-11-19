class UsersController < ApplicationController
  before_action :authenticate_user!, only: [:index, :destroy]
  before_action :set_snowstyle, :set_playstyle, only: [:edit, :search]
  before_action :admin_user, only: [:destroy]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :confirmWithdrawal, :withdrawal, :followings, :followers, :likes]

  def index
    @users = User.order(id: :desc).page(params[:page]).per(PER)
  end

  def show
    @posts = @user.posts.includes(:comments).order(id: :desc).page(params[:page]).per(PER)
    @comment = Comment.new(flash[:comment])
    @followings = @user.followings.page(params[:page])
    @followers = @user.followers.page(params[:page])
    @like_posts = @user.like_posts.includes(:user, :comments).page(params[:page])

    if user_signed_in?
      @current_user_entry = Entry.where(user_id: current_user.id)
      @user_entry = Entry.where(user_id: @user.id)
      unless @user.id == current_user.id
        @current_user_entry.each do |cu|
          @user_entry.each do |u|
            if cu.room_id == u.room_id
              @have_room = true
              @room_id = cu.room_id
            end
          end
        end
        unless @have_room
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
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
      flash.now[:danger] = @user.errors.full_messages
      render :new
    end
  end

  def edit
    unless @user.snow_style.nil?
      @user_snow_style = User.where(id: @user.snow_style.split(','))
    end
    unless @user.play_style.nil?
      @user_play_style = User.where(id: @user.play_style.split(','))
    end
  end

  def update
    # パスワードがブランクの場合はvalidateを無視する
    if params[:user][:password].blank?
      params[:user].delete("password")
      params[:user].delete("password_confirmation")
    end
    if @user.update(user_params)
      flash[:success] = 'プロフィールが更新されました'
      redirect_to @user
    else
      flash[:danger] = @user.errors.full_messages
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "ユーザー「#{@user.name}」は正常に削除されました"
    redirect_to users_path
  end

  def like_posts; end

  def confirm_withdrawal
  end

  def withdrawal
    @user.destroy
    flash[:success] = "退会しました"
    redirect_to root_path
  end

  def followings
    @followings = @user.followings.page(params[:page])
    counts(@user)
  end

  def followers
    @followers = @user.followers.page(params[:page])
    counts(@user)
  end

  def likes
    @likes = @user.likes.page(params[:page])
    counts(@user)
  end

  def search
    @comment = Comment.new(flash[:comment])
    @q = User.ransack(params[:q])
    @users = @q.result.page(params[:page]).per(15)
  end

  private

  def set_snowstyle
    @snowstyle = SNOWSTYLE
  end

  def set_playstyle
    @playstyle = PLAYSTYLE
  end

  def user_params
    params.require(:user).permit(:name, :introduction, :email, :password, :password_confirmation, :sex, :age, :home_gelande, :age_open_range, :sex_open_range, :avator, :avator_cache, snow_style: [], play_style: [])
  end

  def search_params
    params.permit(:name_cont, :sex_eq, :age_qteq, :age_ltq, :home_gelande_cont, :snow_style_cont, :play_style_cont)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end

  def set_user
    @user = User.find(params[:id])
  end
end
