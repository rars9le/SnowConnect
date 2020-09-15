Rails.application.routes.draw do
  root 'static_pages#home'

  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    member do
      get :followings
      get :followers
      get :likes
      get :confirm_withdrawal
      delete :withdrawal
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
  
  post '/posts/feed', to: 'posts#create'

  resources :relationships, only: [:create, :destroy]
  resources :favorites, only: [:create, :destroy]

  resources :comments, only: %i[create destroy]

end
