class Api::V1::PapersController < ApplicationController
  skip_before_action :authenticate_user, only: [:index, :show]

  def index
    if params[:query].present?
      # Construct ArXiv API URL with query parameters
      base_url = "http://export.arxiv.org/api/query"
      query_params = {
        search_query: params[:query],
        start: params[:start] || 0,
        max_results: params[:max_results] || 10,
        sortBy: params[:sort_by] || 'relevance'
      }
      
      response = HTTParty.get(base_url, query: query_params)
      papers = ArxivService.parse_response(response.body)
      
      render json: papers
    else
      render json: [], status: :ok
    end
  end

  def show
    paper = Paper.find_by(arxiv_id: params[:id])
    
    unless paper
      # If not in database, fetch from ArXiv
      arxiv_paper = ArxivService.get_paper(params[:id])
      
      if arxiv_paper
        paper = Paper.create(
          arxiv_id: arxiv_paper[:arxiv_id],
          title: arxiv_paper[:title],
          authors: arxiv_paper[:authors],
          abstract: arxiv_paper[:abstract],
          url: arxiv_paper[:url],
          published_date: arxiv_paper[:published_date]
        )
      else
        return render json: { error: 'Paper not found' }, status: :not_found
      end
    end
    
    render json: paper.as_json
  end
end
