Rails.application.routes.draw do
  constraints subdomain: "api" do
    scope module: "api" do
      namespace :v1 do
        post "/signup", to: "users#create"
        patch "/change_email", to: "users#change_email"
        patch "/change_password", to: "users#change_password"
        patch "/change_name", to: "users#change_name"
        delete "/delete_account", to: "users#destroy"

        post "/login", to: "sessions#create"
        get "/check_logged_in", to: "sessions#check_logged_in"
        delete "/logout", to: "sessions#logout"

        resources :video_rooms, only: [:create, :update, :destroy]
      end
    end
  end
end
