module RailsAuthenticationEngine
  class PasswordRecoveryEmailsController < BaseEmailConfirmationsController
    private

    def email_method
      :password_recovery
    end
  end
end
