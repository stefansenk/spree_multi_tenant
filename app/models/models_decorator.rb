
require 'active_record'

module SpreeMultiTenant
  module ActiveRecordExtensions
    def raise_error_if_no_tenant(association = :tenant)
      default_scope lambda {
        raise 'OperationWithNoTenant' unless Multitenant.current_tenant
      }
    end
  end
end
ActiveRecord::Base.extend SpreeMultiTenant::ActiveRecordExtensions


SpreeMultiTenant.tenanted_models.each do |model|
  model.class_eval do
    belongs_to :tenant
    belongs_to_multitenant
    # raise_error_if_no_tenant if Rails.env = 'production'
  end
end


class Spree::Preferences::StoreInstance
  # Initialize the preference without writing to the database
  def set_without_persist(key, value)
    @cache.write(key, value)
  end
end

module SpreeMultiTenant

  def self.init_preferences
    default_country = Spree::Country.find_by_iso(Rails.application.config.default_country_iso)
    default_locale = Rails.application.config.i18n.default_locale || :en

    defaults = [
      {key: :address_requires_state, value: true},
      {key: :admin_interface_logo, value: 'admin/bg/spree_50.png'},
      {key: :admin_pgroup_per_page, value: 10},
      {key: :admin_pgroup_preview_size, value: 10},
      {key: :admin_products_per_page, value: 10},
      {key: :allow_backorder_shipping, value: false }, 
      {key: :allow_backorders, value: false},
      {key: :allow_checkout_on_gateway_error, value: false},
      {key: :allow_guest_checkout, value: true},
      {key: :allow_locale_switching, value: true},
      {key: :allow_ssl_in_development_and_test, value: false},
      {key: :allow_ssl_in_production, value: true},
      {key: :allow_ssl_in_staging, value: true},
      {key: :alternative_billing_phone, value: false }, 
      {key: :alternative_shipping_phone, value: false }, 
      {key: :always_put_site_name_in_title, value: false},
      {key: :auto_capture, value: false }, 
      {key: :cache_static_content, value: true},
      {key: :check_for_spree_alerts, value: true},
      {key: :checkout_zone, value: nil }, 
      {key: :company, value: false }, 
      {key: :create_inventory_units, value: true }, 
      {key: :default_country_id, value: (default_country ? default_country.id : nil)},
      {key: :default_locale, value: default_locale},
      {key: :default_meta_description, value: 'Spree demo, value: site'},
      {key: :default_meta_keywords, value: 'spree, value: demo'},
      {key: :default_seo_title, value: ''},
      {key: :dismissed_spree_alerts, value: ''},
      {key: :last_check_for_spree_alerts, value: nil},
      {key: :logo, value: 'admin/bg/spree_50.png'},
      {key: :max_level_in_taxons_menu, value: 1 }, 
      {key: :orders_per_page, value: 15},
      {key: :prices_inc_tax, value: false},
      {key: :products_per_page, value: 12},
      {key: :select_taxons_from_tree, value: false }, 
      {key: :shipment_inc_vat, value: false},
      {key: :shipping_instructions, value: false }, 
      {key: :show_descendents, value: true},
      {key: :show_only_complete_orders_by_default, value: true},
      {key: :show_zero_stock_products, value: true},
      {key: :site_name, value: 'Spree Demo, value: Site'},
      {key: :site_url, value: 'demo.spreecommerce.com'},
      {key: :tax_using_ship_address, value: true},
      {key: :track_inventory_levels, value: true }, 
    ]

    defaults.each do |default|
      p = Spree::Preference.where("key LIKE '%/#{default[:key].to_s}%'").first
      if p
        Spree::Preferences::Store.instance.set_without_persist(p.key, p.value)
      else
        Spree::Config[default[:key]] = default[:value]
      end
    end

  end
end


SpreeMultiTenant.tenanted_controllers.each do |controller|
  controller.class_eval do

    append_before_filter :init_preferences

    private

      def init_preferences
        SpreeMultiTenant.init_preferences
      end
  end
end

