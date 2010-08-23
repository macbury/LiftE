class PlayerController < ServerController	
	
	def server_methods
		[:chat, :disconnect, :get_info_for_current_actor, :get_info_for_player]
	end
	
	def chat(player, msg)
		brodcast(player.client_chat(msg), player)
	end
	
	def npc_picked_waypoint(player, waypoint)
		$logger.info "Moving path: #{[player.position.to_tile_cords, waypoint.to_tile_cords]}" if DEV_MODE
		command = player.client_move_using_path(player.to_id, [player.position.to_tile_cords, waypoint.to_tile_cords, waypoint.to_tile_cords])
		
		brodcast_to_near_players(command, player)
		send_to(player, command)
	end
	
	def get_info_for_player(current_player, player_id)
		$logger.info "Info for player: #{player_id}"
		player = self.server_contex.clients[player_id.to_sym]
		send_to(current_player, player.client_create_player(player_id, {
			:charset => "warrior.png",
			:name => "Cragmorton",
			:hp => 24,
			:max_hp => 24,
			:rage => 0,
			:x => player.position.tile_x,
			:y => player.position.tile_y,
			:map => player.map
		}))
		
	end
	
	def get_info_for_current_actor(player, field_of_view)
		player.field_of_view = field_of_view.to_i
		send_to(player, player.client_start_game(player.to_id, {
			:charset => "warrior.png",
			:name => "Cragmorton",
			:hp => 24,
			:max_hp => 24,
			:rage => 0,
			:x => player.position.tile_x,
			:y => player.position.tile_y,
			:map => player.map
		}))
		
		send_to(player, player.client_players_near_you(self.players_near_player(player).map(&:to_id)))
	end
	
	def disconnect(player)
		self.server_contex.disconnect(player.connection, -1)
	end
	
end