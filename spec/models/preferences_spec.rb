require 'spec_helper'

describe Spree::Config do
  before do
    @tenant1 = FactoryGirl.create(:tenant)
    @tenant2 = FactoryGirl.create(:tenant)

    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Config[:site_name] = "Site1Name"
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Config[:site_name] = "Site2Name"
    end
  end

  it "should have the right preference for the tenant" do
    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Config.site_name.should == "Site1Name"
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Config.site_name.should == "Site2Name"
    end
  end
end

describe Spree::Api::Config do
  before do
    @tenant1 = FactoryGirl.create(:tenant)
    @tenant2 = FactoryGirl.create(:tenant)

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

describe Spree::Dash::Config do
  before do
    @tenant1 = FactoryGirl.create(:tenant)
    @tenant2 = FactoryGirl.create(:tenant)

    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Dash::Config[:app_id] = "App1"
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Dash::Config[:app_id] = "App2"
    end
  end

  it "should have the right preference for the tenant" do
    SpreeMultiTenant.with_tenant @tenant1 do
      Spree::Dash::Config.app_id.should == "App1"
    end
    SpreeMultiTenant.with_tenant @tenant2 do
      Spree::Dash::Config.app_id.should == "App2"
    end
  end
end