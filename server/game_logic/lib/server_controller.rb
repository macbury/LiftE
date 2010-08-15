class ServerController
	include RemoteMethods
	attr_accessor :server_contex
	
	def initialize(server_contex)
		self.server_contex = server_contex
	end
	
	def clients
		self.server_contex.clients
	end
	
	def brodcast(msg,owner)
		self.server_contex.brodcast(msg, owner)
	end
	
	def send_to(players, msg)
		self.server_contex.send_to(players, msg)
	end
	
	def log(message)
		puts message
	end
	
end