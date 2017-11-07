var equipmentfrominfo = "";
$(document).ready(function () {
    var session = getSession();
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
         $("#Menu-EquipmentView").attr("href", "javascript:;");
         $("#Menu-EquipmentView").bind("click", function(){
            alert("权限不够！");
         });
    }
	chooseEquipment();
	$("#sureEquipment").unbind("click").click(function(){
        var equipmentType = $("#equipmentType").val();
		var equipmentID = $("#equipment").val();
		if (equipmentID == null) {
			alert("请选择设备！");
			return false;
		}
        if (equipmentType == "加速器") {
            $("#AppointType").attr("href","#appointViewAccelerate");
            if ($("#appointViewAccelerate").hasClass("active") || $("#appointView").hasClass("active")) {
                $("#appointView").removeClass("active");
                $("#appointViewAccelerate").addClass("active");
            }
            AccelerateAppointView();
        }else{
            $("#AppointType").attr("href","#appointView");
            if ($("#appointViewAccelerate").hasClass("active") || $("#appointView").hasClass("active")) {
                $("#appointViewAccelerate").removeClass("active");
                $("#appointView").addClass("active");
            }
            appointView();
        }
		patientView();
	});
	document.getElementById("chooseProject").addEventListener("click", function () {
	    CreateNewAppiontTable(event);
	}, false);//根据条件创建预约表
	$("#timeselect").bind("change", function () {
	    var dateString = document.getElementById("AppiontDate").value;
	    CreateCurrentAccerEquipmentTbale(dateString);
	});
    

});

