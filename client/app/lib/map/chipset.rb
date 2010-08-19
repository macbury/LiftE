require "json"

class Chipset
	attr_accessor :tiles
	
	def initialize(chipset_name)
		self.tiles = []
		
		chipset_definition_path = File.join [LiftE.root, "assets", "graphics", "chipsets", "#{chipset_name}.lec"]
		$logger.info "Loading chipset definition #{chipset_definition_path}"
		
		json_chipset_definition_content = ""
		File.open(chipset_definition_path, "r").each { |line| json_chipset_definition_content += line }
		
		cd = JSON.parse(json_chipset_definition_content)
		
		chipset_image_path = File.join [LiftE.root, "assets", "graphics", "chipsets", cd["image"]]
		
		$logger.info "Loading chipset image #{chipset_image_path}"

		image_tiles = Gosu::Image.load_tiles($window, chipset_image_path, 32,32, true)
		
		$logger.info "Loaded #{image_tiles.size} tiles"
		
		image_tiles.each_with_index do |image_tile, index|
			self.tiles << Tile.new(image_tile, cd["name"], index)
		end
	end
end