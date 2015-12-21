module RailsAuthenticationEngine
  class SignUpEmailsController < ApplicationController
    before_action :set_email_confirmation, only: :create

    def create
      if @email_confirmation.update(email_confirmation_params)
        UserMailer.email_confirmation(@email_confirmation).deliver_now
        render :show
      else
        render :new
      end
    end

    def new
      @email_confirmation = EmailConfirmation.new
    end

    private

    def find_or_initialize_email_confirmation

    end

    def set_email_confirmation
      @email_confirmation ||= EmailConfirmation.find_or_initialize_by(email: params[:email])
    end

    def email_confirmation_params
      params.permit(:email)
    end
  end
end
