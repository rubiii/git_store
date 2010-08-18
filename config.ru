require "sinatra"

set :env, :production
set :port, 4567
disable :run#, :reload

$:.unshift File.expand_path("../lib", __FILE__)
require "git_store"

require File.expand_path("../app/app", __FILE__)

run Sinatra::Application
