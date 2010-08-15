class MapState < Chingu::GameState
	attr_accessor :client
	
	def initialize(options={}, client)
		self.client = client
		@player_controller = PlayerController.new
		@connectionMutex = Mutex.new
		prepare_connection(self.client)
		super(options={})
	end
	
	def setup
		self.input = { :escape => :exit }
		
		$logger.info "Downloading main character info..."
		send(@player_controller.server_current_actor)
	end
	
	def send(command)
		$logger.info "Sending #{command}" if DEV_MODE
		self.client.puts command
	end
	
	def serve(client)
		while true
			command = client.readline.strip
			args = command.split("|")
			controller = args[0]
			
			while !(args.last =~ /END/i)
				rest_of_command = client.readline.strip
				args += rest_of_command.split("|")
				command += rest_of_command
			end
			
			$logger.info "Recived command #{command}" if DEV_MODE
			
			if controller =~ /PLAYER/i
				#@player_controller.exec_command(command, player)
			end
		end
	end
	
	def prepare_connection(tcpClient)
		@client_thread.stop unless @client_thread.nil?
		@client_thread = Thread.new(tcpClient) do |myTcpClient|
			begin
        serve(myTcpClient)
      rescue => detail
        $logger.log detail if DEV_MODE
      ensure
        $logger.log "Client is disconnecting"
      end
		end
	end
	
	def finalize
		self.client.puts(@player_controller.server_disconnect)
		self.client.close
	end
	
end