class LiftE < Gosu::Window
	attr_accessor :player_controller
	@@sync_mutex = Mutex.new
	
	def initialize
		self.player_controller = PlayerController.new(self)
		@game_objects = []
		@@sync_mutex.synchronize { $window = self }
		@last_value = 0
		@milliseconds_since_last_tick = 0
    super(800,600,!DEV_MODE)
		login
	end
	
	def add_game_object(new_game_object)
		@game_objects << new_game_object unless @game_objects.include?(new_game_object)
	end
	
	def delta_time
		@milliseconds_since_last_tick
	end
	
	def update
		@milliseconds_since_last_tick = Gosu::milliseconds - @last_value
		@last_value = Gosu::milliseconds
		
		@player_controller.update(self.delta_time)
		
		@game_objects.each do |go|
			go.update(self.delta_time)
		end
	end
	
	def draw
		@game_objects.each do |go|
			go.draw
		end
	end
	
	def login
		begin
			@client_thread.exit unless @client_thread.nil?
			@client = TCPSocket.new(HOST, PORT) 
			$logger.info "Connecting to #{HOST}:#{PORT}"
		rescue Exception => e
			$logger.info "Could not connect to #{HOST}:#{PORT}"
			$logger.error e.to_s
		end
		
		$logger.info "Logging in..."
		@client.puts("macbury|haslo")
		
		if @client.readline.strip == "PLAYER|AUTHORIZED|END"
			$logger.info "Logging in sucessful..."
			@client_thread = Thread.new(@client) do |myTcpClient|
				begin
	        serve(myTcpClient)
	      rescue => detail
	        $logger.log detail if DEV_MODE
	      ensure
	        $logger.log "Client is disconnecting"
	      end
			end

			#switch_game_state(@ingame_state)
		else
			$logger.info "Unauthorized..."
			@client.close
		end
	end
	
	def send_command(command)
		$logger.info "Sending #{command}" if DEV_MODE
		@client.puts command
	end
	
	def serve(client)
		self.player_controller.server_current_actor
		
		while true
			command = @client.readline.strip
			args = command.split("|")
			controller = args[0]
			
			while !(args.last =~ /END/i)
				rest_of_command = @client.readline.strip
				args += rest_of_command.split("|")
				command += rest_of_command
			end
			
			$logger.info "Recived command #{command}" if DEV_MODE
			
			if controller =~ /PLAYER/i
				self.player_controller.exec_command(command)
			end
		end
	end

end