TILE_WIDTH = 32
TILE_HEIGHT = 32

class Point
	attr_accessor :x, :y
	
	def self.down
		Point.new(0,1)
	end
	
	def self.up
		Point.new(0,-1)
	end
	
	def self.zero
		Point.new(0,0)
	end
	
	def self.left
		Point.new(-1, 0)
	end
	
	def self.right
		Point.new(1, 0)
	end
	
	def ==(other_point)
		self.x == other_point.x && self.y == other_point.y
	end
	
	def initialize(new_x=0, new_y=0)
		self.x = new_x.to_i
		self.y = new_y.to_i
	end
	
	def self.new_tile(tile_x, tile_y)
		p = Point.new(0,0)
		p.tile_x = tile_x.to_i
		p.tile_y = tile_y.to_i
		
		return p
	end
	
	def screen_x
		self.x.round
	end
	
	def screen_y
		self.y.round
	end
	
	def *(other_point)
		if other_point.class == Point
			self.x *= other_point.x
			self.y *= other_point.y
		elsif other_point.class == Fixnum
			self.x *= other_point
			self.y *= other_point
		end
	end
	
	def tile_center_point
		cp = Point.tile_to_pixels(self.tile_x, self.tile_y)
		cp[0] += (TILE_WIDTH / 2).round
		cp[1] += (TILE_HEIGHT / 2).round
		
		return Point.new(cp[0], cp[1])
	end
	
	def snap
		np = Point.tile_to_pixels(self.tile_x, self.tile_y)
		self.x = np[0]
		self.y = np[1]
	end
	
	def distance_to(b)
		return (b.x - self.x).abs + (b.y - self.y).abs
	end
	
	def distance_to_center_of_tile(other_point)
		a = self.tile_center_point
		b = other_point.tile_center_point
		
		return (b.x - a.x).abs + (b.y - a.y).abs
	end
	
	def one_direction_vector(b_point)
		pos_x = b_point.x - self.x
		
		if pos_x.to_i != 0
			if pos_x > 0
				return Point.right
			elsif pos_x < 0
				return Point.left
			end
		else
			pos_y = b_point.y - self.y
			
			if pos_y > 0
				return Point.down
			elsif pos_y < 0
				return Point.up
			end
		end
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