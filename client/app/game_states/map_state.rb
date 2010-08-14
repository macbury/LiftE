class MapState < Chingu::GameState
	def setup
		self.input = { :escape => :exit }
		
		actor = Actor.create
	end
end