module RailsAuthenticationEngine
  class SignInPresenter
    def self.present(hash = {})
      hash_ish(
        presenter(hash))
    end

    class << self
      private

      def continue_url(hash)
        hash.fetch(:continue_url, main_app.root_path)
      end

      def fetch_user(hash)
        hash[:user] || User.new
      end

      def hash_ish(hash)
        HashIsh.new(hash)
      end

      def main_app
        Rails.application.routes.url_helpers
      end

      def presenter(hash)
        {
          continue_url: continue_url(hash),
          user:         user(hash)
        }
      end

      def user(hash)
        user = fetch_user(hash)

        {
          email:          user.email,
          error_messages: user.errors.full_messages
        }
      end
    end
  end
end
