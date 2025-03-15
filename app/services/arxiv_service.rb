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
    
    response = HTTParty.get(url, query: params)
    parse_response(response.body)
  end
  
  def self.get_paper(arxiv_id)
    url = "http://export.arxiv.org/api/query?id_list=#{arxiv_id}"
    response = HTTParty.get(url)
    papers = parse_response(response.body)
    papers.first if papers.any?
  end
  
  def self.parse_response(xml)
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
  end
end
