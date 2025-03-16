# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  before_action :authenticate_user
  
  # Skip authentication for these routes
  skip_before_action :authenticate_user, only: [:index], if: -> { self.class == ApplicationController }
  
  def index
    render template: 'layouts/application'
  end
  
  private
  
  def authenticate_user
    header = request.headers['Authorization']
    
    return render json: { error: 'Authentication required' }, status: :unauthorized unless header
    
    # Better token extraction - handles various formats
    token = header.gsub(/^Bearer\s+/, '')
    
    begin
      # Explicitly specify algorithm and verification
      decoded = JWT.decode(
        token, 
        Rails.application.secret_key_base,
        true,  # Verify the signature
        { algorithm: 'HS256' }  # Specify the algorithm
      )
      
      # Properly access the user_id from the decoded payload
      user_id = decoded[0]['user_id']
      
      @current_user = User.find(user_id)
      
      return true
    rescue JWT::DecodeError => e
      render json: { error: 'Invalid token' }, status: :unauthorized
    rescue JWT::ExpiredSignature => e
      Rails.logger.error "AUTH ERROR - Token expired: #{e.message}"
      render json: { error: 'Token expired' }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound => e
      Rails.logger.error "AUTH ERROR - User not found: #{e.message}"
      render json: { error: 'User not found' }, status: :unauthorized
    rescue => e
      Rails.logger.error "AUTH ERROR - Unexpected: #{e.class.name} - #{e.message}"
      render json: { error: 'Authentication failed' }, status: :unauthorized
    end
  end
  
  
  def current_user
    @current_user
  end
end
