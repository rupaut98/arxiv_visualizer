class Api::V1::AuthController < ApplicationController
    skip_before_action :authenticate_user, only: [:login, :register]
  
    def register
      user = User.new(user_params)
      
      if user.save
        token = generate_token(user.id)
        render json: { user: user.as_json(except: :password_digest), token: token }, status: :created
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    def login
        user = User.find_by(email: params[:auth][:email])
        Rails.logger.debug "Login attempt for: #{params[:auth][:email]}"
        Rails.logger.debug "User found: #{user ? 'Yes (ID: ' + user.id.to_s + ')' : 'No'}"
        
        if user && user.authenticate(params[:auth][:password])
          token = JWT.encode(
            { user_id: user.id, exp: 24.hours.from_now.to_i },
            Rails.application.secret_key_base
          )
          
          Rails.logger.debug "JWT generated for user #{user.id}: #{token[0..10]}..."
          render json: { token: token, user: { id: user.id, email: user.email, username: user.username } }
        else
          Rails.logger.debug "Authentication failed for email: #{params[:auth][:email]}"
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
      
  
  
    private
  
    def user_params
        params.require(:auth).permit(:email, :password, :username)
    end
      
    def generate_token(user_id)
        JWT.encode({ user_id: user_id }, Rails.application.secret_key_base)
    end
      
  end
  