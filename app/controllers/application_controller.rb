# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user
  
  # Skip authentication for these routes
  skip_before_action :authenticate_user, only: [:index]
  
  def index
    render template: 'layouts/application'
  end
  
  private
  
  def authenticate_user
    header = request.headers['Authorization']
    return render json: { error: 'Unauthorized' }, status: :unauthorized unless header
    
    token = header.split(' ').last
    begin
      decoded = JWT.decode(token, Rails.application.secret_key_base, true, { algorithm: 'HS256' })[0]
      @current_user = User.find(decoded['user_id'])
    rescue JWT::DecodeError, ActiveRecord::RecordNotFound => e
      Rails.logger.error("Authentication error: #{e.message}")
      render json: { error: 'Invalid token' }, status: :unauthorized
    end
  end
  
  def current_user
    @current_user
  end
end
