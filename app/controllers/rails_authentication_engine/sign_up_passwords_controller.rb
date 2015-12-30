module RailsAuthenticationEngine
  class SignUpPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def expired_email_confirmation_flash_message
      'Expired password recovery email link.  Please enter your email to receive another one.'
    end

    def invalid_email_confirmation_flash_message
      t('rails_authentication_engine.flash.invalid_sign_up_email')
    end

    def new_email_confirmation_path_helper
      new_sign_up_email_path
    end
  end
end
