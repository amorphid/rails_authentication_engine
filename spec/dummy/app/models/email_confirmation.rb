class EmailConfirmation < ActiveRecord::Base
  after_initialize :initialize_token

  has_many :password_resets

  validates :email, presence: true

  private

  def initialize_token
    self.token ||= SecureRandom.urlsafe_base64(24)
  end
end
