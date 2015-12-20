module RailsAuthenticationEngine
  class SignUpEmailsController < ApplicationController
    before_action :set_user

    def create
      if @user.update(sign_up_email_params)
        UserMailer.email_confirmation(@user).deliver_now
        render :show
      else
        render :new
      end
    end

    def new
    end

    private

    def find_or_initialize_user
      User.find_or_initialize_by(email: params[:email])
    end

    def set_user
      @user ||= CreateSignUpUserDelegator.new(find_or_initialize_user)
    end

    def sign_up_email_params
      params.permit(:email).merge({
        reset_password_token:   @user.reset_password_token_as_urlsafe_base64,
        reset_password_sent_at: DateTime.now.utc
      })
    end
  end
end
