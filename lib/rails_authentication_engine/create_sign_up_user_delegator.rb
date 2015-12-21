module RailsAuthenticationEngine
  class CreateSignUpUserDelegator < SimpleDelegator
    def email_confirmation_token
      @email_confirmation_token ||= SecureRandom.urlsafe_base64(24)
    end
  end
end


