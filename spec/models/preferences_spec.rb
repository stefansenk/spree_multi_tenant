require 'spec_helper'

describe Spree::Config do
  before do
    @tenant1 = FactoryBot.create(:tenant)
    @tenant2 = FactoryBot.create(:tenant)

    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Config[:currency] = "CAD"
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Config[:currency] = "EUR"
    end
  end

  it "should have the right preference for the tenant" do
    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Config.currency.should == "CAD"
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Config.currency.should == "EUR"
    end
  end
end

describe Spree::Api::Config do
  before do
    @tenant1 = FactoryBot.create(:tenant)
    @tenant2 = FactoryBot.create(:tenant)

    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Api::Config[:requires_authentication] = true
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Api::Config[:requires_authentication] = false
    end
  end

  it "should have the right preference for the tenant" do
    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Api::Config.requires_authentication.should == true
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Api::Config.requires_authentication.should == false
    end
  end
end
