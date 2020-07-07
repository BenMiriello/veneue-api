module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def profile
      if user = current_user
        render json: {name: user.name}, status: :accepted
      else
        render json: {error: ''}, status: :not_acceptable
      end
    end

    def create
      @user = User.create(user_params)
      if @user.valid?
        @token = encode_token(user_id: @user.id)
        # cookies.signed[:jwt] = {value: token, httponly: true, expires: 2.days.from_now}
        render json: {user: {name: @user.name}, token: @token}, status: :created
      else
        render json: {error: 'failed to create user.'}, status: :not_acceptable
      end
    end

    def test
      cookies[:test] = {value: 'test'}
      cookies.signed[:test2] = {value: 'test2'}
      render json: "look at the cookies"
    end

    private

    def user_params
      params.permit(:name, :password, :email)
    end
  end
end
