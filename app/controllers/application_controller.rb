class ApplicationController < ActionController::Base
  # include ActionController::Serialization
  # include ActionController::Cookies
  # include ActionController::RequestForgeryProtection

  # protect_from_forgery with: :exception
  before_action :authorized

  def encode_token(data)
    JWT.encode(data, 'hashketball')
  end

  def auth_header
    request.headers['Authorization']
  end

  def decoded_token
    # if auth_header
    if jwt = cookies[:jwt]
      begin
        @token = JWT.decode(jwt, 'hashketball', true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by id: user_id
    end
  end

  def logged_in?
    !!current_user
  end

  def authorized
    render json: {message: 'Please log in'}, status: :unauthorized unless logged_in?
  end
end
