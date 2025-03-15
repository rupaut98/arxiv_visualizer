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
      user = User.find_by(email: params[:email])
      
      if user && user.authenticate(params[:password])
        token = generate_token(user.id)
        render json: { user: user.as_json(except: :password_digest), token: token }
      else
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
  