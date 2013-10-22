# encoding: UTF-8
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_multi_tenant'
  s.version     = '0.3.0'
  s.summary     = 'Adds multi-tenant support to Spree'
  s.description = 'Allows completely separate Spree sites to be run from the same installation'
  s.required_ruby_version     = '>= 1.9.3'

   s.author            = 'Stefan Senk'
  # s.email             = 'you@example.com'
  # s.homepage          = 'http://www.spreecommerce.com'

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.1.0'
  s.add_dependency 'spree_auth_devise'
  s.add_dependency 'multitenant'

  s.add_development_dependency 'capybara', '~> 1.1.0'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'launchy'
end
