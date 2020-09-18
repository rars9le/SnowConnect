class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 255 }
  mount_uploader :image, ImageUploader
  
  has_many :favorites, dependent: :destroy
  has_many :favoriter, through: :favorites, source: :users
  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :DESC) }
  
end
