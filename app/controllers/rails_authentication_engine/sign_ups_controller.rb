module RailsAuthenticationEngine
  class SignUpsController < ApplicationController
    def new
    end

    def create
      @user = User.find_or_initialize_by(email: params[:email])

      if @user.update(sign_up_params)
        UserMailer.email_confirmation(@user).deliver_now
        render :show
      else
        render :new
      end
    end

    private

    def sign_up_params
      params.permit(:email)
    end
  end
end
