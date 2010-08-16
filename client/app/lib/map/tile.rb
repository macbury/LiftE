class Tile
	attr_accessor :image, :chipset_index, :chipset_name
	
	def initialize(image, chipset_name, chipset_index)
		self.image = image
		self.chipset_index = chipset_index
		self.chipset_name = chipset_name
	end
end