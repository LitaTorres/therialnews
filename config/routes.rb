Rails.application.routes.draw do
  resources :comments
  resources :publications
  devise_for :users, controller:{
    sessiones: "users/sessions",
    registrations: "users/registrations"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'homes/index'
  # Defines the root path route ("/")
   root "homes#index"
   get "/publications",  to: "publications#index", as:"user_root"
end
