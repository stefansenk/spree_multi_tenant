source 'http://rubygems.org'

group :test do
  gem 'ffaker'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gem 'spree', :git => 'git://github.com/spree/spree.git', :tag => 'v1.2.0'
gem 'spree_auth_devise', :git => 'git://github.com/spree/spree_auth_devise.git', :branch => '1-2-stable'


gemspec