function AccelerateAppointView(){
    var equipmentID = $("#equipment").val();
    var appiontview = getAppointRecords(equipmentID);
    var machineinfo = appiontview.machineinfo;
    var appointinfo = appiontview.appointinfo;
    var morningEnd = 720;
    var afternoonEnd = 1080;
    var count = 0;
    var num = appointinfo.length;
    var DayTimeArea = $("#DayTimeArea");
    var WeekArea = $("#WeekArea");
    WeekArea.html("");
    var chooseWeek = $("#chooseWeek");
    chooseWeek.html("");
    var begintime = parseInt(appointinfo[0].Begin);
    var maxbegin = parseInt(appiontview.maxbegin);
    var timelength = parseInt(machineinfo.Timelength);
    var rows = (maxbegin - begintime) / timelength + 1;
    var endtime = begintime + timelength;
    while(count < num){
        var currentdate = appointinfo[count].Date;
        var datediff = GetDateDiff(new Date().Format("yyyy-MM-dd"),new Date(currentdate).Format("yyyy-MM-dd"));
        var needtable = Math.floor(datediff / 7) + 1;
        var tablenum = WeekArea.find("table").length;
        if(tablenum < needtable){
            if (WeekArea.find("table").length == 0) {
                var table = '<table class="table table-bordered" style="table-layout:fixed;"><thead><tr>';
                var button = '<button type="button" class="time-btn selected-btn" style="margin-right:5px;margin-bottom:4px;">'+ '第' + needtable + '周' +'</button>';
            }else{
                var table = '<table class="table table-bordered" style="display:none;table-layout:fixed;"><thead><tr>';
                var button = '<button type="button" class="time-btn" style="margin-right:5px;margin-bottom:4px;">'+ '第' + needtable + '周' +'</button>';
            }
            chooseWeek.append(button);
            table += '<th>时间' + '\\' + '日期</th>';
            for (var i = 0; i < 7; i++) {
                var thisDate = new Date(dateAdd(new Date().Format("yyyy-MM-dd"),i + tablenum * 7));
                var weekday = thisDate.getDay();
                var th = '<th>'+ thisDate.Format("MM/dd") + '('+ num2week(weekday) +')' +'</th>';
                table += th;
            }
            table += "</tr></thead><tbody style='text-align:center;'>";
            for (var i = 0; i < rows; i++) {
                var TempBegin = begintime + i * timelength;
                var TempEnd = TempBegin + timelength;
                if (TempEnd <= morningEnd) {
                    var tr = '<tr class="morning"><td>'+ toTime(TempBegin) + '-'+ toTime(TempEnd) +'</td>';
                }else if (TempEnd <= afternoonEnd) {
                    var tr = '<tr class="afternoon"><td>'+ toTime(TempBegin) + '-'+ toTime(TempEnd) +'</td>';
                }else{
                    var tr = '<tr class="evening"><td>'+ toTime(TempBegin) + '-'+ toTime(TempEnd) +'</td>';
                }
                for (var j = 0; j < 7; j++) {
                    tr += "<td id='"+ (needtable).toString() + i + j +"'></td>";
                }
                tr += "</tr>";
                table += tr;
            }
            table += "</tbody></table>";
            WeekArea.append(table);
        }

        count ++;
    }

    count = 0;

    while(count < num){
        var currentdate = appointinfo[count].Date;
        var currenttime = parseInt(appointinfo[count].Begin);
        var datediff = GetDateDiff(new Date().Format("yyyy-MM-dd"),new Date(currentdate).Format("yyyy-MM-dd"));
        var tablenum = Math.floor(datediff / 7) + 1;
        var col = datediff - 7 * (tablenum - 1);
        var row = (currenttime - begintime) / timelength;
        var tdid = tablenum.toString() + row.toString() + col.toString();
        var span = '<span id='+ appointinfo[count].TreatmentID + '_' + appointinfo[count].appointid +'>'+ appointinfo[count].patientname + " " + appointinfo[count].treatdescribe +'</span>'
        $("#" + tdid).append(span);
        /*$("#" + tdid).bind("click",function(){
            var treatID = $(this).find("span").attr('id');
            findAllTreatIDTd(treatID);
        });*/
        count ++;
    }

    $("#chooseWeek").find("button").each(function(index,e){
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

    BatchChooseTreat();

    $("#chooseWay").find("button").each(function(index,e){
        $(this).bind("click",{index:index},function(e){
            if (e.data.index == 0) {
                CancelClick();
                UnlimitedChooseTreat();
                $(this).removeClass("selected-btn").addClass("selected-btn");
                if ($(this).next().hasClass("selected-btn")) {
                    $(this).next().removeClass("selected-btn");
                }
            }else if (e.data.index == 1) {
                CancelClick();
                BatchChooseTreat();
                $(this).removeClass("selected-btn").addClass("selected-btn");
                if ($(this).prev().hasClass("selected-btn")) {
                    $(this).prev().removeClass("selected-btn");
                }
            }
        });
    });

    $("#CancelTreatment").bind("click",function(){
        CancelTreatment();
    });

    $("#DeleteAppoint").bind("click",function(){
        DeleteTreatment(timelength,begintime);
    });
}

function BatchChooseTreat(){
    var WeekArea = $("#WeekArea");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(index,e){
            if($(this).find("span").length > 0){
                $(this).bind("click",function(){
                    var treatID = $(this).find("span").attr('id').split("_")[0];
                    if (!($(this).hasClass("treat-td"))) {
                        findAllTreatIDTd(treatID);
                    }else{
                        cancelAllTreatIDTd(treatID)
                    }
                });
            }
        });
    });
}

function UnlimitedChooseTreat(){
    var WeekArea = $("#WeekArea");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(index,e){
            if($(this).find("span").length > 0){
                $(this).bind("click",function(){
                    if ($(this).hasClass("treat-td")) {
                        $(this).removeClass("treat-td");
                    }else{
                        $(this).addClass("treat-td");
                    }
                });
            }
        });
    });
}

function findAllTreatIDTd(treatID){
    var WeekArea = $("#WeekArea");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(index,e){
            if($(this).find("span").length > 0){
                if ($(this).find("span").attr("id").split("_")[0] == treatID) {
                    $(this).addClass("treat-td");
                }else if ($(this).hasClass("treat-td")) {
                    $(this).removeClass("treat-td");
                }
            }
        });
    });
}

