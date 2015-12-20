module RailsAuthenticationEngine
  class SignUpPasswordsController < ApplicationController
    before_action :set_user

    def create
      if @user && @user.password_reset_token == params[:token]
      end
    end

    def new
      if User.exists?(reset_password_token: params[:token])
        @user = User.find_by(reset_password_token: params[:token])
        if DateTime.now.utc.to_f - @user.reset_password_sent_at.to_f > 86400
          flash[:error] = "Expired email confirmation link.  Please enter your email to receive another one."
          redirect_to new_sign_up_email_path
        else
          render :new
        end
      else
        flash[:error] = "Invalid email confirmation link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      end
    end

    private

    def set_user

    end

    def sign_up_password_params
      params.permit(:token)
    end
  end
end
