FactoryGirl.define do
  # Define your Spree extensions Factories within this file to enable applications, and other extensions to use and override them.
  #
  # Example adding this to your spec_helper will load these Factories for use:
  # require 'spree_multi_tenant/factories'

  sequence(:domain_sequence) { |n| "mydomain#{n}.com" }
  sequence(:code_sequence) { |n| "mydomain#{n}" }

  factory :tenant, :class => Spree::Tenant  do
    domain { FactoryGirl.generate :domain_sequence }
    code { FactoryGirl.generate :code_sequence }
  end
    
end
