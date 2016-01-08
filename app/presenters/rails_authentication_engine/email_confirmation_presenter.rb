module RailsAuthenticationEngine
  class EmailConfirmationPresenter
    def self.present(hash = {})
      hash_ish(
        presenter(hash))
    end

    class << self
      private

      def hash_ish(hash)
        HashIsh.new(hash)
      end

      def presenter(email_confirmation)
        {
          email_confirmation: parse_model(email_confirmation)
        }
      end

      def parse_model(model)
        model.attributes.merge(error_messages: model.errors.full_messages)
      end
    end
  end
end
