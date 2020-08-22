class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user

  default_scope -> { order(created_at: :desc) }

  validates :comment, presence: true, length: { maximum: 150 }
end
