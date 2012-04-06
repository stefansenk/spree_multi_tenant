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

    it "permalinks can be the same for different tenants" do
      pending
      # item = FactoryGirl.build(:product, :permalink => @item2.permalink)
      item = @item2.clone
      item.id = nil
      item.tenant = @tenant1
      item.should be_valid
    end

    it "permalinks can not be the same for the same tenant" do
      # item = FactoryGirl.build(:product, :permalink => @item1.permalink)
      item = @item1.clone
      item.id = nil
      item.should_not be_valid
      item.errors.should include(:permalink)
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

describe Spree::User do
  context 'when a tenant is set' do
    around(:each) do |block|
      @tenant1 = FactoryGirl.create(:tenant)
      @tenant2 = FactoryGirl.create(:tenant)
      @user1 = FactoryGirl.create(:user, :tenant_id => @tenant1.id)
      @user2 = FactoryGirl.create(:user, :tenant_id => @tenant2.id)
      Multitenant.with_tenant @tenant1 do
        block.run
      end
    end

    it "email can be the same for diffent tenants" do
      pending
      user = FactoryGirl.build(:user, :email => @user2.email)
      user.should be_valid
    end

    it "email can not be the same for the same tenant" do
      user = FactoryGirl.build(:user, :email => @user1.email)
      user.should_not be_valid
    end

  end
end

