module RailsAuthenticationEngine
  class SignInPresenter < BasePresenter
    class << self
      private

      def presenter(continue_url:, user:)
        {
          continue_url: continue_url,
          user:         parse_model(user)
        }
      end

      def parse_user(user)
        {
          email:          user.email,
          error_messages: user.errors.full_messages
        }
      end
    end
  end
end
