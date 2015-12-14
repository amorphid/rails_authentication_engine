class CreateSignUpUserDelegator < SimpleDelegator
  def reset_password_token_as_urlsafe_base64
    @reset_password_token ||= SecureRandom.urlsafe_base64(24)
  end

  def reset_password_token_as_md5_hash
    Digest::MD5.new.update(reset_password_token_as_uuid).to_s
  end
end
