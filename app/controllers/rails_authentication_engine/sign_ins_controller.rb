module RailsAuthenticationEngine
  class SignInsController < RailsAuthenticationEngine::ApplicationController

    prepend_before_action :authenticate_guest!

    before_action :vet_email!,
                  :vet_user!,
                  only: :create

    def create
      if user_authenticate?
        set_session_user_id
        redirect_to_continue_url
      else
        render_new_for_unauthenticated_user
      end
    end

    def new
      render_new
    end

    private

    def continue_url
      @continue_url ||= params[:continue_url] || main_app.root_url
    end

    def email
      @email ||= params[:email]
    end

    def email_invalid?
      email.blank?
    end

    def flash_now(type: nil, message: nil)
      if type && message
        flash.now[type] = message
      end
    end

    def invalid_user_message
      t('rails_authentication_engine.sign_in.invalid_email', {
        email: user.email,
        path: new_sign_up_email_path
      })
    end

    def invalid_user_alert
      {
        type:    :danger,
        message: invalid_user_message
      }
    end

    def password
      @password ||= params[:password]
    end

    def presenter
      SignInPresenter.present(continue_url, user)
    end

    def render_new(alert = {})
      render_type({
        type:  :new,
        alert: alert
      })
    end

    def render_new_for_invalid_email
      trigger_user_errors
      render_new
    end

    def render_new_for_invalid_user
      render_new(invalid_user_alert)
    end

    def render_new_for_unauthenticated_user
      render_new(unauthenticated_user_alert)
    end

    def render_type(type:, alert:)
      flash_now(alert)
      render(type, locals: { presenter: presenter })
    end

    def redirect_to_continue_url
      redirect_to(continue_url, flash: {
        success: t('rails_authentication_engine.sign_in.success')
      })
    end

    def set_session_user_id
      session[:user_id] = user.id
    end

    def sign_up_params
      params.permit(:continue_url, :email, :password)
    end

    def trigger_user_errors
      user.password = password
      user.valid?
    end

    def unauthenticated_user_alert
      {
        type:    :danger,
        message: unauthenticated_user_message
      }
    end

    def unauthenticated_user_message
      t('rails_authentication_engine.sign_in.invalid_password', {
        email: user.email,
        path:  new_password_recovery_email_path
      })
    end

    def user
      @user ||= User.find_or_initialize_by(email: email)
    end

    def user_authenticate?
      user.authenticate(password)
    end

    def user_invalid?
      user.new_record?
    end

    def user_new?
      user.new_record?
    end

    def vet_email!
      if email_invalid?
        render_new_for_invalid_email
      end
    end

    def vet_user!
      if user_invalid?
        render_new_for_invalid_user
      end
    end
  end
end
