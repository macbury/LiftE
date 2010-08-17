class Layer
	@@content = []
	
	def initialize(width, height)
		width.times do |index|
			@@content[index] = Array.new(height)
		end
	end
	
	def set_tile_for_cords(tile, x, y)
		@@content[x][y] = tile
	end
	
	def tile_for_cords(x,y)
		begin
			@@content[x][y]
		rescue 
			nil
		end
	end
end