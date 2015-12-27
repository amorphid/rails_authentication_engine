module RailsAuthenticationEngine
  class SignUpPasswordsController < ApplicationController
    prepend_before_action :authenticate_guest!

    def create
      if PasswordReset.exists?(token: session[:password_reset_token])
        password_reset = PasswordReset.find_by(token: session[:password_reset_token])

        if (DateTime.now.utc.to_f - password_reset.created_at.to_f) > 86400
          flash[:error] = "Expired password link.  Please enter your email to receive another one."
          redirect_to new_sign_up_email_path
        else
          email_confirmation = password_reset.email_confirmation
          @user = User.find_or_initialize_by(email: email_confirmation.email)

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
      else
        flash[:error] = "Invalid password link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      end
    end

    def new
      if EmailConfirmation.exists?(token: params[:token])
        email_confirmation = EmailConfirmation.find_by(token: params[:token])
        if (DateTime.now.utc.to_f - email_confirmation.created_at.to_f) > 86400
          flash[:error] = "Expired email confirmation link.  Please enter your email to receive another one."
          redirect_to new_sign_up_email_path
        else
          reset = PasswordReset.create(email_confirmation_id: email_confirmation.id)
          session[:password_reset_token] = reset.token
          @user = User.new
          render :new
        end
      else
        flash[:error] = "Invalid email confirmation link.  Please enter your email to receive another one."
        redirect_to new_sign_up_email_path
      end
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

    def user_params
      params.permit(:password)
    end
  end
end
