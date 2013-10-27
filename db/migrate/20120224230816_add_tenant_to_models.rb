class AddTenantToModels < ActiveRecord::Migration
  def change
    tables = [
      "spree_activators",
      "spree_addresses",
      "spree_adjustments",
      "spree_assets",
      "spree_calculators",
      "spree_configurations",
      "spree_countries",
      "spree_credit_cards",
      "spree_payment_methods",
      "spree_inventory_units",
      "spree_line_items",
      "spree_log_entries",
      "spree_option_types",
      "spree_option_values",
      "spree_orders",
      "spree_payments",
      "spree_preferences",
      "spree_product_option_types",
      "spree_product_properties",
      "spree_products",
      "spree_promotion_action_line_items",
      "spree_promotion_actions",
      "spree_promotion_rules",
      "spree_properties",
      "spree_prototypes",
      "spree_return_authorizations",
      "spree_roles",
      "spree_shipments",
      "spree_shipping_categories",
      "spree_shipping_methods",
      "spree_state_changes",
      "spree_states",
      "spree_tax_categories",
      "spree_tax_rates",
      "spree_taxonomies",
      "spree_taxons",
      "spree_tokenized_permissions",
      "spree_trackers",
      "spree_users",
      "spree_variants",
      "spree_zone_members",
      "spree_zones",
    ]
    tables.each do |table|
      add_column table, :tenant_id, :integer
      add_index table, :tenant_id
    end
  end
end

