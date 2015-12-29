require 'rails_helper'

module RailsAuthenticationEngine
  describe PasswordRecoveryEmailsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    context '#create' do
      it 'renders show w/ valid email' do
        post :create, email: Faker::Internet.email
        expect(response).to render_template(:show)
      end

      it 'renders new w/ invalid email' do
        post :create, email: ''
        expect(response).to render_template(:new)
      end

      it 'has 1 error on user w/ invalid email' do
        post :create, email: ''
        result = assigns[:email_confirmation].errors.count
        expect(result).to eq(1)
      end

      it 'redirects authenticated users to root path' do
        session[:user_id] = Fabricate(:user).id
        post :create
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end
    end

    context '#new' do
      it 'redirects authenticated users to root path' do
        session[:user_id] = Fabricate(:user).id
        get :new
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end
    end
  end
end
