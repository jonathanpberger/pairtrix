Pairtrix::Application.routes.draw do

  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  match "/sign_out", to: "sessions#destroy", :as => "sign_out"
  match "/sign_in", to: "sessions#new", :as => "sign_in"
  match "/dashboard", to: "users#dashboard", :as => "dashboard"

  resources :sessions
  resources :users
  resources :employees
  resources :teams

  root :to => 'pages#home'

end
