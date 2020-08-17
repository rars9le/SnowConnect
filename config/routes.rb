Rails.application.routes.draw do
  root 'static_pages#home'

  resources :settings, only: [:index]

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  devise_for :users,
    path: '',
    path_names: {
      sign_up: '',
      sign_in: 'login',
      sign_out: 'logout',
      registration: 'signup'
    },
    controllers: {
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      passwords: 'users/passwords'
    }
  devise_scope :user do
    get 'signup', to: 'users/registrations#new'
    get 'login', to: 'users/sessions#new'
    get 'logout', to: 'users/sessions#destroy'
  end
  
  resources :posts do
    collection do
      get :search
      get :feed
      get :popular
    end
  end
  
  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]

end
