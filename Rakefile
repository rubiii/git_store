begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new do |t|
    t.spec_opts = %w(-fd -c)
    t.warning = true
  end
rescue LoadError
  task :spec do
    abort "Run 'gem install rspec' to be able to run specs"
  end
end

task :default => :spec
