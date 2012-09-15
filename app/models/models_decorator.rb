
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
