Rails.application.routes.draw do
  constraints subdomain: 'api' do
    scope module: 'api' do
      namespace :v1 do
        resources :registrations, only: [:create]
        resources :sessions, only: [:create]
        delete :logout, to: "sessions#logout"
        get :logged_in, to: "sessions#logged_in"
        post :edit_account, to: "users#update"
        post :update_password, to: "users#update_password"
        delete :delete_account, to: "users#destroy"
      end
    end
  end
end
