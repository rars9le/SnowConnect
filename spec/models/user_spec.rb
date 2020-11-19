# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  admin                  :boolean          default(FALSE)
#  age                    :integer
#  age_open_range         :integer
#  avator                 :string(255)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  guest                  :boolean          default(FALSE)
#  home_gelande           :string(255)
#  introduction           :text(65535)
#  name                   :string(255)      not null
#  play_style             :string(255)
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string(255)
#  sex                    :integer
#  sex_open_range         :integer
#  snow_style             :string(255)
#  unconfirmed_email      :string(255)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#
# Indexes
#
#  index_users_on_confirmation_token    (confirmation_token) UNIQUE
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = build(:user)
  end

  it '有効なファクトリを持つこと' do
    expect(build(:user)).to be_valid
  end

  it '名前、メール、パスワードがある場合、有効であること' do
    user = User.new(
      name: 'TestUser',
      email: 'test@expample.com',
      password: 'password'
    )
    expect(user).to be_valid
  end

  describe '存在性の検証' do
    it '名前がない場合、無効であること' do
      @user.name = nil
      @user.valid?
      expect(@user).to_not be_valid
    end

    it "メールアドレスがない場合、無効である"  do
      @user.email = ''
      @user.valid?
      expect(@user).to_not be_valid
    end

    it "パスワードがない場合、無効である" do
      @user.password = @user.password_confirmation = ' ' * 8
      @user.valid?
      expect(@user).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it '名前が51文字以上の場合、無効であること' do
      @user.name = 'a' * 51
      expect(@user).to_not be_valid
    end

    it '自己紹介が150文字以内の場合、有効であること' do
      @user.introduction = 'a' * 150
      expect(@user).to be_valid
    end

    it '自己紹介が151文字以上の場合、無効であること' do
      @user.introduction = 'a' * 151
      expect(@user).to_not be_valid
    end

    it 'メールアドレスが255文字以内の場合、有効であること' do
      @user.email = 'a' * 243 + '@example.com'
      expect(@user).to be_valid
    end

    it 'メールアドレスが255文字を越える場合、無効であること' do
      @user.email = 'a' * 244 + '@example.com'
      @user.valid?
      expect(@user.errors).to be_added(:email, :too_long, count: 255)
    end

    it 'パスワードが8文字以上の場合、有効であること' do
      @user.password = @user.password_confirmation = 'a' * 8
      expect(@user).to be_valid
    end

    it 'パスワードが8文字未満の場合、無効であること' do
      @user.password = @user.password_confirmation = 'a' * 7
      @user.valid?
      expect(@user.errors).to be_added(:password, :too_short, count: 8)
    end
  end

  describe '一意性の検証' do
    it '重複したメールアドレスの場合、無効であること' do
      user1 = create(:user, name: 'taro', email: 'taro@example.com')
      user2 = build(:user, name: 'ziro', email: user1.email)
      expect(user2).to_not be_valid
    end

    it 'メールアドレスは大文字小文字を区別せず扱うこと' do
      create(:user, email: 'sample@example.com')
      duplicate_user = build(:user, email: 'SAMPLE@EXAMPLE.COM')
      duplicate_user.valid?
      expect(duplicate_user.errors).to be_added(:email, :taken, value: 'sample@example.com')
    end
  end

  describe 'パスワードの検証' do
    it 'パスワードと確認用パスワードが間違っている場合、無効であること' do
      @user.password = 'password'
      @user.password_confirmation = 'pass'
      expect(@user).to_not be_valid
    end

    it 'パスワードが暗号化されていること' do
      user = create(:user)
      expect(user.encrypted_password).to_not eq 'password'
    end
  end

  describe 'フォーマットの検証' do
    it 'メールアドレスが正常なフォーマットの場合、有効であること' do
      valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                          first.last@foo.jp user1+user2@baz.cn]
      valid_addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end

    it 'メールアドレスが不正なフォーマットの場合、無効であること' do
      expect(build(:user, email: 'user@example,com')).to_not be_valid
      expect(build(:user, email: 'user_at_foo.org')).to_not be_valid
      expect(build(:user, email: 'user.name@example.')).to_not be_valid
      expect(build(:user, email: 'foo@bar_baz.com')).to_not be_valid
      expect(build(:user, email: 'foo@bar+baz.com')).to_not be_valid
    end
  end

  describe 'メソッド' do
    it 'ユーザーをフォロー/フォロー解除できること' do
      user1 = create(:user)
      user2 = create(:user)
      expect(user1.followed_by?(user2)).to eq false
      user2.follow(user1)
      expect(user1.followed_by?(user2)).to eq true
      user2.unfollow(user1)
      expect(user1.followed_by?(user2)).to eq false
    end
  end

  describe 'その他' do
    it 'メールアドレスがすべて小文字で保存されること' do
      @user.email = 'TeSt@ExaMPle.CoM'
      @user.save!
      expect(@user.reload.email).to eq 'test@example.com'
    end

    it 'ユーザーを削除すると、関連する投稿も削除されること' do
      user = create(:user, :with_posts, posts_count: 1)
      expect { user.destroy }.to change { Post.count }.by(-1)
    end

    it 'ユーザーを削除すると、関連するコメントも削除されること' do
      user = create(:user, :with_comments, comments_count: 1)
      expect { user.destroy }.to change { Comment.count }.by(-1)
    end

    it 'ユーザーを削除すると、関連するいいねも削除されること' do
      user = create(:user)
      post = create(:post)
      user.favorite(post)
      expect(post.liked_by?(user)).to eq true
      expect { user.destroy }.to change { user.like_posts.count }.by(-1)
    end

    it 'ユーザーを削除すると、フォローしているユーザーとの関係も削除されること' do
      user = create(:user)
      following_user = create(:user)
      user.follow(following_user)
      expect(following_user.followed_by?(user)).to eq true
      expect { user.destroy }.to change { following_user.followers.count }.by(-1)
    end

    it 'ユーザーを削除すると、フォロワーのユーザーとの関係も削除されること' do
      user = create(:user)
      follower_user = create(:user)
      follower_user.follow(user)
      expect(user.followed_by?(follower_user)).to eq true
      expect { user.destroy }.to change { follower_user.followings.count }.by(-1)
    end
  end
end
