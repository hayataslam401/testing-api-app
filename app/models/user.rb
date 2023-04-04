class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
  :jwt_authenticatable,
  :registerable,
  jwt_revocation_strategy: JwtDenylist
  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  validates :email, presence: true
  has_one_attached :avatar
end
