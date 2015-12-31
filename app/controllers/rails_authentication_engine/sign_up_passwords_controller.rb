module RailsAuthenticationEngine
  class SignUpPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def expired_email_confirmation_flash_message
      t('rails_authentication_engine.flash.expired_sign_up_email')
    end

    def invalid_email_confirmation_flash_message
      t('rails_authentication_engine.flash.invalid_sign_up_email')
    end

    def new_email_confirmation_path_helper
      new_sign_up_email_path
    end

    def notify_user
      is_an_existing_user = !user.new_record?

      if is_an_existing_user
        flash.now[:info] = t(
          'rails_authentication_engine.flash.existing_user_sign_up_flash_message',
          email: user.email
        )
      end
    end

    def successful_password_reset_flash_message
      t('rails_authentication_engine.flash.successful_sign_up')
    end
  end
end
