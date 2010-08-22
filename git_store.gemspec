Gem::Specification.new do |s|
  s.name = "git_store"
  s.version = "0.1.0"
  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/rubiii/git_store"

  s.summary = "A key/value store based on Git"
  s.description = "Git Store lets you work with revision-based values"
  s.rubyforge_project = "git_store"

  s.add_dependency "sinatra", "~> 1.0"
  s.add_dependency "sinatra_more", "~> 0.3.40"
  s.add_dependency "rack-flash", "~> 0.1.1"
  s.add_dependency "haml", "~> 3.0.15"

  s.add_development_dependency "rspec", ">= 2.0.0.beta.19"

  s.files = Dir["[A-Z]*", "{autotest,bin,lib,spec}/**/*"] + %w(.rspec config.ru)
  s.executables = ["git_store"]
  s.require_path = "lib"
end
