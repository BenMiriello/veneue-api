Rails.application.routes.draw do
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        resources :users, only: [:create]
        patch '/update_account', to: "users#update_account"
        post '/update_password', to: "users#update_password"
        delete '/delete_account', to: "users#destroy"

        resources :sessions, only: [:create]
        get '/logged_in', to: "sessions#logged_in"
        delete '/logout', to: "sessions#logout"
      end
    end
  end
end
