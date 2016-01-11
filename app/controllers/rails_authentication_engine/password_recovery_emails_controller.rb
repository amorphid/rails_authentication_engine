module RailsAuthenticationEngine
  class PasswordRecoveryEmailsController < RailsAuthenticationEngine::BaseEmailConfirmationsController
    private

    def base_email_confirmation_email_path
      password_recovery_emails_path
    end

    def mailer_method
      :password_recovery
    end
  end
end
