module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authorize, only: [:create]

    # POST /users
    def create
      if @user = User.create(params.require(:user).permit(:email, :password, :name))
        set_session
        render json: with_user, status: :created
      else
        reset_user_and_errors
        render json: with_user(@errors), status: :not_acceptable
      end
    end

    # PATCH /update_account
    def update_account
      if @user.authenticate(user_params["password"]) && @user.update(user_params)
        render json: with_user, status: :ok
      else
        reset_user_and_errors
        render json: with_user(@errors), status: :not_acceptable
      end
    end

    # POST /update_password
    def update_password
      old_password = params[:user][:old_password]
      new_password = params[:user][:new_password]
      
      if @user.authenticate(old_password) && !@user.authenticate(new_password) &&
        @user.update(password: new_password)
          render json: with_user, status: :ok
      else
        reset_user_and_errors
        render json: with_user(@errors), status: :not_acceptable
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

    def reset_user_and_errors
      user_errors = @user.errors.full_messages
      @errors = user_errors[0] ? user_errors : ['Unable to create user.']
      authorize
    end
  end
end
