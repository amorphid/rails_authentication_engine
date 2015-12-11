$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_authentication_engine/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_authentication_engine"
  s.version     = RailsAuthenticationEngine::VERSION
  s.authors     = ["Michael Pope"]
  s.email       = ['mpope.cr@gmail.com']
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of RailsAuthenticationEngine."
  s.description = "TODO: Description of RailsAuthenticationEngine."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.2.5"

  s.add_development_dependency "sqlite3"
end
