Rails.application.routes.draw do

  # root to: "static#home"

  resources :registrations, only: [:create]
  resources :sessions, only: [:create]
  delete :logout, to: "sessions#logout"
  get :logged_in, to: "sessions#logged_in"
  post :edit_account, to: "users#update"
  post :update_password, to: "users#update_password"
  delete :delete_account, to: "users#destroy"

  # # namespace :api do
  # constraints subdomain: 'api' do
  #   scope module: 'api' do
  #     namespace :v1 do
  #       resources :users
  #       post '/login', to: 'auth#create'
  #       get '/profile', to: 'users#profile'
  #     end
  #   end
  # end
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
