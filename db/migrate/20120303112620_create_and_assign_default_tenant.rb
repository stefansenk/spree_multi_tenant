class CreateAndAssignDefaultTenant < ActiveRecord::Migration
  def up
    models = [
      Spree::Activator,
      Spree::Address,
      Spree::Adjustment,
      Spree::Asset,
      Spree::Calculator,
      Spree::Configuration,
      Spree::Country,
      Spree::CreditCard,
      Spree::Gateway,
      Spree::InventoryUnit,
      Spree::LineItem,
      Spree::LogEntry,
      Spree::MailMethod,
      Spree::OptionType,
      # Spree::OptionTypesPrototype,
      Spree::OptionValue,
      # Spree::OptionValuesVariant,
      Spree::Order,
      Spree::PaymentMethod,
      Spree::Payment,
      # Spree::PendingPromotion,
      Spree::Preference,
      Spree::ProductOptionType,
      Spree::ProductProperty,
      Spree::Product,
      # Spree::ProductsPromotionRule,
      # Spree::ProductsTaxon,
      Spree::PromotionActionLineItem,
      Spree::PromotionAction,
      Spree::PromotionRule,
      # Spree::PromotionRulesUser,
      Spree::Property,
      # Spree::PropertiesPrototype,
      Spree::Prototype,
      Spree::ReturnAuthorization,
      Spree::Role,
      # Spree::RolesUser,
      Spree::Shipment,
      Spree::ShippingCategory,
      Spree::ShippingMethod,
      Spree::StateChange,
      Spree::State,
      Spree::TaxCategory,
      Spree::TaxRate,
      Spree::Taxonomy,
      Spree::Taxon,
      Spree::TokenizedPermission,
      Spree::Tracker,
      Spree::User,
      Spree::Variant,
      Spree::ZoneMember,
      Spree::Zone
    ]

    # Create the first tenant - change domain and code as appropriate
    tenant = Spree::Tenant.new
    tenant.domain = "example"
    tenant.code = "example"
    tenant.save!
    tenant.create_template_and_assets_paths

    # Assign all existing items to the tenant
    models.each do |model|
      model.all.each do |item|
        item.update_attribute(:tenant_id, tenant.id)
      end
    end
  end

  def down
  end
end
