Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'users/new'
  get 'user/new'
  root 'static_pages#home'
  get '/home',      to: 'static_pages#home'
  get '/help',      to: 'static_pages#help'
  get 'about',      to: 'static_pages#about'
  get '/contact',   to: 'static_pages#contact'
  get '/signup',    to: 'users#new'
  post '/signup',   to: 'users#create'
  get '/login',     to: 'sessions#new'
  post '/login',    to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'
  get 'events/:url_token/url_copy',   to: 'events#url_copy', as: 'url_copy'
  resources :users do
    member do
      get :following
    end
  end
  resources :groups do
    member do
      get :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update] 
  resources :events, param: :url_token do
    resources :answers, only: [:index, :new, :create, :edit, :update]
  end
  resources :relationships,       only: [:create, :destroy]
end
