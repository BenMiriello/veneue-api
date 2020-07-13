module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :authorized, only: [:create]

    def create
      @user = User
        .find_by(email: params["user"]["email"])
        .try(:authenticate, params["user"]["password"])

      if @user
        set_session
        render json: {
          logged_in: true,
          status: :created,
          user: user_serialized,
        }
      else
        render json: { logged_in: false, status: :unauthorized }
      end
    end

    def logged_in
      render json: {
        logged_in: true,
        status: :ok,
        user: user_serialized,
      }
    end

    def logout
      cookies.delete("_veneue")
    end
  end
end
