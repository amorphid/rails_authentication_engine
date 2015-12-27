require 'rails_helper'

module RailsAuthenticationEngine
  describe SignInsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    let(:user) { Fabricate(:user) }

    context '#create' do
      it 'redirects w/ valid login' do
        post :create, email: user.email, password: user.password
        expect(response).to redirect_to(url_helper('main_app.root_path'))
      end

      it 'renders new w/ blank email and/or password' do
        post :create, email: '', password: ''
        expect(response).to render_template(:new)
      end

      it 'renders new w/ invalid email' do
        post :create, email: Faker::Internet.email, password: ''
        expect(response).to render_template(:new)
      end

      it 'renders new w/ valid email and invalid password' do
        post :create, email: user.email, password: Faker::Internet.password(8)
        expect(response).to render_template(:new)
      end
    end
  end
end
