module RailsAuthenticationEngine
  module RedirectHelpers
    def flash_redirect(type:, message:)
      if type && message
        flash[type] = message
      end
    end

    def redirect_with_alert(alert:, path:)
      flash_redirect(alert)
      redirect_to path
    end
  end
end
