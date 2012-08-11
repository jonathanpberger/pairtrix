Pairtrix::Application.routes.draw do

  match "/auth/:provider/callback", to: "sessions#create"
  match "/auth/failure", to: "sessions#failure"
  match "/sign_out", to: "sessions#destroy", :as => "sign_out"
  match "/sign_in", to: "sessions#new", :as => "sign_in"
  match "/dashboard", to: "users#dashboard", :as => "dashboard"

  match "/pairs/ajax_create", to: "pairs#create"
  match "/about", to: "pages#about", as: :about

  resources :sessions
  resources :users
  resources :companies, shallow: true do
    resources :employees
    resources :teams, shallow: true do
      resources :team_memberships
      resources :pairing_days do
        resources :pairs
      end
    end
  end

  root :to => 'companies#index'

end
