module RailsAuthenticationEngine
  class BasePresenter
    def self.present(*args)
      hash_ish(
        presenter(*args))
    end

    class << self
      private

      def hash_ish(hash)
        HashIsh.new(hash)
      end

      def parse_model(model)
        model.attributes.merge(error_messages: model.errors.full_messages)
      end

      def presenter
        raise NotImplementedError, 'method must be implementd by subclass of BasePresenter'
      end
    end
  end
end
