class StaticController < ApplicationController
  skip_before_action :authorized

  def home
    render json: { status: "It's working" }
  end
end
