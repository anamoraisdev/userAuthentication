class Order < ApplicationRecord
  belongs_to :user
  has_many :order_items, dependent: :destroy
  has_many :products, through: :order_items
  belongs_to :coupon, optional: true

  enum status: { pending: 'pending', paid: 'paid', cancelled: 'cancelled', shipped: 'shipped' }
end
