require "rubygems"
require "logger"
require "gosu"
require "chingu"
require "digest/sha2"
require "socket"
require "yaml"
require 'base64'

include Gosu
include Chingu

HOST = "127.0.0.1"
PORT = "9666"

$stderr.sync = $stdout.sync = true 

$logger = Logger.new(STDOUT)

DEV_MODE = ARGV.include?("--dev")

require "../shared/lib/remote_object"

$logger.info "============ Loading source files ============"
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].each do |file| 
	require file 
	$logger.info file
end
$logger.info "========== End Loading source files =========="

$logger.info "LiftE starting and initializing window..."

LiftE.new.show