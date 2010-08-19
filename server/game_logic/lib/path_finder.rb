DIRECTIONS = [
	Tile.new(0,-1),
	Tile.new(1,0),
	Tile.new(0,1),
	Tile.new(-1, 0)
]

UNSEEN_FIELD = -1
MtFree = 0
MtStart = 1 
MtEnd = 2 
MtWall = 3
MtWay = 4

class PathFinder
	attr_accessor :map_contex, :start_pos, :end_pos
	
	attr_accessor :q, :buff_way, :map, :way
	
	def initialize(map, start_pos, end_pos)
		self.map_contex = map
		self.start_pos = start_pos
		self.end_pos = end_pos
		self.q = []
		self.buff_way = []
	end
	
	def prepare_map
		$logger.info "Preparing map..." if DEV_MODE
		self.q = []
		self.map = []
		self.buff_way = []
		self.way = []

		self.map_contex.width.times do |x|
			self.map[x] = Array.new(self.map_contex.height)
			self.map_contex.height.times do |y|
				self.map[x][y] = UNSEEN_FIELD
			end
		end
		
		$logger.info "Unseen fields: #{self.map_contex.width * self.map_contex.height}" if DEV_MODE
	end
	
	def find_way
		prepare_map
		return if self.start_pos == self.end_pos
		
		self.q = [self.start_pos]
		self.map[self.start_pos.x][self.start_pos.y] = 0
		searching_complete = false
		
		while !(searching_complete || self.q.empty?)
			v = self.q.shift
	
			DIRECTIONS.each do |direction|
				w = Tile.new(v.x + direction.x, v.y + direction.y)			
				
				next if isPointOutOfMap?(w)
				
				if (!self.map_contex.wall?(w) && self.map[w.x][w.y] == UNSEEN_FIELD) 
					self.map[w.x][w.y] = self.map[v.x][v.y] + 1
					self.q << w
				end

				if self.end_pos == w
					build_way(w)
					searching_complete = true
					break
				end
			end
		end
	end
	
	def build_way(actual_pos)
		ret_way = []
		next_way = nil
		
		while actual_pos != self.start_pos
			ret_way << actual_pos
			DIRECTIONS.each do |direction|
				next_way = Tile.new(actual_pos.x + direction.x, actual_pos.y + direction.y)
				next if isPointOutOfMap?(next_way)
				
				if (self.map[next_way.x][next_way.y] == self.map[actual_pos.x][actual_pos.y] - 1)
					actual_pos = next_way
					break
				end
			end
		end
		
		self.way = ret_way.reverse
		self.way.insert(0, start_pos)
		self.way << end_pos
	end
	
	def debug
		s = ""
		self.map_contex.width.times { s += "====" }
		s = "+#{s}+"
		puts s
		
		self.map_contex.width.times do |x|
			line = []
			self.map_contex.height.times do |y|
				p = Tile.new(x,y)
				t = self.map[x][y]
				
				
				if p == self.start_pos
					line << "STA"
				elsif p == self.end_pos
					line << "END"
				elsif self.way.include?(p)
						line << "***"
				elsif self.map_contex.wall?(p)
					line << "XXX"
				else
					if (t == -1)
						line << "   "
					else
						line << number_to_map(t)
					end
				end
			end
			
			puts "|#{line.join(" ")}|"
		end
		puts s
	end
	
	def number_to_map(n)
		if n > 99
			n
		elsif n > 9
			"0#{n}"
		else
			"00#{n}"
		end
	end
	
	def to_response
		self.way.map { |waypoint| [waypoint.x, waypoint.y] }
	end
	
	def isPointOutOfMap?(point)
		((point.x < 0) || (point.x >= self.map_contex.width) || (point.y < 0) || (point.y >= self.map_contex.height))
	end
end