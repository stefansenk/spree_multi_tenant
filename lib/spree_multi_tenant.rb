require 'spree_core'
require 'spree_multi_tenant/engine'
require 'multitenant'

module SpreeMultiTenant
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.reset
    @configuration = Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.tenanted_models
    [
      Spree::Address,
      Spree::Adjustment,
      Spree::Asset,
      Spree::Calculator,
      Spree::Country,
      Spree::CreditCard,
      Spree::Gateway,
      Spree::CustomerReturn,
      Spree::InventoryUnit,
      Spree::LineItem,
      Spree::LogEntry,
      Spree::OptionType,
      Spree::OptionTypePrototype,
      Spree::OptionValue,
      Spree::OptionValueVariant,
      Spree::Order,
      Spree::OrderPromotion,
      Spree::PaymentMethod,
      Spree::Payment,
      Spree::PaymentCaptureEvent,
      Spree::Preference,
      Spree::Price,
      Spree::ProductOptionType,
      Spree::ProductPromotionRule,
      Spree::ProductProperty,
      Spree::Product,
      Spree::Classification,
      Spree::Property,
      Spree::PropertyPrototype,
      Spree::Prototype,
      Spree::PrototypeTaxon,
      Spree::RefundReason,
      Spree::Refund,
      Spree::Reimbursement::Credit,
      Spree::ReimbursementType,
      Spree::Reimbursement,
      Spree::ReturnAuthorizationReason,
      Spree::ReturnAuthorization,
      Spree::ReturnItem,
      Spree::Role,
      Spree::RoleUser,
      Spree::Shipment,
      Spree::ShippingCategory,
      Spree::ShippingMethod,
      Spree::ShippingMethodCategory,
      Spree::ShippingMethodZone,
      Spree::ShippingRate,
      Spree::StateChange,
      Spree::State,
      Spree::StockItem,
      Spree::StockLocation,
      Spree::StockMovement,
      Spree::StockTransfer,
      Spree::StoreCreditCategory,
      Spree::StoreCreditEvent,
      Spree::StoreCreditType,
      Spree::StoreCredit,
      Spree::Store,
      Spree::TaxCategory,
      Spree::TaxRate,
      Spree::Taxonomy,
      Spree::Taxon,
      Spree::Variant,
      Spree::ZoneMember,
      Spree::Zone,

      Spree::Promotion,
      Spree::PromotionAction,
      Spree::Promotion::Actions::CreateAdjustment,
      Spree::Promotion::Actions::CreateItemAdjustments,
      Spree::Promotion::Actions::CreateLineItems,
      Spree::Promotion::Actions::FreeShipping,
      Spree::PromotionActionLineItem,
      Spree::PromotionCategory,
      Spree::PromotionRule,
      Spree::Promotion::Rules::Country,
      Spree::Promotion::Rules::FirstOrder,
      Spree::Promotion::Rules::ItemTotal,
      Spree::Promotion::Rules::OneUsePerUser,
      Spree::Promotion::Rules::OptionValue,
      Spree::Promotion::Rules::Product,
      Spree::Promotion::Rules::Taxon,
      Spree::Promotion::Rules::UserLoggedIn,
      Spree::Promotion::Rules::User,
      Spree::PromotionRuleTaxon,
      Spree::PromotionRuleUser,
    ] +
    [
      'Spree::User',
      'Spree::Tag'
    ].map(&:safe_constantize).compact
  end

  def self.tenanted_controllers
    [
      Spree::BaseController,
      Spree::Api::BaseController,
      Spree::Api::V2::BaseController
    ] +
    [
      'Spree::UserPasswordsController',
      'Spree::UserSessionsController',
      'Spree::UserRegistrationsController',
      'Spree::UserConfirmationsController'
    ].map(&:safe_constantize).compact
  end

  def self.with_tenant(tenant, &block)
    Multitenant.with_tenant tenant do
      SpreeMultiTenant.init_preferences
      yield
    end
  end

end

