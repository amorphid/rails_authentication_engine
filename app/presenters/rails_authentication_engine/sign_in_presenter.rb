module RailsAuthenticationEngine
  module SignInPresenter
    def self.present(hash = {})
      hash_ish(
        presenter(hash))
    end

    class << self
      private

      def hash_ish(hash)
        HashIsh.new(hash)
      end

      def presenter(continue_url:, user:)
        {
          continue_url: continue_url,
          user:         parse_user(user)
        }
      end

      def parse_user(user)
        {
          email:          user.email,
          error_messages: user.errors.full_messages
        }
      end
    end
  end
end
