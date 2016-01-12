module RailsAuthenticationEngine
  class PasswordRecoveryPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def expired_email_confirmation_alert
      alert_danger(t('rails_authentication_engine.password_recovery.expired'))
    end

    def invalid_email_confirmation_alert
      alert_danger(t('rails_authentication_engine.password_recovery.invalid'))
    end

    def new_email_confirmation_path_helper
      new_password_recovery_email_path
    end

    def notify_user
      if user_new?
        flash.now[:info] = t(
          'rails_authentication_engine.password_recovery.new_user',
          email: user.email
        )
      end
    end

    def successful_password_reset_alert
      alert_success(t('rails_authentication_engine.password_recovery.success'))
    end
  end
end
