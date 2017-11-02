$(document).ready(function () {
	var parameter = window.location.search.split("?")[1];
    treatid = parameter.split("=")[1];
    var session = getSession();
    var userID = session.userID;
    var D;
    var T;
    var remaintimes,total,appointnumber;
    var firstDate,firstTime;
    var ambegin,pmend,timelength,equipmentname,equipmentstate,TimeInteral;
    $.ajax({
        type: "POST",
        async: false,
        data:{
        	treatid:treatid
        },
        url: "../../../pages/Main/Records/GetBasicTableInfo.ashx",
        success: function(data){
        	//alert(data);
        	var info = $.parseJSON(data);
        	$("#Ways").text(info.Ways);
        	$("#appointnumber").text(info.appointnumber);
        	$("#total").text(info.total);
        	$("#equipmentname").text(info.equipmentname);
        	total = info.total;
        	TimeInteral = info.TimeInteral;
        	D = parseInt(info.Interal);
        	T = parseInt(info.Times);
        	appointnumber = parseInt(info.appointnumber);
        	remaintimes = parseInt(info.total) - parseInt(info.appointnumber);
        	firstDate = new Date(info.begindate);
        	firstTime = info.begin;
        	$("#firstdate").text(firstDate.Format("yyyy-MM-dd") + " " +toTime(firstTime));
        	ambegin = parseInt(info.ambegin);
        	pmend = parseInt(info.pmend);
        	timelength = parseInt(info.timelength);
        }
    });
	var getdays = createDateTable(D, T, firstDate.Format("yyyy-MM-dd"), remaintimes, ambegin, pmend, timelength);
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
	$.ajax({
		type: "POST",
        async: false,
        data:{
        	treatid:treatid,
        	times:getdays
        },
        url: "../../../pages/Main/Records/GetAccerWorkCondition.ashx",
        success: function(data){
        	//alert(data);
        	var info = $.parseJSON(data);
        	if (info.appointinfo) {
        		for (var i = 0; i < info.appointinfo.length; i++) {
        			var daysdiff = GetDateDiff(firstDate.Format("yyyy-MM-dd"),new Date(info.appointinfo[i].Date).Format("yyyy-MM-dd"));
        			var tablenum = Math.floor(daysdiff / 7) + 1;
        			var col = daysdiff % 7;
        			var row = (info.appointinfo[i].Begin - ambegin) / timelength;
        			var tdid = tablenum.toString() + row.toString() + col.toString();
        			$("#"+ tdid).addClass("selected-td");
        		}
        	}
			var firstrow = (firstTime - ambegin) / timelength;
			var firsttdid = "1" + firstrow.toString() + "0";
			$("#"+ firsttdid).text("首次");
			$("#"+ firsttdid).addClass("self-selected");
			var trclass = $("#"+ firsttdid).parent().attr("class");
			switch(trclass){
				case "afternoon":
					$("#chooseTime").find("button").each(function(index,e){
						if (index == 1) {
							$(this).click();
						}else if(index == 0){
							$(this).click();
						}
					});
					break;
				case "evening":
					$("#chooseTime").find("button").each(function(index,e){
						if (index == 2) {
							$(this).click();
						}else if(index == 0){
							$(this).click();
						}
					});
					break;
			}
        }
	});

	BatchAppoint(remaintimes,D,T,timelength,TimeInteral,appointnumber);

	$("#chooseWay").find("button").each(function(index,e){
		$(this).bind("click",{index:index,total:total,remaintimes:remaintimes,T:T,D:D,timelength:timelength,TimeInteral:TimeInteral,appointnumber:appointnumber},function(e){
			if (e.data.index == 0) {
				$(this).removeClass("selected-btn").addClass("selected-btn");
				UnlimitedAppoint(e.data.remaintimes,e.data.appointnumber);
				if ($(this).next().hasClass("selected-btn")) {
					$(this).next().removeClass("selected-btn");
				}
			}else if (e.data.index == 1) {
				CancelAppoint(e.data.appointnumber);
				$("#selectedrownum").val("0");
				var selectednum = CalculateTimes();
				var num = e.data.remaintimes - selectednum;
				$(this).removeClass("selected-btn").addClass("selected-btn");
				BatchAppoint(num,e.data.D,e.data.T,e.data.timelength,e.data.TimeInteral,e.data.appointnumber);
				if ($(this).prev().hasClass("selected-btn")) {
					$(this).prev().removeClass("selected-btn");
				}
			}
		});
	});
	$("#removeAppointment").bind("click",function(){
		CancelAppoint(appointnumber);
		$("#chooseWay").find("button").each(function(index,e){
			if (index == 0 && $(this).hasClass("selected-btn")) {
				UnlimitedAppoint(remaintimes,appointnumber);
			}
			if (index == 1 && $(this).hasClass("selected-btn")) {
				$("#selectedrownum").val("0");
				var selectednum = CalculateTimes();
				var num = remaintimes - selectednum;
				BatchAppoint(num,D,T,timelength,TimeInteral,appointnumber);
			}
		});
	});

	$("#confirm").bind("click",function(){
		var exist = CalculateTimes();
		if (exist == remaintimes) {
			var appointdata = findAllAppointData(ambegin,timelength,firstDate.Format("yyyy-MM-dd"));
			//alert(appointdata.toString());
			$.ajax({
				type: "POST",
		        async: false,
		        data:{
		        	userID:userID,
		        	treatid:treatid,
		        	isdouble:isdouble,
		        	appointdata:appointdata
		        },
		        url: "../../../pages/Main/Records/InsertAllAppoint.ashx",
		        success:function(){
		        	window.onbeforeunload = function(){
		        		var tmplInfo = "预约成功！";
		        		window.opener._doChromeWindowShowModalDialog(tmplInfo);
		        	}
		        	window.close();
		        }
			});
		}else{
			alert("还未预约完！");
		}
		
	});

	/*$("#avoidway").bind("change",function(){
		$("#removeAppointment").click();
	});*/
})

