module RailsAuthenticationEngine
  class BasePasswordResetsController < RailsAuthenticationEngine::ApplicationController
    prepend_before_action :authenticate_guest!

    before_action :vet_password_reset_exists,
                  :vet_password_reset_and_set_email_confirmation,
                  only: :create

    before_action :vet_email_confirmation_exists_and_set_email_confirmation,
                  :vet_email_confirmation,
                  :vet_user!,
                  only: :new

    append_before_action :notify_user

    def create
      if user.update(user_params)
        email_confirmation_destroy
        session_password_reset_totken_destroy
        session_user_id_set
        redirect_with_alert({
          alert: successful_password_reset_alert,
          path:  main_app.root_path
        })
      else
        render_new
      end
    end

    def new
      session[:password_reset_token] = PasswordReset
                                       .create(email_confirmation_id: email_confirmation.id)
                                       .token
      render_new
    end

    private

    def email_confirmation
      @_email_confirmation
    end

    def email_confirmation_destroy
      email_confirmation.destroy
    end

    def email_confirmation_exists?
      EmailConfirmation.exists?(token: params[:token])
    end

    def email_confirmation_expired?
      (DateTime.now.utc.to_f - email_confirmation.created_at.to_f) >= 86400
    end

    def session_password_reset_totken_destroy
      session[:password_reset_token] = nil
    end

    def password_reset
      @_password_reset ||= PasswordReset.find_by(token: session[:password_reset_token])
    end

    def password_reset_exists?
      PasswordReset.exists?(token: session[:password_reset_token])
    end

    def password_reset_expired?
      (DateTime.now.utc.to_f - password_reset.created_at.to_f) >= 86400
    end

    def presenter
      PasswordResetPresenter.present({
        form_path: sign_up_passwords_path,
        user:      user
      })
    end

    def user
      @_user ||= User.find_or_initialize_by(email: email_confirmation.email)
    end

    def user_params
      params.permit(:password)
    end

    def vet_password_reset_and_set_email_confirmation
      if password_reset_expired?
        redirect_with_alert({
          alert: expired_email_confirmation_alert,
          path:  new_email_confirmation_path_helper
        })
      else
        @_email_confirmation = password_reset.email_confirmation
      end
    end

    def vet_password_reset_exists
      unless password_reset_exists?
        redirect_with_alert({
          alert: invalid_email_confirmation_alert,
          path:  new_email_confirmation_path_helper
        })
      end
    end

    def vet_email_confirmation
      if email_confirmation_expired?
        redirect_with_alert({
          alert: expired_email_confirmation_alert,
          path:  new_email_confirmation_path_helper
        })
      end
    end

    def vet_email_confirmation_exists_and_set_email_confirmation
      unless email_confirmation_exists?
        redirect_with_alert({
          alert: invalid_email_confirmation_alert,
          path:  new_email_confirmation_path_helper
        })
      else
        @_email_confirmation = EmailConfirmation.find_by(token: params[:token])
      end
    end

    def vet_user!
      raise "implement me"
    end
  end
end
