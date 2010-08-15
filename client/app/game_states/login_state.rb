class LoginState < Chingu::GameState
	def setup
		self.input = { :escape => :exit, :space => :login }
	end
	
	def login
		begin
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
			map_state = MapState.new({}, @client)
			switch_game_state(map_state)
		else
			$logger.info "Unauthorized..."
			@client.close
			login
		end
		
	end
end