/*window.onbeforeunload = function () {
	var tmplInfo = "预约成功！";
    window.opener._doChromeWindowShowModalDialog(tmplInfo);
}*/

function findAllAppointData(ambegin,timelength,firstDate){
	var WeekArea = $("#WeekArea");
	var data = "[";
	var count = 0;
	WeekArea.find("table").each(function(index,e){
		$(this).find("td").each(function(){
			if ($(this).find("i").length > 0) {
				var tdid = $(this).attr("id");
				var rownum = parseInt(tdid.substring(1,tdid.length-1));
				var tablenum = parseInt(tdid.substring(0,1));
				var colnum = parseInt(tdid.substring(tdid.length-1,tdid.length));
				var date = dateAdd(firstDate,(tablenum - 1) * 7 + colnum);
				isdouble = 0;
				var begin = ambegin + rownum * timelength;
				var end = begin + (isdouble + 1) * timelength;
				data += '{"Date":"' + date + '","Begin":"' + begin + '","End":"' + end + '"},';
			}
			return count;
		});
	});
	data = data.substring(0,data.length-1) + ']';
	return data;
}

function BatchAppoint(num,D,T,timelength,TimeInteral,appointnumber){
	CancelClick();
	var table = $("#WeekArea").find("table");
	table.find("td").each(function(index,e){
		$(this).bind("click",function(){
			if (!($(this).hasClass("selected-td"))) {
				var tdid = $(this).attr("id");
				var rownum = parseInt(tdid.substring(1,tdid.length-1));
				var tablenum = parseInt(tdid.substring(0,1));
				var colnum = parseInt(tdid.substring(tdid.length-1,tdid.length));
				var rowTimes = new Array(T);
				var aver = Math.floor(num/T);
				var count = aver;
				var extracount = 0;
				var extra = num - aver * T;
				var selectedrownum = parseInt($("#selectedrownum").val());
				rowTimes[0] = aver;
				for (var i = 1; i < T; i++) {
					if (extracount < extra) {
						rowTimes[i] = aver + 1;
						extracount ++;
					}else{
						rowTimes[i] = aver;
					}
				}
				if ($(this).find("i").length == 0) {
					RowBatchAppoint(this,rownum,colnum,num,rowTimes[selectedrownum],D,timelength,TimeInteral,appointnumber);
				}
			}
		});
	});
}

