var currentID = 0;

$(document).ready(function () {
	var session = getSession();
	adjustPage();
	//chooseEquipment(session);
	patientView(session);
	
	$("#changeEquipment").unbind("click").bind("click", function () {
		var session = getSession();
        chooseEquipment(session);
    });
	$("#main-content").show();
	$("#appointment-content").show();
	//$("#appointResult").modal({ backdrop: 'static' });
})

function adjustPage() {
	$("#patient-content").height($(document).height() - 151);
    $("#patient-table-content").height($(document).height() - 190);
	$("#appointment-content").height($(document).height() - 101);
}

function patientView(session) {
	if (session.role == "医师" || session.role == "治疗技师") {
		var alldate;
        if (session.equipmentID == "0") {
            chooseEquipment(session);
        }else {
            var data = {
            	equipid:session.equipmentID
            };
            var patientURL = "../../pages/Main/getPatientInfoNew.ashx";
            var returnData = postData(patientURL, data, false);
            alldate = $.parseJSON(returnData);
            Paging(alldate.patientinfo, alldate.worktime);
            drawAppointTable(alldate.basicinfo, alldate.doctortime, alldate.worktime);
            $("#chosenEquipment").html(session.equipmentName);
        }

        $("#getSelectedPatient").unbind("click").click(function () {
            var equipmentID = $("#equipment").val();
            var equipmentName = $("#equipment option:selected").html();
            if (!equipmentID) {
                alert("设备不能为空！");
                return false;
            }
            $("#chosenEquipment").html(equipmentName);
            var dataequip = {
            	equipid: $("#equipment").val()
            };
            var patientURL = "../../pages/Main/getPatientInfoNew.ashx";
            var returnData = postData(patientURL, dataequip, false);
            alldate = $.parseJSON(returnData);
            Paging(alldate.patientinfo, alldate.worktime);
            drawAppointTable(alldate.basicinfo, alldate.doctortime, alldate.worktime);
            var datasession = {
                id: $("#equipment").val(),
                name: $("#equipment option:selected").html()
            };
            var setEquipmentURL = "../../pages/Main/Records/setEquipment.ashx";
            postData(setEquipmentURL, datasession, false);
        });

        $("#patient-search").bind('input propertychange', function (e) {
            var Searchedpatients = Search($("#patient-search").val(), alldate.patientinfo);
            Paging(Searchedpatients, alldate.worktime);
        });
    }
}

function getSession() {
    var sessionurl = "../../pages/Main/Records/getSession.ashx";
    var Session = getData(sessionurl, false);
    return Session;
}

function Paging(patients, worktime) {
    if (patients != "") {
        tableheight = $("#patient-content").height() - 160;
        var table = $("#patient-table");
        table.html("");
        $("#patient_info").text("一共" + patients.length + "条记录");
        var Name, Gender, patientid, Age, doctor, groupname;
        var thead = '<thead><tr><th>患者姓名</th><th>性别</th><th>年龄</th><th>主治医生</th><th>医疗组</th></tr></thead>';
        table.append(thead);
        var tbody = '<tbody>';
        for (var i = 0; i < patients.length; i++) {
            Name = patients[i].name;
            Gender = patients[i].Gender;
            patientid = patients[i].patientid;
            doctor = patients[i].doctor;
            Age = patients[i].Age;
            groupname = patients[i].groupname;
            var tr = '<tr id="'+ patientid +'" class="pointer"><td>'+ Name +'</td><td>'+ Gender +'</td>'+
            		 '<td>'+ Age +'</td><td>'+ doctor +'</td><td>'+ groupname +'</td></tr>';
            tbody += tr;
        }
        tbody += '</tbody>';
        table.append(tbody);
        RecordAddClick(worktime);
    } else {
        var table = $("#patient-table");
        table.html("");
        var thead = '<thead><tr><th>患者姓名</th><th>性别</th><th>年龄</th><th>主治医生</th><th>医疗组</th></tr></thead>';
        table.append(thead);
        var tbody = '<tbody><tr><td colspan="5" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
        table.append(tbody);
        $("#patient_info").text("共0条记录");
    }
    Recover("Search");
}

