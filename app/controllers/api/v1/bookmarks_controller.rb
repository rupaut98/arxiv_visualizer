class Api::V1::BookmarksController < ApplicationController
    before_action :authenticate_user
    before_action :set_bookmark, only: [:destroy]
  
    def index
        if current_user.nil?
          return render json: { error: 'Authentication required' }, status: :unauthorized
        end
        
        bookmarks = current_user.bookmarks.includes(:paper)
        
        render json: bookmarks.as_json(include: :paper)
      end
    
      def debug_auth
        header = request.headers['Authorization']
        
        response = {
          headers_received: {
            authorization: header
          },
          current_user: current_user ? {
            id: current_user.id,
            email: current_user.email
          } : nil,
          token_decoded: nil
        }
        
        if header
          token = header.split(' ').last
          begin
            decoded = JWT.decode(token, Rails.application.secret_key_base)[0]
            response[:token_decoded] = decoded
          rescue => e
            response[:decode_error] = e.message
          end
        end
        
        render json: response
      end
      
      
  
    # app/controllers/api/v1/bookmarks_controller.rb
    def create
        # Find the paper in the database
        paper = Paper.find_by(arxiv_id: params[:arxiv_id])
        
        unless paper
        # If not in database, fetch minimal data from ArXiv
        paper_data = ArxivService.get_paper(params[:arxiv_id])
        return render json: { error: 'Paper not found' }, status: :not_found unless paper_data
        
        # Create with essential fields only
        paper = Paper.create(
            arxiv_id: paper_data[:arxiv_id],
            title: paper_data[:title],
            authors: paper_data[:authors],
            abstract: paper_data[:abstract],
            url: paper_data[:url],
            published_date: paper_data[:published_date]
        )
        end
        
        # Check if already bookmarked
        existing_bookmark = current_user.bookmarks.find_by(paper_id: paper.id)
        if existing_bookmark
        return render json: { message: 'Paper already bookmarked' }, status: :ok
        end
        
        # Create bookmark
        bookmark = current_user.bookmarks.new(paper: paper, notes: params[:notes])
        
        if bookmark.save
        render json: bookmark.as_json(include: :paper), status: :created
        else
        render json: { errors: bookmark.errors.full_messages }, status: :unprocessable_entity
        end
    end
  
    def auth_check
        if current_user
          render json: { 
            authenticated: true, 
            user_id: current_user.id,
            email: current_user.email,
            bookmarks_count: current_user.bookmarks.count
          }
        else
          render json: { authenticated: false, error: 'Authentication failed' }, status: :unauthorized
        end
      end
    def destroy
      @bookmark.destroy
      head :no_content
    end
  
    private
  
    def set_bookmark
      @bookmark = current_user.bookmarks.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Bookmark not found' }, status: :not_found
    end
  end
  