module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :authorize, only: [:create]

    # POST /sessions
    def create
      @user = User.find_by(email: params[:user][:email])
        .try(:authenticate, params[:user][:password])
      if @user
        set_session
        render json: with_user, status: :created
      else
        render json: with_user, status: :unauthorized
      end
    end

    # GET /logged_in
    def logged_in
      render json: with_user, status: :ok
    end

    # DELETE /logout
    def logout
      cookies.delete("_veneue")
    end
  end
end
