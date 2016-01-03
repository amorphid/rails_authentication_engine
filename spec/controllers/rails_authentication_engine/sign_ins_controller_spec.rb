require 'rails_helper'

module RailsAuthenticationEngine
  describe SignInsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    let(:user) { Fabricate(:user) }

    context '#vet_email!' do
      before { post :create, email: '' }

      it 'renders new' do
        expect(response).to render_template(:new)
      end
    end

    context '#create' do
      context 'invalid email' do
        let(:email) { Faker::Internet.email }

        before { post :create, email: email }

        it 'renders new' do
          expect(response).to render_template(:new)
        end

        it 'sets flash message' do
          i18n_key = 'rails_authentication_engine.sign_in.invalid_email'
          i18n_params = {
            email: email,
            path: new_sign_up_email_path
          }
          message = t(i18n_key, i18n_params)
          expect(message).to eq(flash.now[:danger])
        end
      end

      context 'valid email, valid password' do
        def post_params(continue_url = main_app.root_url)
          session[:user_id] = nil
          post :create, email: user.email, password: user.password, continue_url: continue_url
        end

        it 'redirects to main_app.root_url' do
          post_params(main_app.root_url)
          expect(response).to redirect_to(main_app.root_url)
        end

        it 'redirects to main_app.pagey_mc_page_url' do
          post_params(main_app.pagey_mc_page_url)
          expect(response).to redirect_to(main_app.pagey_mc_page_url)
        end

        it 'sets user id session' do
          post_params
          expect(session[:user_id]).to eq(user.id)
        end

        it 'set flash message' do
          post_params
          i18n_key = 'rails_authentication_engine.sign_in.success'
          message = t(i18n_key)
          expect(message).to eq(flash[:success])
        end
      end

      context 'valid email, invalid password' do
        before do
          post :create, email: user.email, password: Faker::Internet.password(8)
        end

        it 'renders new' do
          expect(response).to render_template(:new)
        end

        it 'sets flash message' do
          message = t('rails_authentication_engine.sign_in.invalid_password', {
            email: user.email,
            path:  new_password_recovery_email_path
          })
          expect(message).to eq(flash[:danger])
        end
      end

      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { post :create }
      end
    end

    context 'new' do
      it 'renders new' do
        get :new
        expect(response).to render_template(:new)
      end

      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { get :new }
      end
    end
  end
end
