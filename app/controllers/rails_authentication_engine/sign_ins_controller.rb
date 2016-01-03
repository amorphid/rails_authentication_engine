module RailsAuthenticationEngine
  class SignInsController < RailsAuthenticationEngine::ApplicationController
    include SignIn::Manager

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

    def sign_up_params
      params.permit(:continue_url, :email, :password)
    end

    def vet_user!
      if user_invalid?
        render_new_for_invalid_user
      end
    end

    def vet_email!
      if email_invalid?
        render_new_for_invalid_email
      end
    end
  end
end
