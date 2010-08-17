class LiftEServer < GServer
	
	def initialize(port=9666, *args)
		super(port, *args)

		@clients = {}
		@player_controller = PlayerController.new(self)
		@sync_mutex = Mutex.new
	end
 
	def clients
		@clients
	end
 
	def log(msg)
		$logger.info msg
	end
 
	def serve(client)
		begin
			log("New client have connected...")
			args = client.readline.split("|")
			email = args[0]
			password = args[1]

			player = Player.authorize(email, password)

			if player
				@clients[player] = client
				brodcast(player.client_joined(player.id), player)
				log("Player have been authorized: #{player.id}")
				send_to(player, player.client_authorized)

				while @clients[player]
					command = client.readline.strip
					args = command.split("|")
					controller = args[0]
					
					while !(args.last =~ /END/i)
						rest_of_command = client.readline.strip
						args += rest_of_command.split("|")
						command += rest_of_command
					end
					
					$logger.info "Recived command: #{command} from player #{player.id}" if DEV_MODE
					
					if controller =~ /PLAYER/i
						@player_controller.exec_command(command, player)
					end
				end

				disconnect_player(player) if player
			else
				log("Player unauthorized: wrong email or password")
				client.puts "PLAYER|UNAUTHORIZED"
			end
		rescue Exception => e
			log(e.backtrace.join("\n"))
			disconnect(client, -1)
		end
	end
 
	def brodcast(command, owner=nil)
		$logger.info "Brodcasting command: #{command}" if DEV_MODE
		@clients.each do |player, client|
			client.puts(command) unless player == owner
		end
	end
 
	def send_to(players, command)
		if players.class == Array
			$logger.info "Sending command: #{command} to players: #{players.map(&:id)}" if DEV_MODE
			@clients.each do |player, client|
				client.puts(command) if players.include?(player)
			end
		else
			$logger.info "Sending command: #{command} to player: #{players.id}" if DEV_MODE
			@clients.each do |player, client|
				client.puts(command) if player == players
			end
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
		brodcast(player.client_disconnected(player.id), player)
		disconnect(@clients[player])
	end
end