module RailsAuthenticationEngine
  class ApplicationController < ::ActionController::Base
    include AuthenticationHelpers
    include PresenterHelpers
  end
end
