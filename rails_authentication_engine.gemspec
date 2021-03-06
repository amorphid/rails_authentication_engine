$:.push File.expand_path("../lib", __FILE__)

require "rails_authentication_engine/version"

Gem::Specification.new do |s|
  s.name        = "rails_authentication_engine"
  s.version     = RailsAuthenticationEngine::VERSION
  s.authors     = ["Michael Pope"]
  s.email       = ['mpope.cr@gmail.com']
  s.homepage    = "https://github.com/SpaceballsThe/rails_authentication_engine"
  s.summary     = "An authentication engine"
  s.description = "An authentication engine"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency 'bcrypt-ruby', '~> 3.1.5'
  s.add_dependency 'hash_ish', '~> 0.4.3'
  s.add_dependency 'rails', '~> 4.2.5'
end
