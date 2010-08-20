var map_editor = {
	map_canvas: null,
	width: 0,
	height: 0,
	map: null,
	visible_x: 0,
	visible_y: 0,
	
	current_chipset: null,
	current_layer: "layer1",
	selected_tile: 0,
	chipsets: {},
	
	mouse_pos: null,
	
	init: function(chipsets){
		var self = map_editor;
		this.load_chipsets(chipsets);
		this.mouse_pos = new Point(0, 0);
		this.map_canvas = $("#map_editor");
		this.chipset_canvas = $('#chipset_select_canvas');
		
		this.calculate_draw_size();
		
		$('#layers button').click(function () {
			self.current_layer = "layer" + $(this).attr("layer");
			self.redraw();
			return false;
		});
		
		$(this.map_canvas).mousemove(function(e){
			var offset = $(this).offset();

			var x = e.pageX - offset.left;
			var y = e.pageY - offset.top;
			map_editor.mouse_pos = new Point(x, y);
			map_editor.render_title();
			//console.log("X :" + x + "("+(map_editor.mouse_pos.tile_x())+") Y:" + y + "("+(map_editor.mouse_pos.tile_y())+")" );
			//map_editor.redraw();
		});
		
		$(this.chipset_canvas).mousedown(function(e){
			var offset = $(this).offset();

			var x = e.pageX - offset.left;
			var y = e.pageY - offset.top;
			var mp = new Point(x, y);
			
			self.select_chipset(mp);
		});
		
		$(this.map_canvas).bind("contextmenu", function(e) {
			e.preventDefault();
		});
		
		$(this.map_canvas).mousedown(function(e){
			var offset = $(this).offset();

			var x = e.pageX - offset.left;
			var y = e.pageY - offset.top;
			var mp = new Point(x, y);
			
			if( (!$.browser.msie && e.button == 0) || ($.browser.msie && e.button == 1) ) {
				self.map.set_tile_for_cords(self.current_layer, self.current_chipset["name"], self.selected_tile, mp.tile_x(), mp.tile_y());
				//self.map.fill_tile_for_cords(self.current_layer, self.current_chipset["name"], self.selected_tile);
			} else if(e.button == 2){
				self.map.delete_tile_for_cords(self.current_layer, mp.tile_x(), mp.tile_y());
			}
			self.redraw();
			
			return false;
		});
		
		$(window).resize(function(){
			self.calculate_draw_size();
		});
		
		this.map = new Map({
			"zone": "New zone",
			"name": "New map",

			"width": 32,
			"height": 32,

			"music": "Town1.mid",

			"chipsets": [],

			"map": {
				"layer1": [],
				"layer3": [],
				"layer2": []
			},

			"game_objects": []
		}, null);
		
		setTimeout(map_editor.calculate_draw_size, 500);
		map_editor.redraw();
	},
	
	render_title: function(){
		document.title = "["+this.map.zone+"] > " + this.map.name + " - " + "x: " + this.mouse_pos.tile_x() + " y: " + this.mouse_pos.tile_y();
	},
	
	select_chipset: function(pos){
		$.each(this.current_chipset["_ids"], function (index, element) {
			if (element.tile_x() == pos.tile_x() && element.tile_y() == pos.tile_y()) {
				map_editor.selected_tile = index;
			}
		})
		this.redraw();
	},
	
	load_map: function(map_content, name){
		this.map = new Map(map_content, name);
		this.redraw();
	},
	
	save_map: function(){
		var self = this;
		$.ajax({
		  type: 'POST',
		  url: "/save_map/",
		  data: { file: self.map.file_name, map_content: self.map.content() }
		});
	},
	
	redraw: function(){
		var ctx = map_editor.map_canvas[0].getContext("2d");
		ctx.fillStyle = "rgb(0,0,0)";  
		ctx.fillRect (0, 0, this.width, this.height);
		
		if (map_editor.map != null) {
			map_editor.map.draw(ctx, self.current_layer, 0, 0, this.visible_x, this.visible_y);
		}
		
		//map_editor.draw_cursor();
		map_editor.redraw_chipset();
	},
	
	draw_cursor: function(){
		var self = map_editor;
		var ctx = self.map_canvas[0].getContext("2d");
		
		ctx.fillStyle = "rgba(255, 0, 0, 50)";
		var cords = self.mouse_pos.tile_to_pixels(self.mouse_pos.tile_x(), self.mouse_pos.tile_y());
		ctx.fillRect(cords[0],cords[1],32,32);
	},
	
	redraw_chipset: function(){
		var self = map_editor;
		var ctx = self.chipset_canvas[0].getContext("2d");
		ctx.fillStyle = "rgb(0,0,0)";
		ctx.fillRect (0, 0, self.chipset_canvas.width(), self.chipset_canvas.height());
		
		if (self.current_chipset != undefined && self.current_chipset["_img"] != undefined) {
			ctx.drawImage(self.current_chipset["_img"],0,0); 
			
			ctx.lineWidth = 2;  
			ctx.strokeStyle = "#ff0000";
			var p = self.current_chipset["_ids"][self.selected_tile];
			ctx.strokeRect(p.x,p.y,32,32);
		}
	},
	
	calculate_draw_size: function(){
		var me = map_editor;
		this.width = $("#editor").width();
		this.height = $("#editor").height();
		
		this.visible_x = Math.round(this.width / $TILE_WIDTH);
		this.visible_y = Math.round(this.height / $TILE_HEIGHT);
		
		$(this.map_canvas).attr("width", this.width);
		$(this.map_canvas).attr("height", this.height);

		map_editor.redraw();
	},
	
	calculate_chipset_size: function(){
		var self = map_editor;
		$(self.chipset_canvas).attr("width", "256");

		if (self.current_chipset != undefined && self.current_chipset["_img"] != undefined) {
			$(self.chipset_canvas).attr("height", self.current_chipset['_img'].height);
			$(self.chipset_canvas).attr("width", self.current_chipset['_img'].width);
		}
		
		map_editor.redraw();
	},
	
	load_chipsets: function(chipsets){
		this.chipsets = chipsets;
		var self = map_editor;
		
		$.each(this.chipsets, function (key, value) {
			$('#chipset_name').append("<option>"+key+"</option>");
			var img = new Image();
			img.onload = function(){  
			  map_editor.chipsets[key]["_img"] = img;
			}
			img.src = "/chipset_image/"+value["image"];
			
			self.chipsets[key]["_ids"] = [];
			for (var row=0; row < value["rows"]; row++) {
				for (var column=0; column < value["columns"]; column++) {
					var p = new Point(0,0);
					p.set_tile_pos(column, row);
					self.chipsets[key]["_ids"].push(p);
				}
			}
		});
		
		$("#chipset_name").change(function () {
			var key = $(this).val();
			
			if (self.chipsets[key]["_img"] == undefined) {
				$("#progress_indicator").show();
				var img = new Image();
				img.onload = function(){  
				  map_editor.chipsets[key]["_img"] = img;
					map_editor.current_chipset = self.chipsets[key];
					self.calculate_chipset_size();
					self.selected_tile = 0;
					$("#progress_indicator").hide();
				}
				img.src = "/chipset_image/"+self.chipsets[key]["image"];
				
			} else {
				map_editor.current_chipset = map_editor.chipsets[key];
				self.selected_tile = 0;
				self.calculate_chipset_size();
			}
		});
		$("#chipset_name").change();
	},
}
