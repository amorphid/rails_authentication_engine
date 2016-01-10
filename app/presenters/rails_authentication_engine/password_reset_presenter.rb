module RailsAuthenticationEngine
  class PasswordResetPresenter < BasePresenter
    class << self
      private

      def form(path)
        { path: path }
      end

      def presenter(form_path:, password_reset:)
        {
          form:           form(form_path),
          password_reset: password_reset,
        }
      end
    end
  end
end
