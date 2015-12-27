require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpPasswordsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    let(:email_confirmation)   { Fabricate(:email_confirmation) }
    let(:password_reset_token) { Fabricate(:password_reset).token }

    context 'create' do
      it 'redirects authenticated users to root path' do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end

      it 'redirects to sign up path w/ password reset does not exist' do
        session[:password_reset_token] = nil
        post :create, password: Faker::Internet.password(7)
        expect(response).to redirect_to(new_sign_up_email_path)
      end

      it 'redirects to sign up path w/ password reset is 24 hours old' do
        Timecop.freeze(Time.now)
        session[:password_reset_token] = password_reset_token
        allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_400.seconds.from_now.to_f)
        get :create, password: Faker::Internet.password(7)
        expect(response).to redirect_to(new_sign_up_email_path)
        Timecop.return
      end

      it 'redirects to sign up path w/ password reset is 24 hours old' do
        Timecop.freeze(Time.now)
        session[:password_reset_token] = password_reset_token
        allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_399.seconds.from_now.to_f)
        get :create, password: Faker::Internet.password(7)
        expect(response).not_to redirect_to(new_sign_up_email_path)
        Timecop.return
      end

      it 'renders new template w/ password is blank' do
        session[:password_reset_token] = password_reset_token
        get :create, password: ''
        expect(response).to render_template(:new)
      end

      it 'has 2 errors on user w/ blank password' do
        session[:password_reset_token] = password_reset_token
        get :create, password: ''
        result = assigns[:user].errors.count
        expect(result).to eq(2)
      end

      it 'renders new template w/ invalid password' do
        session[:password_reset_token] = password_reset_token
        get :create, password: Faker::Internet.password(6)
        expect(response).to render_template(:new)
      end

      it 'has 1 error on user w/ invalid password' do
        session[:password_reset_token] = password_reset_token
        get :create, password: Faker::Internet.password(6)
        result = assigns[:user].errors.count
        expect(result).to eq(1)
      end
    end

    context 'new' do
      it 'redirects authenticated users to root path' do
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end

      it 'redirects to sign up path for invalid token' do
        get :new, token: SecureRandom.urlsafe_base64(24)
        expect(response).to redirect_to(new_sign_up_email_path)
      end

      it 'redirects to sign up path if email confirmation is 24 hours old' do
        Timecop.freeze(Time.now)
        token = email_confirmation.token
        allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_400.seconds.from_now.to_f)
        get :new, token: token
        expect(response).to redirect_to(new_sign_up_email_path)
        Timecop.return
      end

      it 'does not redirect if email confirmation is less than 24 hours old' do
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
    end
  end
end
