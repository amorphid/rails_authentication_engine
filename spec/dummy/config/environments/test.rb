Rails.application.configure do
  config.action_controller.allow_forgery_protection = false
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.active_support.test_order = :random
  config.cache_classes = true
  config.consider_all_requests_local = true
  config.eager_load = false
  config.serve_static_files = true
  config.static_cache_control = 'public, max-age=3600'

  # default url options (allows for use of `root_url` helper)
  Rails.application.routes.default_url_options = { host: 'test.host', port: 80 }

  # email
  config.action_mailer.default_url_options = { host: 'test.host2', port: 80 }

  # I18n
  config.action_view.raise_on_missing_translations = true
end
