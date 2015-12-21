module RailsAuthenticationEngine
  class SignUpPasswordsController < ApplicationController
    def create
      reset = PasswordResetUser.find_by(token: session[:password_reset_token])

      if DateTime.now.utc.to_f - reset.created_at.to_f > 86400
        binding.pry
      end
    end

    def new
      if EmailConfirmation.exists?(token: params[:token])
        email_confirmation = EmailConfirmation.find_by(token: params[:token])
        if (DateTime.now.utc.to_f - email_confirmation.created_at.to_f) > 86400
          flash[:error] = "Expired email confirmation link.  Please enter your email to receive another one."
          redirect_to new_sign_up_email_path
        else
          reset = PasswordReset.create(token: SecureRandom.urlsafe_base64(24), email_confirmation_id: email_confirmation.id)
          session[:password_reset_token] = reset.token
          render :new
        end
      else
        flash[:error] = "Invalid email confirmation link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      end
    end

    private

    def sign_up_password_params
      params.permit(:token)
    end
  end
end
