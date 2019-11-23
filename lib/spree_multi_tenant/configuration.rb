module SpreeMultiTenant
  class Configuration
    attr_accessor :use_tenanted_controllers
    attr_accessor :use_tenanted_mailers

    def initialize
      @use_tenanted_controllers = true
      @use_tenanted_mailers = true
    end
  end
end
