module RailsAuthenticationEngine
  class SignUpEmailsController < BaseEmailConfirmationsController
    private

    def email_method
      :email_confirmation
    end
  end
end
