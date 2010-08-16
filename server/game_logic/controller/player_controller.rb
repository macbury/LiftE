class PlayerController < ServerController	
	
	def server_methods
		[:chat, :disconnect, :get_info_for_current_actor]
	end
	
	def chat(player, msg)
		brodcast(player.client_chat(msg), player)
	end
	
	def get_info_for_current_actor(player)
		log("Sending info for player #{player.id}")
		send_to(player, player.client_start_game(player.id, {
			:charset => "warrior.png",
			:name => "Cragmorton",
			:hp => 24,
			:max_hp => 24,
			:rage => 0,
			:x => 5,
			:y => 5,
			:map => "MAP00001"
		}))
	end
	
	def disconnect(player)
		self.server_contex.disconnect_player(player)
	end
	
end