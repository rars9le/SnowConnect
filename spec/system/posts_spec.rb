require 'rails_helper'

RSpec.describe 'Posts', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end

  it '新規投稿、編集、削除をする', js: true do
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
    click_link "新規投稿"
    expect(current_path).to eq new_post_path
    expect(page).to have_content '新規投稿'

    attach_file 'post[image]', "#{Rails.root}/spec/fixtures/test.jpg", make_visible: true
    fill_in '内容', with: 'スノーボードしたい'
    click_button '投稿する'
    sleep 5

    post = Post.first
    aggregate_failures do
      expect(post.content).to eq 'スノーボードしたい'
    end

    # 投稿を削除する
    delete_link = find_link '×'
    page.accept_confirm '投稿を削除してもよろしいですか？' do
      delete_link.click
    end
    sleep 1

    expect(page).to have_content "投稿を削除しました"
    expect(Post.where(id: post.id)).to be_empty
  end

  describe 'フィード関係' do
    let!(:user1) { create(:user, name: 'user1') }
    let!(:user2) { create(:user, name: 'user2') }
    let!(:user3) { create(:user, name: 'user3') }

    let!(:user1_post) { create(:post, user: user1) }
    let!(:user2_post) { create(:post, user: user2) }
    let!(:user3_post) { create(:post, user: user3) }

    before 'user1でログインする' do
      visit root_path

      click_link 'ログイン'
      expect(current_path).to eq login_path
      expect(page).to have_content '次回から自動的にログイン'

      fill_in 'メールアドレス', with: user1.email
      fill_in 'パスワード', with: user1.password
      click_button 'ログイン'
      expect(current_path).to eq feed_posts_path
    end

    it 'フィードに自身の投稿が表示されるか' do
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'user1'
        expect(page).to_not have_link 'user2'
        expect(page).to_not have_link 'user3'
      end
    end

    it '他のユーザーをフォローし、フィードに表示されるか' do
      user1.follow(user2)
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'user1'
        expect(page).to have_link 'user2'
        expect(page).to_not have_link 'user3'
      end
    end

    it '他のユーザーをアンフォローし、フィードから消えるか' do
      user1.follow(user2)
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'user1'
        expect(page).to have_link 'user2'
        expect(page).to_not have_link 'user3'
      end

      user1.unfollow(user2)
      click_link 'フィード'
      within(:css, '.post-cards') do
        expect(page).to have_link 'user1'
        expect(page).to_not have_link 'user2'
        expect(page).to_not have_link 'user3'
      end
    end
  end
end
