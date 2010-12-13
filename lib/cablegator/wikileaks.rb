class WikiLeaks 
  include HTTParty
  base_uri 'http://wikileaks.ch'
  HOME = '/cablegate.html'

  class << self
    def reference_id(cable_url)
      File.basename(cable_url).gsub(File.extname(cable_url),'') 
    end

    def with_each_cable
      doc = Nokogiri::HTML(self.get(HOME))
      doc.css(%{a[href^='/date']}).each do |link|
        page_with_cables = Nokogiri::HTML(WikiLeaks.get(link.attributes['href'].value))
        page_with_cables.css(%{a[href^='/cable']}).each do |cable|
          cable_url = cable.attributes['href'].value
          yield cable_url
        end
      end
    end

    def with_each_cable_data
      doc = Nokogiri::HTML(self.get(HOME))
      doc.css(%{a[href^='/date']}).each do |link|
        page_with_cables = Nokogiri::HTML(WikiLeaks.get(link.attributes['href'].value))

        page_with_cables.css(%{table.cable tr:has(td)}).each do |cable|

          cable_hash = {}	
	  children = cable.element_children.map{ |x| x.text.strip }
    	  cable_hash['reference_id'] = children[0]	  
	  cable_hash['subject'] = children[1]	  
	  cable_hash['origin_date'] =  children[2]	  
	  cable_hash['release_date'] = children[3]	  
	  cable_hash['classification'] = children[4]
	  cable_hash['location'] = children[5]
	  yield cable_hash
        end
      end
    end
  end
end
