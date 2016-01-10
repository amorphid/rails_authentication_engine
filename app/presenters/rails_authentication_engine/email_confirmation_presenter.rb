module RailsAuthenticationEngine
  class EmailConfirmationPresenter < BasePresenter
    class << self
      private

      def form(path)
        { path: path }
      end

      def presenter(email_confirmation:, form_path:)
        {
          email_confirmation:  email_confirmation,
          form:                form(form_path)
        }
      end
    end
  end
end
