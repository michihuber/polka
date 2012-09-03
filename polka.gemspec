$:.push File.expand_path("../lib", __FILE__)
require 'polka/version'

Gem::Specification.new do |s|
  s.name        = "polka"
  s.version     = Polka::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Michi Huber"]
  s.email       = ["michi.huber@gmail.com"]
  s.homepage    = "http://github.com/michihuber/polka"
  s.summary     = ""
  s.description = "Easy Dotfile Management"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency "thor", ">=0.16.0"
  s.add_dependency "colorize", "0.5.8"
  s.add_development_dependency 'rspec', '~> 2.11'
end
