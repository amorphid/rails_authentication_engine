module RailsAuthenticationEngine
  module ApplicationModelHelpers
    def error_messages
      errors.full_messages
    end

    def to_json
      attributes.merge({
        error_messages: error_messages
      }).to_json
    end
  end
end
