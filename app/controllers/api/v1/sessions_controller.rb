module Api::V1
  class SessionsController < ApplicationController
    skip_before_action :authorize, only: [:create]

    # POST /login
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

    # GET /check_logged_in
    def check_logged_in
      render json: with_user, status: :ok
    end

    # DELETE /logout
    def logout
      cookies.delete("_veneue")
    end
  end
end
