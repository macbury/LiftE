class LiftE < Chingu::Window
	include Chingu
	def initialize
    super(800,600,!DEV_MODE)
	end
	
	def update
		super
		
		if DEV_MODE
			self.caption = "LiftE - #{self.fps}"
		end
	end
	
	def setup
		if DEV_MODE
			switch_game_state(LoginState.new)
		else
			switch_game_state(MapState.new)
			#switch_game_state(FadeIn.new(MenuState.new))
		end
  end
end