class PlayerController < GameController
	
	def update(delta_time)
		super(delta_time)
	end
	
	def create_main_actor(player_id, options="")
		options = YAML::load(options)
		$logger.info("Creating main actor #{options[:name]}...")
		start_pos = Point.new
		start_pos.set_tile_pos(10, 10)
		Actor.new
	end

	def server_methods
		[:create_main_actor]
	end
	
end