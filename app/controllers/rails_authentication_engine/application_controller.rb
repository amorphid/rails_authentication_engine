module RailsAuthenticationEngine
  class ApplicationController < ::ActionController::Base
    def authenticate_guest!
      if User.exists?(session[:user_id])
        flash[:info] = t('rails_authentication_engine.flash.authenticated_user_exists')
        redirect_to main_app.root_path
      end
    end
  end
end
