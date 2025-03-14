require 'httparty'
require 'nokogiri'

class ArxivService
  def self.search(query, start = 0, max_results = 10)
    url = "http://export.arxiv.org/api/query?search_query=#{URI.encode(query)}&start=#{start}&max_results=#{max_results}"
    response = HTTParty.get(url)
    parse_response(response.body)
  end
  
  def self.get_paper(arxiv_id)
    url = "http://export.arxiv.org/api/query?id_list=#{arxiv_id}"
    response = HTTParty.get(url)
    papers = parse_response(response.body)
    papers.first if papers.any?
  end
  
  private
  
  def self.parse_response(xml)
    doc = Nokogiri::XML(xml)
    entries = doc.xpath('//xmlns:entry')
    
    entries.map do |entry|
      {
        arxiv_id: entry.xpath('.//xmlns:id').text.split('/').last,
        title: entry.xpath('.//xmlns:title').text.strip,
        abstract: entry.xpath('.//xmlns:summary').text.strip,
        authors: entry.xpath('.//xmlns:author/xmlns:name').map(&:text).join(', '),
        url: entry.xpath('.//xmlns:id').text,
        published_date: Date.parse(entry.xpath('.//xmlns:published').text)
      }
    end
  end
end
