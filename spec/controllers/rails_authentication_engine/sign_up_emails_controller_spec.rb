require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpEmailsController, type: :controller do
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

      it 'has 1 error on model w/ invalid email' do
        post :create, email: ''
        result = assigns[:email_confirmation].errors.count
        expect(result).to eq(1)
      end
    end
  end
end
