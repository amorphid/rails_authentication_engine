require 'rails_helper'

module RailsAuthenticationEngine
  describe PasswordRecoveryEmailsController, type: :routing do
    routes { RailsAuthenticationEngine::Engine.routes }

    it do
      expect(get: '/password_recovery_emails/new').to route_to(
        controller: 'rails_authentication_engine/password_recovery_emails',
        action:     'new'
      )
    end

    it do
      expect(post: '/password_recovery_emails').to route_to(
        controller: 'rails_authentication_engine/password_recovery_emails',
        action:     'create'
      )
    end
  end
end
