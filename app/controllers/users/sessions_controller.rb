# frozen_string_literal: true
require './lib/json_web_token.rb'

class Users::SessionsController < Devise::SessionsController
  before_action :authorize_request, except: :create

  def create
    user = User.find_by_email(params[:user][:email])
    if user&.valid_password?(params[:user][:password])
      token = JsonWebToken.encode(user_id: user.id)
      time = 1.day.from_now
      render json: { token: token, exp: time, id: user.id, email: user.email }, status: :ok
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end