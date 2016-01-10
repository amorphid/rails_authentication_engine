module RailsAuthenticationEngine
  class EmailConfirmation < ApplicationModel
    has_many :password_resets

    validates :email, presence: true
  end
end
