# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Faker::Config.locale = :ja

# 管理者ユーザー作成
User.create!(name:  "AdminUser",
  email: "admin@example.com",
  password:  "12345678",
  password_confirmation: "12345678",
  admin: true)

# ゲストユーザー作成
User.create!(name:  "GuestUser",
  email: "guest@example.com",
  password:  "12345678",
  password_confirmation: "12345678",
  guest: true)

# ユーザー作成
1.upto(49) do |i|
  name  = Faker::Name.name
  email = "sample-#{i}@example.com"
  password = 'password'
  User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password,
                confirmed_at: Time.zone.now,
                confirmation_sent_at: Time.zone.now)
end

# ユーザーアバター生成
users = User.order(:id).take(10)
users.each_with_index do |user, i|
  user.avator = open("#{Rails.root}/db/fixtures/avator/avator-#{i + 1}.jpg")
  user.save
end

# Post作成
i = 0
users = User.order(:id).take(3)

users.each do
  1.upto(7) do |j|
    j = ((i * 7) + j)
    image = open("#{Rails.root}/db/fixtures/post/post-#{j}.jpg")
    content = Faker::Lorem.sentence

    users[i].posts.create!(
      image: image,
      content: content,
      created_at: i.zero? ? Time.zone.now : rand(Time.zone.yesterday.beginning_of_day..Time.zone.yesterday.end_of_day)
    )
  end
  i += 1
end

# お気に入りデータ作成
users = User.order(:id).take(5)
posts = Post.order(:id).take(10)
users.each do |user|
  posts.each do |post|
    user.favorite(post) unless user.id == post.user_id
  end
end

# リレーションシップ
users = User.all
user_array = [users.find(1), users.find(2), users.find(3), users.find(4), users.find(5)]
user_array.each_with_index do |user, index|
  following = users[index + 2..index + 40]
  followers = users[index + 3..index + 30]
  following.each { |followed| user.follow(followed) }
  followers.each { |follower| follower.follow(user) }
end