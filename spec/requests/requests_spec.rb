require 'spec_helper'

def login(user, tenant=user.tenant)
  visit "http://#{tenant.domain}/login"
  fill_in 'Email', :with => user.email
  fill_in 'Password', :with => 'secret'
  click_button 'Login'
end

describe "with multiple tenants", type: :request do
  xit "skip until capybara tests are fixed on TravisCI (they succeed locally)" do

  before(:each) do
    @tenant1 = FactoryBot.create(:tenant)
    @tenant2 = FactoryBot.create(:tenant)
  end

  context "visiting the homepage page" do
    before do
      Multitenant.with_tenant @tenant1 do
        FactoryBot.create(:store)
        Spree::Store.default.update(seo_title: 'Site1Title')
      end
      Multitenant.with_tenant @tenant2 do
        FactoryBot.create(:store)
        Spree::Store.default.update(seo_title: 'Site2Title')
      end
    end

    it "homepage should display the page title for the tenant" do
      visit "http://#{@tenant1.domain}"
      page.title.should include("Site1Title")
      page.title.should_not include("Site2Title")
    end

    it "homepage should display the page title for the tenant" do
      visit "http://#{@tenant2.domain}"
      page.title.should include("Site2Title")
      page.title.should_not include("Site1Title")
    end
  end

  context "visiting the products page" do
    before do
      Multitenant.with_tenant @tenant1 do
        @product1 = FactoryBot.create(:product, name: 'my first product')
      end
      Multitenant.with_tenant @tenant2 do
        @product2 = FactoryBot.create(:product, name: 'my second product')
      end
    end

    it "#index should display products for the tenant" do
      visit "http://#{@tenant1.domain}/products"
      page.should have_content(@product1.name)
      page.should_not have_content(@product2.name)
    end

    it "#show should display the tenant's product" do
      visit "http://#{@tenant1.domain}/products/#{@product1.slug}"
      page.should have_content(@product1.name)
      page.should_not have_content(@product2.name)
    end

    it "#show should not display a different tenant's product" do
      expect{
        visit "http://#{@tenant1.domain}/products/#{@product2.slug}"
      }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  context "logging in" do
    before do
      Multitenant.with_tenant @tenant1 do
        @user = FactoryBot.create(:admin_user)
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
        @user = FactoryBot.create(:admin_user)
        @product1 = FactoryBot.create(:product)
      end
      Multitenant.with_tenant @tenant2 do
        @product2 = FactoryBot.create(:product)
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
        @user = FactoryBot.create(:admin_user)
        @order1 = FactoryBot.create(:order, :completed_at => Time.now)
      end
      Multitenant.with_tenant @tenant2 do
        @order2 = FactoryBot.create(:order, :completed_at => Time.now)
      end
      login @user
    end

    it "#index should display orders for the tenant" do
      visit "http://#{@tenant1.domain}/admin/orders"
      page.should have_content(@order1.number)
      page.should_not have_content(@order2.number)
    end

    it "#show should display the tenant's order" do
      visit "http://#{@tenant1.domain}/admin/orders/#{@order1.number}/edit"
      page.should have_content(@order1.number)
      page.should_not have_content(@order2.number)
    end

    it "#show should not display a different tenant's order" do
      lambda {
        visit "http://#{@tenant1.domain}/admin/orders/#{@order2.number}/edit"
      }.should raise_exception(ActiveRecord::RecordNotFound)
    end
  end

  context "visiting the admin promotions page" do
    before do
      Multitenant.with_tenant @tenant1 do
        @user = FactoryBot.create(:admin_user)
        @promotion1 = FactoryBot.create(:promotion, :name => "MyPromo1")
      end
      Multitenant.with_tenant @tenant2 do
        @promotion2 = FactoryBot.create(:promotion, :name => "MyPromo2")
      end
      login @user
    end

    it "#index should display promotions for the tenant" do
      visit "http://#{@tenant1.domain}/admin/promotions"
      page.should have_content("MyPromo1")
      page.should_not have_content("MyPromo2")
    end
  end

  end # skip "is skipped" do
end

