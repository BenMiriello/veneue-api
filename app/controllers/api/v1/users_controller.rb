module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authorized, only: [:create]

    # POST /users
    def create
      @user = User.create(params.require(:user).permit(:email, :password, :name))
      if @user
        set_session
        render json: {
          logged_in: true,
          status: :created,
          user: user_serialized
        }
      else
        render json: { logged_in: false, status: 500 }
      end
    end

    # PATCH/PUT /users/1
    def update
      if @user && @user.authenticate(user_params["password"])
        new_user_data = {
          name: user_params["name"],
          email: user_params["email"],
          password: user_params["password"]
        }

        if @user.update(new_user_data)
          render json: {
            logged_in: true,
            status: :ok,
            user: user_serialized
          }
        else
          render json: { logged_in: false, status: :not_acceptable, error: @user.errors }
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    # POST /update_password
    def update_password
      old_password = update_password_params["old_password"]
      new_password = update_password_params["new_password"]

      if @user && !@user.authenticate(new_password) && @user.authenticate(old_password)
        if @user.update(password: new_password)
          render json: {
            logged_in: true,
            status: :ok,
            user: user_serialized
          }
        else
          render json: { logged_in: false, error: @user.errors }, status: :not_acceptable
        end
      else
        render json: { logged_in: false, error: @user.errors }, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
      cookies.delete("_veneue")
    end

    private

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def update_password_params
      params.require(:user).permit(:name, :email, :old_password, :new_password)
    end
  end
end
