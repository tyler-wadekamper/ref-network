Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users
  resources :questions, only: [:edit, :new, :create, :index, :update]
  resources :answers, only: [:edit, :new, :create, :update]

  # Defines the root path route ("/")
  root "questions#index"
end
