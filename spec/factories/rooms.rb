# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
FactoryBot.define do
  factory :room do
    created_at { Faker::Time.between(from: DateTime.now - 2, to: DateTime.now) }
  end
end