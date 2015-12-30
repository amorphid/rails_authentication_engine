module RailsAuthenticationEngine
  class PasswordRecoveryEmailsController < RailsAuthenticationEngine::BaseEmailConfirmationsController
    private

    def email_method
      :password_recovery
    end
  end
end
