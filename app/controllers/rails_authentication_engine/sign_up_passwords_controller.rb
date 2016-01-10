module RailsAuthenticationEngine
  class SignUpPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def expired_email_confirmation_alert
      {
        type:    :danger,
        message: t('rails_authentication_engine.sign_up.expired')
      }
    end

    def invalid_email_confirmation_alert
      {
        type:    :danger,
        message: t('rails_authentication_engine.sign_up.invalid')
      }
    end

    def new_email_confirmation_path_helper
      new_sign_up_email_path
    end

    def notify_user
      is_an_existing_user = !user.new_record?

      if is_an_existing_user
        flash.now[:info] = t(
          'rails_authentication_engine.sign_up.existing_user',
          email: user.email
        )
      end
    end

    def successful_password_reset_alert
      t('rails_authentication_engine.sign_up.success')
    end
  end
end
