module RailsAuthenticationEngine
  class ApplicationController < ::ActionController::Base
    include AuthenticationHelpers
    include PresenterHelpers
    include RedirectHelpers

    def user_new?
      user.new_record?
    end
  end
end
