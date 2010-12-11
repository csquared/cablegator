class WikiLeaks 
  include HTTParty
  base_uri 'http://wikileaks.ch'

  HOME = '/cablegate.html'

  class << self
    def home
      self.get(HOME)
    end
  end
end
