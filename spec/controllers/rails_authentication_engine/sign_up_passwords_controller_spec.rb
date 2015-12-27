require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpPasswordsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    let(:email_confirmation) { Fabricate(:email_confirmation) }

    context 'create' do
      it 'redirects authenticated users to root path' do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end
    end

    context 'new' do
      it 'redirects to sign up path for invalid token' do
        get :new, token: SecureRandom.urlsafe_base64(24)
        expect(response).to redirect_to(new_sign_up_email_path)
      end

      it 'redirects to sign up path if token 24 hours old' do
        Timecop.freeze(Time.now)
        token = email_confirmation.token
        allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_400.seconds.from_now.to_f)
        get :new, token: token
        expect(response).to redirect_to(new_sign_up_email_path)
        Timecop.return
      end

      it 'does not redirect if less than 24 hours old' do
        Timecop.freeze(Time.now)
        token = email_confirmation.token
        allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_399.seconds.from_now.to_f)
        get :new, token: token
        expect(response).not_to redirect_to(new_sign_up_email_path)
        Timecop.return
      end

      it 'sets password reset token' do
        session[:password_reset_token] = nil
        get :new, token: email_confirmation.token
        expect(session[:password_reset_token]).not_to eq(nil)
      end

      it 'redirects authenticated users to root path' do
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end
    end
  end
end
