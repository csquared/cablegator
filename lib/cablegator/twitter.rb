require 'oauth'
require 'launchy'

module Twitter
  def self.command_line_login
    consumer_key = 'ddxhhHSHys7210VR8lhYag'
    consumer_secret = 'FN5kIDAvwWU4jb54JMfWWTbtpI30JKeEmRWMYSMYk'

    oauth_client = OAuth::Consumer.new(consumer_key, consumer_secret, 
                        :site => 'http://api.twitter.com', 
                        :request_endpoint => 'http://api.twitter.com', 
                        :sign_in => true)

    req_token = oauth_client.get_request_token
    Launchy.open(req_token.authorize_url)

    puts "\nAllow access to get pin\n"

    puts "Enter Pin: "
    pin = STDIN.gets.strip 

    begin 
      access_token = req_token.get_access_token(:oauth_verifier => pin)

      Twitter.configure do |config|
        config.consumer_key = access_token.consumer.key
        config.consumer_secret = access_token.consumer.secret
        config.oauth_token = access_token.token 
        config.oauth_token_secret = access_token.secret
      end
    rescue
      STDOUT.puts "Twitter Authentication failed - please try again"
    end
  end
end
