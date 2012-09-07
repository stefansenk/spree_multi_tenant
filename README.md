SpreeMultiTenant
================

Adds multi-tenant support to Spree. Allows completely separate Spree sites with separate admins to be run from the same installation.


Install
=======

Gemfile:

    gem 'spree', :git => 'git://github.com/spree/spree.git', :branch => '1-1-stable'
    gem 'spree_multi_tenant', :git => 'git://github.com/stefansenk/spree_multi_tenant.git'

    $ bundle install


Generate and run migrations:

    $ rake spree_multi_tenant:install:migrations
    $ rake db:migrate


Update the domain for the tenant in the database:

    Spree::Tenant.first.update_attribute(:domain, 'shop.dev')
    

Usage
=====

Create a new tenant:

    $ rake spree_multi_tenant:create_tenant domain=mydomain.com code=mydomain
    

Tenant specific templates:

    app/tenants/mydomain/views


With other Spree plugins
========================

Any other models that are tenant specific, will need to have the tenant\_id field and multitenant scope added. 

Database migration:

    class AddTenantToSomeModels < ActiveRecord::Migration
      def change
        models = [
          Spree::Page,
          Spree::PaypalAccount,
          Spree::ProductGroup
        ]
        models.each do |model|
          table = model.to_s.tableize.gsub '/', '_'
          add_column table, :tenant_id, :integer
          add_index table, :tenant_id
        end
      end
    end


Add scope to the models:
    
    models = [
      Spree::Page,
      Spree::PaypalAccount,
      Spree::ProductGroup
    ]
    models.each do |model|
      model.class_eval do
        belongs_to :tenant
        belongs_to_multitenant
      end
    end


Testing
=======

    $ cd spree_multi_tenant
    $ bundle install
    $ bundle exec rake test_app
    $ bundle exec rspec spec



TODO
====

- Allow tenant specific Deface overrides.
- Allow same user email address to be used on multiple sites.
- Allow same parmalink to be used on multiple sites.
- Example CSS and JS files.



Copyright (c) 2012 Stefan Senk, released under the New BSD License
