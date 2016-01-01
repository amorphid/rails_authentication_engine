module RailsAuthenticationEngine
  class BaseEmailConfirmationsController < RailsAuthenticationEngine::ApplicationController
    prepend_before_action :authenticate_guest!

    before_action :vet_and_set_email_confirmation, only: :create

    def create
      if @email_confirmation.update(email_confirmation_params)
        UserMailer.send(email_method, @email_confirmation).deliver_now
        render :show
      else
        render :new
      end
    end

    def new
      @email_confirmation = EmailConfirmation.new
      render :new
    end

    private

    def vet_and_set_email_confirmation
      email_confirmation            = EmailConfirmation.find_or_initialize_by(email: params[:email])
      email_confirmation_is_expired = (DateTime.now.utc.to_f - email_confirmation.created_at.to_f) >= 86400

      @email_confirmation ||= if email_confirmation_is_expired
        email_confirmation.destroy
        EmailConfirmation.new(email: params[:email])
      else
        email_confirmation
      end
    end

    def email_confirmation_params
      params.permit(:email)
    end
  end
end
