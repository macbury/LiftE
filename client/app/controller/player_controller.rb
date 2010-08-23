class PlayerController < GameController
	attr_accessor :main_actor
	
	def server_methods
		[:start_game, :move_using_path, :create_player, :joined, :disconnected, :players_near_you]
	end
	
	def update(delta_time)
		super(delta_time)
	end
	
	def players_near_you(players_ids)
		players_ids = YAML::load(players_ids)
		$logger.info "Players near #{self.main_actor.to_id}: #{players_ids}"
		players_ids.each do |player_id|
			self.server_get_info_for_player(player_id)
		end
	end
	
	def disconnected(player_id)
		$logger.info "Player #{player_id} is disconnecting! Removing game_object"
		self.engine.game_objects.delete(player_id.to_sym)
	end
	
	def joined(player_id)
		$logger.info "New player joined game #{player_id}"
		self.server_get_info_for_player(player_id)
	end
	
	def move_using_path(player_id, waypoints)
		$logger.info "Moving game_object #{player_id} using waypoints"
		#self.engine.game_objects("playe")
		player = self.engine.game_objects[player_id.to_sym]
		if player.nil?
			self.server_get_info_for_player(player_id)
		else
			player.waypoints = YAML::load(waypoints)
		end

	end
	
	def create_player(player_id, options="")
		options = YAML::load(options)
		$logger.info("Creating new actor #{options[:name]} in cords #{options[:x]}, #{options[:y]}...")
		
		start_pos = Point.new_tile(options[:x], options[:y])
		actor = Player.new(:position => start_pos, :id => player_id)
		$logger.info("GameObject id: #{actor.to_id}")
	end
	
	def start_game(player_id, options="")
		options = YAML::load(options)
		load_map(options[:map])
		
		$logger.info("Creating main actor #{options[:name]} in cords #{options[:x]}, #{options[:y]}...")
		start_pos = Point.new_tile(options[:x], options[:y])
		self.main_actor = Player.new(:position => start_pos, :id => player_id)
		$logger.info("GameObject id: #{self.main_actor.to_id}")
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