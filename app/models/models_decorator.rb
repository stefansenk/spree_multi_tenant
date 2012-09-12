
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
    Spree::Preference.all.each do |preference|
      Spree::Preferences::Store.instance.set_without_persist(preference.key, preference.value)
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

