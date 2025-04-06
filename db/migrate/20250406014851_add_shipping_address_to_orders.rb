class AddShippingAddressToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :address_line1, :string
    add_column :orders, :address_line2, :string
    add_column :orders, :city, :string
    add_column :orders, :state, :string
    add_column :orders, :zip_code, :string
    add_column :orders, :country, :string
  end
end
