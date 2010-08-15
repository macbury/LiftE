class PlayerController < ServerController	
	
	def server_methods
		[:chat, :disconnect, :current_actor]
	end
	
	def chat(player, msg)
		brodcast(player.client_chat(msg), player)
	end
	
	def current_actor(player)
		log("Sending info for player #{player.id}")
		send_to(player, player.client_create_main_actor(player.id, {
			:charset => "warrior.png",
			:name => "Cragmorton",
			:hp => 24,
			:max_hp => 24,
			:rage => 0,
			:x => 10,
			:y => 5
		}))
	end
	
	def disconnect(player)
		self.server_contex.disconnect_player(player)
	end
	
end