module RailsAuthenticationEngine
  class SignInsController < RailsAuthenticationEngine::ApplicationController
    prepend_before_action :set_presenter, :authenticate_guest!

    before_action :vet_email_params,
                  :vet_user,
                  only: :create

    def create
      case
      when user.authenticate(params[:password])
        session[:user_id] = user.id
        flash[:success]   = t('rails_authentication_engine.sign_in.success')
        redirect_to params[:continue_url]
      else
        flash.now[:danger] = "That's the incorrect password for the account with email '#{@user.email}' :P<br />If needed, click <a href='#{}'>here</a> to reset your password!".html_safe
        render :new
      end
    end

    def new
    end

    private

    def set_presenter
      @presenter ||= SignInPresenter.present(continue_url: params[:continue_url], user: user)
    end

    def user
      @user ||= User.find_or_initialize_by(email: params[:email])
    end

    def vet_user
      is_not_existing_user = @user.new_record?

      if is_not_existing_user
        flash.now[:danger] = t('rails_authentication_engine.sign_in.no_account', email: user.email, path: new_sign_up_email_path)
        render :new
      end
    end

    def vet_email_params
      no_email_provided = params[:email].blank?

      if no_email_provided
        user.password = params[:password]
        user.valid?
        render :new
      end
    end
  end
end
