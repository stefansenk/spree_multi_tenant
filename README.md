SpreeMultiTenant
================

[![Build Status](https://travis-ci.org/stefansenk/spree_multi_tenant.png?branch=master)](https://travis-ci.org/stefansenk/spree_multi_tenant)

Adds multi-tenant support to Spree. Allows completely separate Spree sites with separate admins to be run from the same installation.


Install
=======

Disable caching in `config/application.rb` (and check `config/environments/*`):

```ruby
config.cache_store = :memory_store, {size: 0}
```

Set ActiveJob's queue adapter to a persistent implementation such as `:delayed_job` or `:sidekiq`.  Do not use `:async` or `:inline`.

```ruby
config.active_job.queue_adapter = :delayed_job
```

Gemfile:

```ruby
gem 'spree'
gem 'spree_auth_devise'
gem 'spree_multi_tenant'
```

```shell
bundle install
```

Generate and run migrations:

```shell
bundle exec rake spree_multi_tenant:install:migrations
bundle exec rake db:migrate
````
    

Creating the first tenant
=========================

Create the first tenant and assign all existing items to it:

```shell
bundle exec rake spree_multi_tenant:create_tenant_and_assign domain=mydomain.com code=mydomain

```    

Put tenant specific template, CSS and JS files here:

```
app/tenants/mydomain/views/
app/assets/stylesheets/tenants/mydomain.css
app/assets/javascripts/tenants/mydomain.js
```


Creating more tenants
=====================

Create another tenant (without anything assigned):

```shell
bundle exec rake spree_multi_tenant:create_tenant domain=anotherdomain.com code=anotherdomain
```

Or from the console:

```ruby
Spree::Tenant.create({domain: "anotherdomain.com", code: "anotherdomain"})
```


With other Spree plugins
========================

Any other models that are to be tenant specific will need to have the tenant\_id field and multitenant scope added. 

Database migration (e.g. db/migrate/XXXXXXXXXXXXXX_add_tenant_to_some_models.rb):

```ruby
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
```

Add scope to the models (e.g. app/models/multitenant_decorator.rb):
    
```ruby
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
```

Customizing controller and mailer behavior
====================

In order to customize the default controller or mailer behavior, it might be necessary
to disable the default behavior in `config/initializers/spree_multi_tenant.rb`

```ruby
SpreeMultiTenant.configure do |config|
  config.use_tenanted_controllers = false
  config.use_tenanted_mailers = false
end
```

In a Raketask
=============

Something like this:

```ruby
SpreeMultiTenant.with_tenant(Spree::Tenant.find_by_code('mydomain')) do
  # Do stuff for tenant. e.g.
  puts Spree::Product.first.name
end
```


Testing
=======

```shell
bundle
bundle exec rake test_app
bundle exec rspec spec
```


TODO
====

- Don't require spree_auth_devise as a depandancy.
- Allow tenant specific Deface overrides.
- Example CSS and JS files.
- Should CSS and JS files be grouped under app/tenants instead of app/assets? (e.g. app/tenants/mydomain/assets/stylesheets/store.css)
- Initialise preferences.


Copyright (c) 2014 Stefan Senk, released under the New BSD License
