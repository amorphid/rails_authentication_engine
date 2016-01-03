module RailsAuthenticationEngine
  class SignInsController < RailsAuthenticationEngine::ApplicationController
    # include SignIn::Manager

    prepend_before_action :authenticate_guest!

    before_action :vet_email!,
                  :vet_user!,
                  only: :create

    def create
      if user_authenticate?
        redirect_to_continue_url
      else
        render_new_for_unauthenticated_user
      end
    end

    def new
      render_new
    end

    private

    def continue_url
      @continue_url ||= params[:continue_url] || main_app.root_url
    end

    def email
      @email ||= params[:email]
    end

    def email_invalid?
      email.blank?
    end

    def password
      @password ||= params[:password]
    end

    def presenter
      SignIn::Presenter.present(continue_url: continue_url, user: user)
    end

    def render_new
      render :new, locals: { presenter: presenter }
    end

    def render_new_for_invalid_email
      user.password = password
      user.valid?
      render_new
    end

    def render_new_for_invalid_user
      flash.now[:danger] = t('rails_authentication_engine.sign_in.invalid_email', {
        email: user.email,
        path: new_sign_up_email_path
      })
      render_new
    end

    def render_new_for_unauthenticated_user
      flash.now[:danger] = t('rails_authentication_engine.sign_in.invalid_password', {
          email: user.email,
          path:  new_password_recovery_email_path
        })
      render_new
    end

    def redirect_to_continue_url
      session[:user_id] = user.id
      flash[:success]   = t('rails_authentication_engine.sign_in.success')
      redirect_to continue_url
    end

    def sign_up_params
      params.permit(:continue_url, :email, :password)
    end

    def user
      @user ||= User.find_or_initialize_by(email: email)
    end

    def user_authenticate?
      user.authenticate(password)
    end

    def user_invalid?
      user.new_record?
    end

    def user_new?
      user.new_record?
    end

    def vet_email!
      if email_invalid?
        render_new_for_invalid_email
      end
    end

    def vet_user!
      if user_invalid?
        render_new_for_invalid_user
      end
    end
  end
end
