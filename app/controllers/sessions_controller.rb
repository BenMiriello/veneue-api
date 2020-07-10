class SessionsController < ApplicationController
  before_action :set_current_user, except: :create

  def create
    @user = User
      .find_by(email: params["user"]["email"])
      .try(:authenticate, params["user"]["password"])

    if @user
      # token = issue_token({user_id: user.id})
      # session[:user_id] = @user.id
      cookies.signed["_veneue"] = {
        value: @user.id,
        httponly: true,
        # expires: 14.days.from_now,
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
    # byebug
    if @current_user
      render json: {
        logged_in: true,
        user: {
          id: @current_user.id,
          name: @current_user.name,
          email: @current_user.email
        }
      }
    else
      render json: { logged_in: false }
    end
  end

  def logout
    # byebug
    cookies.delete("_veneue")
    # session = {}
    # session[:id] = nil
    # render json: { status: 200, logged_out: true }
  end

  def set_current_user
    # if session[:user_id]
    #   @current_user = User.find(session[:user_id])
    # end
    user_id = cookies.signed["_veneue"]
    if user_id
      @current_user = User.find(user_id)
    end
  end
end
