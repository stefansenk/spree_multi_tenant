require 'spec_helper'

describe Spree::Product do
  context 'when a tenant is set' do
    around(:each) do |block|
      @tenant1 = FactoryBot.create(:tenant)
      @tenant2 = FactoryBot.create(:tenant)
      Multitenant.with_tenant @tenant1 do
        @item1 = FactoryBot.create(:product, tenant_id: @tenant1)
      end
      Multitenant.with_tenant @tenant2 do
        @item2 = FactoryBot.create(:product, tenant_id: @tenant2)
      end

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
      item = FactoryBot.build(:product, :slug => @item2.slug)
      item = @item2.clone
      item.id = nil
      item.tenant = @tenant1
      item.should be_valid
    end

  end
end

describe 'Models' do
  around(:each) do |block|
    @tenant = FactoryBot.create(:tenant)
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
      @tenant1 = FactoryBot.create(:tenant)
      @tenant2 = FactoryBot.create(:tenant)
      @user1 = FactoryBot.create(:user, :tenant_id => @tenant1.id)
      @user2 = FactoryBot.create(:user, :tenant_id => @tenant2.id)
      Multitenant.with_tenant @tenant1 do
        block.run
      end
    end

    it "email can be the same for diffent tenants" do
      user = FactoryBot.build(:user, :email => @user2.email)
      user.should be_valid
    end

    it "email can not be the same for the same tenant" do
      user = FactoryBot.build(:user, :email => @user1.email)
      user.should_not be_valid
    end

  end
end


describe Spree::Taxon do
  context 'when a tenant is set' do
    before do
      @tenant1 = FactoryBot.create(:tenant)
      @tenant2 = FactoryBot.create(:tenant)

      Multitenant.with_tenant @tenant1 do
        @taxonomy1 = FactoryBot.create(:taxonomy)
        @taxon1 = FactoryBot.create(:taxon, :taxonomy_id => @taxonomy1.id, :parent_id => @taxonomy1.root.id)
        @taxon2 = FactoryBot.create(:taxon, :taxonomy_id => @taxonomy1.id, :parent_id => @taxon1.id)
        @taxon3 = FactoryBot.create(:taxon, :taxonomy_id => @taxonomy1.id, :parent_id => @taxon2.id)
      end

      Multitenant.with_tenant @tenant2 do
        @taxonomy2 = FactoryBot.create(:taxonomy)
        @taxon6 = FactoryBot.create(:taxon, :taxonomy_id => @taxonomy2.id, :parent_id => @taxonomy2.root.id)
        @taxon7 = FactoryBot.create(:taxon, :taxonomy_id => @taxonomy2.id, :parent_id => @taxon6.id)
        @taxon8 = FactoryBot.create(:taxon, :taxonomy_id => @taxonomy2.id, :parent_id => @taxon7.id)
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


# Tests for unique indexes
tables = {
  country: [:name, :iso_name, :iso, :iso3],
  customer_return: [:number],
  order: [:number],
  payment: [:number],
  preferences: [:key],
  product: [:slug],
  promotion: [:code],
  refund_reason: [:name],
  reimbursement: [:number],
  reimbursement_type: [:name],
  return_authorization: [:number],
  return_authorization_reason: [:name],
  role: [:name],
  shipment: [:number],
  stock_transfer: [:number],
  store: [:code],
  tag: [:name],
  user: [:email],
}
tables.each do |table, columns|
  klass = "Spree::#{table.to_s.classify}".safe_constantize
  if klass
    describe klass do
      context 'when multiple tenants exist' do
        columns.each do |column|
          before(:each) do
            @tenant1 = FactoryBot.create(:tenant)
            @tenant2 = FactoryBot.create(:tenant)

            @column_value =
              if column == :email
                'foo@bar.com'
              else
                'ABC' # Valid value for most cases
              end

            # Skip callbacks which interfere with some of these tests.  https://mattpruitt.com/post/skip-callbacks/
            module SkipCallbacks
              def run_callbacks(kind, *args, &block)
                yield(*args) if block_given?
              end
            end

            # Most models have a corresponding factory, with exceptions.
            @create = ->() {
              if klass == Spree::Preference # spree has no factory
                Spree::Preference.new(key: 'test_key', column => @column_value).save(validate: false)
              elsif klass == Spree::StockTransfer # spree has no factory
                Spree::StockTransfer.new(column => @column_value).save(validate: false)
              elsif klass == Spree::Reimbursement # Avoid factory's associated records callbacks
                Spree::Reimbursement.new(column => @column_value).save(validate: false)
              else # General case
                FactoryBot.build(table, column => @column_value).extend(SkipCallbacks).save(validate: false)
              end
            }

            Multitenant.with_tenant @tenant1 do
              @create.call
            end
          end

          it "#{column} cannot be the same for the same tenant" do
            Multitenant.with_tenant @tenant1 do
              expect {@create.call}.to raise_error(ActiveRecord::RecordNotUnique)
            end
          end

          it "#{column} can be the same for different tenants" do
            Multitenant.with_tenant @tenant2 do
              expect {@create.call}.not_to raise_error
            end
          end
        end
      end
    end
  end
end
