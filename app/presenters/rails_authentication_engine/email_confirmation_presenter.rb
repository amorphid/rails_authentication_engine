module RailsAuthenticationEngine
  class EmailConfirmationPresenter < BasePresenter
    class << self
      private

      def presenter(model)
        {
          email_confirmation: parse_model(model)
        }
      end
    end
  end
end
