module RailsAuthenticationEngine
  class SignInsController < RailsAuthenticationEngine::ApplicationController
    prepend_before_action :set_sign_in_manager,
                          :authenticate_guest!

    before_action :vet_email!,
                  :vet_user!,
                  only: :create

    def create
      if manager.user_authenticate?
        manager.redirect_to_continue_url
      else
        manager.render_new_for_unauthenticated_user
      end
    end

    def new
      manager.render_new
    end

    private

    def manager
      @sign_in_manager
    end

    def set_sign_in_manager
      @sign_in_manager = SignIn::Manager.new(self, sign_up_params)
    end

    def sign_up_params
      params.permit(:continue_url, :email, :password)
    end

    def vet_user!
      if manager.user_invalid?
        manager.render_new_for_invalid_user
      end
    end

    def vet_email!
      if manager.email_invalid?
        manager.render_new_for_invalid_email
      end
    end
  end
end
