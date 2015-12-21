class EmailConfirmation < ActiveRecord::Base
  after_initialize :initialize_token

  def initialize_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end
end
