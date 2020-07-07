module Api::V1
  class AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create # POST /api/v1/login
      @user = User.find_by(email: login_params[:email])
      if @user && @user.authenticate(login_params[:password])
        @token = encode_token(user_id: @user.id)
        # cookies[:jwt] = {value: token}, httponly: true, expires: 2.days.from_now}
        render json: {user: {name: @user.name}, jwt: @token}, status: :accepted
      else
        render json: { message: "Invalid username or password" }, status: :unauthorized
      end
    end

    # def destroy
    #   cookies.delete(:jwt)
    # end

    private

    def login_params
      params.require(:user).permit(:email, :password)
    end
  end
end
