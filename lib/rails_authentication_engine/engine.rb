module RailsAuthenticationEngine
  class Engine < ::Rails::Engine
    isolate_namespace RailsAuthenticationEngine

    config.generators do |g|
      g.test_framework      :rspec, fixture: true
    end

    initializer :append_migrations do |app|
      config.paths["db/migrate"].expanded.each do |expanded_path|
        app.config.paths["db/migrate"] << expanded_path
      end
    end
  end
end
