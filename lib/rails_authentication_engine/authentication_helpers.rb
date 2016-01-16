module RailsAuthenticationEngine
  module AuthenticationHelpers
    def authenticate!
      unless current_user
        flash[:danger] = t('rails_authentication_engine.authentication.sign_in_required')
        # flash[:danger] = 'You must be logged in to visit that page.'
        redirect_to rails_authentication_engine.new_sign_in_path(continue_url: request.url)
      end
    end

    def authenticate_guest!
      if User.exists?(session[:user_id])
        flash[:info] = t('rails_authentication_engine.flash.authenticated_user_exists')
        redirect_to main_app.root_path
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
