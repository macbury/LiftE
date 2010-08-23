require "json"

class Map
	attr_accessor :layers, :name, :zone, :width, :height, :music, :chipsets
	attr_accessor :scroll_x, :scroll_y, :visible_x, :visible_y
	@@layer_z_order = { :layer1 => 1, :layer2 => 2, :layer3 => 5 } #zorder 3 is for game objects!
	
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
		
		self.layers = { :layer1 => Layer.new(self.width, self.height), 
										:layer2 => Layer.new(self.width, self.height), 
										:layer3 => Layer.new(self.width, self.height) }
		
		$logger.info "Loading tiles from map JSON file..."
		rmc["map"].each do |layer_name, layer_content|
			layer_sym = layer_name.to_sym
			layer_content.each do |raw_tile|
				$logger.info "#{layer_sym} <- #{raw_tile["id"].to_i} <- #{raw_tile["chipset"]} x: #{raw_tile["x"]} y: #{raw_tile["y"]}" if DEV_MODE
				tile = self.chipsets[raw_tile["chipset"]].tiles[raw_tile["id"].to_i]
				
				self.layers[layer_sym].set_tile_for_cords(tile, raw_tile["x"].to_i, raw_tile["y"].to_i)
			end
		end
		
		self.layers.each do |name, controller|
			$logger.info "[COUNT] #{name} -> #{controller.tiles_count}"
		end
		
		self.visible_x, self.visible_y = Point.pixels_to_tiles($window.width, $window.height)
		
		$logger.info "Visible tiles for this resolution: #{self.visible_x}x#{self.visible_y}"
	end
	
	def draw_tile_for_cords(x, y, layer_name)
		tile = self.layers[layer_name].tile_for_cords(x,y)
		return if tile.nil?
		pixel_x, pixel_y = Point.tile_to_pixels(x, y)
		tile.image.draw(pixel_x, pixel_y, @@layer_z_order[layer_name], 1, 1)
	end
	
	def draw
		for	x in (0..self.visible_x)
			for	y in (0..self.visible_y)
				draw_tile_for_cords(x, y, :layer1)
				draw_tile_for_cords(x, y, :layer2)
				draw_tile_for_cords(x, y, :layer3)
			end
		end
	end
end