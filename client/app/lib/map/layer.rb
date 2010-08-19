class Layer
	attr_accessor :width, :height, :tiles_count, :content
	
	def initialize(width, height)
		self.width = width
		self.height = height
		self.tiles_count = 0
		self.content = []
		width.times do |index|
			self.content[index] = Array.new(height)
		end
	end
	
	def set_tile_for_cords(tile, x, y)
		self.tiles_count += 1
		self.content[x][y] = tile
	end

	def tile_for_cords(x,y)
		begin
			self.content[x][y]
		rescue 
			nil
		end
	end
end