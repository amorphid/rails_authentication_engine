require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpPasswordsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    before { session[:user_id] = Fabricate(:user).id }

    context 'create' do
      it 'redirects authenticated users to root path' do
        post :create
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end
    end

    context 'create' do
      it 'redirects authenticated users to root path' do
        get :new
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end
    end
  end
end
