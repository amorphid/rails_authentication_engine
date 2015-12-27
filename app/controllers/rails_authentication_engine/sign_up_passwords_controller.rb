module RailsAuthenticationEngine
  class SignUpPasswordsController < ApplicationController
    prepend_before_action :authenticate_guest!

    before_action :vet_password_reset_exists,
                  :vet_password_reset_and_set_email_confirmation,
                  :set_user,
                  only: :create

    before_action :vet_email_confirmation_exists_and_set_email_confirmation,
                  :vet_email_confirmation,
                  only: :new

    def create
      if @user.update(user_params)
        email_confirmation.password_resets.delete_all
        email_confirmation.destroy
        session[:password_reset_token] = nil
        session[:user_id] = @user.id
        flash[:success] = "Password set successfully.  You are now logged in.  Woot!"
        redirect_to main_app.root_path
      else
        render :new
      end
    end

    def new
      session[:password_reset_token] = PasswordReset.create(email_confirmation_id: email_confirmation.id).token
      @user = User.new
    end

    private

    def authenticate_guest!
      if User.exists?(session[:user_id])
        redirect_to main_app.root_path, {
          flash: {
            notice: 'Your password has already been set, and you are logged in!'
          }
        }
      end
    end

    def email_confirmation
      @email_confirmation
    end

    def user_params
      params.permit(:password)
    end

    def set_user
      @user = User.find_or_initialize_by(email: email_confirmation.email)
    end

    def vet_email_confirmation
      email_confirmation_is_expired = (DateTime.now.utc.to_f - email_confirmation.created_at.to_f) >= 86400

      if email_confirmation_is_expired
        flash[:error] = "Expired email confirmation link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      end
    end

    def vet_email_confirmation_exists_and_set_email_confirmation
      confirmation_does_not_exist = !EmailConfirmation.exists?(token: params[:token])

      if confirmation_does_not_exist
        flash[:error] = "Invalid email confirmation link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      else
        @email_confirmation = EmailConfirmation.find_by(token: params[:token])
      end
    end

    def vet_password_reset_and_set_email_confirmation
      password_reset            = PasswordReset.find_by(token: session[:password_reset_token])
      password_reset_is_expired = (DateTime.now.utc.to_f - password_reset.created_at.to_f) >= 86400

      if password_reset_is_expired
        flash[:error] = "Expired password link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      else
        @email_confirmation = password_reset.email_confirmation
      end
    end

    def vet_password_reset_exists
      password_reset_does_not_exist = !PasswordReset.exists?(token: session[:password_reset_token])

      if password_reset_does_not_exist
        flash[:error] = "Invalid password link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      end
    end
  end
end
