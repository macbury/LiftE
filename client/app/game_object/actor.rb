class Actor < GameObject
	attr_accessor :speed
	
	def initialize(options={})
		super(options)
		@animation = Animation.new(:file => "./assets/graphics/characters/warrior.png", :size => [-3 ,-4], :loop => true, :delay => 250)
    @animation.frame_names = { :up => [10,9,10,11], :down => [1,0,1,2], :left => [4,3,4,5], :right => [7,6,7,8] }
		@frame_name = :down
		@waypoints = []
		
		self.speed = 0.08
		@moving_vector = Point.new(0,0)
		@moving = false
	end
	
	def waypoints=(new_waypoints)
		@waypoints = []
		@current_waypoint = nil
		
		new_waypoints.each do |vector_array|
			@waypoints << Point.new_tile(vector_array[0], vector_array[1])
		end
	end
	
	def update(delta_time=0)
		move_using_waypoints(delta_time)
		
		if @moving
			@image = @animation[@frame_name].next
		else
			@image = @animation[@frame_name].first
		end
  end

	def move_using_waypoints(delta_time=0)
		if @waypoints.empty?
			@moving = false
			return
		else
			@moving = true
		end
		
		if @current_waypoint.nil?
			@current_waypoint = @waypoints.shift
			@moving_vector = self.position.one_direction_vector(@current_waypoint)
			if @moving_vector == Point.left
				@frame_name = :left
			elsif @moving_vector == Point.right
				@frame_name = :right
			elsif @moving_vector == Point.up
				@frame_name = :up
			elsif
				@frame_name = :down
			end
		end
		
		distance = self.position.distance_to(@current_waypoint)
		if (distance < 2.0)
			self.position = @current_waypoint
			@current_waypoint = nil
		else
			self.position.x += @moving_vector.x.to_f * self.speed.to_f * delta_time.to_f
			self.position.y += @moving_vector.y.to_f * self.speed.to_f * delta_time.to_f
		end
	end
end