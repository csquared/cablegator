require 'socket'
require 'timeout'
require 'nokogiri'
require 'httparty'

class WikiLeaks 
  include HTTParty
  PROXY_URL = 'localhost'
  PROXY_PORT = 8118
  base_uri 'http://wikileaks.ch'

  #let's check for tor on privoxy
  Timeout::timeout(1) do
    TCPSocket.new(PROXY_URL, PROXY_PORT).close
    http_proxy 'localhost', 8118
    puts "Using TOR!"
  end rescue nil
    
  HOME = '/cablegate.html'

  class << self
    def reference_id(cable_url)
      File.basename(cable_url).gsub(File.extname(cable_url),'') 
    end

    def with_each_cable
      doc = Nokogiri::HTML(self.get(HOME))
      doc.css(%{a[href^='/date']}).each do |link|
      cable_url = link.attributes['href'].value
        page_with_cables = Nokogiri::HTML(WikiLeaks.get(cable_url))
        page_with_cables.css(%{a[href^='/cable']}).each do |cable|
          cable_url = cable.attributes['href'].value
          yield cable_url
        end
      end
    end

    def with_each_cable_data
      doc = Nokogiri::HTML(self.get(HOME))
      doc.css(%{a[href^='/date']}).each do |link|
        cable_url = link.attributes['href'].value
        begin
          page_with_cables = Nokogiri::HTML(WikiLeaks.get(cable_url))
          page_with_cables.css(%{table.cable tr:has(td)}).each do |cable|
            cable_hash = {}	
            #cable_hash['cable_url'] = cable.css(%{a[href='/cable']}).first.attributes['href'].value
            children = cable.element_children.map{ |x| x.text.strip }
            cable_hash['reference_id'] = children[0]	  
            cable_hash['subject'] = children[1]	  
            cable_hash['origin_date'] =  children[2]	  
            cable_hash['release_date'] = children[3]	  
            cable_hash['classification'] = children[4]
            cable_hash['location'] = children[5]
            yield cable_hash
          end
        rescue
          STDOUT.puts "error GETtin page #{cable_url}"
        end
      end
    end
  end
end
