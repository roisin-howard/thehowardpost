Rails.application.routes.draw do
  devise_for :users
  resources :users, :only =>[:show, :index]
  resources :blog do
    post :new
  end
  root :to => "home#index"
  get '/users/show', to: 'users#show'
  get '/users/index', to: 'users#index'
  post '/blog/new', to: 'blog#create'
end
