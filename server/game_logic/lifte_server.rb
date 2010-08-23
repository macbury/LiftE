class LiftEServer < GServer
	attr_accessor :delta_time
	
	def initialize(port=9666, *args)
		super(port, *args)

		@clients = {}
		@map_controller = MapController.new(self)
		@player_controller = PlayerController.new(self)
		@sync_mutex = Mutex.new
		@update_interval = UPDATE_INTERVAL / 1000.0
		@game_objects_thread = Thread.new(self) do |server_contex|
			while true
				start = Time.now
				server_contex.clients.each do |player_id, player|
					begin
						player.update(server_contex.delta_time)
					rescue Exception => e
						$logger.error e.to_s
						$logger.error(e.backtrace.join("\n")) if DEV_MODE
						disconnect(player.connection,  -1)
					end
				end

				sleep(@update_interval)
				server_contex.delta_time = (Time.now - start) * 1000
			end
		end
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
			$logger.info "Authorizing player with #{email} and #{password}" if DEV_MODE
			
			if player
				#disconnect(@clients[player]) unless @clients[player].nil?
				player.connection = client
				player.npc_delegate = @player_controller
				@clients[player.to_id] = player
				log("Player have been authorized: #{player.to_id}")
				brodcast_to_near_players(player.client_joined(player.to_id), player)
				send_to(player, player.client_authorized)

				while client && command = client.readline.strip
					args = command.split("|")
					controller = args[0]
					
					while !(args.last =~ /END/i)
						rest_of_command = client.readline.strip
						args += rest_of_command.split("|")
						command += rest_of_command
					end
					
					$logger.info "Recived command: #{command} from player #{player.to_id}" if DEV_MODE
					
					if controller =~ /PLAYER/i
						@player_controller.exec_command(command, player)
					elsif controller =~ /MAP/i
						@map_controller.exec_command(command, player)
					else
						#client.puts "PLAYER|UNKNOW_COMMAND|END"
						#disconnect_player(player)
					end
				end

				disconnect(player.connection,  -1) if player
			else
				log("Player unauthorized: wrong email or password")
				client.puts "PLAYER|UNAUTHORIZED|END"
			end
		rescue Exception => e
			log(e.to_s)
			log(e.backtrace.join("\n"))
			disconnect(client, -1)
		end
	end
 
	def brodcast(command, owner=nil)
		$logger.info "Brodcasting command: #{command}" if DEV_MODE
		@clients.each do |player_id, player|
			player.connection.puts(command) unless player == owner
		end
	end
 
	def send_to(players, command)
		if players.class == Array
			$logger.info "Sending command: #{command} to players: #{players.map(&:to_id)}" if DEV_MODE
			@clients.each do |player_id, player|
				player.connection.puts(command) if players.include?(player)
			end
		else
			$logger.info "Sending command: #{command} to player: #{players.to_id}" if DEV_MODE
			@clients.each do |player_id, player|
				player.connection.puts(command) if player == players
			end
		end
	end
	
	def brodcast_to_near_players(command, player)
		send_to(players_near_player(player), command)
	end
	
	def players_near_player(main_player)
		near = []
		@clients.each do |player_id, player|
			next if player.map != main_player.map || player.id == main_player.id
			
			if player.position.distance_to_tile(main_player.position) <= main_player.field_of_view
				near << player
			end
		end
		
		$logger.info("Players near player #{main_player.to_id}: #{near.map(&:to_id)}") if DEV_MODE
		
		return near
	end
	
	def disconnecting(client, port)
		self.clients.each do |player_id, player|
			next unless player.connection == client
		  
			self.clients.delete(player_id) 
	    log("Removed player from client list: #{player_id}")
			begin
				brodcast(@player_controller.client_disconnected(player_id), player)
			rescue Exception => e
				$logger.error e
			end
			
	    break
		end
	end

end