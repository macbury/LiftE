require "rubygems"
require "logger"
require "yaml"
require 'base64'
require "json"
require "./game_logic/lib/gserver"
require "../shared/lib/point"
require "../shared/lib/remote_object"
require "../shared/lib/remote_methods"
require "../shared/lib/game_objects/npc_locomotion"
require "../shared/lib/remote_id"
require "./game_logic/models/player"

require "./game_logic/lib/tile"
require "./game_logic/lib/path_finder"
require "./game_logic/lib/vmap"
require "./game_logic/lib/server_controller"
require "./game_logic/controller/player_controller"
require "./game_logic/controller/map_controller"

require "./game_logic/lifte_server"

$stderr.sync = $stdout.sync = true 

DEV_MODE = ARGV.include?("--dev")
UPDATE_INTERVAL = 20.99999
FILE_ROOT = File.dirname(File.expand_path($0))

$logger = Logger.new(STDOUT)

$server = LiftEServer.new(9666)
$server.audit = true
$server.debug = DEV_MODE
$server.start
$server.join

#5baa61e4c9b93f3f0682250b6cf8331b7ee68fd8