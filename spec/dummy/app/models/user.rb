class User < ActiveRecord::Base
  include RailsAuthenticationEngine::ApplicationModelHelpers

  has_secure_password

  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 8 }
end
