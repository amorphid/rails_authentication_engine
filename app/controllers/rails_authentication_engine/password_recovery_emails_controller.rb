module RailsAuthenticationEngine
  class PasswordRecoveryEmailsController < RailsAuthenticationEngine::BaseEmailConfirmationsController
    private

    def mailer_method
      :password_recovery
    end
  end
end
