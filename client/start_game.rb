require "rubygems"
require "logger"
require "gosu"
require "chingu"

include Gosu
include Chingu

$stderr.sync = $stdout.sync = true 

logger = Logger.new(STDOUT)

DEV_MODE = ARGV.include?("--dev")

logger.info "============ Loading source files ============"
Dir[File.dirname(__FILE__) + '/app/**/*.rb'].each do |file| 
	require file 
	logger.info file
end
logger.info "========== End Loading source files =========="

logger.info "LiftE starting and initializing window..."

LiftE.new.show