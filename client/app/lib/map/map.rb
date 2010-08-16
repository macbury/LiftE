require "json"

class Map
	attr_accessor :layers, :name, :zone, :width, :height, :music, :chipsets
	attr_accessor :scroll_x, :scroll_y, :visible_x, :visible_y
	@@layer_z_order = { :layer1 => 1, :layer2 => 2, :layer3 => 4 } #zorder 3 is for game objects!
	
	def initialize(map_name)
		map_path = File.join [LiftE.root, "/assets", "/maps", "/#{map_name}.lem"]
		
		$logger.info "Opening map #{map_path}"
		json_map_content = ""
		File.open(map_path, "r").each { |line| json_map_content += line }
		rmc = JSON.parse(json_map_content)
		
		self.name = rmc["name"]
		self.zone = rmc["zone"]
		self.width = rmc["width"].to_i
		self.height = rmc["height"].to_i
		self.music = rmc["music"]
		
		$logger.info "Map: #{self.name} in zone #{self.zone}. Size: #{self.width}x#{self.height}"
		
		self.chipsets = {}
		rmc["chipsets"].each do |chipset_name|
			self.chipsets[chipset_name] = Chipset.new(chipset_name)
		end
		
		clear_layers
		rmc["map"].each do |layer_name, layer_content|
			self.layers[layer_name] = Array.new(self.width) { Array.new(self.height) }
			layer_content.each do |raw_tile|
				self.layers[layer_name][raw_tile["x"]][raw_tile["y"]] = self.chipsets[raw_tile["chipset"]].tiles[raw_tile["id"]]
			end
		end
		
		self.visible_x, self.visible_y = Point.pixels_to_tiles($window.width, $window.height)
		
		$logger.info "Visible tiles for this resolution: #{self.visible_x}x#{self.visible_y}"
	end
	
	def clear_layers
		self.layers = { :layer1 => [], :layer2 => [], :layer3 => [] }
	end
	
	def draw
		self.layers.each do |layer_name, layer_content|
			for	x in (0..self.visible_x)
				for	y in (0..self.visible_y)
					pixel_x, pixel_y = Point.tile_to_pixels(x, y)
					tile = self.layers[layer_name][x][y]
					next if tile.nil?
					tile.image.draw(pixel_x, pixel_y, @@layer_z_order[layer_name])
				end
			end
		end
	end
end