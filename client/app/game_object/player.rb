class Player < GameObject
	include NPC::Locomotion
	include RemoteId
	
	attr_accessor :id
	
	def initialize(options={})
		self.id = options[:id]
		super(options)
		@animation = Animation.new(:file => "./assets/graphics/characters/warrior.png", :size => [-3 ,-4], :loop => true, :delay => 250)
    @animation.frame_names = { :up => [10,9,10,11], :down => [1,0,1,2], :left => [4,3,4,5], :right => [7,6,7,8] }
		@frame_name = :down
		@moving = false
		
		setup_locomotion
	end
	
	def id=(new_id)
		@id = new_id.gsub("player_", "").to_i
	end
	
	def id
		@id
	end
	
	def update(delta_time=0)
		move_using_waypoints(delta_time)
		
		if @moving
			@image = @animation[@frame_name].next
		else
			@image = @animation[@frame_name].first
		end
  end
	
	def path_complete
		@moving = false
	end
	
	def npc_picked_waypoint(player, waypoint)
		if @moving_vector == Point.left
			@frame_name = :left
		elsif @moving_vector == Point.right
			@frame_name = :right
		elsif @moving_vector == Point.up
			@frame_name = :up
		elsif @moving_vector == Point.down
			@frame_name = :down
		end
		
		@moving = true
	end

end