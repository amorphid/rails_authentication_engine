module RailsAuthenticationEngine
  module AuthenticationHelpers
    include RedirectHelpers

    def authenticate!
      unless current_user
        redirect_with_alert({
          alert: alert_danger(t('rails_authentication_engine.authentication.sign_in_required')),
          path:  rails_authentication_engine.new_sign_in_path(continue_url: request.url)
        })
      end
    end

    def authenticate_guest!
      if User.exists?(session[:user_id])
        redirect_with_alert({
          alert: alert_info(t('rails_authentication_engine.authentication.already_signed_in')),
          path:  main_app.root_path
        })
      end
    end

    def current_user
      if User.exists?(session[:user_id])
        @user = User.find(session[:user_id])
      else
        session[:user_id] = nil
      end
    end

    def session_user_id_set
      session[:user_id] = user.id
    end
  end
end
