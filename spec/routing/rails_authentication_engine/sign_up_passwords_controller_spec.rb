require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpPasswordsController, type: :routing do
    routes { RailsAuthenticationEngine::Engine.routes }

    it do
      expect(get: '/sign_up_passwords/new').to route_to(
        controller: 'rails_authentication_engine/sign_up_passwords',
        action:     'new'
      )
    end

    it do
      expect(post: '/sign_up_passwords').to route_to(
        controller: 'rails_authentication_engine/sign_up_passwords',
        action:     'create'
      )
    end
  end
end
