module RailsAuthenticationEngine
  class SignUpsController < ApplicationController

    def new
    end

    def create
      if @user.update(sign_up_params)
        UserMailer.email_confirmation(@user).deliver_now
        render :show
      else
        render :new
      end
    end

    private

    def find_or_initialize_user
      User.find_or_initialize_by(email: params[:email])
    end

    def set_user
      @user ||= CreateSignUpUserDelegator.new(find_or_initialize_user)
    end

    def sign_up_params
      params.permit(:email).merge({
        reset_password_token:   @user.reset_password_token_as_md5_hash,
        reset_password_sent_at: DateTime.new.getutc
      })
    end
  end
end
