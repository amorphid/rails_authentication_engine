module RailsAuthenticationEngine
  class SignInsController < ApplicationController
    def create
      @user = User.find_or_initialize_by(email: params[:email])

      case
      when params[:email].blank?
        @user.password = params[:password]
        @user.valid?
        render :new
      when @user.new_record?
        flash.now[:danger] = "We don't have an account for email '#{@user.email}' :P  If needed, you can sign up <a href='#{new_sign_up_email_path}'>here</a>!".html_safe
        render :new
      when @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to main_app.root_path, flash: { success: 'You are now logged in.  Exciting!' }
      else
        flash.now[:danger] = "That's the incorrect password for the account with email '#{@user.email}' :P<br />If needed, click <a href='#{}'>here</a> to reset your password!".html_safe
        render :new
      end
    end

    def new
      @user = User.new
    end
  end
end
