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
class Post < ApplicationRecord
  belongs_to :user

  validates :content, presence: true, length: { maximum: 255 }
  mount_uploader :image, ImageUploader

  has_many :favorites, dependent: :destroy
  has_many :favoriter, through: :favorites, source: :users
  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :DESC) }

  # お気に入りされているか判定
  def liked_by?(user)
    likes.where(user_id: user.id).exists?
  end

end
