class MapController < ServerController	
	@@vmaps = {}
	
	def server_methods
		[:go_to_cords]
	end
	
	def setup
		$logger.info "Loading Vector Maps"
		vmd = File.join([FILE_ROOT, "vmaps", "/**/", "*.lev"])
		
		Dir[vmd].each do |file_path|
			map = File.basename(file_path, ".lev")
			@@vmaps[map] = VMap.new(file_path)
			$logger.info "+ #{map} from #{file_path}"
		end
		
		$logger.info "Loaded all vMaps!"
	end
	
	def go_to_cords(player, end_x, end_y)
		end_pos = Tile.new(end_x.to_i, end_y.to_i)
		player.waypoints = []
		if @@vmaps[player.map].wall?(end_pos)
			$logger.info "This is wall"
			send_to(player, player.client_path_unavailable)
		else
			$logger.info "Generating way for map #{player.map} to cords #{end_x}:#{end_y} from #{player.position.tile_x}:#{player.position.tile_y} for player #{player.to_id}"

			pf = PathFinder.new(@@vmaps[player.map], player.position.to_tile, end_pos)
			pf.find_way
			
			player.waypoints = pf.way.map(&:to_point)
			#send_to(player, player.client_move_using_path(pf.to_response))
			$logger.info "Calculated path: #{pf.to_response}" if DEV_MODE
		end
	end
	
end