class AddCouponFieldsToCoupons < ActiveRecord::Migration[7.1]
  def change
    add_column :coupons, :expires_at, :datetime
    add_column :coupons, :usage_limit, :integer
  end
end