function cancelAllTreatIDTd(treatID){
    var WeekArea = $("#WeekArea");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(index,e){
            if($(this).find("span").length > 0){
                if ($(this).find("span").attr("id").split("_")[0] == treatID) {
                    $(this).removeClass("treat-td");
                }
            }
        });
    });
}

function CancelTreatment(){
    var WeekArea = $("#WeekArea");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(){
            if ($(this).hasClass("treat-td")) {
                $(this).removeClass("treat-td");
            }
        });
    });
}

function DeleteTreatment(timelength,begintime){
    var data = findAllTreatData(timelength,begintime);
    $.ajax({
        type: "POST",
        async: false,
        data:{
            appoint:data
        },
        url: "../../../pages/Main/Records/AppointChangeAndDelete.ashx",
        success:function(){
            alert("修改成功！");
        }
    });
}

function findAllTreatData(timelength,begintime){
    var WeekArea = $("#WeekArea");
    var data = "[";
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(){
            if ($(this).hasClass("treat-td")) {
                var tdid = $(this).attr("id").split("_")[0];
                var appointid = $(this).find("span").attr("id").split("_")[1];
                var rownum = parseInt(tdid.substring(1,tdid.length-1));
                var tablenum = parseInt(tdid.substring(0,1));
                var colnum = parseInt(tdid.substring(tdid.length-1,tdid.length));
                var begindate = new Date();
                var date = dateAdd(begindate.Format("yyyy-MM-dd"),(tablenum - 1) * 7 + colnum);
                var begin = begintime + rownum * timelength;
                var isdouble = 0;
                var end = begin + (isdouble + 1) * timelength;
                data += '{"appointid":"'+ appointid +'","Date":"' + date + '","Begin":"' + begin + '","End":"' + end + '"},';
            }
        });
    });
    var l = data.length;
    if (l > 1) {
        data = data.substring(0,data.length-1);
    }else{
        data += "\"\"";
    }
    data += ']';
    return data;
}

function CancelClick(){
    var WeekArea = $("#WeekArea");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(){
            $(this).unbind("click");
        });
    });
}

