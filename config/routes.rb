Rails.application.routes.draw do
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        resources :users, only: [:create]
        patch '/change_email', to: "users#change_email"
        patch '/change_password', to: "users#change_password"
        patch '/change_name', to: "users#change_name"
        delete '/delete_account', to: "users#destroy"

        resources :sessions, only: [:create]
        get '/logged_in', to: "sessions#logged_in"
        delete '/logout', to: "sessions#logout"
      end
    end
  end
end
