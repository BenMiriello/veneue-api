module Api::V1
  class UsersController < ApplicationController
    skip_before_action :authorize, only: [:create]

    # POST /users
    def create
      if @user = User.create(params.require(:user)
        .permit(:email, :password, :name))
        set_session
        valid(:created)
      else
        errors = @user.errors
        authorize
        valid(:not_acceptable, errors)
      end
    end

    # PATCH /update_account
    def update_account
      if @user && @user.authenticate(user_params["password"]) &&
        @user.update(user_params)
          valid(:ok)
      else
        errors = @user.errors
        authorize
        valid(:not_acceptable, errors)
      end
    end

    # POST /update_password
    def update_password
      old_password = params[:user][:old_password]
      new_password = params[:user][:new_password]
      if @user && !@user.authenticate(new_password) &&
        @user.authenticate(old_password) &&
          @user.update(password: new_password)
            valid(:ok)
      else
        errors = @user.errors
        authorize
        valid(:not_acceptable, errors)
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
      params.require(:user)
        .permit(:name, :email, :old_password, :new_password)
    end
  end
end
