class Coupon < ApplicationRecord
    has_many :orders
    has_many :coupon_usages
    has_many :users, through: :coupon_usages
end