function chooseEquipment(session) {
	$("#chooseMachine").modal({ backdrop: 'static' });
    $("#equipmentType").html("");
    switch (session.role) {
        case "模拟技师":
            var options = '<option value="体位固定">体位固定</option><option value="模拟定位">CT模拟</option><option value="复位模拟">复位验证</option>';
            $("#equipmentType").append(options);
            break;
        case "治疗技师":
            var options = '<option value="加速器">加速器治疗</option>';
            $("#equipmentType").append(options);
            break;
        default:
        	var options = '<option value="加速器">加速器治疗</option>';
            $("#equipmentType").append(options);
    }
    var EquipmentURL = "../../pages/Main/getEquipIDAndName.ashx";
    var data = {
    	task: $("#equipmentType").val()
    };
    var returnData = postData(EquipmentURL, data, false);
    var equipInfo = $.parseJSON(returnData);
    var equipment = $("#equipment");
    equipment.html("");
    if (equipInfo) {
    	for (var i = 0; i < equipInfo.machine.length; i++) {
    		var equipmentOption = '<option value="'+ equipInfo.machine[i].ID +'">'+ equipInfo.machine[i].Name +'</option>';
    		equipment.append(equipmentOption);
    	}
    }
}

function Search(str, patients) {
    var Searchedpatient = new Array();
    var count = 0;
    for (var i = 0; i < patients.length; i++) {
        Name = patients[i].name;
        Gender = patients[i].Gender;
        patientid = patients[i].patientid;
        doctor = patients[i].doctor;
        Age = patients[i].Age;
        groupname = patients[i].groupname;
        if (Name.search(str) >= 0 || Gender.search(str) >= 0 || doctor.search(str) >= 0 || Age.search(str) >= 0 || groupname.search(str) >= 0) {
            var singlepatient = {name: patients[i].name,Gender:patients[i].Gender,patientid:patients[i].patientid, doctor:patients[i].doctor, Age:patients[i].Age, groupname:patients[i].groupname, Radiotherapy_ID: patients[i].Radiotherapy_ID};
            Searchedpatient[count++] = singlepatient;
        }
    }
    return Searchedpatient;
}

