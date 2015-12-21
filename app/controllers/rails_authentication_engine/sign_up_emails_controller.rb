module RailsAuthenticationEngine
  class SignUpEmailsController < ApplicationController
    before_action :set_user

    def create
      if @user.update(sign_up_email_params)
        EmailConfirmation.create(
          sent_at: DateTime.now.utc,
          token: @user.email_confirmation_token,
          user_id: @user.id
        )
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
      params.permit(:email)
    end
  end
end
