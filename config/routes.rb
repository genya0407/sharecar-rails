Rails.application.routes.draw do
  root to: 'home#index'

  resources :user_sessions, only: [:new, :create, :destroy]
  get 'login' => 'user_sessions#new', :as => :login
  post 'logout' => 'user_sessions#destroy', :as => :logout
  resources :password_resets

  resources :users do
    member do
      post :resend_invitation
      get :activate
      put :confirm
    end
  end

  resources :cars do
    resources :bookings
    resources :drives
    resources :fuels
  end
end
