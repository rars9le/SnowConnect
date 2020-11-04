# == Schema Information
#
# Table name: posts
#
#  id         :bigint           not null, primary key
#  content    :text(65535)
#  image      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_posts_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
require 'rails_helper'

RSpec.describe Post, type: :model do
  let(:post) { create(:post) }

  it '有効なファクトリを持つこと' do
    expect(post).to be_valid
  end

  it '内容、画像、ユーザー、有効であること' do
    post.image = Rack::Test::UploadedFile.new(File.join(Rails.root, 'spec/fixtures/test.jpg'))
    expect(post).to be_valid
  end

  describe '存在性の検証' do
    it '内容がない場合、無効であること' do
      post.content = ''
      post.valid?
      expect(post).to_not be_valid
    end
    it 'ユーザーがない場合、無効であること' do
      post.user = nil
      post.valid?
      expect(post).to_not be_valid
    end
  end

  describe '文字数の検証' do
    it '内容が255文字以内の場合、有効であること' do
      post.content = 'a' * 255
      expect(post).to be_valid
    end
    it '内容が256文字以上の場合、無効であること' do
      post.content = 'a' * 256
      expect(post).to_not be_valid
    end
  end

  describe 'メソッド' do
    it '投稿をいいね/いいね解除できること' do
      user1 = create(:user)
      user2 = create(:user, :with_posts, posts_count: 1)
      expect(user2.posts.first.liked_by?(user1)).to eq false
      user1.favorite(user2.posts.first)
      expect(user2.posts.first.liked_by?(user1)).to eq true
      user1.unfavorite(user2.posts.first)
      expect(user2.posts.first.liked_by?(user1)).to eq false
    end
  end

  describe 'その他' do
    it '投稿が新しい順に並んでいること' do
      create(:post, created_at: 2.days.ago)
      most_recent_post = create(:post, created_at: Time.zone.now)
      create(:post, created_at: 5.minutes.ago)

      expect(most_recent_post).to eq Post.first
    end

    it '投稿を削除すると、関連するコメントも削除されること' do
      post = create(:post, :with_comments, comments_count: 1)
      expect { post.destroy }.to change { Comment.count }.by(-1)
    end

    it '投稿を削除すると、関連するいいねも削除されること' do
      post = create(:post, :with_likes, likes_count: 1)
      expect { post.destroy }.to change { Post.count }.by(-1)
    end
  end

end
