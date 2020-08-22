class Post < ApplicationRecord
  belongs_to :user
  
  validates :content, presence: true, length: { maximum: 255 }
    
  has_many :favorites, dependent: :destroy
  has_many :favoriter, through: :favorites, source: :users
  has_many :comments, dependent: :destroy

  default_scope -> { order(created_at: :DESC) }

  #Like検索,ない場合は全てを返す
  def self.search(search)
    return Post.all unless search
    Post.where(['content LIKE ?', "%#{search}%"])
  end
  
end
