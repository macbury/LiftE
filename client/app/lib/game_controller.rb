class GameController
	include RemoteObject
	include RemoteMethods
	
	attr_accessor :engine
	
	@@command_quee = []
	
	def quee_command(command)
		@@command_quee << command
	end
	
	def initialize(engine)
		self.engine = engine
		setup
	end
	
	def setup
		
	end
	
	def send_command(msg)
		self.engine.send_command(msg)
	end
	
	def log(msg)
		$logger.info msg
	end
	
	def update(delta_time)
		@@command_quee.each do |command|
			exec_command(command)
		end
		@@command_quee = []
	end
	
	def method_missing(method, *args, &block)
		if method =~ /server_/i
			send_command(super(method, *args, &block))
		else
			super(method, *args, &block)
		end
	end
end