module RailsAuthenticationEngine
  class PasswordRecoveryPasswordsController < RailsAuthenticationEngine::BasePasswordResetsController
    private

    def expired_email_confirmation_flash_message
      t('rails_authentication_engine.flash.expired_password_recovery_email')
    end

    def invalid_email_confirmation_flash_message
      t('rails_authentication_engine.flash.invalid_password_recovery_email')
    end

    def new_email_confirmation_path_helper
      new_password_recovery_email_path
    end

    def set_and_notify_user
      email         = email_confirmation.email
      @user         = User.find_or_initialize_by(email: email)
      is_a_new_user = @user.new_record?

      if is_a_new_user
        flash.now[:info] = t(
          'rails_authentication_engine.flash.new_user_password_reset_flash_message',
          email: email
        )
      end
    end

    def successful_password_reset_flash_message
      t('rails_authentication_engine.flash.successful_password_recovery')
    end
  end
end
