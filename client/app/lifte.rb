class LiftE < Gosu::Window
	attr_accessor :player_controller, :map_controller
	@@sync_mutex = Mutex.new
	
	def initialize
		self.player_controller = PlayerController.new(self)
		self.map_controller = MapController.new(self)
		@game_objects = []
		$window = self
		@last_value = 0
		@milliseconds_since_last_tick = 0
		@fps_counter = FPSCounter.new
		
    super(800,600,!DEV_MODE)

		$logger.info "Loading cursor..."
		@cursor = Gosu::Image.new(self, File.join([FILE_ROOT, 'assets/graphics/gui/cursor.png']), false)

		login
	end
	
	
	def add_game_object(new_game_object)
		@game_objects << new_game_object unless @game_objects.include?(new_game_object)
	end
	
	def delta_time
		@milliseconds_since_last_tick
	end
	
	def update
		self.caption = "LiftE - [#{@fps_counter.fps} FPS]" if DEV_MODE
		@milliseconds_since_last_tick = Gosu::milliseconds - @last_value
		@last_value = Gosu::milliseconds
		
		@fps_counter.register_tick
		
		@player_controller.update(self.delta_time)
		
		@game_objects.each do |go|
			go.update(self.delta_time)
		end
	end
	
	def button_up(id)
		if id == Gosu::MsRight
			p = Point.new(self.mouse_x, self.mouse_y)
			$logger.info "Clicked on tile x:#{p.tile_x} y:#{p.tile_y}"
			self.map_controller.server_go_to_cords(p.tile_x, p.tile_y)
    end
	end
	
	def draw
		self.player_controller.draw
		@game_objects.each do |go|
			go.draw
		end
		
		@cursor.draw(self.mouse_x, self.mouse_y, 1000)
	end
	
	def disconnect
		$logger.info "You have been disconnected!"
		@client.close unless @client.nil?
		@client_thread.exit unless @client_thread.nil?
		@client_thread = nil
		@client = nil
		
		Process.exit
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
		@client.puts([ARGV[0], Digest::SHA1.hexdigest(ARGV[1])].join("|"))
		
		if @client.readline.strip == "PLAYER|AUTHORIZED|END"
			$logger.info "Logging in sucessful..."
			@client_thread = Thread.new(@client) do |myTcpClient|
				begin
	        serve(myTcpClient)
	      rescue => detail
	        $logger.log detail if DEV_MODE
	      ensure
	        disconnect
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
		self.player_controller.server_get_info_for_current_actor
		
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
			
			begin
				if controller =~ /PLAYER/i
					self.player_controller.quee_command(command)
				end
			rescue Exception => e
				$logger.error e.to_s
				$logger.error(e.backtrace.join("\n"))
			end
			
		end
	end
	
	def self.root
		FILE_ROOT
	end
	
end