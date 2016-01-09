module RailsAuthenticationEngine
  class EmailConfirmationPresenter < BasePresenter
    class << self
      private

      def form(path)
        { path: path }
      end

      def presenter(form_path, model)
        {
          form:                form(form_path),
          email_confirmation:  parse_model(model)
        }
      end
    end
  end
end
