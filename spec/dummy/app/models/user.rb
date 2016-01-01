class User < ActiveRecord::Base
  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }, if: :validate_password?

  private

  def validate_password?
    password.present?
  end
end
