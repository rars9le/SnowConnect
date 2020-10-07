class ApplicationController < ActionController::Base
  include ApplicationHelper
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  # ページネーション[1ページ表示数]
  PER = 12

  def counts(user)
    @count_posts = user.posts.count
    @count_followings = user.followings.count
    @count_followers = user.followers.count
    @count_likes = user.likes.count
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :avator, :introduction, :sex, :age, :snow_style, :play_style, :home_gelande, :age_open_range, :sex_open_range])
  end
end
