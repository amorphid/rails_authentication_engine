class CreateSignUpUserDelegator < SimpleDelegator
  def reset_password_token_as_urlsafe_base64
    @reset_password_token ||= SecureRandom.urlsafe_base64(24)
  end

  def reset_password_token_as_bcrypt_hash
    BCrypt::Password.new(reset_password_token_as_uuid)
  end
end
