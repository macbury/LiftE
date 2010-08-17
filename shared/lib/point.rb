TILE_WIDTH = 32
TILE_HEIGHT = 32

class Point
	attr_accessor :x, :y
	
	def initialize(new_x=0, new_y=0)
		self.x = new_x
		self.y = new_y
	end
	
	def set_tile_pos(new_x, new_y)
		self.tile_x = new_x
		self.tile_y = new_y
	end
	
	def tile_x
		(self.x / TILE_WIDTH).to_i
	end
	
	def tile_x=(new_x)
		self.x = new_x * TILE_WIDTH
	end
	
	def tile_y
		(self.y / TILE_HEIGHT).to_i
	end
	
	def tile_y=(new_y)
		self.y = new_y * TILE_HEIGHT
	end
	
	def to_tile_cords
		[tile_x, tile_y]
	end
	
	def self.pixels_to_tiles(tx,ty)
		[(tx / TILE_WIDTH).to_i, (ty / TILE_HEIGHT).to_i]
	end
	
	def self.tile_to_pixels(tx,ty)
		[tx * TILE_WIDTH, ty * TILE_HEIGHT]
	end
end