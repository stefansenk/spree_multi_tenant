source 'http://rubygems.org'

group :test do
  gem 'ffaker'
end

group :assets do
  gem 'sass-rails', "~> 3.2"
  gem 'coffee-rails', "~> 3.2"
  gem 'therubyracer'
end

if RUBY_VERSION < "1.9"
  gem "ruby-debug"
else
  gem "ruby-debug19"
end

gem 'spree', :git => 'git://github.com/spree/spree.git', :branch => '1-2-stable'
gem 'spree_auth_devise', :git => 'git://github.com/spree/spree_auth_devise.git', :branch => '1-2-stable'

gemspec

