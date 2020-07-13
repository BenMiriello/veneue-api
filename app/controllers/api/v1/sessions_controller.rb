module Api::V1
  class SessionsController < ApplicationController
    before_action :set_current_user, except: :create

    def create
      @user = User
        .find_by(email: params["user"]["email"])
        .try(:authenticate, params["user"]["password"])

      if @user
        cookies.signed["_veneue"] = {
          value: @user.id,
          httponly: true,
          expires: 14.days.from_now,
        }
        render json: {
          status: :created,
          logged_in: true,
          user: {
            name: @user.name,
            email: @user.email
          },
        }
      else
        render json: { logged_in: false, status: 401 }
      end
    end

    def logged_in
      if @current_user
        render json: {
          logged_in: true,
          user: {
            name: @current_user.name,
            email: @current_user.email
          }
        }
      else
        render json: { logged_in: false }
      end
    end

    def logout
      cookies.delete("_veneue")
    end

    def set_current_user
      user_id = cookies.signed["_veneue"]
      if user_id
        @current_user = User.find(user_id)
      end
    end
  end
end