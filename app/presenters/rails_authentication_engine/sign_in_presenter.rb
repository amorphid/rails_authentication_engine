module RailsAuthenticationEngine
  class SignInPresenter < BasePresenter
    class << self
      private

      def presenter(url, model)
        {
          continue_url: url,
          user:         parse_model(model)
        }
      end
    end
  end
end
