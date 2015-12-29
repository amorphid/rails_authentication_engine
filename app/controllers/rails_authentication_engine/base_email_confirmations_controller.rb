module RailsAuthenticationEngine
  class BaseEmailConfirmationsController < ApplicationController
    prepend_before_action :authenticate_guest!

    before_action :set_email_confirmation, only: :create

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

    def set_email_confirmation
      @email_confirmation ||= EmailConfirmation.find_or_initialize_by(email: params[:email])
    end

    def email_confirmation_params
      params.permit(:email)
    end
  end
end
