class PlayerController < GameController
	attr_accessor :main_actor
	
	def server_methods
		[:start_game, :move_using_path]
	end
	
	def update(delta_time)
		super(delta_time)
	end
	
	def move_using_path(waypoints)
		$logger.info "Moving player using waypoints"
		self.main_actor.waypoints = YAML::load(waypoints)
	end
	
	def start_game(player_id, options="")
		options = YAML::load(options)
		load_map(options[:map])
		
		$logger.info("Creating main actor #{options[:name]} in cords #{options[:x]}, #{options[:y]}...")
		start_pos = Point.new
		start_pos.set_tile_pos(options[:x], options[:y])
		self.main_actor = Actor.new(:position => start_pos)
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