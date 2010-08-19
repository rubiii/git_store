Gem::Specification.new do |s|
  s.name = "git_store"
  s.version = "0.1.0"
  s.platform = Gem::Platform::RUBY
  s.authors = "Daniel Harrington"
  s.email = "me@rubiii.com"
  s.homepage = "http://github.com/rubiii/git_store"
#  s.summary = ""
#  s.description = ""

  s.rubyforge_project = "git_store"

  s.add_development_dependency "rspec"

#  s.files = Dir["[A-Z]*", "{lib,spec}/**/*.{rb,xml,yml,gz}"]
#  s.files += [".autotest", "spec/spec.opts"]
#  s.files = Dir.glob("{bin,lib}/**/*") + %w(LICENSE README.md ROADMAP.md CHANGELOG.md ISSUES.md)
  s.executables = ['git_storefront']
  s.require_path = 'lib'
end
