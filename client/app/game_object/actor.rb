class Actor < GameObject
	@@speed = 1
	@@waypoints = []
	
	def initialize(options={})
	  super(options)
		#self.input = {:holding_left => :move_left, :holding_right => :move_right, :holding_down => :move_down, :holding_up => :move_up}
		
		@animation = Animation.new(:file => "./media/warrior.png", :size => [-3 ,-4], :loop => true, :delay => 250)
    #@animation.frame_names = { :up => 9..11, :down => [0,1,0,2], :left => 3..5, :right => 6..8 }
    @frame_name = :down
		@moving = false
		update
		
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
		#if @moving
		#	@image = @animation[@frame_name].next
		#else
		#	@image = @animation[@frame_name].last
		#end
		
		@moving = false
  end
end