class Actor < GameObject
	@@speed = 1
	@@waypoints = []
	
	def initialize(options={})
		super(options)
		@animation = Animation.new(:file => "./assets/graphics/characters/warrior.png", :size => [-3 ,-4], :loop => true, :delay => 250)
    @animation.frame_names = { :up => 9..11, :down => [1,0,1,2], :left => 3..5, :right => 6..8 }
    @frame_name = :down
		
		@moving = false
	end
	
  def move_left
    @x -= @@speed
		@frame_name = :left
		@moving = true
  end

  def move_right
    @x += @@speed
		@frame_name = :right
		@moving = true
  end
	
	def move_up
    @y -= @@speed
		@frame_name = :up
		@moving = true
  end

  def move_down
    @y += @@speed
		@frame_name = :down
		@moving = true
  end
	
	def update(delta_time=0)
		if @moving
			@image = @animation[@frame_name].next
		else
			@image = @animation[@frame_name].first
		end
		
		@moving = false
  end
end