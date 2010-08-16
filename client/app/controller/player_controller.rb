class PlayerController < GameController
	
	def server_methods
		[:start_game]
	end
	
	def update(delta_time)
		super(delta_time)
	end
	
	def start_game(player_id, options="")
		options = YAML::load(options)
		load_map(options[:map])
		
		$logger.info("Creating main actor #{options[:name]} in cords #{options[:x]}, #{options[:y]}...")
		start_pos = Point.new
		start_pos.set_tile_pos(options[:x], options[:y])
		Actor.new(:position => start_pos)
	end
	
	def load_map(map_name)
		$logger.info("Preparing map...")
		@map = Map.new(map_name)
	end
	
	def draw
		return if @map.nil?
		
		@map.draw
	end
	
end