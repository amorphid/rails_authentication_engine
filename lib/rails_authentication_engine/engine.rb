module RailsAuthenticationEngine
  class Engine < ::Rails::Engine
    isolate_namespace RailsAuthenticationEngine

    config.generators do |g|
      g.test_framework :rspec, :fixture => false
    end
  end
end
