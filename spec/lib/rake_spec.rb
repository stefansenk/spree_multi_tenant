require 'spec_helper'
require 'rake'
import File.dirname(__FILE__) + '/../../lib/tasks/spree_multi_tenant.rake'
      
describe "spree_multi_tenant raketasks" do
  before :all do
    Dummy::Application.load_tasks
  end

  context "create_tenant" do
    it "should create a new tenant" do
      ENV["domain"] = "example.com"
      ENV["code"] = "example"
      Rake::Task['spree_multi_tenant:create_tenant'].invoke
      
      Spree::Tenant.last.domain.should == "example.com"
      Spree::Tenant.last.code.should == "example"
    end
  end

  context "create_tenant_and_assign" do
    it "should create a new tenant and assign all exisiting items to the tenant" do
      store = FactoryBot.create(:store, tenant_id: 0)
      store.tenant.should be_nil

      ENV["domain"] = "somedomain.com"
      ENV["code"] = "somedomain"
      Rake::Task['spree_multi_tenant:create_tenant_and_assign'].invoke

      store.reload.tenant.domain.should == "somedomain.com"
      store.reload.tenant.code.should == "somedomain"
    end
  end

end