function drawPlanInfoTable(planinfo, timeduan) {
	if (planinfo) {
		var time = "默认时间段（";
		if (timeduan == "") {
			time = time + "无";
		}else{
			for (var i = 0; i < timeduan.length; i++) {
				var B = timeduan[i].begin;
				var E = timeduan[i].end;
				if (i == 0) {
					time = time + Num2Time(B, E);
				}else {
					time = time + " , " + Num2Time(B, E);
				}
			}
		}
		time += "）";
		$("#timeduan").html(time);
		var table = $("#PlanInfo");
		table.find("tbody").html("");
		var tbody = '<tbody>';
		for (var i = 0; i < planinfo.length; i++) {
			var firstday = planinfo[i].firstday == "" ? "无" : planinfo[i].firstday.replace(/\//g, "-") + " , " + Num2Time(planinfo[i].firstbegin, planinfo[i].firstend);
			var checked = planinfo[i].rest == "0" ? "disabled" : "checked";
			var tr = '<tr id="'+ planinfo[i].chid +'"><td class="hide">'+ planinfo[i].Interal +'</td><td class="hide">'+ planinfo[i].Times +
					 '</td><td>'+ planinfo[i].DesignName +'</td><td>'+ planinfo[i].Treatmentdescribe +
					 '</td><td>'+ planinfo[i].Totalnumber +'</td><td>'+ planinfo[i].rest + '</td><td>'+
					 planinfo[i].Ways +'</td><td data-date="'+ planinfo[i].firstday +'">'+ firstday +
					 '</td><td class="choose-appoint"><input type="checkbox" class="flat-red" '+ checked +'></td></tr>';
			tbody += tr;
		}
		table.append(tbody);
		$('input[type="checkbox"].flat-red').iCheck({
	        checkboxClass: 'icheckbox_flat-blue',
      		radioClass: 'iradio_flat-blue'
	    });
	    $(".choose-appoint").find("ins").bind("click", function(){
	    	$("#confirm").attr("disabled","disabled");
	    	$(".weekday").removeClass("chosen");
	    	$("#AppointTime").find("td").removeClass("occupied chosen");
	    });
	}
}

function drawAppointTable(basicinfo, doctortime, worktime) {
	drawDateTable(worktime);
	drawTimeTable(basicinfo, doctortime);
	
}

function drawDateTable(worktime) {
	var table = $("#AppointDate");
	table.html("");
	var thead = '<thead><tr>';
	var tbody = '<tbody><tr>';

	var beginDate = new Date();
	var weekday=new Array("日","一","二","三","四","五","六");
	for (var i = 0; i < 7; i++) {
		th = '<th>'+ weekday[beginDate.getDay()] +'</th>';
		var tdid = beginDate.Format("yyyy-MM-dd");
		//var tdclass = (beginDate.getDay() == 0 || beginDate.getDay() == 6) ? "weekend" : "weekday";
		var tdclass = "weekday";
		var isworkday = "";
		for (var j = 0; j < worktime.length; j++) {
			var tempdate = new Date(worktime[j]);
			if (tempdate.getFullYear() == beginDate.getFullYear() && tempdate.getMonth() == beginDate.getMonth() && tempdate.getDate() == beginDate.getDate()) {
				isworkday ="(假)";
				tdclass = "weekend";
				break;
			}
		}
		td = '<td data-date="'+ tdid +'" class="'+ tdclass +'"><span class="appoint-date pointer">'+ (beginDate.getMonth() + 1) + '月' + beginDate.getDate() + '日' + isworkday +'</span></td>';
		thead += th;
		tbody += td;
		var nextDate = beginDate.setDate(beginDate.getDate() + 1);
		beginDate = new Date(nextDate);
	}
	thead += '</tr></thead>';
	tbody += '</tr></tbody>';
	table.append(thead);
	table.append(tbody);
}

function drawTimeTable(basicinfo, doctortime) {
	var table = $("#AppointTime");
	table.html("");
	var tbody = '<tbody>';
	var TimePoint = new Array(4);
	TimePoint[0] = parseInt(basicinfo.BeginTimeAM);
	var _TimeLength = parseInt(basicinfo.Timelength);
	TimePoint[3] = parseInt(basicinfo.EndTimeTPM);
	TimePoint[1] = 720;
	TimePoint[2] = 1080;
	var rows = new Array(3);
	var TimeName = new Array("上午","下午","晚上");
	for (var i = 0; i < TimePoint.length - 1; i++) {
		rows[i] = TimePoint[i + 1] > TimePoint[i] ? Math.ceil((TimePoint[i + 1] - TimePoint[i]) / (_TimeLength * 6)) : 0;
	}
	for (var i = 0; i < rows.length; i++) {
		var flag = true;
		if (rows[i] > 0) {
			var temptime = TimePoint[i];
			for (var j = 0; j < rows[i]; j++) {
				var tr = '<tr>';
				for (var k = 0; k < 6; k++) {
					if (j == 0 && flag) {
						tr += '<td rowspan='+ rows[i] +'>'+ TimeName[i] +'</td>';
						flag = false;
					}
					if (temptime < TimePoint[i + 1]) {
						var tdclass = "";
						for (var m = 0; m < doctortime.length; m++) {
							if (temptime >= doctortime[m].begin && (temptime + _TimeLength) <= doctortime[m].end) {
								tdclass = "doctortime";
							}
						}
						var td = '<td id="'+ temptime +'" class="'+ tdclass +'" data-begin="'+ temptime +'" data-end="'+ (temptime + _TimeLength) +'"><span class="pointer">'+ Num2Time(temptime, temptime + _TimeLength) +'</span></td>';
					}else {
						var td = '<td></td>';
					}
					tr += td;
					temptime += _TimeLength;
				}
				tr += '</tr>';
				tbody += tr;
			}
		}
	}
	table.append(tbody);
}

function RecordAddClick(worktime) {
	var table = $("#patient-table");
	var tbody = table.find("tbody");
	var session = getSession();
	tbody.find("tr").each(function(){
		$(this).unbind("click").bind("click",{worktime:worktime}, function(e){
			$(this).parent().find("tr").removeClass("chosen");
			$(this).addClass("chosen");
			var patientid = $(this).attr("id");
			currentID = patientid;
			$("#patient-name").html($(this).find("td").eq(0).html());
			$("#doctor").html($(this).find("td").eq(3).html());
			$("#group").html($(this).find("td").eq(4).html());
			$("#patientid").val($(this).attr("id"));
			var data = {
			    patientid:patientid,
			    equipid:session.equipmentID
			};
			var getPlanURL = '../../pages/Main/getPInfoAndEquipAppInfo.ashx';
			var returnData = postData(getPlanURL, data, false);
			var planinfo = $.parseJSON(returnData);
			drawPlanInfoTable(planinfo.patientinfo, planinfo.timeduan);
			var datetable = $("#AppointDate");
			var timetable = $("#AppointTime");
			timetable.find("td").removeClass("occupied chosen");
			$(".weekday").removeClass("chosen");
			DateAddClick(planinfo.patientinfo,e.data.worktime);
			$("#confirm").unbind("click").bind("click", function(){
				var session = getSession();
				var userid = session.userID;
				var equipmentid = session.equipmentID;
				var patientid = $("#patientid").val();
				var begindate = $("#AppointDate").find(".chosen").attr("data-date");
				var chidgroup = "[";
				$("#PlanInfo").find(".choose-appoint").each(function(){
					if ($(this).find("div").hasClass("checked")) {
						var planid = $(this).parent().attr("id");
						chidgroup += planid + ",";
					}
				});
				var l = chidgroup.length;
			    if (l > 1) {
			        chidgroup = chidgroup.substring(0,chidgroup.length-1);
			    }else{
			        chidgroup += "\"\"";
			    }
			    chidgroup += ']';
			    var appointrange = "[";
			    $("#AppointTime").find(".chosen").each(function(){
					var begin = $(this).attr("data-begin");
					var end = $(this).attr("data-end");
					appointrange += '{"begin":'+ begin +',"end":'+ end +'},';
				});
				var l = appointrange.length;
			    if (l > 1) {
			        appointrange = appointrange.substring(0,appointrange.length-1);
			    }else{
			        appointrange += "\"\"";
			    }
			    appointrange += ']';
			    var appointstr = '{"begindate":"'+ begindate +'","patientid":"'+ patientid +'","chidgroup":'+ chidgroup +',"userid":"'+ userid +'","equipmentid":"'+ equipmentid +'","appointrange":'+ appointrange +'}';
			    var appointdata = {
			    	data:appointstr,
			    	type:"0"
			    };
			    var postURL = '../../pages/Main/InsertAllappointment.ashx';
			    var returnData = postData(postURL, appointdata, false);
			    if (returnData != "failure") {
			    	$("#appointResult").modal({ backdrop: 'static' });
			    	var info = $.parseJSON(returnData);
			    	var appointments = info.backinfo;
			    	var table = $("#AppointRecords");
			    	table.html("");
			    	table.next().find("ul").html("");
			    	var thead = '<thead><tr><th>序号</th><th>日期</th><th>时间</th><th>计划</th></tr></thead>';
			    	var tbody = '<tbody>';
			    	for (var i = 0; i < appointments.length; i++) {
			    		var childplan = "";
			    		var pagenum = 10;
			    		var page = parseInt(i/pagenum) + 1;
			    		for (var j = 0; j < appointments[i].chidinfogroup.length; j++) {
			    			if (j == 0) {
			    				childplan += appointments[i].chidinfogroup[j].designname;
			    			}else {
			    				childplan = childplan + '、' + appointments[i].chidinfogroup[j].designname;
			    			}
			    		}
			    		var date = new Date(appointments[i].date);
			    		var trclass = page == 1 ? "showpage " : "";
			    		var tr = '<tr class="'+ trclass +'page_'+ page +' pages"><td>'+ (i + 1) +'</td><td>'+ date.Format("yyyy-MM-dd") +'</td><td>'+ Num2Time(appointments[i].begin, appointments[i].end) +'</td><td>'+ childplan +'</td></tr>';
			    		tbody += tr;
			    	}
			    	tbody += '</tbody>';
			    	table.append(thead);
			    	table.append(tbody);
			    	if (page > 1) {
			    		var lis = '';
				    	for (var i = 1; i <= page; i++) {
				    		var liclass = i == 1 ? "active page_num" : "page_num";
				    		var li = '<li class="'+ liclass +'"><a href="javascript:;">'+ i +'</a></li>';
				    		lis += li;
				    	}
				    	table.next().find("ul").append(lis);
				    	$(".page_num").each(function(){
				    		$(this).unbind("click").bind("click",function(){
				    			$(".page_num").removeClass("active");
				    			$(this).addClass("active");
				    			var page = $(this).find("a").html();
					    		$(".pages").each(function(){
					    			if ($(this).hasClass("page_" + page)) {
					    				$(this).addClass("showpage");
					    			}else{
					    				$(this).removeClass("showpage");
					    			}
					    		});
				    		});
				    	});
			    	}
			    	$("#DeleteAppoint").unbind("click").bind("click", {appointarray:info.appointarray,treatmentrecordarray:info.treatmentrecordarray}, function(e){
			    		var data = {
			    			type:"3",
			    			appointarray:e.data.appointarray,
			    			treatmentrecordarray:e.data.treatmentrecordarray
			    		};
			    		var DeleteURL = '../../pages/Main/InsertAllappointment.ashx';
			    		var returnData = postData(DeleteURL, data, false);
			    		if (returnData == "success") {
			    			alert("删除成功！");
			    		}
			    		Recover("click");
			    		$("#AppointTime").find("td").unbind("click");
			    		$("#confirm").attr("disabled","disabled");
			    	});
			    	$("#SureAppoint").unbind("click").bind("click", function(){
			    		Recover("click");
			    	});
			    }else{
			    	alert("预约失败！");
			    }
			    Recover("click");
			});
		});
	});
}

function DateAddClick(planinfo, worktime) {
	var dateTable = $("#AppointDate");
	var tbody = dateTable.find("tbody");
	tbody.find("td").each(function(){
		$(this).unbind("click").bind("click", {planinfo:planinfo,worktime:worktime}, function(e){
			if (!($(this).hasClass("weekend"))) {
				$(this).parent().find("td").removeClass("chosen");
				$(this).addClass("chosen");
				var beginDate = $(this).attr("data-date");
				var endDate = CalculateEndDate(beginDate, e.data.planinfo, e.data.worktime);
				var currentDay = $(this).attr("data-date");
				var session = getSession();
				var equipmentid = session.equipmentID;
				var data = {
					begindate:beginDate,
					enddate:endDate,
					equipmentid,equipmentid
				};
				var getAppointsURL = '../../pages/Main/getAllappointInfoFromDate.ashx';
				var returnData = postData(getAppointsURL, data, false);
				var B_E_Appointments = $.parseJSON(returnData);
				TimeAddClick(B_E_Appointments.appointinfo, currentDay);
			}
		});
	});
}

function TimeAddClick(appointments, currentDay) {
	var table = $("#AppointTime");
	var plantable = $("#PlanInfo");
	var patientid = $("#patientid").val();
	var maxTimes = 0;
	$("#confirm").attr("disabled","disabled");
	plantable.find("tbody").find("tr").each(function(){
		if ($(this).find("td").eq(8).find("div").hasClass("checked")) {
			var currentTimes = parseInt($(this).find("td").eq(1).html());
			maxTimes = maxTimes < currentTimes ? currentTimes : maxTimes;
			return maxTimes;
		}
	});
	table.find("td").removeClass("occupied chosen");
	table.find("td").unbind("click");
	var today = new Date();
	var time = today.getHours() * 60 + today.getMinutes();
	if (today.Format("yyyy-MM-dd") == currentDay) {
		table.find("td").each(function(){
			if (parseInt($(this).attr("data-begin")) < time) {
				$(this).addClass("occupied");
			}
		});
	}
	for (var i = 0; i < appointments.length; i++) {
		if (appointments[i].Patient_ID != patientid) {
			var timetdid = appointments[i].Begin;
			if (!($("#" + timetdid).addClass("occupied"))) {
				$("#" + timetdid).addClass("occupied");
			}
		}
	}
	table.find("td").each(function(){
		if (!($(this).hasClass("occupied")) && !($(this).hasClass("doctortime"))) {
			$(this).unbind("click").bind("click", {maxTimes:maxTimes}, function(e){
				var count = $(this).parent().parent().find(".chosen").length;
				if ($(this).hasClass("chosen")) {
					$(this).removeClass("chosen");
				}else{
					if (count < e.data.maxTimes) {
						$(this).addClass("chosen");
					}
				}
				count = $(this).parent().parent().find(".chosen").length;
				if (count == e.data.maxTimes) {
					$("#confirm").removeAttr("disabled");
				}else{
					$("#confirm").attr("disabled","disabled");
				}
			});
		}
	});
}

function CalculateEndDate(beginDate, planinfo, worktime) {
	var dateStr = beginDate.split("-");
	var year = parseInt(dateStr[0]);
	var month = parseInt(dateStr[1]) - 1;
	var day = parseInt(dateStr[2]);
	var currentDay = new Date(year, month, day);
	var endDate = new Date(currentDay);
	$(".choose-appoint").each(function(){
		if ($(this).find("div").hasClass("checked")) {
			var Interal = parseInt($(this).parent().find("td").eq(0).html());
			var Times = parseInt($(this).parent().find("td").eq(1).html());
			var rest = parseInt($(this).parent().find("td").eq(5).html());
			if ($(this).parent().find("td").eq(7).html() != "无") {
				var date = $(this).prev().attr("data-date");
				var C_Date = new Date(date);
				
			}else{
				var C_Date = new Date(currentDay);
			}
			var count = 0;
			var temp = rest;
			while(temp > 0){
				var flag = 0;
				for (var i = 0; i < worktime.length; i++) {
					var tempdate = new Date(worktime[i]);
					if (tempdate.getFullYear() == C_Date.getFullYear() && tempdate.getMonth() == C_Date.getMonth() && tempdate.getDate() == C_Date.getDate()) {
						flag = 1;
						break;
					}
				}
				if (flag == 1) {
					count = 0;
				}else{
					if (count % Interal == 0) {
						temp = temp - Times;
					}
				}
				count ++;
				C_Date = new Date(C_Date.setDate(C_Date.getDate() + 1));
			}
			//tempDate = new Date(C_Date.setDate(C_Date.getDate() - 1));
			if (C_Date.getTime() > endDate.getTime()) {
				endDate = new Date(C_Date);
			}
		}
		return endDate;
	});
	return endDate.Format("yyyy-MM-dd");
}

function Num2Time(minute1, minute2) {
    var hour1 = parseInt(parseInt(minute1) / 60);
    var min1 = parseInt(minute1) - hour1 * 60;
    var hour2 = parseInt(parseInt(minute2) / 60);
    var min2 = parseInt(minute2) - hour2 * 60;
    h1 = hour1 >= 24 ? (hour1 - 24) : hour1;
    h2 = hour2 >= 24 ? (hour2 - 24) : hour2;
    var timestr1 = h1.toString() + ":" + (min1 < 10 ? "0" : "") + min1.toString();
    var timestr2 = h2.toString() + ":" + (min2 < 10 ? "0" : "") + min2.toString();
    if (hour1 >= 24) {
        return "(次日)" + timestr1 + " - " + timestr2;
    } else {
        return timestr1 + " - " + timestr2;
    }
}

function getData(url, async) {
	var returnData;
	$.ajax({
        type: "GET",
        url: url,
        async: async,
        dateType: "json",
        success: function (data) {
        	returnData = data;
        },
        error: function() {
        	returnData = false;
        }
    });
    return returnData;
}

function postData(url, data, async) {
	var returnData;
	$.ajax({
        type: "POST",
        url: url,
        data: data,
        async: async,
        dateType: "json",
        success: function (data) {
            returnData = data;
        },
        error: function() {
        	returnData = false;
        }
    });
    return returnData;
}

function Recover(type) {
	if (type == "click") {
		if (currentID != "0" && $("#" + currentID).length > 0) {
	        $("#" + currentID).click();
	        $("#AppointTime").find("td").unbind("click");
    		$("#confirm").attr("disabled","disabled");
	    }
	}else{
		if (currentID != "0" && $("#" + currentID).length > 0) {
	        $("#" + currentID).addClass("chosen");
	    }
	}
    
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