class ServerController
	include RemoteMethods
	include RemoteObject
	attr_accessor :server_contex
	
	def initialize(server_contex)
		self.server_contex = server_contex
		setup
	end
	
	def setup
		
	end
	
	def clients
		self.server_contex.clients
	end
	
	def players_near_player(player)
		self.server_contex.players_near_player(player)
	end
	
	def brodcast(msg,owner)
		self.server_contex.brodcast(msg, owner)
	end
	
	def brodcast_to_near_players(msg, owner)
		self.server_contex.brodcast_to_near_players(msg, owner)
	end
	
	def send_to(players, msg)
		self.server_contex.send_to(players, msg)
	end
	
	def log(message)
		puts message
	end
	
end