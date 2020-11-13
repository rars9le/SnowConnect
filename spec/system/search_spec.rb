require 'rails_helper'

RSpec.describe 'Search', type: :system do
  let!(:user1) do
    create(:user,
           name: 'User1',
           age: 10
           sex: 0
           introduction: 'スノーボーダーです'
           snow_style: 'スノーボーダー'
           play_style: 'フリーラン'
           home_gelande: 'スカイバレイ'
           email: 'user1@example.com',
           password: 'password_user1')
  end
  let!(:user2) do
    create(:user,
           name: 'User2',
           age: 20
           sex: 1
           introduction: 'スキーヤーです'
           snow_style: 'スキーヤー'
           play_style: 'パウダー'
           home_gelande: 'ハチ北'
           email: 'user2@example.com',
           password: 'password_user2')
  end
  let!(:user3) do
    create(:user,
           name: 'User3',
           age: nil
           sex: nil
           introduction: 'スノースクートです'
           snow_style: ''
           play_style: ''
           home_gelande: ''
           email: 'user3@example.com',
           password: 'password_user3')
  end

  before '検索ページへ移動する' do
    visit root_path
    click_link '検索'
    expect(current_path).to eq search_users_path
  end

  describe 'ユーザーを検索する', js: true do
    it '内容で検索できること' do
      # 内容「スノーボーダー」で検索する
      fill_in '内容', with: 'スノーボーダー'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 内容「曇り」で検索する
      fill_in '内容', with: '曇り'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 内容「雨」で検索する
      fill_in '内容', with: '雨'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"

      # 内容「今日」で検索する
      fill_in '内容', with: '今日'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end

    it '都道府県で検索できること' do
      # 「北海道」で検索する
      select '北海道', from: '都道府県'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「東京都」で検索する
      select '東京都', from: '都道府県'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「沖縄県」で検索する
      select '沖縄県', from: '都道府県'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end

    it '都道府県、市区町村で検索できること' do
      # 「北海道」で検索する
      select '北海道', from: '都道府県'
      select '札幌市中央区', from: '市区町村'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「東京都」で検索する
      select '東京都', from: '都道府県'
      select '渋谷区', from: '市区町村'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 「沖縄県」で検索する
      select '沖縄県', from: '都道府県'
      select '那覇市', from: '市区町村'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end

    it '天気で検索できること' do
      # 天気「晴れ」で検索する
      select '晴れ', from: '天気'
      click_button '検索する'
      expect(page).to have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 天気「曇り」で検索する
      select '曇り', from: '天気'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post3.id}"

      # 天気「雨」で検索する
      select '雨', from: '天気'
      click_button '検索する'
      expect(page).to_not have_link 'a', href: "/posts/#{post1.id}"
      expect(page).to_not have_link 'a', href: "/posts/#{post2.id}"
      expect(page).to have_link 'a', href: "/posts/#{post3.id}"
    end
  end
end
