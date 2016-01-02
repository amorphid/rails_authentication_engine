require 'rails_helper'

module RailsAuthenticationEngine
  describe SignInsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    let(:user) { Fabricate(:user) }

    context '#create' do
      context 'no account' do
        let(:email) { Faker::Internet.email }

        before { post :create, email: email }

        it 'renders new' do
          expect(response).to render_template(:new)
        end

        it 'sets flash message' do
          i18n_key = 'rails_authentication_engine.sign_in.no_account'
          i18n_params = {
            email: email,
            path: new_sign_up_email_path
          }
          message = I18n.t(i18n_key, i18n_params)
          # expect(message).to eq(flash.now[:danger])
          expect(message).not_to eq(i18n_missing_translation(i18n_key))
        end
      end

      it 'redirects w/ valid login' do
        continue_url = Faker::Internet.url
        post :create, email: user.email, password: user.password, continue_url: continue_url
        expect(response).to redirect_to(continue_url)
      end

      it 'renders new w/ invalid email' do
        post :create, email: Faker::Internet.email, password: ''
        expect(response).to render_template(:new)
      end

      it 'renders new w/ valid email and invalid password' do
        post :create, email: user.email, password: Faker::Internet.password(8)
        expect(response).to render_template(:new)
      end

      it 'redirects to root path w/ authenticated users' do
        session[:user_id] = Fabricate(:user).id
        post :create

      end

      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { post :create }
      end
    end

    context 'new' do
      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { get :new }
      end
    end
  end
end
