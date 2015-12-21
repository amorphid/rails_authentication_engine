Rails.application.routes.draw do
  mount RailsAuthenticationEngine::Engine => "/rails_authentication_engine"

  root to: "static_pages#home"
end
