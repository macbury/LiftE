require "rubygems"
require "logger"
require "gosu"
require "digest/sha2"
require "socket"
require "yaml"
require 'base64'

include Gosu

HOST = "127.0.0.1"
PORT = "9666"

FILE_ROOT = File.dirname(File.expand_path($0))

$stderr.sync = $stdout.sync = true 

$logger = Logger.new(STDOUT)

DEV_MODE = ARGV.include?("--dev")

require "../shared/lib/point"
require "../shared/lib/game_objects/npc_locomotion"
require "../shared/lib/remote_object"
require "../shared/lib/remote_id"
require "../shared/lib/remote_methods"
require "./app/lib/game_controller"
require "./app/lib/game_object"

$logger.info "============ Loading source files ============"
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].each do |file| 
	require file 
	$logger.info file
end
$logger.info "========== End Loading source files =========="

$logger.info "LiftE starting and initializing window..."

LiftE.new.show