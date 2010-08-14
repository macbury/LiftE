class PlayerController < ServerController	
	
	def server_methods
		[:chat, :disconnect]
	end
	
	def chat(player, msg)
		log(msg)
	end
	
	def disconnect(player)
		self.server_contex.disconnect_player(player)
	end
	
end