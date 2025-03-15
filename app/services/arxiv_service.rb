# app/services/arxiv_service.rb
require 'httparty'
require 'nokogiri'

class ArxivService
  def self.search(query, start = 0, max_results = 10, sort_by = nil)
    url = "http://export.arxiv.org/api/query"
    params = {
      search_query: query,
      start: start,
      max_results: max_results
    }
    
    params[:sortBy] = sort_by if sort_by
    
    # Add retry mechanism with exponential backoff
    max_retries = 3
    retries = 0
    
    begin
      response = HTTParty.get(url, query: params, timeout: 30)  # Add a timeout
      parse_response(response.body)
    rescue Errno::ECONNRESET, Net::ReadTimeout, Net::OpenTimeout => e
      retries += 1
      if retries <= max_retries
        sleep_time = 2 ** retries  # Exponential backoff: 2, 4, 8 seconds
        Rails.logger.warn("Connection error with ArXiv API. Retrying in #{sleep_time} seconds... (Attempt #{retries}/#{max_retries})")
        sleep(sleep_time)
        retry
      else
        Rails.logger.error("Failed to connect to ArXiv API after #{max_retries} attempts: #{e.message}")
        return []  # Return empty array instead of raising an error
      end
    rescue => e
      Rails.logger.error("Unexpected error with ArXiv API: #{e.message}")
      return []
    end
  end
  
  def self.get_paper(arxiv_id)
    url = "http://export.arxiv.org/api/query?id_list=#{arxiv_id}"
    
    begin
      response = HTTParty.get(url, timeout: 30)
      papers = parse_response(response.body)
      papers.first if papers.any?
    rescue => e
      Rails.logger.error("Error fetching paper #{arxiv_id}: #{e.message}")
      nil
    end
  end

  # In ArxivService, add caching
    def self.get_paper(arxiv_id)
        # Check cache first (using Rails.cache)
        Rails.cache.fetch("arxiv_paper_#{arxiv_id}", expires_in: 1.day) do
        url = "http://export.arxiv.org/api/query?id_list=#{arxiv_id}"
        response = HTTParty.get(url)
        papers = parse_response(response.body)
        papers.first if papers.any?
        end
    end
  
  
    def self.parse_response(xml)
        begin
        doc = Nokogiri::XML(xml)
        entries = doc.xpath('//xmlns:entry')
        
        entries.map do |entry|
            published_text = entry.xpath('.//xmlns:published').text.strip
            
            # More robust date parsing
            begin
            published_date = published_text.present? ? Date.parse(published_text) : nil
            rescue Date::Error
            published_date = nil
            end
            
            {
            arxiv_id: entry.xpath('.//xmlns:id').text.split('/').last,
            title: entry.xpath('.//xmlns:title').text.strip,
            abstract: entry.xpath('.//xmlns:summary').text.strip,
            authors: entry.xpath('.//xmlns:author/xmlns:name').map(&:text).join(', '),
            url: entry.xpath('.//xmlns:id').text,
            published_date: published_date
            }
        end
        rescue => e
        Rails.logger.error("Error parsing ArXiv response: #{e.message}")
        []
        end
  end
end
