module RailsAuthenticationEngine
  class BaseEmailConfirmationsController < RailsAuthenticationEngine::ApplicationController
    prepend_before_action :authenticate_guest!

    def create
      if email_confirmation.update(email_confirmation_params)
        send_email_confirmation_email
        render_show
      else
        render_new
      end
    end

    def new
      render_new
    end

    private

    def email
      @email ||= params[:email] || ''
    end

    def email_present?
      email.present?
    end

    def email_confirmation
      @email_confirmation ||= if email_present?
        vetted_email_confirmation
      else
        new_email_comfirmation
      end
    end

    def email_confirmation_params
      params.permit(:email)
    end

    def email_confirmation_expired?(email_confirmation)
      (DateTime.now.utc.to_f - email_confirmation.created_at.to_f) >= 86400
    end

    def new_email_comfirmation
      EmailConfirmation.new
    end

    def presenter
      EmailConfirmationPresenter.present({
        email_confirmation: email_confirmation,
        form_path:          base_email_confirmation_email_path
      })
    end

    def send_email_confirmation_email
      UserMailer
      .send(mailer_method, email_confirmation)
      .deliver_now
    end

    def vetted_email_confirmation
      email_confirmation = EmailConfirmation.find_or_initialize_by(email: params[:email])

      if email_confirmation_expired?(email_confirmation)
        email_confirmation.destroy
        EmailConfirmation.new(email: params[:email])
      else
        email_confirmation
      end
    end
  end
end
