$(document).ready(function () {
	var parameter = window.location.search.split("?")[1];
    treatid = parameter.split("=")[1];
    var D;
    var T;
    var remaintimes;
    $.ajax({
        type: "POST",
        async: false,
        data:{
        	treatid:treatid
        },
        url: "../../../pages/Main/Records/GetBasicTableInfo.ashx",
        success: function(data){
        	alert(data);
        	var info = $.parseJSON(data);
        	$("#Ways").text(info.Ways);
        	$("#appointnumber").text(info.appointnumber);
        	$("#total").text(info.total);
        	D = parseInt(info.Interal);
        	T = parseInt(info.Times);
        	remaintimes = parseInt(info.total) - parseInt(info.appointnumber);
        	//var firstDate = info.firstDate;
        }
    });
	var getdays = createDateTable(D, T, "2017-11-01", remaintimes, 360, 1320, 10);
	$.ajax({
		type: "POST",
        async: false,
        data:{
        	treatid:treatid,
        	times:getdays
        },
        url: "../../../pages/Main/Records/GetAccerWorkCondition.ashx",
        success: function(data){
        	alert(data);
        }
	});
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

window.onbeforeunload = function () {
    var tmplInfo = "SUCCESS";
    window.opener._doChromeWindowShowModalDialog(tmplInfo);
}

function createDateTable(D, T, startDate, times, startTime, endTime, singleInterval){
	var morningEnd = 720;
	var afternoonEnd = 1080;
	var currentTime = startTime;
	var TempDate = startDate;
	var DayTimeArea = $("#DayTimeArea");
	var WeekArea = $("#WeekArea");
	var chooseWeek = $("#chooseWeek");
	var DTA_tbody = "<tbody style='text-align:center;'>";
	var days = CalculateDays(D, T, startDate, times);
	var countdays = 0;
	var extradays = (days % 7 == 0) ? 7 : days % 7;
	while(countdays < days + 14 - extradays){
		var singlecurrentTime = startTime;
		var weeknum = Math.floor(countdays/7) + 1;
		if (countdays == 0) {
			var table = '<table class="table table-bordered"><thead><tr>';
			var button = '<button type="button" class="time-btn selected-btn" style="margin-right:5px;">'+ '第' + weeknum + '周' +'</button>';
		}else{
			var table = '<table class="table table-bordered" style="display:none;"><thead><tr>';
			var button = '<button type="button" class="time-btn" style="margin-right:5px;">'+ '第' + weeknum + '周' +'</button>';
		}
		
		chooseWeek.append(button);
		for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
			var currentDate = new Date(dateAdd(TempDate,i));
			var weekday = currentDate.getDay();
			var th = '<th>'+ currentDate.Format("MM/dd") + '('+ num2week(weekday) +')' +'</th>';
			table += th;
		}
		table += "</tr></thead><tbody>";
		var rownum = 0;
		while(singlecurrentTime < endTime){
			var start = singlecurrentTime;
			var end = singlecurrentTime + singleInterval;
			if (end <= morningEnd) {
				var tr = '<tr class="morning">';
				for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
					tr += "<td>"+ i +"</td>";
				}
				tr += "</tr>";
			}else if (end <= afternoonEnd) {
				var tr = '<tr class="afternoon">';
				for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
					tr += "<td>"+ i +"</td>";
				}
				tr += "</tr>";
			}else{
				var tr = '<tr class="evening">';
				for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
					tr += "<td>"+ i +"</td>";
				}
				tr += "</tr>";
			}
			table += tr;
			singlecurrentTime = end;
			rownum ++;
		}
		table += "</tbody>";
		countdays += 7;
		TempDate = dateAdd(TempDate,7);
		table += "</table>";
		WeekArea.append(table);
	}

	while(currentTime < endTime){
		var start = currentTime;
		var end = currentTime + singleInterval;
		if (end <= morningEnd) {
			var tr = '<tr class="morning"><td>'+ toTime(start) + '-'+ toTime(end) +'</td></tr>';
		}else if (end <= afternoonEnd) {
			var tr = '<tr class="afternoon"><td>'+ toTime(start) + '-'+ toTime(end) +'</td></tr>';
		}else{
			var tr = '<tr class="evening"><td>'+ toTime(start) + '-'+ toTime(end) +'</td></tr>';
		}
		DTA_tbody += tr;
		currentTime = end;
	}
	DTA_tbody += "</tbody>";
	DayTimeArea.find("table").append(DTA_tbody);
	return days + 14 - extradays;
}

function CalculateDays(D, T, startDate, times){
	var days = 0;
	var count = 0;
	var extra = (times % T == 0) ? 0 : 1;
	var actualTimes = 0;
	var today = startDate;
	while(actualTimes <= times){
		var isweek = new Date(today).getDay();
		if (isweek != 0 && isweek != 6) {
			actualTimes = actualTimes + T;
			today = dateAdd(today, D);
			days = count;
			count = count + D;
		}else if (isweek == 6) {
			today = dateAdd(today, 2);
			days = count;
			count = count + 2;
		}else{
			today = dateAdd(today, 1);
			days = count;
			count = count + 1;
		}
	}
	return days + extra;
}

function toTime(minute) {
    var time;
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    if (hour < 24) {
        time = hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
    }else{
        time = (hour - 24).toString() + ":" + (min < 10 ? "0" : "") + min.toString() + "(次日)";
    }
    return time;
}

function num2week(isweek){
	switch(isweek){
		case 0:
			var xq = "周日";
			break;
		case 1:
			var xq = "周一";
			break;
		case 2:
			var xq = "周二";
			break;
		case 3:
			var xq = "周三";
			break;
		case 4:
			var xq = "周四";
			break;
		case 5:
			var xq = "周五";
			break;
		case 6:
			var xq = "周六";
			break;
	}
	return xq;
}

function dateAdd(dd, n) {
    var strs = new Array();
    strs = dd.split("-");
    var y = strs[0];
    var m = strs[1];
    var d = strs[2];
    var t = new Date(y, m - 1, d);
    var str = t.getTime() + n * (1000 * 60 * 60 * 24);
    var newdate = new Date();
    newdate.setTime(str);
    var strYear = newdate.getFullYear();
    var strDay = newdate.getDate();
    if (strDay < 10) {
        strDay = "0" + strDay;
    }
    var strMonth = newdate.getMonth() + 1;
    if (strMonth < 10) {
        strMonth = "0" + strMonth;
    }
    var strdate = strYear+"-"+strMonth + "-" + strDay;
    return strdate;
}

Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}