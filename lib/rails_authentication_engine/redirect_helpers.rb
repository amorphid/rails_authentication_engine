module RailsAuthenticationEngine
  module RedirectHelpers
    def alert_danger(message)
      alert_type_and_message(:danger, message)
    end

    def alert_info(message)
      alert_type_and_message(:info, message)
    end

    def alert_success(message)
      alert_type_and_message(:success, message)
    end

    def alert_type_and_message(type, message)
      {
        type:    type,
        message: message
      }
    end

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
