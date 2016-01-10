module RailsAuthenticationEngine
  class PasswordReset < ApplicationModel
    belongs_to :email_confirmation
  end
end
