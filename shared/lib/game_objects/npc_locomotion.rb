module NPC
	module Locomotion
		attr_accessor :speed, :position, :npc_delegate

		def setup_locomotion
			@waypoints = []
			self.speed = 0.08
			self.npc_delegate = self
			@moving_vector = Point.new(0,0)
		end

		def waypoints=(new_waypoints)
			@waypoints = []

			new_waypoints.each do |vector_array|
				if vector_array.class == Point
					@waypoints << vector_array
				else
					@waypoints << Point.new_tile(vector_array[0], vector_array[1])
				end
			end
			
			unless @waypoints.empty?
				if @current_waypoint && @waypoints.first.distance_to_tile(@current_waypoint) <= 1
					@waypoints.insert(0, @current_waypoint)
				else
					self.position = @waypoints.shift
				end
			end
			
			@current_waypoint = nil
		end

		def move_using_waypoints(delta_time=0)
			if @waypoints.empty?
				self.path_complete
				return 
			end

			if @current_waypoint.nil?
				@current_waypoint = @waypoints.shift

				@moving_vector = self.position.one_direction_vector(@current_waypoint)
				npc_delegate.npc_picked_waypoint(self, @current_waypoint)
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
		
		def path_complete
			
		end
		
		#fire after waypoint is picked
		def npc_picked_waypoint(npc, waypoint)

		end
	end
end