class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def authenticate!
    unless current_user
      redirect_to rails_authentication_engine.new_sign_in_path, {
        flash: {
          danger: 'You must be logged in to visit that page.'
        }
      }
    end
  end

  def current_user
    if User.exists?(session[:user_id])
      @user = User.find(session[:user_id])
    else
      session[:user_id] = nil
    end
  end
end
