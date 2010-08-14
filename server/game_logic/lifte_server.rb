class LiftEServer < GServer
	def initialize(port=9666, *args)
		super(port, *args)
		
		@clients = {}
		@player_controller = PlayerController.new(self)
	end
	
	def clients
		@clients
	end
	
	def log(msg)
		#$logger.log("[LiftEServer] #{msg || ""}")
		puts msg
	end
	
	def serve(client)
		log("New client have connected...")
		args = client.readline.split("|")
		email = args[0]
		password = args[1]
		
		player = Player.authorize(email, password)
		
		if player
			@clients[player] = client
			brodcast("PLAYER|JOINED|#{player.id}", player)
			log("Player have been authorized: #{player.id}")
			@clients[player].puts "PLAYER|AUTHORIZED"
			
			while @clients[player]
				command = client.readline
				args = command.split("|")
				controller = args[0]
				
				if controller =~ /PLAYER/i
					@player_controller.exec_command(command, player)
				end
				
			end
			
			disconnect_player(player) if player
		else
			log("Player unauthorized: wrong email or password")
			client.puts "PLAYER|UNAUTHORIZED"
		end
	end
	
	def brodcast(command, owner=nil)
		@clients.each do |player, client|
			client.puts(command) unless player == owner
		end
	end
	
	def disconnecting(client, port)
		super(client,port)
		@clients.each do |player, s_client|
			if s_client == client
				@clients.delete(player) 
				log("Removed player from client list: #{player.id}")
				break
			end
		end
	end
	
	def disconnect_player(player)
		log("Player is disconnecting: #{player.id}")
		brodcast("PLAYER|DISCONNECTED|#{player.id}", player)
		disconnect(@clients[player])
		
	end
end