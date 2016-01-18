RailsAuthenticationEngine::Engine.routes.draw do
  resources :password_recovery_emails,    only: [:create, :new]
  resources :password_recovery_passwords, only: [:create, :new]
  resources :sign_ins,                    only: [:create, :new]
  resources :sign_up_emails,              only: [:create, :new]
  resources :sign_up_passwords,           only: [:create, :new]

  get '/password_recovery', to: 'password_recovery_emails#new'
  get '/sign_in',           to: 'sign_ins#new'
  get '/sign_up',           to: 'sign_up_emails#new'
end
