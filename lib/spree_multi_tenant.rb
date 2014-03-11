require 'spree_core'
require 'spree_multi_tenant/engine'
require 'multitenant'

module SpreeMultiTenant
  def self.tenanted_models
    [
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
      Spree::OptionType,
      Spree::OptionValue,
      Spree::Order,
      Spree::PaymentMethod,
      Spree::Payment,
      Spree::PaymentCaptureEvent,
      Spree::Preference,
      Spree::ProductOptionType,
      Spree::ProductProperty,
      Spree::Product,
      Spree::Property,
      Spree::Prototype,
      Spree::ReturnAuthorization,
      Spree::Role,
      Spree::Shipment,
      Spree::ShippingCategory,
      Spree::ShippingMethod,
      Spree::ShippingMethodCategory,
      Spree::ShippingRate,
      Spree::StateChange,
      Spree::State,
      Spree::StockMovement,
      Spree::TaxCategory,
      Spree::TaxRate,
      Spree::Taxonomy,
      Spree::Taxon,
      Spree::TokenizedPermission,
      Spree::Tracker,
      Spree::User,
      Spree::Variant,
      Spree::ZoneMember,
      Spree::Zone,

      # Spree::OptionTypesPrototype,
      # Spree::OptionValuesVariant,
      # Spree::PendingPromotion,
      # Spree::ProductScope,
      # Spree::ProductsPromotionRule,
      # Spree::ProductsTaxon,
      # Spree::PromotionRulesUser,
      # Spree::PropertiesPrototype,
      # Spree::RolesUser,

      Spree::Promotion,
      Spree::PromotionRule,
      Spree::PromotionAction,
      Spree::PromotionActionLineItem,
      Spree::Promotion::Actions::CreateLineItems,
      Spree::Promotion::Actions::CreateAdjustment,
      Spree::Promotion::Rules::FirstOrder,
      Spree::Promotion::Rules::ItemTotal,
      Spree::Promotion::Rules::Product,
      Spree::Promotion::Rules::User,
      Spree::Promotion::Rules::UserLoggedIn,
    ]
  end

  def self.tenanted_controllers
    [
      Spree::BaseController,
      Spree::UserPasswordsController,
      Spree::UserSessionsController,
      Spree::UserRegistrationsController
    ]
  end

  def self.with_tenant(tenant, &block)
    Multitenant.with_tenant tenant do
      SpreeMultiTenant.init_preferences
      yield
    end
  end

end

