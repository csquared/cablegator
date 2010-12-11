# library loader
require 'rubygems'
#require 'bundler'
#Bundler.setup

$LOAD_PATH.unshift(File.dirname(__FILE__)) unless $LOAD_PATH.include?(File.dirname(__FILE__))

# gems
require 'open-uri'
require 'nokogiri'
require 'httparty'
require 'fileutils'
