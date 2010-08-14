require "rubygems"
require "logger"
require "./game_logic/lib/gserver"

require "./game_logic/models/player"

require "./game_logic/lib/server_controller"
require "./game_logic/controller/player_controller"

require "./game_logic/lifte_server"

$stderr.sync = $stdout.sync = true 

DEV_MODE = ARGV.include?("--dev")

$logger = Logger.new(STDOUT)

$server = LiftEServer.new(9666)
$server.audit = true
$server.debug = DEV_MODE
$server.start
$server.join

#5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8