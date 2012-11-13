
def do_create_tenant domain, code
  if domain.blank? or code.blank?
    puts "Error: domain and code must be specified"
    puts "(e.g. rake spree_multi_tenant:create_tenant domain=mydomain.com code=mydomain)"
    exit
  end

  tenant = Spree::Tenant.create!({:domain => domain.dup, :code => code.dup})
  tenant.create_template_and_assets_paths
  tenant
end


namespace :spree_multi_tenant do

  desc "Create a new tenant and assign all exisiting items to the tenant."
  task :create_tenant_and_assign => :environment do
    tenant = do_create_tenant ENV["domain"], ENV["code"]

    # Assign all existing items to the new tenant
    SpreeMultiTenant.tenanted_models.each do |model|
      model.all.each do |item|
        item.update_attribute(:tenant_id, tenant.id)
      end
    end
  end

  desc "Create a new tenant"
  task :create_tenant => :environment do
    tenant = do_create_tenant ENV["domain"], ENV["code"]
  end

end
