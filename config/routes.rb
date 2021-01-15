Rails.application.routes.draw do
  devise_for :users
  resources :users, :only =>[:show]
  resources :blogs do
    resources :comments
  end
  root :to => "home#index"
end
