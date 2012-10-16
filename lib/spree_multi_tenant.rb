require 'spree_core'
require 'spree_multi_tenant/engine'
require 'multitenant'

module SpreeMultiTenant
  def self.tenanted_models
    [
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
      #Spree::ProductScope,
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
  end

  def self.tenanted_controllers
    [
      Spree::BaseController,
      Spree::UserPasswordsController,
      Spree::UserSessionsController,
      Spree::UserRegistrationsController
    ]
  end

end

