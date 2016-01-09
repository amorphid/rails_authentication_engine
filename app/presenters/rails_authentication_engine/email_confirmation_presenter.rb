module RailsAuthenticationEngine
  class EmailConfirmationPresenter < BasePresenter
    class << self
      private

      def presenter(path, model)
        {
          form_path:           path,
          email_confirmation:  parse_model(model)
        }
      end
    end
  end
end
