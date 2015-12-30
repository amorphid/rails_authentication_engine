module RailsAuthenticationEngine
  class SignUpEmailsController < RailsAuthenticationEngine::BaseEmailConfirmationsController
    private

    def email_method
      :sign_up
    end
  end
end
