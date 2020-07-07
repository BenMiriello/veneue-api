class ApplicationController < ActionController::API
  include ActionController::Serialization
  include ActionController::Cookies
  before_action :authorized

  def encode_token(data)
    JWT.encode(data, 'hashketball')
  end

  def decoded_token
    if jwt = cookies.signed[:jwt]
      begin
        JWT.decode(jwt, 'hashketball', true, algorithm: 'HS256')
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
    render json: {message: 'Please log in'}, status: unauthorized unless logged_in?
  end
end
