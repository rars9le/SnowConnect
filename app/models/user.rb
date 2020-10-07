class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable
  before_save do
    snow_style.gsub!(/[\[\]\"]/, "") if attribute_present?("snow_style")
    play_style.gsub!(/[\[\]\"]/, "") if attribute_present?("play_style")
  end
  mount_uploader :avator, AvatorUploader

  validates :name, presence: true, length: { maximum: 50 }
  validates :introduction, length: { maximum: 500 }
  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                    uniqueness: { case_sensitive: false }

  has_many :posts, dependent: :destroy

  has_many :relationships
  has_many :followings, through: :relationships, source: :follow, dependent: :destroy
  has_many :reverses_of_relationship, class_name: 'Relationship', foreign_key: 'follow_id'
  has_many :followers, through: :reverses_of_relationship, source: :user, dependent: :destroy

  has_many :favorites, dependent: :destroy
  has_many :like_posts, through: :favorites, source: :post
  has_many :messages
  has_many :entries, dependent: :destroy
  has_many :rooms, through: :entries

  enum sex: { man: 0, woman: 1 }

  def follow(other_user)
    unless self == other_user
      relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    followings.include?(other_user)
  end

  def favorite(post)
    favorites.find_or_create_by(post_id: post.id)
  end

  def unfavorite(post)
    favorite = favorites.find_by(post_id: post.id)
    favorite.destroy if favorite
  end

  def likes?(post)
    like_posts.include?(post)
  end

  # フォローされているか判定
  def followed_by?(user)
    reverses_of_relationship.find_by(follow_id: user.id).present?
  end

  def feed_posts
    Post.where(user_id: following_ids + [id])
  end

  # Like検索,ない場合は全てを返す
  def self.search(search)
    return Post.includes(:user) unless search
    Post.where(['content LIKE ?', "%#{search}%"])
  end
end
