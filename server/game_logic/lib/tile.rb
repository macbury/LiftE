class Tile
	attr_accessor :x, :y
	
	def ==(other_point)
		self.x == other_point.x && self.y == other_point.y
	end
	
	def initialize(new_x=0, new_y=0)
		self.x = new_x.to_i
		self.y = new_y.to_i
	end
	
	def to_point
		p = Point.new_tile(self.x,self.y)
	end
end