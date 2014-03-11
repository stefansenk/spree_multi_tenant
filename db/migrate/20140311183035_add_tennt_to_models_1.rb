class AddTenntToModels1 < ActiveRecord::Migration
  def change
    tables = [
      "spree_payment_capture_events",
      "spree_promotions",
      "spree_shipping_method_categories",
      "spree_shipping_rates",
      "spree_stock_movements",
    ]
    tables.each do |table|
      add_column table, :tenant_id, :integer
      add_index table, :tenant_id
    end
  end
end
