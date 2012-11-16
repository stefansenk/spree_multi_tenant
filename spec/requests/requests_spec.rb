require 'spec_helper'

def login(user, tenant=user.tenant)
  visit "http://#{tenant.domain}/login"
  within("#existing-customer") do
    fill_in 'user_email', :with => user.email
    fill_in 'user_password', :with => user.password
    click_button 'Login'
  end
end

describe "with multiple tenants" do
  before(:each) do    
    @tenant1 = FactoryGirl.create(:tenant)
    @tenant2 = FactoryGirl.create(:tenant)
  end

  context "visiting the homepage page" do
    before do
      Multitenant.with_tenant @tenant1 do
        Spree::Config[:default_seo_title] = "Site1Title"
      end
      Multitenant.with_tenant @tenant2 do
        Spree::Config[:default_seo_title] = "Site2Title"
      end
    end

    it "homepage should display the page title for the tenant" do
      visit "http://#{@tenant1.domain}"
      page.should have_content("Site1Title")
      page.should_not have_content("Site2Title")
    end

    it "homepage should display the page title for the tenant" do
      visit "http://#{@tenant2.domain}"
      page.should have_content("Site2Title")
      page.should_not have_content("Site1Title")
    end
  end

  context "visiting the products page" do
    before do
      Multitenant.with_tenant @tenant1 do
        @product1 = FactoryGirl.create(:product, name: 'my first product')
      end
      Multitenant.with_tenant @tenant2 do
        @product2 = FactoryGirl.create(:product, name: 'my second product')
      end
    end

    it "#index should display products for the tenant" do
      visit "http://#{@tenant1.domain}/products"
      page.should have_content(@product1.name)
      page.should_not have_content(@product2.name)
    end

    it "#show should display the tenant's product" do
      visit "http://#{@tenant1.domain}/products/#{@product1.permalink}"
      page.should have_content(@product1.name)
      page.should_not have_content(@product2.name)
    end

    it "#show should not display a different tenant's product" do
      visit "http://#{@tenant1.domain}/products/#{@product2.permalink}"
      page.should_not have_content(@product2.name)
      page.status_code.should == 404
    end
  end

  context "logging in" do    
    before do
      Multitenant.with_tenant @tenant1 do
        @user = FactoryGirl.create(:admin_user)
      end
    end

    it "should be sucessfull for a user for the tenant" do
      login @user
      page.should have_content('Logged in successfully')
    end

    it "should fail for a user for a different tenant" do
      login @user, @tenant2
      page.should have_content('Invalid email or password')
    end 
  end

  context "visiting the admin products page" do
    before do
      Multitenant.with_tenant @tenant1 do
        @user = FactoryGirl.create(:admin_user)
        @product1 = FactoryGirl.create(:product)
      end
      Multitenant.with_tenant @tenant2 do
        @product2 = FactoryGirl.create(:product)
      end
      login @user
    end

    it "#index should display products for the tenant" do
      visit "http://#{@tenant1.domain}/admin/products"
      page.should have_content(@product1.name)
      page.should_not have_content(@product2.name)
    end

  end

  context "visiting the admin orders page" do
    before do
      Multitenant.with_tenant @tenant1 do
        @user = FactoryGirl.create(:admin_user)
        @order1 = FactoryGirl.create(:order, :completed_at => Time.now)
      end
      Multitenant.with_tenant @tenant2 do
        @order2 = FactoryGirl.create(:order, :completed_at => Time.now)
      end
      login @user
    end

    it "#index should display orders for the tenant" do
      visit "http://#{@tenant1.domain}/admin/orders"
      page.should have_content(@order1.number)
      page.should_not have_content(@order2.number)
    end

    it "#show should display the tenant's order" do
      visit "http://#{@tenant1.domain}/admin/orders/#{@order1.number}"
      page.should have_content(@order1.number)
      page.should_not have_content(@order2.number)
    end

    # it "#show should not display a different tenant's order" do
    #   pending
    #   visit "http://#{@tenant1.domain}/admin/orders/#{@order2.number}"
    #   page.should_not have_content(@order1.number)
    #   page.status_code.should == 404
    # end

  end

  context "visiting the admin promotions page" do
    before do
      Multitenant.with_tenant @tenant1 do
        @user = FactoryGirl.create(:admin_user)
        @promotion1 = FactoryGirl.create(:promotion, :name => "MyPromo1")
      end
      Multitenant.with_tenant @tenant2 do
        @promotion2 = FactoryGirl.create(:promotion, :name => "MyPromo2")
      end
      login @user
    end

    it "#index should display promotions for the tenant" do
      visit "http://#{@tenant1.domain}/admin/promotions"
      page.should have_content("MyPromo1")
      page.should_not have_content("MyPromo2")
    end

    it "should be able to edit the promotion" do
      visit "http://#{@tenant1.domain}/admin/promotions"
      click_on 'Edit'
      pending
    end

  end


  context "dash config" do
    before do
      Multitenant.with_tenant @tenant1 do
        Spree::Dash::Config[:app_id] = "AppId1"
        Spree::Dash::Config[:site_id] = "SiteId1"
        Spree::Dash::Config[:token] = "TokenId1"
      end
      Multitenant.with_tenant @tenant2 do
        Spree::Dash::Config[:app_id] = "AppId2"
        Spree::Dash::Config[:site_id] = "SiteId2"
        Spree::Dash::Config[:token] = "TokenId2"
      end
    end

    it "homepage should indlude the jirafe id for the tenant" do
      visit "http://#{@tenant1.domain}"
      page.find('head').should have_content("SiteId1")
      page.find('head').should_not have_content("SiteId2")

      visit "http://#{@tenant2.domain}"
      page.find('head').should_not have_content("SiteId1")
      page.find('head').should have_content("SiteId2")
    end

  end

end

