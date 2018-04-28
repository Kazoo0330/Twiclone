class User < ApplicationRecord
  mount_uploader :image, ImageUploader
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }, uniqueness: true
  
  before_save { email.downcase! }
  
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }

  has_many :favorites, dependent: :destroy
  has_many :favorite_posts, through: :favorites, source: :post
end
