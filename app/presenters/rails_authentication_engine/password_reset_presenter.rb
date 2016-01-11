module RailsAuthenticationEngine
  class PasswordResetPresenter < BasePresenter
    class << self
      private

      def form(path)
        { path: path }
      end

      def presenter(form_path:, user:)
        {
          form: form(form_path),
          user: user
        }
      end
    end
  end
end
