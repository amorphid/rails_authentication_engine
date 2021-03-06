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
          post :create, password: Faker::Internet.password(8)
        end

        it 'redirects to new_password_recovery_email_path' do
          expect(response).to redirect_to(new_password_recovery_email_path)
        end

        it 'sets flash message' do
          message = 'rails_authentication_engine.password_recovery.invalid'
          expect(flash[:danger]).to eq(t(message))
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

        it 'redirects to new_password_recovery_email_path' do
          expect(response).to redirect_to(new_password_recovery_email_path)
        end

        it 'sets flash message' do
          message = 'rails_authentication_engine.password_recovery.expired'
          expect(flash[:danger]).to eq(t(message))
        end
      end

      context 'current password reset' do
        before do
          Timecop.freeze(Time.now)
          session[:password_reset_token] = password_reset_token
          allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_399.seconds.from_now.to_f)
        end

        after { Timecop.return }

        it 'redirects to main_app.root_path' do
          post :create, password: user.email
          expect(response).to redirect_to(main_app.root_path)
        end

        it 'sets flash message' do
          post :create, password: user.email
          message = 'rails_authentication_engine.password_recovery.success'
          expect(flash[:success]).to eq(t(message))
        end

        it 'does not change User count' do
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

        it 'renders new' do
          expect(response).to render_template(:new)
        end

        it 'has 1 error' do
          result = assigns[:_user].errors.count
          expect(result).to eq(1)
        end
      end

      context 'password too short' do
        before do
          session[:password_reset_token] = password_reset_token
          post :create, password: Faker::Internet.password(7,7)
        end

        it 'renders new' do
          expect(response).to render_template(:new)
        end

        it 'has 1 error' do
          result = assigns[:_user].errors.count
          expect(result).to eq(1)
        end
      end

      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { post :create }
      end
    end

    context 'new' do
      context 'blank token' do
        before { get :new, token: '' }

        it 'redirects to new_password_recovery_email_path' do
          expect(response).to redirect_to(new_password_recovery_email_path)
        end

        it 'sets flash message' do
          result  = flash[:danger]
          message = 'rails_authentication_engine.password_recovery.invalid'
        end
      end

      context 'invalid token' do
        before { get :new, token: SecureRandom.urlsafe_base64(24) }

        it 'redirects' do
          expect(response).to redirect_to(new_password_recovery_email_path)
        end

        it 'sets flash message' do
          result  = flash[:danger]
          message = 'rails_authentication_engine.password_recovery.invalid'
        end
      end

      context 'expired email confirmation' do
        before do
          Timecop.freeze(Time.now)
          token = email_confirmation.token
          allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_400.seconds.from_now.to_f)
          get :new, token: token
        end

        after { Timecop.return }

        it 'redirects' do
          expect(response).to redirect_to(new_password_recovery_email_path)
        end

        it 'sets flash message' do
          result  = flash[:danger]
          message = 'rails_authentication_engine.password_recovery.expired'
        end
      end

      context 'current email confirmation' do
        let(:token) { email_confirmation.token }

        before do
          Timecop.freeze(Time.now)
          token
          allow_any_instance_of(DateTime).to receive(:to_f).and_return(86_399.seconds.from_now.to_f)
        end

        after { Timecop.return }

        it 'renders new' do
          get :new, token: token
          expect(response).to render_template(:new)
        end

        it 'increases PasswordReset count by 1' do
          expect { get :new, token: token }
          .to change { PasswordReset.count }
          .by(1)
        end

        it 'sets password_reset_token in session' do
          session[:password_reset_token] = nil
          get :new, token: email_confirmation.token
          expect(session[:password_reset_token]).to match(/[A-Za-z0-9\-_]+/)
        end
      end

      context 'new user' do
        let(:email) { email_confirmation.email }

        before do
          token = email_confirmation.token
          User.delete_all
          get :new, token: token
        end

        it 'set flash message' do
          message = t(
            'rails_authentication_engine.password_recovery.new_user',
            email: email
          )
          expect(flash.now[:info]).to eq(message)
        end
      end

      context 'existing user' do
        before { get :new, token: email_confirmation.token }

        it 'does not flash message' do
          expect(flash.now[:info]).to eq(nil)
        end
      end

      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { get :new }
      end
    end
  end
end
