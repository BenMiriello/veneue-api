module Api::V1
  class RegistrationsController < ApplicationController
    def create
      user = User.create!(registration_params)
      if user
        session[:user_id] = user.id
        render json: {
          status: :created,
          user: {
            name: user.name,
            email: user.email,
          },
        }
      else
        render json: { status: 500 }
      end
    end
  
    private
  
    def registration_params
      params.require(:user).permit(:email, :password, :name)
    end
  end
end
