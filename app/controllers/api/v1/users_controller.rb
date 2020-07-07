module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def profile
      if user = current_user
        set_jwt_cookie
        render json: {name: user.name, email: user.email}, status: :accepted
      else
        render json: { error: 'Invalid user information.'}, status: :not_acceptable
      end
    end

    def create
      user = User.create(user_params)
      if user.valid?
        token = encode_token(user_id: user.id)
        render json: {name: user.name, email: user.email}, status: :created
      else
        render json: { error: 'failed to create user.' }, status: :not_acceptable
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :password, :email)
    end
  end
end
