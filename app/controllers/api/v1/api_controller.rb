# frozen_string_literal: true

module Api::V1
  # Api controller
  class ApiController < ActionController::Base
    include ApplicationHelper
    include ActionController::ImplicitRender # if you need render .jbuilder
    include ActionView::Layouts # if you need layout for .jbuilder

    protect_from_forgery with: :null_session
    acts_as_token_authentication_handler_for User

    before_action :require_authentication!

    private

    def require_authentication!
      throw(:warden, scope: :user) unless current_user.presence
    end
  end
end
