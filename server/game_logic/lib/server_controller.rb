class ServerController
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
	
	def exec_command(request_string, player)
		arg = request_string.split("|")
		arg.delete_at(0)
		method = arg[0]
		arg.delete_at(0)
		arg.pop if arg.last =~ /END/i
		
		arg = arg.map { |raw_arg| Base64.decode64(raw_arg).strip }
		arg.insert(0, player)
		
		method_is_avaliable = false
		
		server_methods.each do |sm|
			if method =~ /#{sm.to_s}/i && respond_to?(sm)
				method_is_avaliable = true
				method = sm
				break
			end
		end
		
		if method_is_avaliable
			log("Executing method: #{method} with arguments: #{arg.join(", ")}")
			self.send(method, *arg)
		else
			log("Undefined method: #{method} Arguments: #{arg.join(", ")}")
		end
	end
	
	def server_methods
		[]
	end
	
end