Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'user_sessions#new', as: :new_user_session
    get 'sign_out', to: 'user_sessions#new', as: :destroy_user_session
  end

  root to: 'home#index'

  get 'minecraft', to: 'minecraft/root#index'
  get 'wireguard', to: 'wireguard/root#index'
  get 'admin', to: 'admin/root#index'

  namespace :minecraft do
    resources :backups
    resources :boots
    resources :commands
    resources :jars
    resources :loads
    resources :modders
    resources :mods
    resources :saves
    resources :servers
    resources :services
    resources :shutdowns
    resources :worlds

    get '/servers/:id/cloud-config.yml', to: 'servers#cloud_config'
  end

  namespace :wireguard do
    resources :keys
    resources :networks
    resources :peers
    resources :syncs
  end

  namespace :admin do
    resources :users
  end
end
