require 'rails_helper'

module RailsAuthenticationEngine
  describe SignInsController, type: :routing do
    routes { RailsAuthenticationEngine::Engine.routes }

    it do
      expect(get: '/sign_ins/new').to route_to(
        controller: 'rails_authentication_engine/sign_ins',
        action:     'new'
      )
    end

    it do
      expect(post: '/sign_ins').to route_to(
        controller: 'rails_authentication_engine/sign_ins',
        action:     'create'
      )
    end
  end
end
