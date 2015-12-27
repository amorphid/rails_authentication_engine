module RailsAuthenticationEngine
  class PasswordReset < ActiveRecord::Base
    after_initialize :initialize_token

    belongs_to :email_confirmation

    validates :token, presence: true

    private

    def initialize_token
      self.token ||= SecureRandom.urlsafe_base64(24)
    end
  end
end
