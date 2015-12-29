module RailsAuthenticationEngine
  class BasePasswordResetsController < ApplicationController
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
        flash[:success] = successful_email_confirmation_flash_message
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
        flash[:error] = expired_email_confirmation_flash_message
        redirect_to new_email_confirmation_path_helper
      end
    end

    def vet_email_confirmation_exists_and_set_email_confirmation
      confirmation_does_not_exist = !EmailConfirmation.exists?(token: params[:token])

      if confirmation_does_not_exist
        flash[:danger] = invalid_email_confirmation_flash_message
        redirect_to new_email_confirmation_path_helper
      else
        @email_confirmation = EmailConfirmation.find_by(token: params[:token])
      end
    end

    def vet_password_reset_and_set_email_confirmation
      password_reset            = PasswordReset.find_by(token: session[:password_reset_token])
      password_reset_is_expired = (DateTime.now.utc.to_f - password_reset.created_at.to_f) >= 86400

      if password_reset_is_expired
        flash[:danger] = expired_email_confirmation_flash_message
        redirect_to new_email_confirmation_path_helper
      else
        @email_confirmation = password_reset.email_confirmation
      end
    end

    def vet_password_reset_exists
      password_reset_does_not_exist = !PasswordReset.exists?(token: session[:password_reset_token])

      if password_reset_does_not_exist
        flash[:danger] = invalid_email_confirmation_flash_message
        redirect_to new_email_confirmation_path_helper
      end
    end
  end
end
