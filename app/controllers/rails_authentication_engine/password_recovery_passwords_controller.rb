module RailsAuthenticationEngine
  class PasswordRecoveryPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def expired_email_confirmation_alert
      t('rails_authentication_engine.password_recovery.expired')
    end

    def invalid_email_confirmation_alert
      t('rails_authentication_engine.password_recovery.invalid')
    end

    def new_email_confirmation_path_helper
      new_password_recovery_email_path
    end

    def notify_user
      is_a_new_user = user.new_record?

      if is_a_new_user
        flash.now[:info] = t(
          'rails_authentication_engine.password_recovery.new_user',
          email: user.email
        )
      end
    end

    def successful_password_reset_alert
      t('rails_authentication_engine.password_recovery.success')
    end
  end
end
