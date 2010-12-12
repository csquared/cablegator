# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "cablegator/version"

Gem::Specification.new do |s|
  s.name        = "cablegator"
  s.version     = Cablegator::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["csquared"]
  s.email       = ["christopher.continanza@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Downloads Wikileaks Cables to current directory}
  s.description = %q{Downloads Wikileaks Cables to current directory}

  s.rubyforge_project = "cablegator"

  s.add_dependency('nokogiri')
  s.add_dependency('httparty')
  s.add_dependency('twitter')

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
