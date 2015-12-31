def i18n_missing_translation(message)
  "translation missing: #{I18n.locale}.#{message}"
end

def url_helper(path_or_url)
  routes = {}.tap do |hash|
    Rails.application.routes.url_helpers.tap do |helpers|
      helpers.methods.grep(/_path/).each do |path|
        key = "main_app.#{path}"
        hash[key] = Rails.application.routes.url_helpers
      end
    end
  end

  methyd = path_or_url.split(".").last.to_sym
  routes[path_or_url].send(methyd)
end
