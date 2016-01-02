Rails.application.routes.draw do
  mount RailsAuthenticationEngine::Engine => '/rails_authentication_engine'

  root to: 'static_pages#rooty_mc_root'

  get '/pagey_mc_page', to: 'static_pages#pagey_mc_page'
  get '/rooty_mc_root', to: 'static_pages#rooty_mc_root'
end
