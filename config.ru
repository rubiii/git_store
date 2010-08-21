lib = File.expand_path("../lib/", __FILE__)
$:.unshift lib unless $:.include?(lib)

require "git/store/front"

#log = File.new "sinatra.log", "a"
#STDOUT.reopen log
#STDERR.reopen log

run Git::Store::Front
