# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

require "ios_build_kit/version"

Gem::Specification.new do |s|
  s.name        = "ios_build_kit"
  s.authors     = ["Adam Waite"]
  s.email       = "adam@adamjwaite.co.uk"
  s.homepage    = "https://github.com/adamwaite/iOS-Build-Kit"
  s.version     = BuildKit::VERSION
  s.platform    = Gem::Platform::RUBY
  s.summary     = "iOS Build Kit"
  s.description = "iOS Build Tool CLI - Increment version • Decorate icon • Build app • Run unit tests • Create ipa artefact"

  s.add_dependency "commander", "~> 4.1"
  s.add_dependency "json", "~> 1.8"
  s.add_dependency "paint", "~> 0.8"
  s.add_dependency "nomad-cli", "~> 0.0.2"
  s.add_dependency "rmagick", '~> 2.13'

  s.add_development_dependency "bundler"
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"

  s.files         = Dir["./**/*"].reject { |file| file =~ /\.\/(bin|log|pkg|script|spec|test|vendor|example|resources)/ }
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

end