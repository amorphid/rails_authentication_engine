require 'rails_helper'

module RailsAuthenticationEngine
  describe PasswordRecoveryPasswordsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    let(:email_confirmation)   { Fabricate(:email_confirmation, email: user.email) }
    let(:password_reset_token) do
      Fabricate(:password_reset, email_confirmation: email_confirmation).token
    end
    let(:user)                 { Fabricate(:user) }

    context '#create' do
      context 'no password reset token' do
        before do
          session[:password_reset_token] = nil
          post :create, password: Faker::Internet.password(7)
        end

        it { expect(response).to redirect_to(new_password_recovery_email_path) }

        it do
          result  = flash[:danger]
          message = 'rails_authentication_engine.flash.invalid_password_recovery_email'
          expect(result).to eq(I18n.t(message))
        end
      end

      context 'expired password reset' do
        before do
          Timecop.freeze(Time.now)
          session[:password_reset_token] = password_reset_token
          allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_400.seconds.from_now.to_f)
          post :create, password: Faker::Internet.password(7)
        end

        after { Timecop.return }

        it { expect(response).to redirect_to(new_password_recovery_email_path) }

        it do
          result  = flash[:danger]
          message = 'rails_authentication_engine.flash.expired_password_recovery_email'
          expect(result).to eq(I18n.t(message))
        end
      end

      context 'current password reset' do
        before do
          Timecop.freeze(Time.now)
          session[:password_reset_token] = password_reset_token
          allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_399.seconds.from_now.to_f)
        end

        after { Timecop.return }

        it do
          post :create, password: user.email
          expect(response).to redirect_to(url_helper('main_app.root_path'))
        end

        it do
          post :create, password: user.email
          result  = flash[:success]
          message = 'rails_authentication_engine.flash.successful_password_recovery'
          expect(result).to eq(I18n.t(message))
        end

        it do
          expect { post :create, password: user.email }
          .to change { User.count }
          .by(0)
        end
      end

      context 'blank password' do
        before do
          session[:password_reset_token] = password_reset_token
          post :create, password: ''
        end

        it { expect(response).to render_template(:new) }

        it do
          result = assigns[:user].errors.count
          expect(result).to eq(1)
        end
      end

      context 'password too short' do
        before do
          session[:password_reset_token] = password_reset_token
          get :create, password: Faker::Internet.password(7,7)
        end

        it do
          result = assigns[:user].errors.count
          expect(result).to eq(1)
        end
      end

      it_behaves_like 'an authenticated user' do
        let(:action) { post :create }
      end
    end

    context 'new' do
      context 'blank token' do
        before { get :new, token: '' }

        it { expect(response).to redirect_to(new_password_recovery_email_path) }

        it do
          result  = flash[:danger]
          message = 'rails_authentication_engine.flash.invalid_password_recovery_email'
          expect(result).to eq(I18n.t(message))
        end
      end

      context 'invalid token' do
        before { get :new, token: SecureRandom.urlsafe_base64(24) }

        it { expect(response).to redirect_to(new_password_recovery_email_path) }

        it do
          result  = flash[:danger]
          message = 'rails_authentication_engine.flash.invalid_password_recovery_email'
          expect(result).to eq(I18n.t(message))
        end
      end

      context 'expired email confirmation' do
        before do
          Timecop.freeze(Time.now)
          token = email_confirmation.token
          allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_400.seconds.from_now.to_f)
          get :new, token: token
        end

        it { expect(response).to redirect_to(new_password_recovery_email_path) }

        it do
          result  = flash[:danger]
          message = 'rails_authentication_engine.flash.expired_password_recovery_email'
          expect(result).to eq(I18n.t(message))
        end

        after { Timecop.return }
      end

      it 'current email confirmation' do
        before
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

      it_behaves_like 'an authenticated user' do
        let(:action) { get :new }
      end
    end
  end
end
