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
  end
end
