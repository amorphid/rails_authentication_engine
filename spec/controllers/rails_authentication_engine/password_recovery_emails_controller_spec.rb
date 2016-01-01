require 'rails_helper'

module RailsAuthenticationEngine
  describe PasswordRecoveryEmailsController, type: :controller do
    routes { RailsAuthenticationEngine::Engine.routes }

    context '#create' do
      context 'valid email' do
        before { post :create, email: Faker::Internet.email }

        it 'renders show' do
          expect(response).to render_template(:show)
        end
      end

      context 'blank email' do
        before { post :create, email: '' }

        it 'renders new' do
          expect(response).to render_template(:new)
        end

        it 'has one error on email confirmation' do
          result = assigns[:email_confirmation].errors.count
          expect(result).to eq(1)
        end
      end

      context 'current email confirmation' do
        let(:email) { Faker::Internet.email }

        let(:email_confirmation) do
          Fabricate(
            :email_confirmation,
            email: email,
            created_at: 86_399.seconds.ago
          )
        end

        before do
          Timecop.freeze(Time.now)
          post :create, email: email_confirmation.email
        end

        after { Timecop.return }

        it 'does not delete email confirmation' do
          result = (email_confirmation.id == EmailConfirmation.find_by(email: email).id)
          expect(result).to eq(true)
        end
      end

      context 'expired email confirmation' do
        let(:email) { Faker::Internet.email }

        let(:email_confirmation) do
          Fabricate(
            :email_confirmation,
            email: email,
            created_at: 86_400.seconds.ago
          )
        end

        before do
          Timecop.freeze(Time.now)
          post :create, email: email_confirmation.email
        end

        after { Timecop.return }

        it 'deletes expired email confirmation' do
          result = (email_confirmation.id == EmailConfirmation.find_by(email: email).id)
          expect(result).to eq(false)
        end
      end

      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { post :create }
      end
    end

    context '#new' do
      it_behaves_like 'an authenticated user visiting a page for guests' do
        let(:action) { get :new }
      end
    end
  end
end
