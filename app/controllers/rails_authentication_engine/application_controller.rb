module RailsAuthenticationEngine
  class ApplicationController < ::ActionController::Base
    include AuthenticationHelpers
    include PresenterHelpers
    include RedirectHelpers

    def deliver_mail_now_or_later
      :deliver_now
    end

    def user_new?
      user.new_record?
    end
  end
end
