namespace :spree_multi_tenant do

  desc "Create a new tenant"
  task :create_tenant => :environment do
    domain = ENV["domain"]
    code = ENV["code"]

    if domain.blank? or code.blank?
      puts "Error: domain and code must be specified"
      puts "(e.g. rake spree_multi_tenant:create_tenant domain=mydomain.com code=mydomain)"
      exit
    end

    tenant = Spree::Tenant.create!({:domain => domain.dup, :code => code.dup})
    tenant.create_template_and_assets_paths
  end

end
