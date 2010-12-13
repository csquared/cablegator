# library loader
# require 'rubygems'
# require 'bundler'
# Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

require 'cablegator/wikileaks'

module CableGator
  def self.save_file(pathname)
    require 'fileutils'
    save_file = File.expand_path(pathname)
    FileUtils.mkdir_p(File.dirname(save_file))

    tweeted = File.read(save_file).split(',') rescue []
    at_exit do
      File.open(save_file, 'w') { |f| f << tweeted.join(',') }
    end
    tweeted
  end
end
