# app/controllers/api/v1/auth_status_controller.rb
class Api::V1::AuthStatusController < ApplicationController
    skip_before_action :authenticate_user, only: [:show]
    
    def show
      token = request.headers['Authorization']&.split(' ')&.last
      
      if token.present?
        begin
          decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
          user = User.find_by(id: decoded['user_id'])
          
          if user
            render json: { authenticated: true, user_id: user.id, email: user.email }
          else
            render json: { authenticated: false, error: "User not found" }
          end
        rescue JWT::DecodeError
          render json: { authenticated: false, error: "Invalid token" }
        end
      else
        render json: { authenticated: false, error: "No token provided" }
      end
    end
  end
  