function RowBatchAppoint(e,rownum,colnum,numTotal,num,D,timelength,TimeInteral,appointnumber){
	//alert(rownum + "," + colnum + "," + numTotal + "," + D);
	var exist = CalculateTimes();
	var avoidway = $("#avoidway").val();
	//alert(avoidway);
	var TempI;
	if (exist < numTotal) {
		if (CheckTimeInterva(rownum,timelength,TimeInteral)) {
			var count = 0;
			var TempD = D;
			for (var i = colnum; i < 7 && count < num; i = i + TempD) {
				var tdid = "1" + rownum.toString() + i.toString();
				if (!($("#" + tdid).hasClass("selected-td"))) {
					if(!($("#" + tdid).hasClass("weekend"))){
						$("#" + tdid).append("<i class='fa fa-fw fa-check'></i>");
						count ++;
						TempD = D;
					}else{
						var tdidnext = "1" + rownum.toString() + (i + 1).toString();
						if ($("#" + tdidnext).hasClass("weekend")) {
							TempD = 2;
						}else{
							TempD = 1;
						}
					}
				}else{
					switch(avoidway){
						case '1':
							alert("存在阻挡！");
							RemoveRow(rownum);
							return false;
						case '2':
							var flag = PartialAvoid(1,rownum,i,6);
							if (flag) {
								count ++;
							}else{
								alert("局部存在阻挡！");
								RemoveRow(rownum);
								return false;
							}
							break;
						default:
							var flag = UnconditionalAvoid(1,rownum,i);
							if (flag) {
								count ++;
							}else{
								alert("存在阻挡！");
								RemoveRow(rownum);
								return false;
							}
					}
				}
				TempI =  i + TempD - 7;
			}
			unbindSelectedClick();
			updateTimes(appointnumber);
			var currentTable = $(e);
			var tablenum = 2;
			while($(e).parents('.table').next().length > 0 && count < num){
				currentTable = currentTable.next();
				var TempD = D;
				for (var i = TempI; i < 7 && count < num; i = i + TempD) {
					var tdid = tablenum.toString() + rownum.toString() + i.toString();
					if (!($("#" + tdid).hasClass("selected-td"))) {
						if(!($("#" + tdid).hasClass("weekend"))){
							$("#" + tdid).append("<i class='fa fa-fw fa-check'></i>");
							count ++;
							TempD = D;
						}else{
							var tdidnext = "1" + rownum.toString() + (i + 1).toString();
							if ($("#" + tdidnext).hasClass("weekend")) {
								TempD = 2;
							}else{
								TempD = 1;
							}
						}
						$("#" + tdid).unbind("click");
					}else{
						switch(avoidway){
							case '1':
								alert("存在阻挡！");
								RemoveRow(rownum);
								return false;
							case '2':
								var flag = PartialAvoid(1,rownum,i,6);
								if (flag) {
									count ++;
								}else{
									alert("局部存在阻挡！");
									RemoveRow(rownum);
									return false;
								}
								break;
							default:
								var flag = UnconditionalAvoid(tablenum,rownum,i);
								if (flag) {
									count ++;
								}else{
									alert("存在阻挡！");
									RemoveRow(rownum);
									return false;
								}
						}
					}
					TempI = i + TempD - 7;
				}
				tablenum ++;
			}
			unbindSelectedClick();
			updateTimes(appointnumber);
			var selectedrownum = parseInt($("#selectedrownum").val());
			$("#selectedrownum").val(selectedrownum + 1);
		}
	}else{
		alert("已预约完！");
	}
	return true;
}

function updateTimes(appointnumber){
	var exist = CalculateTimes();
	$("#appointnumber").text(exist + appointnumber);
}

function unbindSelectedClick(){
	var WeekArea = $("#WeekArea");
	WeekArea.find("table").each(function(index,e){
		$(this).find("td").each(function(){
			if ($(this).find("i").length > 0) {
				$(this).unbind("click");
			}
		});
	});
}

function PartialAvoid(tablenum,rownum,colnum,range){
	for (var i = 1; i <= range; i++) {
		var tdid1 = tablenum.toString() + (rownum - i).toString() + colnum.toString();
		var tdid2 = tablenum.toString() + (rownum + i).toString() + colnum.toString();
		if ($("#" + tdid1).length > 0 && !($("#" + tdid1).hasClass("selected-td"))) {
			$("#" + tdid1).append("<i class='fa fa-fw fa-check'></i>");
			return true;
		}else if ($("#" + tdid2).length > 0 && !($("#" + tdid2).hasClass("selected-td"))) {
			$("#" + tdid2).append("<i class='fa fa-fw fa-check'></i>");
			return true;
		}
	}
	return false;
}

function UnconditionalAvoid(tablenum,rownum,colnum){
	var i = 1;
	var tdid1 = tablenum.toString() + (rownum - 1).toString() + colnum.toString();
	var tdid2 = tablenum.toString() + (rownum + 1).toString() + colnum.toString();
	while($("#" + tdid1).length > 0 || $("#" + tdid2).length > 0) {
		if ($("#" + tdid1).length > 0 && !($("#" + tdid1).hasClass("selected-td"))) {
			$("#" + tdid1).append("<i class='fa fa-fw fa-check'></i>");
			return true;
		}else if ($("#" + tdid2).length > 0 && !($("#" + tdid2).hasClass("selected-td"))) {
			$("#" + tdid2).append("<i class='fa fa-fw fa-check'></i>");
			return true;
		}
		i ++;
		tdid1 = tablenum.toString() + (rownum - i).toString() + colnum.toString();
		tdid2 = tablenum.toString() + (rownum + i).toString() + colnum.toString();
	}
	return false;
}

