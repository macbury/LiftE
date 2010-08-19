var builder = {
	library: [],
	openDialog: function () {
		$.ajax({
			type: "GET",
			url: "/map_list",
			dataType: "json",
			success: function(json){
				$('#open_dialog ul').empty();
				$(json).each(function (index, map_name) {
					$('#open_dialog ul').append('<li><a href="/load_map/'+map_name+'">'+map_name+'</a></li>');
				});
				
				$('#open_dialog li a').live("click", function () {
					$('#open_dialog').dialog("close");
					var a = $(this);
					$.ajax({
						type: "GET",
						url: $(this).attr("href"),
						dataType: "json",
						success: function(json){
							map_editor.load_map(json, a.attr("href"));
						}
					 });

					return false;
				});
				
			  $('#open_dialog').dialog("open");
			}
		 });
		
	},
	
	newDialog: function(){

	},
	
	init: function(){
		$(document).ajaxComplete(function() {
		  $("#progress_indicator").hide();
		});
		
		$(document).ajaxStart(function() {
		  $("#progress_indicator").show();
		});
		
		$(document).mousemove(function(e){
			$("#progress_indicator").css({
				left: e.pageX + 10 + "px",
				top: e.pageY + 10 + "px"
			});
		});
		$(".sidebar").accordion({ header: "h3", autoHeight: false });
		
		$("#chipsets").dialog({
			position: [window.innerWidth - 316, 53],
			height: 300,
			width: 272
		});
		
		$('#bottom_scroll_bar').slider({
			slide:function(e, ui){
				//if( scrollContent.width() > scrollPane.width() ){ scrollContent.css('margin-left', Math.round( ui.value / 100 * ( scrollPane.width() - scrollContent.width() )) + 'px'); }
				//else { scrollContent.css('margin-left', 0); }
			}
		});
		$("#right_scroll_bar").slider({
			orientation: "vertical",
		});

		$('#search').keyup(function () {
			var keyword = new RegExp($(this).val(), 'gi');
			
			if (keyword.length == '') {
				$("#library .component").show();
			} else {
				$("#library .component").each(function () {
					var text = $(this).text();
					if (text.match(keyword) == null) {
						$(this).hide();
					}else{
						$(this).show();
					}
				});
			}
			

		});
		
		$('#open_dialog').dialog({
			title: "Load map:",
			modal: true,
			width: 500,
			height: 440,
			autoOpen: false,
			
		});
		
		$(".button:not(.ui-state-disabled)")
				.hover(
					function(){ 
						$(this).addClass("ui-state-hover"); 
					},
					function(){ 
						$(this).removeClass("ui-state-hover"); 
					}
				)
				.mousedown(function(){
						$(this).parents('.buttonset-single:first').find(".button.ui-state-active").removeClass("ui-state-active");
						if( $(this).is('.ui-state-active.button-toggleable, .buttonset-multi .ui-state-active') ){ $(this).removeClass("ui-state-active"); }
						else { $(this).addClass("ui-state-active"); }	
				})
				.mouseup(function(){
					if(! $(this).is('.button-toggleable, .buttonset-single .button,  .buttonset-multi .button') ){
						$(this).removeClass("ui-state-active");
					}
				});
	},
	
}