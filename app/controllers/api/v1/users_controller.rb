module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def profile
      response.set_cookie(
        :jwt,
        {
          value: 'this could be a token or whatever cookie value you wanted.',
          expires: 1.hours.from_now,
          path: '/api/v1/auth',
          secure: Rails.env.production?,
          httponly: Rails.env.production?
        }
      )
      render json: {user: UserSerializer.new(current_user) }, status: :accepted
    end

    def create
      user = User.create(user_params)
      puts user
      # byebug
      if user.valid?
        token = encode_token(user_id: user.id)
        render json: {user: UserSerializer.new(user), jwt: token}, status: :created
      else
        render json: {error: 'failed to create user.'}, status: :not_acceptable
      end
    end

    private

    def user_params
      params.require(:user).permit(:name, :password, :email)
    end
  end
end
