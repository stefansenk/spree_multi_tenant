module SpreeMultiTenant
  module Generators
    class InstallGenerator < Rails::Generators::Base

      class_option :auto_run_migrations, :type => :boolean, :default => false

      def add_javascripts
        append_file 'vendor/assets/javascripts/spree/frontend/all.js', "//= require spree/frontend/spree_multi_tenant\n"
        append_file 'vendor/assets/javascripts/spree/backend/all.js', "//= require spree/backend/spree_multi_tenant\n"
      end

      def add_stylesheets
        inject_into_file 'vendor/assets/stylesheets/spree/frontend/all.css', " *= require spree/frontend/spree_multi_tenant\n", :before => /\*\//, :verbose => true
        inject_into_file 'vendor/assets/stylesheets/spree/backend/all.css', " *= require spree/backend/spree_multi_tenant\n", :before => /\*\//, :verbose => true

        # Disable caching.
        # TODO Do this in a better place.
        prepend_file 'config/environments/test.rb', "Dummy::Application.configure{ config.cache_store = :memory_store, {size: 0} } \# Disable caching for spree_multi_tenant\n"
      end

      def add_migrations
        run 'bundle exec rake railties:install:migrations FROM=spree_multi_tenant'
      end

      def run_migrations
        run_migrations = options[:auto_run_migrations] || ['', 'y', 'Y'].include?(ask 'Would you like to run the migrations now? [Y/n]')
        if run_migrations
          run 'bundle exec rake db:migrate'
        else
          puts 'Skipping rake db:migrate, don\'t forget to run it!'
        end
      end
    end
  end
end
