FactoryGirl.define do

  sequence(:domain_sequence) { |n| "mydomain#{n}.com" }
  sequence(:code_sequence) { |n| "mydomain#{n}" }

  factory :tenant, :class => Spree::Tenant  do
    domain { Factory.next :domain_sequence }
    code { Factory.next :code_sequence }
  end

end
