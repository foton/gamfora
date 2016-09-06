$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gamification/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gamification_playground"
  s.version     = Gamification::VERSION
  s.authors     = ["Foton"]
  s.email       = ["foton@centrum.cz"]
  s.homepage    = "https://github.com/foton/gamification_gem"
  s.summary     = "Rails engine in form of gem for including gamification into your Rails app"
  s.description = "Description of Gamification."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.0", ">= 5.0.0.1"

#  s.add_development_dependency "bundler", "~> 1.10"
#  s.add_development_dependency "rake", "~> 10.0"
  s.add_development_dependency "sqlite3"
  #spec.add_development_dependency "minitest"
  #spec.add_development_dependency "minitest-reporters" 
  s.add_development_dependency "pry-byebug" 
  s.add_development_dependency "nested_scaffold"
end


  
