require "rubygems"
require "logger"

require "json"
require "sinatra"
FILE_ROOT = File.dirname(File.expand_path($0))

DEV_MODE = ARGV.include?("--dev")

require "./editor"
require "../shared/lib/point"

if __FILE__ == $0
	Editor.run!
end