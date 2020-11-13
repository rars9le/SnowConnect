require 'rails_helper'

RSpec.describe 'Relationships', type: :system do
  let!(:user1) do
    create(:user,
           name: 'User1',
           email: 'user1@example.com',
           password: 'password_user1')
  end
  let!(:user2) do
    create(:user,
           name: 'User2',
           email: 'user2@example.com',
           password: 'password_user2')
  end
  let!(:user2_post) do
    create(:post, user: user2)
  end

  it 'ユーザーをフォロー/フォロー解除する', js: true do
    visit root_path

    # user2がログインする
    click_link 'ログイン'
    expect(current_path).to eq login_path
    expect(page).to have_content '次回から自動的にログイン'

    fill_in 'メールアドレス', with: 'user1@example.com'
    fill_in 'パスワード', with: 'password_user1'
    click_button 'ログイン'
    expect(current_path).to eq feed_posts_path

    # user1のページへ移動する
    click_link '新着投稿'
    click_link 'User1'
    expect(current_path).to eq "/users/#{user1.id}"

    # user1をフォローする
    expect(page).to have_content 'フォロワー 0'
    expect do
      click_link 'フォロー'
      expect(page).to have_content 'フォロワー 1'
      expect(page).to_not have_content 'フォロワー 0'
      expect(page).to have_content 'フォロー中'
    end.to change(user2.followings, :count).by(1) &
           change(user1.followers, :count).by(1)

    # マイページ(user2)に移動する
    visit user_path(user2)
    expect(current_path).to eq "/users/#{user2.id}"
    expect(page).to have_content 'フォロー 1'
    expect(page).to have_content 'user1'
    expect(page).to have_content 'フォロー中'

    # user1のフォローを解除する
    expect do
      click_link 'フォロー中'
      expect(page).to have_content 'フォロー 0'
      expect(page).to_not have_content 'フォロー 1'
    end.to change(user2.followings, :count).by(-1) &
           change(user1.followers, :count).by(-1)

    visit user_path(user1)
    expect(find('.tab-content')).to_not have_content 'user1'
    expect(page).to have_content '誰もフォローしていません'

    # user2のユーザーページに移動する
    visit user_path(user2)
    expect(find('.tab-content')).to_not have_content 'user2'
    expect(page).to have_content 'フォローされていません'
  end
end
