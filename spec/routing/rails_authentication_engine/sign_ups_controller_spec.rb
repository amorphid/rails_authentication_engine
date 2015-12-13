require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpsController, type: :routing do
    routes { RailsAuthenticationEngine::Engine.routes }

    it do
      expect(get: '/sign_ups/new').to route_to(
        controller: 'rails_authentication_engine/sign_ups',
        action:     'new'
      )
    end

    it do
      expect(post: '/sign_ups').to route_to(
        controller: 'rails_authentication_engine/sign_ups',
        action:     'create'
      )
    end
  end
end
