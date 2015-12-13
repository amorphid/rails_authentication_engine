RailsAuthenticationEngine::Engine.routes.draw do
  resources :sign_ups, only: [:create, :new]
end
