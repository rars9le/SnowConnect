require 'rails_helper'

RSpec.describe 'Signup', type: :system do
  let!(:user) do
    create(:user,
           name: 'TestUser',
           email: 'test@example.com',
           password: '12345678')
  end

  it '新規ユーザーを作成し、ログインする' do
    visit root_path

    click_link '新規登録'
    expect(current_path).to eq signup_path
    expect(page).to have_content '新規ユーザー登録'

    # 失敗ケース
    fill_in 'ユーザー名（１０文字以内）', with: 'a' * 11
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード（８文字以上）', with: 'password_test'
    fill_in '確認用パスワード', with: 'password_test2'

    click_button '新規登録'
    expect(page).to have_content 'エラーが発生したため ユーザ は保存されませんでした。'
    expect(page).to have_content 'ユーザー名は10文字以内で入力してください'
    expect(page).to have_content 'メールアドレスはすでに存在します'
    expect(page).to have_content '確認用パスワードとパスワードの入力が一致しません'

    # 成功ケース
    fill_in 'ユーザー名（１０文字以内）', with: 'Test'
    fill_in 'メールアドレス', with: 'test@example.com'
    fill_in 'パスワード（８文字以上）', with: 'password_test'
    fill_in '確認用パスワード', with: 'password_test'
    expect do
      click_button '新規登録'
      expect(current_path).to eq feed_posts_path
      expect(page).to have_content 'Testさん'
    end.to change(User, :count).by(1)

    aggregate_failures do
      testUser = User.find_by!(name: 'test')
      expect(testUser.name).to eq 'Test'
      expect(testUser.email).to eq 'test@example.com'
    end
  end
end