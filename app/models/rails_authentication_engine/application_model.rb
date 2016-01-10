module RailsAuthenticationEngine
  class ApplicationModel < ActiveRecord::Base
    include ApplicationModelHelpers

    self.abstract_class = true

    after_initialize :initialize_token

    validates :token, presence: true

    private

    def initialize_token
      self.token ||= SecureRandom.urlsafe_base64(24)
    end
  end
end
