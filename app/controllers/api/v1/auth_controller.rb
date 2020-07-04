module Api::V1
  class AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create # POST /api/v1/login
      user = User.find_by(name: login_params[:name])
      if user && user.authenticate(login_params[:password])
        token = encode_token({ user_id: user.id })
        render json: { user: UserSerializer.new(user), jwt: token }, status: :accepted
      else
        render json: { message: "Invalid username or password" }, status: :unauthorized
      end
    end

    private

    def login_params
      params.require(:user).permit(:username, :password)
    end
  end
end
