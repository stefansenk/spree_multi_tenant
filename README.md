SpreeMultiTenant
================

Adds multi-tenant support to Spree. Allows completely separate Spree sites with seperate admins to be run from the same installation.



Install
=======

Gemfile:

    gem 'spree', :git => 'git://github.com/spree/spree.git', :branch => '1-0-stable'
    gem 'spree_multi_tenant', :git => 'TODO'


Genarate and run migrations:

    rake spree_multi_tenant:install:migrations


Update the domain for the tenant in the database.



Usage
=====

Create a new tenant:

    rake spree_multi_tenant:create_tenant domain=mydomain.com code=mydomain
    

Tenant specific templates:

    app/tenants/TENANT_CODE/views



Testing
=======

    $ bundle install
    $ bundle exec rake test_app
    $ bundle exec rspec spec



TODO
====

- Allow tenant specific Deface overrides.
- Allow same user email address to be used on multiple sites.
- Allow same parmalink to be used on multiple sites.



Copyright (c) 2012 Stefan Senk, released under the New BSD License