function RemoveRow(rownum){
	$("#WeekArea").find("table").each(function(index,e){
		for (var i = 0; i < 7; i++) {
			var tablenum = index + 1;
			var tdid = tablenum.toString() + rownum.toString() + i.toString();
			if ($("#" + tdid).find("i").length > 0) {
				$("#" + tdid).html("");
			}
		}
	});
}

function UnlimitedAppoint(num,appointnumber){
	CancelClick();
	var table = $("#WeekArea").find("table");
	table.find("td").each(function(index,e){
		$(this).bind("click",function(){
			if (!($(this).hasClass("selected-td"))) {
				var currentNum = CalculateTimes();
				if ($(this).find("i").length == 0) {
					if (currentNum < num) {
						$(this).append("<i class='fa fa-fw fa-check'></i>");
					}else{
						alert("已预约完！");
					}
				}else{
					$(this).find("i")[0].remove();
				}
			}
			updateTimes(appointnumber);
		});
	});
}

function CheckTimeInterva(row,timelength,TimeInteral){
	var WeekArea = $("#WeekArea");
	var minInterval = TimeInteral * 60;
	WeekArea.find("table").each(function(index,e){
		$(this).find("td").each(function(){
			if ($(this).find("i").length > 0 || $(this).hasClass("self-selected")) {
				var tdid = $(this).attr("id");
				var rownum = parseInt(tdid.substring(1,tdid.length-1));
				if (minInterval > timelength * Math.abs(rownum - row) && (rownum - row) != 0) {
					minInterval = timelength * Math.abs(rownum - row);
				}
			}
			return minInterval;
		});
		return minInterval;
	});
	if (minInterval >= TimeInteral * 60) {
		return true;
	}else{
		alert("请注意时间间隔！");
		return false;
	}
}

function CancelClick(){
	var WeekArea = $("#WeekArea");
	WeekArea.find("table").each(function(index,e){
		$(this).find("td").each(function(){
			$(this).unbind("click");
		});
	});
}

function CancelAppoint(appointnumber){
	var WeekArea = $("#WeekArea");
	WeekArea.find("table").each(function(index,e){
		$(this).find("td").each(function(){
			if ($(this).find("i").length > 0) {
				$(this).find("i")[0].remove();
			}
		});
	});
	updateTimes(appointnumber);
}

function adjustRemain(){

}

function CalculateTimes(){
	var WeekArea = $("#WeekArea");
	var count = 0;
	WeekArea.find("table").each(function(index,e){
		$(this).find("td").each(function(){
			if ($(this).find("i").length > 0) {
				count ++;
			}
			return count;
		});
		return count;
	});
	return count;
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
		var w1,w0;
		for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
			var currentDate = new Date(dateAdd(TempDate,i));
			var weekday = currentDate.getDay();
			if (weekday == 6) {
				w0 = i;
			}
			if (weekday == 0) {
				w1 = i;
			}
			var th = '<th>'+ currentDate.Format("MM/dd") + '('+ num2week(weekday) +')' +'</th>';
			table += th;
		}
		table += "</tr></thead><tbody style='text-align:center;'>";
		var rownum = 0;
		while(singlecurrentTime < endTime){
			var start = singlecurrentTime;
			var end = singlecurrentTime + singleInterval;
			if (end <= morningEnd) {
				var tr = '<tr class="morning">';
				for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
					if (i == w0 || i == w1) {
						tr += "<td id='"+ weeknum + rownum + i +"' class='td-single weekend'></td>";
					}else{
						tr += "<td id='"+ weeknum + rownum + i +"' class='td-single'></td>";
					}
				}
				tr += "</tr>";
			}else if (end <= afternoonEnd) {
				var tr = '<tr class="afternoon">';
				for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
					if (i == w0 || i == w1) {
						tr += "<td id='"+ weeknum + rownum + i +"' class='td-single weekend'></td>";
					}else{
						tr += "<td id='"+ weeknum + rownum + i +"' class='td-single'></td>";
					}
				}
				tr += "</tr>";
			}else{
				var tr = '<tr class="evening">';
				for (var i = 0; i < 7 && countdays < days + 14 - extradays; i++) {
					if (i == w0 || i == w1) {
						tr += "<td id='"+ weeknum + rownum + i +"' class='td-single weekend'></td>";
					}else{
						tr += "<td id='"+ weeknum + rownum + i +"' class='td-single'></td>";
					}
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

function GetDateDiff(startDate, endDate) {
    var startTime = new Date(Date.parse(startDate.replace(/-/g, "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g, "/"))).getTime();
    var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
    return dates;
}

function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "../../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}
