SpreeMultiTenant
================

Adds multi-tenant support to Spree. Allows completely separate Spree sites with separate admins to be run from the same installation.



Install
=======

Gemfile:

    gem 'spree', :git => 'git://github.com/spree/spree.git', :branch => '1-0-stable'
    gem 'spree_multi_tenant', :git => 'git://github.com/stefansenk/spree_multi_tenant'

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

    app/tenants/TENANT_CODE/views



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



Copyright (c) 2012 Stefan Senk, released under the New BSD License
