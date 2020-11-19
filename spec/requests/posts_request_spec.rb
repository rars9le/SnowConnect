require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  describe '#create' do
    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        post_params = attributes_for(:post)
        post posts_path, params: { post: post_params }
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end
  end

  describe '#destroy' do
    let!(:post) { create(:post) }

    context '未ログイン状態のとき' do
      it 'ログインページにリダイレクトされること' do
        delete post_path(post)
        expect(response).to have_http_status 302
        expect(response).to redirect_to '/login'
      end
    end

    context '認可されていないユーザーがアクセスした場合' do
      it '投稿を削除できず、一覧ページにリダイレクトされること' do
        another_user = create(:user)
        sign_in another_user
        expect { delete post_path(post) }.to change { Post.count }.by(0)
        expect(response).to redirect_to root_path
      end
    end
  end
end
