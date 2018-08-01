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
      post :deactivate
      put :confirm
    end
  end

  resources :cars do
    resources :bookings
    resources :drives
    resources :fuels
    resources :lacking_drives, only: [:new, :create]
  end

  namespace :admin do
    resources :consumptions, only: [:index, :new, :create] do
      collection do
        post :recalculate
        delete :destroy_multiple
      end
    end
    resources :payments
    resources :cars, only: [:index, :edit, :update] do
      resources :drives
      resources :fuels
    end
  end

  namespace :metrics do
    resources :drives, only: [:index]
  end
end
