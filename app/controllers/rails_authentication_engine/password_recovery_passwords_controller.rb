module RailsAuthenticationEngine
  class PasswordRecoveryPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def  expired_email_confirmation_flash_message
      t('rails_authentication_engine.flash.expired_password_recovery_email')
    end

    def invalid_email_confirmation_flash_message
      t('rails_authentication_engine.flash.invalid_password_recovery_email')
    end

    def successful_password_reset_flash_message
      t('rails_authentication_engine.flash.successful_password_recovery')
    end

    def new_email_confirmation_path_helper
      new_password_recovery_email_path
    end
  end
end
