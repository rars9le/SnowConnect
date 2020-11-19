# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

User.create!(name:  "管理者",
  email: "admin@example.com",
  password:  "12345678",
  password_confirmation: "12345678",
  admin: true)

User.create!(name:  "GuestUser",
  email: "guest@example.com",
  password:  "12345678",
  password_confirmation: "12345678",
  guest: true)

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