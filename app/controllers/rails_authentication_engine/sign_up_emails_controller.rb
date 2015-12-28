module RailsAuthenticationEngine
  class SignUpEmailsController < BaseEmailConfirmationsController
    private

    def email_method
      :sign_up
    end
  end
end
