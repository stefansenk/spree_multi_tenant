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
      @product1 = FactoryGirl.create(:product, :tenant_id => @tenant1.id)
      @product2 = FactoryGirl.create(:product, :tenant_id => @tenant2.id)
    end

    # it "#index should display products for the tenant" do
    #   pending
    #   process(:index, {:use_route => :spree}, nil, nil, "GET")
    #   assigns(:products).should == [@product1]
    # end

    it "#show should display the tenant's product" do
      process(:show, {:use_route => :spree, :id => @product1.permalink}, nil, nil, "GET")
      assigns(:product).should == @product1
    end

    it "#show should not display a different tenant's product" do
      process(:show, {:use_route => :spree, :id => @product2.permalink}, nil, nil, "GET")
      assigns(:product).should == nil
    end
  end

  # describe Spree::Admin::ProductsController do
  #   before do
  #     controller.stub :current_user => FactoryGirl.create(:admin_user)
  #     @product1 = FactoryGirl.create(:product, :tenant_id => @tenant1.id)
  #     @product2 = FactoryGirl.create(:product, :tenant_id => @tenant2.id)
  #   end

  #   # it "#index should display products for the tenant" do
  #   #   pending
  #   #   # process(:index, {:use_route => :spree}, nil, nil, "GET")
  #   #   # assigns(:collection).should == [@product1]
  #   # end

  # end

  # describe Spree::Admin::OrdersController do
  #   before do
  #     controller.stub :current_user => FactoryGirl.create(:admin_user)
  #     @order1 = FactoryGirl.create(:order, :tenant_id => @tenant1.id, :completed_at => Time.now)
  #     @order2 = FactoryGirl.create(:order, :tenant_id => @tenant2.id, :completed_at => Time.now)
  #   end

  #   # it "#index should display orders for the tenant" do
  #   #   pending
  #   #   # process(:index, {:use_route => :spree}, nil, nil, "GET")
  #   #   # assigns(:orders).should == [@order1]
  #   # end

  #   it "#show should display a tenant's order" do
  #     process(:show, {:use_route => :spree, :id => @order1.number}, nil, nil, "GET")
  #     assigns(:order).should == @order1
  #   end

  #   it "#show should not display a different tenant's order" do
  #     process(:show, {:use_route => :spree, :id => @order2.number}, nil, nil, "GET")
  #     assigns(:order).should == nil
  #   end

  # end

end

