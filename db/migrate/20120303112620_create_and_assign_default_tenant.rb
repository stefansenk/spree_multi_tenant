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
      Spree::Creditcard,
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
      Spree::ProductGroup,
      # Spree::ProductGroupsProduct,
      Spree::ProductOptionType,
      Spree::ProductProperty,
      Spree::ProductScope,
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
      Spree::StateEvent,
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
    domain = "example"
    code = "example"
    tenant = Spree::Tenant.create!({:domain => domain, :code => code})
    tenant.create_templates_path

    # Assign all existing items to the tenant
    models.each do |model|
      model.all.each do |item|
        item.tenant = tenant
        item.save!
      end
    end
  end

  def down
  end
end
