require 'spec_helper'

describe "with multiple tenants", type: :controller do
  before(:each) do
    @tenant1 = FactoryBot.create(:tenant)
    @tenant2 = FactoryBot.create(:tenant)

    @request.host = @tenant1.domain
  end

  describe Spree::ProductsController do
    before do
      controller.stub :current_user => FactoryBot.create(:user, tenant: @tenant1)
      Multitenant.with_tenant @tenant1 do
        @product1 = FactoryBot.create(:product)
      end
      Multitenant.with_tenant @tenant2 do
        @product2 = FactoryBot.create(:product)
      end
    end

    # TODO Enable this test again.  It succeeds locally but fails on TravisCI.
    xit "#index should display products for the tenant" do
      get :index, params: {}
      assigns(:products).should == [@product1]
    end

    it "#show should display the tenant's product" do
      get :show, params: {id: @product1.slug}
      assigns(:product).should == @product1
    end

    it "#show should respond with 404 for a different tenant's product" do
      expect{
        get :show, params: {id: @product2.slug}
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

end

