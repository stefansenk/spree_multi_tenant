
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

    # Override belongs_to_multitenant implementation in multitenant gem, because
    #  the default_scope implementation fails with current ActiveRecord:
    #    ArgumentError: nil is not an ActiveRecord::Relation
    # TODO: Upstream pull request to fix this in source gem.
    def self.belongs_to_multitenant_fixed(association = :tenant)
      reflection = reflect_on_association association
      before_validation Proc.new {|m|
        m.send("#{association}=".to_sym, Multitenant.current_tenant) if Multitenant.current_tenant
      }, :on => :create
      default_scope lambda {
        Multitenant.current_tenant ? where({reflection.foreign_key => Multitenant.current_tenant.id}) : all
      }
    end
    belongs_to_multitenant_fixed
    # raise_error_if_no_tenant if Rails.env = 'production'   # TODO - would this be useful?

    # always scope these models with the tenant, even if requested unscoped
    def self.unscoped
      r = relation
      r = r.where(:tenant_id => Multitenant.current_tenant.id) if Multitenant.current_tenant
      block_given? ? r.scoping { yield } : r
    end

  end
end


Spree::Core::Search::Base.class_eval do
    def get_base_scope
      base_scope = Spree::Product.active
      base_scope = base_scope.where(tenant_id: Multitenant.current_tenant.id) if Multitenant.current_tenant
      base_scope = base_scope.in_taxon(taxon) unless taxon.blank?
      base_scope = get_products_conditions_for(base_scope, keywords)
      base_scope = add_search_scopes(base_scope)
      base_scope
    end
end

# Define ModelsDecorator.  Otherwise Zeitwerk::NameError
module ModelsDecorator
end