function patientView(){
	var equipmentID = $("#equipment").val();
	var ViewPatient = getViewPatient(equipmentID);
	var viewPatientsBody = $("#viewPatients").find("tbody");
	viewPatientsBody.html("");
	var viewAppointsBody = $("#viewAppoints").find("tbody");
	viewAppointsBody.html("");
	showEquipmentInfo(ViewPatient.equipmentinfo);
	if (ViewPatient.patientinfo != "") {
		for (var i = 0; i < ViewPatient.patientinfo.length; i++) {
			var tr = '<tr id="viewpatient_'+ ViewPatient.patientinfo[i].Treatment_ID +'"><td>'+ ViewPatient.patientinfo[i].Radiotherapy_ID +'</td><td>'
				+ ViewPatient.patientinfo[i].pname +'</td><td>'+ ViewPatient.patientinfo[i].treatmentscribe
				+'</td><td>'+ ViewPatient.patientinfo[i].DiagnosisResult +'</td></tr>'
			viewPatientsBody.append(tr);
		}
	}else{
		var tr = '<tr><td colspan="4">暂无预约</td></tr>';
		viewPatientsBody.append(tr);
	}
	viewPatientsBody.find("tr").each(function(index, element){
		if ($(this).attr("id") != "") {
			$(this).unbind("click").click(function(){
				$(this).parent().find("tr").each(function(){
					$(this).removeClass("chose");
				});
				$(this).addClass("chose");
				viewAppointsBody.html("");
				var appoints = getAppointments($(this).attr("id").split("_")[1]);
				var session = getSession();
				if ((typeof (session) == "undefined")) {
				    if (confirm("用户身份已经失效,是否选择重新登录?")) {
				        parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
				    }
				}
				var flag = 1;
				for (var i = 0; i < appoints.appoint.length; i++) {
				    var appointDate = new Date(appoints.appoint[i].Date);
				    var completed = (appoints.appoint[i].Completed == "1") ? "已完成" : "未完成";
				    if (parseInt(toTime(appoints.appoint[i].End).split(":")[0]) >= 24) {
				        var hour = toTime(appoints.appoint[i].Begin).split(":")[0];
				        var minute = toTime(appoints.appoint[i].Begin).split(":")[1];
				        if (hour >= 24) {
				            var beginhour = parseInt(hour) - 24;
				        } else {
				            var beginhour = hour;
				        }
				        var begin = beginhour + ":" + minute;
				        var endhour = toTime(appoints.appoint[i].End).split(":")[0];
				        var endminute = toTime(appoints.appoint[i].End).split(":")[1];
				        var hourend = parseInt(endhour) - 24;
				        var end = hourend + ":" + endminute;
				        var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '"><td>' + appoints.appoint[i].Task + '</td>'
                         + '<td>' + appointDate.Format("yyyy-MM-dd") + ' , ' + begin + ' - ' + end + '(次日)</td>'
                         + '<td>' + completed + '</td>';
				    } else {
				        var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '"><td>' + appoints.appoint[i].Task + '</td>'
                        + '<td>' + appointDate.Format("yyyy-MM-dd") + ' , ' + toTime(appoints.appoint[i].Begin) + ' - ' + toTime(appoints.appoint[i].End) + '</td>'
                        + '<td>' + completed + '</td>';
				    }
				    if (appoints.appoint[i].Task != "加速器" && session.roleName == "YS") {
				        if (appoints.appoint[i].Completed == "1") {
				            tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				        } else {
				            tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				        }
				    } else {
				        if (appoints.appoint[i].Task == "加速器" && session.roleName == "ZLJS" && flag == 0) {
				            if (appoints.appoint[i].Completed == "1") {
				                tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				            } else {
				                tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				            }
				        } else {
				            if (appoints.appoint[i].Task == "加速器" && session.roleName == "YS" && flag == 1) {
				                if (appoints.appoint[i].Completed == "1") {
				                    tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				                } else {
				                    tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				                }
				                flag = 0;
				            } else {
				                tr = tr + '<td><button disabled="disabled"  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
				            }
				        }
				    }
				    if (appoints.appoint[i].Task == "加速器") {
				        flag = 0;
				    }
				    viewAppointsBody.append(tr);
				}
			});
		}
	});
}
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}
function changeAppoint(e) {
    var treatID = $("#viewPatients tbody tr.chose").attr("ID").split("_")[1];
    var $e = $(e);
    var item = $e.parent().parent().children().first().text();
    var oldappoint = $e.parent().parent().attr("ID").split("_")[1];
    if (item == "体位固定") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Fixed")
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAppiontTable(e);
        });
    }
    if (item == "模拟定位") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Location")
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAppiontTable(e);
        });
    }
    if (item == "加速器") {
        createaccerEquipmachine(document.getElementById("equipmentName"), treatID)
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAccerAppiontTable(e);
        });
    }
    if (item == "复位模拟") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Replacement")
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAppiontTable(e);
        });
    }
    var date = new Date();
    var date = date.Format('yyyy-MM-dd');
    document.getElementById("AppiontDate").value = date;
    if (item != "加速器") {
        CreateNewAppiontTable(e);
    } else {
        CreateNewAccerAppiontTable(e);
    }
    $("#sure").unbind("click").bind("click", function () {
        var choseid = ChoseID();
        var appoint = choseid.split("_");
        var newappoint = appoint[0];

        if (choseid != null) {
            if (item == "体位固定") {
                $.ajax({
                    type: "POST",
                    url: "Records/changeFixAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newappoint: newappoint
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(appoint[1] + "," + appoint[2]);
                            $e.parent().parent().attr("ID", "apoint" + "_" + newappoint)
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
            if (item == "模拟定位") {
                $.ajax({
                    type: "POST",
                    url: "Records/changeLocateAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newappoint: newappoint
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(appoint[1] + "," + appoint[2]);
                            $e.parent().parent().attr("ID", "apoint" + "_" + newappoint)
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
            if (item == "复位模拟") {
                $.ajax({
                    type: "POST",
                    url: "Records/changeReplaceAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newappoint: newappoint
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(appoint[1] + "," + appoint[2]);
                            $e.parent().parent().attr("ID", "apoint" + "_" + newappoint)
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
            if (item == "加速器") {
                var choseid = ChoseID();
                var appoint = choseid.split("_");
                var newdate = appoint[0].split(" ")[0];
                var newbegin = appoint[2];
                var newend = appoint[3];
                $.ajax({
                    type: "POST",
                    url: "Records/changeAccerateAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newdate: newdate,
                        newbegin: newbegin,
                        newend: newend,
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(newdate + "," + appoint[1]);
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
        }
    });
    $("#changeAppoint").modal({ backdrop: 'static' });
}
function getAppointments(treatmentID){
	var appoints;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getappointinfo.ashx?treatID=" + treatmentID,
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            appoints = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return appoints;
}

function getAppointRecords(equipmentID){
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetInfoForEquipAndAppoint.ashx?equipid=" + equipmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    //alert(Items);
    var data = $.parseJSON(Items)
    return data;
}

function geteuqipmenttype(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/geteuqipmenttype.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;

}
function showEquipmentInfo(equipmentinfo){
	var EquipmentInfo = $("#EquipmentInfo");
	var EquipmentState = $("#EquipmentState");
	var EquipmentTime = $("#EquipmentTime");
	EquipmentInfo.nextAll().each(function(){
		$(this).remove();
	});
	EquipmentInfo.html("名称：" + equipmentinfo.Name);
	var EquipmentType = '<p class="text-muted" style="padding-left:20px;margin-top:10px;">类型：'+ equipmentinfo.type +'</p>';
	EquipmentInfo.after(EquipmentType);
	switch(equipmentinfo.State){
		case "1":
			EquipmentState.html("正常运行");
			break;
		case "2":
			EquipmentState.html("检查中");
			break;
		case "3":
			EquipmentState.html("维修中");
			break;
		default:
			EquipmentState.html("无");
	}
	EquipmentTime.nextAll().each(function(){
		$(this).remove();
	});
	EquipmentTime.html("一次治疗时间：" + equipmentinfo.Timelength + "min");
	var TimeRangeAM = '<p class="text-muted" style="padding-left:20px;margin-top:10px;">上午工作时间：'+ toTime(equipmentinfo.BeginTimeAM) + ' - ' + toTime(equipmentinfo.EndTimeAM) +'</p>';
	var TimeRangePM = '<p class="text-muted" style="padding-left:20px;margin-top:10px;">下午工作时间：'+ toTime2(equipmentinfo.BegTimePM) + ' - ' + toTime2(equipmentinfo.EndTimePM) +'</p>';
	EquipmentTime.after(TimeRangePM);
	EquipmentTime.after(TimeRangeAM);
}

function getViewPatient(equipmentID){
    var ViewPatient;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getallpatientforchange.ashx?equipment=" + equipmentID,
        async: false,
        dateType: "text",
        success: function (data) {
            ViewPatient = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return ViewPatient;
}

function chooseEquipment() {
    var session = getSession();
    $("#equipmentType").html("");
    var options = '<option value="">----选择项目----</option><option value="体位固定">体位固定</option><option value="模拟定位">CT模拟</option><option value="复位模拟">复位验证</option></option><option value="加速器">加速器治疗</option>';
    $("#equipmentType").append(options);
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getEquipment.ashx",
        async: false,
        dateType: "json",
        success: function (data) {
            var Equipment = $.parseJSON(data);
            var options;
            $("#equipment").append(options);
            $("#equipmentType").change(function () {
                if ($("#equipmentType").val() != "") {
                    options = "";
                    for (var i = 0; i < Equipment.EquipmentInfo.length; i++) {
                        if ($("#equipmentType").val() == Equipment.EquipmentInfo[i].TreatmentItem) {
                            options += '<option value="' + Equipment.EquipmentInfo[i].equipmentID + '">' + Equipment.EquipmentInfo[i].equipmentName + '</option>';
                        }
                    }
                    $("#equipment").html("").append(options);
                } else {
                    $("#equipment").html("");
                }

            });
        },
        error: function () {
            alert("error");
        }
    });
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

function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
}
//设备下拉菜单
function getNowFormatDate() {
    var date = new Date();
    var seperator1 = "-";
    var seperator2 = ":";
    var month = date.getMonth() + 1;
    var strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var min = date.getMinutes();
    if (min < 10) {
        min = "0" + min;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + min;

    return currentdate;
}

function createfixEquipmachine(thiselement, item) {
    var machineItem = JSON.parse(getmachineItem(item)).Item;
    thiselement.options.length = 0;
    for (var i = 0; i < machineItem.length; i++) {
        if (machineItem[i] != "") {
            thiselement.options[i] = new Option(machineItem[i].Name);
            thiselement.options[i].value = parseInt(machineItem[i].ID);
        }
    }
}
function createaccerEquipmachine(thiselement, treatmentid) {
    var machineItem = JSON.parse(getmachineItem1(treatmentid)).Item;
    thiselement.options.length = 0;
    for (var i = 0; i < machineItem.length; i++) {
        if (machineItem[i] != "") {
            thiselement.options[i] = new Option(machineItem[i].Name);
            thiselement.options[i].value = parseInt(machineItem[i].ID);
        }
    }
}
function getmachineItem1(treatmentid) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getfirstaccermachine.ashx?treatmentid=" + treatmentid;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}
function getmachineItem(item) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getfixmachine.ashx?item=" + item;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}
//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(equiment, dateString) {
    var table = document.getElementById("apptiontTable");
    RemoveAllChild(table);
    if (equiment.length != 0) {
        var tbody = document.createElement("tbody");
        for (var i = 0; i < Math.ceil(equiment.length / 5) * 5 ; i++) {
            var count = i % 5;
            var tr;
            if (count == 0) {
                tr = document.createElement("tr");
            }
            if (i <= equiment.length - 1) {
                var td = document.createElement("td");
                var sign = document.createElement("i");
                if (parseInt(toTime(equiment[i].Begin).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    var beginhour = parseInt(hour) - 24;
                    var begin = beginhour + ":" + minute;
                    var endhour = toTime(equiment[i].End).split(":")[0];
                    var endminute = toTime(equiment[i].End).split(":")[1];
                    var hourend = parseInt(endhour) - 24;
                    var end = hourend + ":" + endminute;
                    td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + begin + "-" + end + "(次日)" + "_" + equiment[i].Euqipment);
                } else {
                    td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
                }
                if (equiment[i].State == "0") {
                    if (compareWithToday(dateString)) {
                        sign.className = "";
                        td.addEventListener("click", chooseItem, false);
                    } else {
                        td.style.backgroundColor = "#C1C1C1";
                        sign.className = "fa fa-fw fa-ban td-sign";
                        td.addEventListener("click", hasChosen, false);
                    }
                } else {
                    td.style.backgroundColor = "#C1C1C1";
                    sign.className = "fa fa-fw fa-ban td-sign";
                    td.addEventListener("click", hasChosen, false);
                }
                if (parseInt(toTime(equiment[i].Begin).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    var beginhour = parseInt(hour) - 24;
                    var begin = beginhour + ":" + minute;
                    var endhour = toTime(equiment[i].End).split(":")[0];
                    var endminute = toTime(equiment[i].End).split(":")[1];
                    var hourend = parseInt(endhour) - 24;
                    var end = hourend + ":" + endminute;
                    var text = document.createTextNode(begin + " - " + end + "(次日)");
                } else {
                    var text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                }
                td.appendChild(text);
                td.appendChild(sign);
                tr.appendChild(td);
            }
            if (i == equiment.length) {
                var k;
                for (k = equiment.length; k <= Math.ceil(equiment.length / 5) * 5 - 1; k++) {
                    var td = document.createElement("td");

                    tr.appendChild(td);
                }
            }
            if (count == 4) {
                tbody.appendChild(tr);
            }
        }
        table.appendChild(tbody);
    } else {
        table.innerHTML = "今天已经不可以预约了,改天吧！";

    }
}

function CreateCurrentAccerEquipmentTbale(dateString) {
    $("#timechoose").show();
    var table = document.getElementById("apptiontTable");
    var equiment;
    if (equipmentfrominfo != "") {
        equiment = [].concat(equipmentfrominfo.Equipment);
    } else {
        equiment = [];
    }
    if (equiment.length != 0) {
        var appointinfo = equipmentfrominfo.appointinfo;
        for (var temp = 0; temp < equiment.length; temp++) {
            for (var temp2 = 0; temp2 < appointinfo.length; temp2++) {
                if (parseInt(equiment[temp].Begin) == parseInt(appointinfo[temp2].Begin)) {
                    equiment[temp].state = "1";
                }
            }
        }
    }
    RemoveAllChild(table);
    var selecttime = document.getElementById("timeselect");
    var currentIndex = selecttime.selectedIndex;
    var selecttimevalue = selecttime.options[currentIndex].value;
    var beginxianzhi = selecttimevalue.split("-")[0];
    var endxianzhi = selecttimevalue.split("-")[1];
    var isspecial = document.getElementById("isspecial");
    var currentIndex1 = isspecial.selectedIndex;
    var isspecialvalue = isspecial.options[currentIndex1].value;
    if (equiment.length == 0) {
        table.innerHTML = "今天已经不可以预约了,改天吧！";
        return;
    }
    var tempcount = 0;
    for (tempcount = 0; tempcount < equiment.length;) {
        if (!(parseInt(equiment[tempcount].Begin) >= parseInt(beginxianzhi) && parseInt(equiment[tempcount].End) <= parseInt(endxianzhi))) {
            equiment.splice(tempcount, 1);
        } else {
            tempcount++;
        }
    }
    if (isspecialvalue == "0") {
        var tbody = document.createElement("tbody");
        var i;
        for (i = 0; i < Math.ceil(equiment.length / 6) * 6 ; i++) {
            var count = i % 6;
            var tr;
            if (count == 0) {
                tr = document.createElement("tr");
            }
            var td = document.createElement("td");
            var sign = document.createElement("i");
            if (i <= equiment.length - 1) {
                if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    if (hour >= 24) {
                        var beginhour = parseInt(hour) - 24;
                    } else {
                        var beginhour = hour;
                    }
                    var begin = beginhour + ":" + minute;
                    var endhour = toTime(equiment[i].End).split(":")[0];
                    var endminute = toTime(equiment[i].End).split(":")[1];
                    var hourend = parseInt(endhour) - 24;
                    var end = hourend + ":" + endminute;
                    td.setAttribute("id", dateString + "_" + begin + "-" + end + "(次日)" + "_" + equiment[i].Begin + "_" + equiment[i].End);
                } else {
                    td.setAttribute("id", dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Begin + "_" + equiment[i].End);
                }
                if (equiment[i].state == "0") {
                    if (compareWithToday(dateString)) {
                        sign.className = "";
                        td.addEventListener("click", chooseItem, false);
                    } else {
                        td.style.backgroundColor = "#C1C1C1";
                        sign.className = "fa fa-fw fa-ban td-sign";
                        td.addEventListener("click", hasChosen, false);
                    }

                } else {
                    td.style.backgroundColor = "#C1C1C1";
                    sign.className = "fa fa-fw fa-ban td-sign";
                    td.addEventListener("click", hasChosen, false);
                }
                if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    if (hour >= 24) {
                        var beginhour = parseInt(hour) - 24;
                    } else {
                        var beginhour = hour;
                    }
                    var begin = beginhour + ":" + minute;
                    var endhour = toTime(equiment[i].End).split(":")[0];
                    var endminute = toTime(equiment[i].End).split(":")[1];
                    var hourend = parseInt(endhour) - 24;
                    var end = hourend + ":" + endminute;
                    var text = document.createTextNode(begin + " - " + end + "(次日)");
                } else {
                    var text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                }
                td.appendChild(text);
                td.appendChild(sign);
                tr.appendChild(td);
            }
            if (i == equiment.length) {
                var k;
                for (k = equiment.length; k <= Math.ceil(equiment.length / 6) * 6 - 1; k++) {
                    var td = document.createElement("td");
                    tr.appendChild(td);
                }
            }
            if (count == 5) {
                tbody.appendChild(tr);
            }
        }
        table.appendChild(tbody);
    }

}
function chooseItem() {
    if (ChoseID() == null) {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        } else {
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    } else {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        } else {
            Clear();
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    }

}
function ChoseID() {
    var td_id = null;
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    return td_id;
}
function Clear() {
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                cell.className = "";
                cell.lastChild.className = "";
                return;
            }
        }
    }
}

function hasChosen() {
	alert("该时间段已被预约！");
}
//清楚所有子节点
function RemoveAllChild(area) {
    while (area.hasChildNodes()) {
        var first = area.firstChild;
        if (first != null && first != undefined)
            area.removeChild(first);
    }
}
//根据日期创建新表
function CreateNewAppiontTable(evt) {
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipmentID = equipmentName.options[currentIndex].value;
    var AppiontDate = document.getElementById("AppiontDate");
    if (!compareWithToday(AppiontDate.value)) {
        alert("不能选择小于当天的日期");
        return;
    }
    var date = AppiontDate.value;
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetEquipmentAppointment.ashx?equipmentID=" + equipmentID + "&date=" + date;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    thisObj = eval("(" + json + ")");
    CreateCurrentEquipmentTbale(thisObj, date);
}
function CreateNewAccerAppiontTable(evt) {
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipmentID = equipmentName.options[currentIndex].value;
    var AppiontDate = document.getElementById("AppiontDate");
    if (!compareWithToday(AppiontDate.value)) {
        alert("不能选择小于当天的日期");
        var table = document.getElementById("apptiontTable");
        RemoveAllChild(table);
        equipmentfrominfo = [];
        return;
    }
    var date = AppiontDate.value;
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetEquipmentWorktime.ashx?equipmentID=" + equipmentID + "&date=" + date;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    equipmentfrominfo = eval("(" + json + ")");
    CreateCurrentAccerEquipmentTbale(date);

}
function checkAllTable() {
    var choseid = ChoseID();
    var appoint = choseid.split("_");
    document.getElementById("idforappoint").value = appoint[0];
    document.getElementById("appointtime").value = appoint[3] + " " + appoint[1] + " " + appoint[2];
}

function compareWithToday(time) {
    var year = time.split("-")[0];
    var month = time.split("-")[1];
    var day = time.split("-")[2];
    var date = new Date();
    if (parseInt(year) < parseInt(date.getFullYear())) {
        return false;
    } else {
        if (parseInt(year) == parseInt(date.getFullYear())) {
            if (parseInt(month) < parseInt(date.getMonth() + 1)) {
                return false;
            } else {
                if (parseInt(month) == parseInt(date.getMonth() + 1)) {
                    if (parseInt(day) < parseInt(date.getDate())) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return true;
                }
            }
        } else {
            return true;
        }
    }
}

function toTime2(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    if (hour >= 24) {
        hour = hour - 24;
        return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString() + "(次日)";
    } else {
        return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
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

function GetDateDiff(startDate, endDate) {
    var startTime = new Date(Date.parse(startDate.replace(/-/g, "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g, "/"))).getTime();
    var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
    return dates;
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