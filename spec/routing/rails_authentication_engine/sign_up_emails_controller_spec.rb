require 'rails_helper'

module RailsAuthenticationEngine
  describe SignUpEmailsController, type: :routing do
    routes { RailsAuthenticationEngine::Engine.routes }

    it do
      expect(get: '/sign_up_emails/new').to route_to(
        controller: 'rails_authentication_engine/sign_up_emails',
        action:     'new'
      )
    end

    it do
      expect(post: '/sign_up_emails').to route_to(
        controller: 'rails_authentication_engine/sign_up_emails',
        action:     'create'
      )
    end
  end
end
