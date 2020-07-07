module Api::V1
  class AuthController < ApplicationController
    include ActionController::Cookies
    skip_before_action :authorized, only: [:create]

    def create # POST /api/v1/login
      user = User.find_by(email: login_params[:email])
      if user && user.authenticate(login_params[:password])
        token = encode_token({ user_id: user.id })
        cookies.signed[:jwt] = {jwt: token, httponly: true, expires: 2.days.from_now}
        render json: {name: user.name, email: user.email}, status: :accepted
      else
        render json: { message: "Invalid username or password" }, status: :unauthorized
      end
    end

    def destroy
      cookies.delete(:jwt)
    end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end
  end
end
