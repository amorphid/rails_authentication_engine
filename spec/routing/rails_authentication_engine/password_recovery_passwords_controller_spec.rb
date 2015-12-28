require 'rails_helper'

module RailsAuthenticationEngine
  describe PasswordRecoveryPasswordsController, type: :routing do
    routes { RailsAuthenticationEngine::Engine.routes }

    it do
      expect(get: '/password_recovery_passwords/new').to route_to(
        controller: 'rails_authentication_engine/password_recovery_passwords',
        action:     'new'
      )
    end

    it do
      expect(post: '/password_recovery_passwords').to route_to(
        controller: 'rails_authentication_engine/password_recovery_passwords',
        action:     'create'
      )
    end
  end
end
