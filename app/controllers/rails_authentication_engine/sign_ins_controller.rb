module RailsAuthenticationEngine
  class SignInsController < RailsAuthenticationEngine::ApplicationController
    prepend_before_action :set_sign_in_manager,
                          :authenticate_guest!

    before_action :vet_email!,
                  :vet_user!,
                  only: :create

    def create
      if user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success]   = t('rails_authentication_engine.sign_in.success')
        redirect_to continue_url
      else
        flash.now[:danger] = t('rails_authentication_engine.sign_in.invalid_password', {
          email: user.email,
          path:  new_password_recovery_email_path
        })
        render :new, locals: { presenter: presenter }
      end
    end

    def new
      sign_in_manager.render_new
    end

    private

    def sign_in_manager
      @sign_in_manager
    end

    def set_sign_in_manager
      @sign_in_manager = SignInManager.new(self, sign_up_params)
    end

    def continue_url
      sign_up_params[:continue_url] || main_app.root_url
    end

    def presenter
      SignInPresenter.present(continue_url: params[:continue_url], user: user)
    end

    def sign_up_params
      params.permit(:continue_url, :email, :password)
    end



    def vet_user!
      if sign_in_manager.new_record?

        flash.now[:danger] = t('rails_authentication_engine.sign_in.invalid_email', email: user.email, path: new_sign_up_email_path)
        render :new, locals: { presenter: presenter }
      end
    end

    def vet_email!
      unless sign_in_manager.email_valid?
        sign_in_manager.validate_user_and_render_new
      end
    end
  end

  class SignInManager
    def initialize(controller, params)
      @controller = controller
      @params     = params
    end

    def email_valid?
      email.present?
    end

    def render_new
      controller.render :new, locals: { presenter: presenter }
    end

    def validate_user_and_render_new
      user.password = password
      user.valid?
      render_new
    end

    private

    attr_reader :controller,
                :params

    def continue_url
      @continue_url ||= params[:continue_url]
    end

    def email
      @email ||= params[:email]
    end

    def user
      @user ||= User.find_or_initialize_by(email: email)
    end

    def password
      @password ||= params[:password]
    end

    def presenter
      SignInPresenter.present(continue_url: continue_url, user: user)
    end
  end
end
