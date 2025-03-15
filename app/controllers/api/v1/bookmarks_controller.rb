class Api::V1::BookmarksController < ApplicationController
    before_action :set_bookmark, only: [:destroy]
  
    def index
      bookmarks = current_user.bookmarks.includes(:paper)
      render json: bookmarks.as_json(include: :paper)
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
  