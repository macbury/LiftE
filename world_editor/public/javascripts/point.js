function Point (x,y) {
	this.x = x;
	this.y = y;
}

$.extend(Point.prototype, {
	
	tile_x: function(){
		var tx = parseInt(this.x / $TILE_WIDTH);
		if (tx == NaN) { tx = 0; };
		return tx;
	},
	
	set_tile_x: function(new_x){
		this.x = new_x * $TILE_WIDTH;
	},
	
	tile_y: function(){
		var ty = parseInt(this.y / $TILE_HEIGHT);
		if (ty == NaN) { ty = 0; };
		return ty;
	},
	
	set_tile_y: function(new_y){
		this.y = new_y * $TILE_HEIGHT;
	},
	
	set_tile_pos: function(new_x, new_y){
		this.set_tile_x(new_x);
		this.set_tile_y(new_y);
	},
	
	to_tile_cords: function(){
		return [this.tile_x(), this.tile_y()]
	},
	
	pixels_to_tiles: function(tx,ty){
		var px = parseInt(tx / $TILE_WIDTH);
		var py = parseInt(ty / $TILE_HEIGHT);
		if (px == NaN) { px = 0; };
		if (py == NaN) { py = 0; };
		return [px, py];
	},
	
	tile_to_pixels: function(tx, ty){
		return [tx * $TILE_WIDTH, ty * $TILE_HEIGHT];
	},
	
	snap_to_grid: function(){
		
	},
});