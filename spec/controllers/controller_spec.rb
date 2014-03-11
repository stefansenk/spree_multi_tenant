require 'spec_helper'

describe "with multiple tenants" do
  before(:each) do    
    @tenant1 = FactoryGirl.create(:tenant)
    @tenant2 = FactoryGirl.create(:tenant)

    @request.host = @tenant1.domain
  end

  describe Spree::ProductsController do
    before do
      controller.stub :current_user => FactoryGirl.create(:user)
      Multitenant.with_tenant @tenant1 do
        @product1 = FactoryGirl.create(:product)
      end
      Multitenant.with_tenant @tenant2 do
        @product2 = FactoryGirl.create(:product)
      end
    end

    it "#index should display products for the tenant" do
      spree_get :index
      assigns(:products).should == [@product1]
    end

    it "#show should display the tenant's product" do
      spree_get :show, :id => @product1.slug
      assigns(:product).should == @product1
    end

    it "#show should not display a different tenant's product" do
      spree_get :show, :id => @product2.slug
      assigns(:product).should == nil
    end
  end

end

