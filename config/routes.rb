Rails.application.routes.draw do
  resources :publications
  get 'homes/index'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
   root "homes#index"
   get "/publications",  to: "publications#index", as:"user_root"
end
