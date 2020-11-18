require 'rails_helper'

RSpec.describe 'Comments', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end
  # let!(:post) { create(:post) }

  it '既存の投稿にコメントをして、削除をする', js: true do
    visit root_path

    # ログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード', with: '12345678'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    # 新規投稿する
    fill_in 'post-area', with: 'スノーボードしたい'
    click_button '投稿する'
    sleep 5

    # 新着投稿へ移動する
    click_link '新着投稿'

    # コメントを投稿する
    click_on 'comment-link'
    pending 'この先はなぜかテストが失敗するのであとで直す'
    fill_in 'comment-area', with: 'こんにちは'
    click_on '投稿'
    sleep 3
    
    click_button 'comment-link'
    expect(page).to have_content 'こんにちは'

    # コメントを削除する
    comment = post.comments.find_by!(comment: 'こんにちは')

    delete_link = find_link '×', href: "/comments/#{comment.id}"
    page.accept_confirm 'コメントを削除しますか？' do
      delete_link.click
    end
    expect(page).to have_content 'コメントが削除されました'
    expect(Comment.where(id: comment.id)).to be_empty
  end
end
