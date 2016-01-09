module RailsAuthenticationEngine
  class BasePresenter
    def self.present(hash = {})
      hash_ish(
        presenter(hash))
    end

    class << self
      private

      def hash_ish(hash)
        HashIsh.new(hash)
      end

      def parse_model(model)
        model.attributes.merge(error_messages: model.errors.full_messages)
      end
    end
  end
end
