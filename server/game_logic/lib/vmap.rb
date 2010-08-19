class VMap
	attr_accessor :width, :height, :content
	
	def initialize(file_name)
		json_content = ""
		File::open(file_name, "r+").each do |line|
			json_content += line
		end
		
		vmap_json = JSON.parse(json_content)
		self.width = vmap_json["width"]
		self.height = vmap_json["height"]
		self.content = []
		
		width.times do |x|
			self.content[x] = Array.new(height)
			height.times do |y|
				self.content[x][y] = MtFree
			end
		end
		
		vmap_json["vmap"].each do |tile|
			self.content[tile["x"]][tile["y"]] = (tile["passable"] == true) ? MtFree : MtWall
		end
	end
	
	def wall?(point)
		self.content[point.x][point.y] == MtWall
	end
end