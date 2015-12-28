module RailsAuthenticationEngine
  class PasswordRecoveryEmailsController < BaseEmailConfirmationsController
    private

    def email_method
      :email_confirmation
    end
  end
end
