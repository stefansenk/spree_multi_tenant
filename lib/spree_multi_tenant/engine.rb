module SpreeMultiTenant
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_multi_tenant'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
        Rails.configuration.cache_classes ? require(c) : load(c)
      end
    end

    config.to_prepare &method(:activate).to_proc

    # Disable caching because Spree caching doesn't work with multitenant.
    #   For example: Rails.cache('default_store')
    initializer 'spree_multi_tenant.disable_caching' do |app|
      app.config.cache_store = :null_store
    end
  end
end
