class AddDiscountAmountToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :discount_amount, :decimal
  end
end
