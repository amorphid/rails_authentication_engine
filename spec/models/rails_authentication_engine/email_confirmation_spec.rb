require 'rails_helper'

module RailsAuthenticationEngine
  describe EmailConfirmation, type: :model do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:token) }
  end
end
