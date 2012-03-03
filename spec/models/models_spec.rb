require 'spec_helper'

describe Spree::Product do
  context 'when a tenant is set' do
    around(:each) do |block|
      @tenant1 = FactoryGirl.create(:tenant)
      @tenant2 = FactoryGirl.create(:tenant)
      @item1 = FactoryGirl.create(:product, :tenant_id => @tenant1.id)
      @item2 = FactoryGirl.create(:product, :tenant_id => @tenant2.id)

      Multitenant.with_tenant @tenant1 do
        block.run
      end
    end

    it "a new item should have the tenant" do
      item = Spree::Product.new
      item.tenant.should == @tenant1
    end

    it "only items for the tenant should be returned" do
      Spree::Product.all.should == [@item1]
    end

  end
end

describe 'Models' do
  around(:each) do |block|
    @tenant = FactoryGirl.create(:tenant)
    Multitenant.with_tenant @tenant do
      block.run
    end
  end

  it "when a tenant is set a new ProductGroup should have the tenant" do
    item = Spree::ProductGroup.new
    item.tenant.should == @tenant
  end

  it "when a tenant is set a new Order should have the tenant" do
    item = Spree::Order.new
    item.tenant.should == @tenant
  end
end

