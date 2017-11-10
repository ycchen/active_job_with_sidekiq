Rails.application.routes.draw do
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  
  get 'users/create_random'
  resources :users
  root to: 'users#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
