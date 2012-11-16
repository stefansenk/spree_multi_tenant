FactoryGirl.define do

  sequence(:domain_sequence) { |n| "mydomain#{n}.com" }
  sequence(:code_sequence) { |n| "mydomain#{n}" }

  factory :tenant, :class => Spree::Tenant  do
    domain { FactoryGirl.generate :domain_sequence }
    code { FactoryGirl.generate :code_sequence }
  end

end


FactoryGirl.define do
  factory :promotion, :class => Spree::Promotion, :parent => :activator do
    name 'Promo'
  end
end
