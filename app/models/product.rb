class Product < ApplicationRecord
    has_many_attached :images
    has_and_belongs_to_many :collections
    belongs_to :category

    has_many :favorites, dependent: :destroy
    has_many :favorited_by_users, through: :favorites, source: :user
end
