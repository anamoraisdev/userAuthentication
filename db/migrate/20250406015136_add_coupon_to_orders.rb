class AddCouponToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :coupon_id, :integer
  end
end
