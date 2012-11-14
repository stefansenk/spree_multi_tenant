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

  it "when a tenant is set a new Taxonomy should have the tenant" do
    item = Spree::Taxonomy.new
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


describe Spree::Taxon do
  context 'when a tenant is set' do
    before do
      @tenant1 = FactoryGirl.create(:tenant)
      @tenant2 = FactoryGirl.create(:tenant)

      Multitenant.with_tenant @tenant1 do
        @taxonomy1 = FactoryGirl.create(:taxonomy)
        @taxon1 = FactoryGirl.create(:taxon, :taxonomy_id => @taxonomy1.id, :parent_id => @taxonomy1.root.id)
        @taxon2 = FactoryGirl.create(:taxon, :taxonomy_id => @taxonomy1.id, :parent_id => @taxon1.id)
        @taxon3 = FactoryGirl.create(:taxon, :taxonomy_id => @taxonomy1.id, :parent_id => @taxon2.id)
      end
 
      Multitenant.with_tenant @tenant2 do
        @taxonomy2 = FactoryGirl.create(:taxonomy)
        @taxon6 = FactoryGirl.create(:taxon, :taxonomy_id => @taxonomy2.id, :parent_id => @taxonomy2.root.id)
        @taxon7 = FactoryGirl.create(:taxon, :taxonomy_id => @taxonomy2.id, :parent_id => @taxon6.id)
        @taxon8 = FactoryGirl.create(:taxon, :taxonomy_id => @taxonomy2.id, :parent_id => @taxon7.id)
      end
    end

    it "#ancestors should only return the tenant's ancestors" do
      Multitenant.with_tenant @tenant1 do
        @taxon3.ancestors.count.should == 3
        @taxon3.lft.should == 4
      end
      Multitenant.with_tenant @tenant2 do
        @taxon8.ancestors.count.should == 3
        @taxon8.lft.should == 4
      end
    end

  end
end
