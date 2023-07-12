Rails.application.routes.draw do
  resources :comments
  resources :publications
  devise_for :users, controller:{
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  devise_scope :user do
    resources :users do
      member do
        get 'edit_role'
        patch 'update_role'
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get 'homes/index'
  # Defines the root path route ("/")
   root "homes#index"
   get "/publications",  to: "publications#index", as:"user_root"
end
