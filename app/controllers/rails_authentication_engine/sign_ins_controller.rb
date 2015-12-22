module RailsAuthenticationEngine
  class SignInsController < ApplicationController
    def new
      @user = User.new
    end
  end
end
