Rails.application.routes.draw do
  devise_for :users
  resources :users, :only =>[:show, :index]
  root 'home#index'
  get '/users/show', to: 'users#show'
  get '/users/index', to: 'users#index'
end
