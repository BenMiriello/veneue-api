class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :authorized

  def authorized
    if user_id = cookies.signed["_veneue"]
      @user = User.find(user_id)
    else
      render json: { logged_in: false }
    end
  end

  def set_session
    cookies.signed["_veneue"] = {
      value: @user.id,
      httponly: true,
      expires: 14.days.from_now,
      sameSite: 'none',
    }
    if Rails.env != 'development'
      cookies.signed["_veneue"].secure = 'true'
    end
  end

  def user_serialized
    {
      name: @user.name,
      email: @user.email
    }
  end
end
