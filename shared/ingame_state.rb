#class InGameState < Chingu::GameState
#	include RemoteGameState
#	include RemoteMethods
	
#	def create_main_actor(player_id, options="")
#		log("Creating main actor #{options[:name]}...")
#		options = YAML::load(options)
#		Actor.create
#	end
	
#	def setup
#		self.input = { :escape => :exit }
		
#		log("Downloading main character info...")
		
#		send(self.engine.player_controller.server_current_actor)
#	end
	
#	def finalize
		#self.client.puts(@player_controller.server_disconnect)
		#self.client.close
#	end
	
#	def server_methods
#		[:create_main_actor]
#	end
#end