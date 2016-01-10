module RailsAuthenticationEngine
  class SignInPresenter < BasePresenter
    class << self
      private

      def presenter(url, model)
        {
          continue_url: url,
          user:         model
        }
      end
    end
  end
end
