require 'spec_helper'
require 'email_spec'

describe Spree::OrderMailer, type: :mailer do
  include EmailSpec::Helpers
  include EmailSpec::Matchers

  before do
    @tenants = FactoryBot.create_list(:tenant, 2)
    @store_names = @tenants.map{ |tenant| "Store For Tenant #{tenant.id}" }
    @store_mail_from_addresses = @tenants.map{ |tenant| "spree_tenant_#{tenant.id}@example.org" }
    @tenant_logo_urls = @tenants.map{ |tenant| "http://nonexistentdomain.org/logo_tenant_#{tenant.id}.png" }
    @stores = []
    @orders = []
    @shipments = []
    @reimbursements = []
    @tenants.each_with_index do |tenant, tenant_index|
      SpreeMultiTenant.with_tenant(tenant) do
        # Create stores with unique name and mail_from_address
        @stores[tenant_index] = FactoryBot.create(:store,
          name: @store_names[tenant_index],
          mail_from_address: @store_mail_from_addresses[tenant_index]
        )
        # Set per-tenant preference for logo
        Spree::Preference.create!({
          key: 'spree/app_configuration/logo',
          value: @tenant_logo_urls[tenant_index],
        })
        # Create order, shipment, and reimbursement
        @orders[tenant_index] = FactoryBot.create(:order)
        @shipments[tenant_index] = FactoryBot.create(:shipment)
        @reimbursements[tenant_index] = FactoryBot.create(:reimbursement)
      end
    end
  end

  it 'uses the correct tenant for the order confirm email' do
    @tenants.each_with_index do |tenant, tenant_index|
      message = Spree::OrderMailer.confirm_email(@orders[tenant_index].id)
      expect(message.from).to eq([@store_mail_from_addresses[tenant_index]])
      expect(message.subject).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@tenant_logo_urls[tenant_index])
    end
  end

  it 'uses the correct tenant for the order cancel email' do
    @tenants.each_with_index do |tenant, tenant_index|
      message = Spree::OrderMailer.cancel_email(@orders[tenant_index].id)
      expect(message.from).to eq([@store_mail_from_addresses[tenant_index]])
      expect(message.subject).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@tenant_logo_urls[tenant_index])
    end
  end

  it 'uses the correct tenant for the reimbursement email' do
    @tenants.each_with_index do |tenant, tenant_index|
      message = Spree::ReimbursementMailer.reimbursement_email(@reimbursements[tenant_index].id)
      expect(message.from).to eq([@store_mail_from_addresses[tenant_index]])
      expect(message.subject).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@tenant_logo_urls[tenant_index])
    end
  end

  it 'uses the correct tenant for the shipped email' do
    @tenants.each_with_index do |tenant, tenant_index|
      message = Spree::ShipmentMailer.shipped_email(@shipments[tenant_index].id)
      expect(message.from).to eq([@store_mail_from_addresses[tenant_index]])
      expect(message.subject).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@store_names[tenant_index])
      expect(message.html_part.body.decoded).to include(@tenant_logo_urls[tenant_index])
    end
  end
end
