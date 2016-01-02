Rails.application.configure do
  config.action_controller.perform_caching = false
  config.active_record.migration_error = :page_load
  config.active_support.deprecation = :log
  config.assets.debug = true
  config.assets.digest = true
  config.assets.raise_runtime_errors = true
  config.cache_classes = false
  config.consider_all_requests_local = true
  config.eager_load = false

  # default url options (allows for use of `root_url` helper)
  Rails.application.routes.default_url_options = { host: 'localhost', port: 3000 }

  # email
  config.action_mailer.delivery_method = :letter_opener
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
end
