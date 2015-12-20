RailsAuthenticationEngine::Engine.routes.draw do
  resources :sign_up_passwords, only: [:create, :new]
  resources :sign_up_emails, only: [:create, :new]
end
