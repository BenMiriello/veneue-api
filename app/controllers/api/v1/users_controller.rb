module Api::V1
  class UsersController < ApplicationController
      before_action :set_current_user, except: :create

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
            status: 200,
            user: {
              name: @user.name,
              email: @user.email
            }
          }
        else
          render json: { logged_in: false, status: :not_acceptable, error: {messages: ["Unable to process request."]} }
        end
      else
        render json: @user.errors, status: :unprocessable_entity
      end
    end

    def update_password
      old_password = update_password_params["old_password"]
      new_password = update_password_params["new_password"]

      if @user && !@user.authenticate(new_password) && @user.authenticate(old_password)
        if @user.update(password: new_password)
          render json: {
            logged_in: true,
            status: 200,
            user: {
              name: @user.name,
              email: @user.email
            }
          }
        else
          render json: { logged_in: false, error: {messages:  @user.errors}}, status: :not_acceptable
        end
      else
        render json: { logged_in: false, error: {messages:  @user.errors}}, status: :unprocessable_entity
      end
    end

    # DELETE /users/1
    def destroy
      @user.destroy
      cookies.delete("_veneue")
    end

    private

    def set_current_user
      user_id = cookies.signed["_veneue"]
      if user_id
        @user = User.find(user_id)
      end
    end

    def user_params
      params.require(:user).permit(:name, :email, :password)
    end

    def update_password_params
      params.require(:user).permit(:name, :email, :old_password, :new_password)
    end
  end
end