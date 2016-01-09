module RailsAuthenticationEngine
  class SignUpEmailsController < RailsAuthenticationEngine::BaseEmailConfirmationsController
    private

    def mailer_method
      :sign_up
    end
  end
end
