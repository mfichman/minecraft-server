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
    resources :worlds
    resources :backups
    resources :commands
    resources :servers
    resources :saves
    resources :loads
    resources :services


    get '/servers/:id/cloud-config.yml', to: 'servers#cloud_config'
  end

  namespace :wireguard do
    resources :networks
    resources :peers
    resources :keys
    resources :syncs
  end

  namespace :admin do
    resources :users
  end
end
