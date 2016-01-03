module RailsAuthenticationEngine
  class SignInPresenter
    def self.present(hash = {})
      hash_ish(
        presenter(hash))
    end

    class << self
      private

      def continue_url(hash)
        hash[:continue_url]
      end

      def hash_ish(hash)
        HashIsh.new(hash)
      end

      def presenter(hash)
        {
          continue_url: continue_url(hash),
          user:         user(hash)
        }
      end

      def user(hash)
        user = hash[:user]

        {
          email:          user.email,
          error_messages: user.errors.full_messages
        }
      end
    end
  end
end
