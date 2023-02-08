Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  devise_for :users, only: [:sessions, :registrations, :passwords]
  resources :questions, only: [:edit, :new, :create, :index, :update, :destroy]
  resources :answers, only: [:edit, :new, :create, :update]

  resources :references, only: [:show] do
    collection do
      post :search
    end
  end

  # Defines the root path route ("/")
  root "questions#index"
end
