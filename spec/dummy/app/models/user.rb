class User < ActiveRecord::Base
  has_secure_password

  has_many :email_confirmations

  validates :email, presence: true, uniqueness: true
end
