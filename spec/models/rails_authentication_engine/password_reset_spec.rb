require 'rails_helper'

module RailsAuthenticationEngine
  describe PasswordReset, type: :model do
    it { should validate_presence_of(:token) }
  end
end
