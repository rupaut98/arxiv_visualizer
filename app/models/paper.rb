class Paper < ApplicationRecord
    has_many :bookmarks, dependent: :destroy
    has_many :users, through: :bookmarks
    has_many :citations, dependent: :destroy
    
    validates :arxiv_id, presence: true, uniqueness: true
  end
  