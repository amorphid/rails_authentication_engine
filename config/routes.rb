RailsAuthenticationEngine::Engine.routes.draw do
  resources :passwords, only: [:new]
  resources :sign_ups, only: [:create, :new]
end
