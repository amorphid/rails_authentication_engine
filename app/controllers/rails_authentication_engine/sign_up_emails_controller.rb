module RailsAuthenticationEngine
  class SignUpEmailsController < RailsAuthenticationEngine::BaseEmailConfirmationsController
    private

    def base_email_confirmation_email_path
      sign_up_emails_path
    end

    def mailer_method
      :sign_up
    end
  end
end
