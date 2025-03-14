class ApplicationController < ActionController::Base
  before_action :authenticate_user, except: [:index]
  
  def index
    render template: 'layouts/application'
  end
  
  private
  
  def authenticate_user
    header = request.headers['Authorization']
    if header
      token = header.split(' ').last
      begin
        @decoded = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        @current_user = User.find(@decoded['user_id'])
      rescue JWT::DecodeError
        render json: { error: 'Invalid token' }, status: :unauthorized
      end
    else
      render json: { error: 'Token required' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
end
