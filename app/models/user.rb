class User < ApplicationRecord
    has_secure_password
    has_many :bookmarks, dependent: :destroy
    has_many :papers, through: :bookmarks
    
    validates :email, presence: true, uniqueness: true
    validates :username, presence: true, uniqueness: true
  end
  