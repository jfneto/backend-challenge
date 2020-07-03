# frozen_string_literal: true

class RegistrationsController < ApplicationController
  def index
    @users = if current_user.admin
               User.all
             else
               User.where(id: current_user)
             end
  end

  # def create
  #   user = User.new(params[:user])
  #   if user.save
  #     render json: user.as_json(auth_token: user.authentication_token, email: user.email), status: 201
  #     nil
  #   else
  #     warden.custom_failure!
  #     render json: user.errors, status: 422
  #   end
  # end
end
