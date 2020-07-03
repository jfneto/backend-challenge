# frozen_string_literal: true

class Api::V1::RegistrationsController < Api::V1::ApiController
  respond_to :json

  def index
    @users = User.all
  end

  def create
    user = User.new(params[:user])
    if user.save
      render json: user.as_json(auth_token: user.authentication_token, email: user.email), status: 201
      nil
    else
      warden.custom_failure!
      render json: user.errors, status: 422
    end
  end
end
