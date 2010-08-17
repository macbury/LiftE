$TILE_WIDTH = 32;
$TILE_HEIGHT = 32;

function Map(content, file_name) {
	this.file_name = file_name;
	this.width = content["width"];
	this.height = content["height"];
	this.name = content["name"];
	this.zone = content["zone"]
	
	this.layers = { layer1: [], layer2: [], layer3: [] };
	var self = this;
	
	$.each(this.layers, function (layer) {
		for (var x=0; x < self.width; x++) {
			self.layers[layer][x] = [];
			for (var y=0; y < self.height; y++) {
				self.layers[layer][x][y] = {};
			};
		}
	})
	
	self.load_map_from_content(content["map"]);
	
	document.title = "["+this.zone+"] > " + this.name;
}

$.extend(Map.prototype, {
	
	load_map_from_content: function(content){
		var self = this;
		
		$.each(content, function (layer_name, tiles) {
			$.each(tiles, function (index, tile) {
				self.layers[layer_name][tile.x][tile.y] = tile;
			});
		});
	},
	
	set_tile_for_cords: function(layer, chipset, tile_id, x, y){
		this.layers[layer][x][y] = { "x": x, "y": y, "chipset": chipset, "id": tile_id };
	},
	
	draw: function(contex, layer, startX, startY, width, height){
		var self = this;
		$.each(self.layers, function (layer_name, layer_content) {
			for (var x=startX; x < width; x++) {
				for (var y=startY; y < height; y++) {
					var tile = self.layers[layer_name][x][y];
					
					if (tile["id"] != undefined) {
						var p = new Point(0,0);
						p.set_tile_pos(x, y);
						var c = map_editor.chipsets[tile["chipset"]]["_ids"][tile["id"]];
						contex.drawImage(map_editor.chipsets[tile["chipset"]]["_img"], c.x, c.y, 32, 32, p.x, p.y, 32, 32);
					}
				}
			}
		});
	},
});