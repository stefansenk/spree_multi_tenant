SpreeMultiTenant
================

Adds multi-tenant support to Spree. Allows completely separate Spree sites with separate admins to be run from the same installation.


Install
=======

Gemfile:

    gem 'spree', :git => 'git://github.com/spree/spree.git', :branch => '1-2-stable'
    gem 'spree_auth_devise', :git => 'git://github.com/spree/spree_auth_devise.git', :branch => '1-2-stable'
    gem 'spree_multi_tenant', :git => 'git://github.com/stefansenk/spree_multi_tenant.git'

    $ bundle install


Generate and run migrations:

    $ rake spree_multi_tenant:install:migrations
    $ rake db:migrate
    

Creating the first tenant
=========================

Create the fist tenant and assign all existing items to it:

    $ bundle exec rake spree_multi_tenant:create_tenant_and_assign domain=mydomain.com code=mydomain
    

Put tenant specific template, CSS and JS files here:

    app/tenants/mydomain/views/
    app/assets/stylesheets/tenants/mydomain.css
    app/assets/javascripts/tenants/mydomain.js


Creating more tenants
=====================

Create another tenant (without anything assigned):

    $ bundle exec rake spree_multi_tenant:create_tenant domain=anotherdomain.com code=anotherdomain

Or from the console:

    > Spree::Tenant.create({domain: "anotherdomain.com", code: "anotherdomain"})


With other Spree plugins
========================

Any other models that are to be tenant specific will need to have the tenant\_id field and multitenant scope added. 

Database migration (e.g. db/migrate/XXXXXXXXXXXXXX_add_tenant_to_some_models.rb):

    class AddTenantToSomeModels < ActiveRecord::Migration
      def change
        tables = [
          "spree_pages",
          "spree_paypal_accounts",
          "spree_product_groups",
        ]
        tables.each do |table|
          add_column table, :tenant_id, :integer
          add_index table, :tenant_id
        end
      end
    end

Add scope to the models (e.g. app/models/multitenant_decorator.rb):
    
    models = [
      Spree::Page,
      Spree::PaypalAccount,
      Spree::ProductGroup,
    ]
    models.each do |model|
      model.class_eval do
        belongs_to :tenant
        belongs_to_multitenant
      end
    end


In a Raketask
=============

Something like this:

    SpreeMultiTenant.with_tenant(Spree::Tenant.find_by_code('mydomain')) do
      # Do stuff for tenant. e.g.
      puts Spree::Product.first.name
    end


Testing
=======

    $ cd spree_multi_tenant
    $ bundle install
    $ bundle exec rake test_app
    $ bundle exec rspec spec


TODO
====

- Don't require spree_auth_devise as a depandancy.
- Allow same user email address to be used on multiple sites.
- Allow tenant specific Deface overrides.
- Allow same parmalinks to be used on multiple sites.
- Example CSS and JS files.
- Should CSS and JS files be grouped under app/tenants instead of app/assets? (e.g. app/tenants/mydomain/assets/stylesheets/store.css)
- Initialise preferences.


Copyright (c) 2012 Stefan Senk, released under the New BSD License
