module RailsAuthenticationEngine
  class EmailConfirmationPresenter < BasePresenter
    def self.present(hash = {})
      hash_ish(
        presenter(hash))
    end

    class << self
      private

      def presenter(email_confirmation)
        {
          email_confirmation: parse_model(email_confirmation)
        }
      end
    end
  end
end
