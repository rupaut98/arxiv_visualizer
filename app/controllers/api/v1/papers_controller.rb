class Api::V1::PapersController < ApplicationController
    skip_before_action :authenticate_user, only: [:index, :show]
  
    def index
      if params[:query].present?
        papers = ArxivService.search(params[:query], params[:start] || 0, params[:max_results] || 10)
        render json: papers
      else
        render json: [], status: :ok
      end
    end
  
    def show
      paper = Paper.find_by(arxiv_id: params[:id]) || find_and_create_paper(params[:id])
      
      if paper
        render json: paper.as_json(include: :citations)
      else
        render json: { error: 'Paper not found' }, status: :not_found
      end
    end
  
    def citations
      paper = Paper.find_by(arxiv_id: params[:id])
      
      if paper
        citations = paper.citations.map do |citation|
          cited_paper = Paper.find_by(arxiv_id: citation.cited_paper_arxiv_id)
          if cited_paper
            cited_paper.as_json
          else
            { arxiv_id: citation.cited_paper_arxiv_id }
          end
        end
        
        render json: citations
      else
        render json: { error: 'Paper not found' }, status: :not_found
      end
    end
  
    private
  
    def find_and_create_paper(arxiv_id)
      paper_data = ArxivService.get_paper(arxiv_id)
      return nil unless paper_data
      
      paper = Paper.create(paper_data)
      
      paper
    end
  end
  