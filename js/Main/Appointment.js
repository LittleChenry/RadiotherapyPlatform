$(document).ready(function () {
	var chooseWeek = $("#chooseWeek");
	chooseWeek.find("button").each(function(index,e){
		$(this).bind("click",{index:index},function(e){
			var WeekArea = $("#WeekArea");
			var btnindex = e.data.index;
			chooseWeek.find("button").each(function(index,e){
				if ($(this).hasClass("selected-btn")) {
					$(this).removeClass("selected-btn");
				}
			});
			$(this).addClass("selected-btn");
			WeekArea.find("table").each(function(index,e){
				if ($(this).css("display") != "none") {
					$(this).fadeOut(200,function(){
						WeekArea.find("table").each(function(index,e){
							if (btnindex == index) {
								$(this).fadeIn(200);
							}
						});
					});
				}
			});
		});
	});
	var chooseTime = $("#chooseTime");
	chooseTime.find("button").each(function(index,e){
		$(this).bind("click",{index:index},function(e){
			switch(e.data.index){
				case 0:
					if ($(this).hasClass("selected-btn")) {
						$(".morning").fadeOut(200);
						$(this).removeClass("selected-btn");
					}else{
						$(".morning").fadeIn(200);
						$(this).addClass("selected-btn");
					}
					break;
				case 1:
					if ($(this).hasClass("selected-btn")) {
						$(".afternoon").fadeOut(200);
						$(this).removeClass("selected-btn");
					}else{
						$(".afternoon").fadeIn(200);
						$(this).addClass("selected-btn");
					}
					break;
				case 2:
					if ($(this).hasClass("selected-btn")) {
						$(".evening").fadeOut(200);
						$(this).removeClass("selected-btn");
					}else{
						$(".evening").fadeIn(200);
						$(this).addClass("selected-btn");
					}
					break;
			}
		});
		
	});
})