begin
  require "rspec/core/rake_task"

  RSpec::Core::RakeTask.new do |t|
    t.spec_opts = %w(-fd -c)
  end
rescue LoadError
  task :spec do
    abort "Run 'gem install rspec' to be able to run specs"
  end
end

config_ru = File.expand_path("../config.ru", __FILE__)

desc "Launch Git Store via rackup"
task :rackup do
  `rackup #{config_ru} -p 4567`
end

desc "Launch Git Store via shotgun"
task :shotgun do
  `shotgun #{config_ru} -p 4567`
end

task :default => :spec
