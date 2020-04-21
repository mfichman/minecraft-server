Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }

  devise_scope :user do
    get 'sign_in', to: 'user_sessions#new', as: :new_user_session
    get 'sign_out', to: 'user_sessions#new', as: :destroy_user_session
  end

  root to: 'home#index'
end
