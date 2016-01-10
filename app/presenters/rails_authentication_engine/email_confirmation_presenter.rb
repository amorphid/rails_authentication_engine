module RailsAuthenticationEngine
  class EmailConfirmationPresenter < BasePresenter
    class << self
      private

      def form(path)
        { path: path }
      end

      def page(header)
        { header: header }
      end

      def presenter(form_path:, email_confirmation:)
        {
          form:                form(form_path),
          email_confirmation:  parse_model(email_confirmation)
          # page:                page(page_header)
        }
      end
    end
  end
end
