var equipmentfrominfo = "";
var temptreatmentID = "";
var nowDate = new Date();
$(document).ready(function () {
    var session = getSession();
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
         $("#Menu-EquipmentView").attr("href", "javascript:;");
         $("#Menu-EquipmentView").bind("click", function(){
            alert("权限不够！");
         });
    }
	chooseEquipment();
	$("#sureEquipment").unbind("click").click(function () {
	    nowDate = new Date();
		var equipmentID = $("#equipment").val();
        $("#currentEquipment").val(equipmentID);
		if (equipmentID == null) {
			alert("请选择设备！");
			return false;
		}
        showButton();
        patientView();
		if ($("#equipmentType").val() == "加速器") {
		    AccelerateAppointView(nowDate);
        }else{
            appointView(nowDate);
            Appoint2Patient();
        }
	});

	$("#timeselect").unbind("click").bind("change", function () {
	    var dateString = document.getElementById("AppiontDate").value;
	    CreateCurrentAccerEquipmentTbale(dateString);
	});
	$("#lastWeek").unbind("click").bind("click", function () {
	    changeDate(-7);
	});
	$("#lastDay").unbind("click").bind("click", function () {
	    changeDate(-1);
	});
	$("#nextDay").unbind("click").bind("click", function () {
	    changeDate(1);
	});
	$("#nextWeek").unbind("click").bind("click", function () {
	    changeDate(7);
	});

	$("#sureDate").unbind("click").bind("click", function () {
	    var dates = $("#dates").val().split("-");
	    nowDate = new Date(dates[0],parseInt(dates[1])-1,dates[2]);
        if ($("#equipmentType").val() == "加速器") {
            AccelerateAppointView(nowDate);
        }else{
            appointView(nowDate);
            Appoint2Patient();
        }
	});
});

function changeDate(days) {
    nowDate.setDate(nowDate.getDate() + days);
    if ($("#equipmentType").val() == "加速器") {
        AccelerateAppointView(nowDate);
    }else{
        appointView(nowDate);
        Appoint2Patient();
    }
}

function showButton() {
    $("#buttonArea").show();
    $("#deleteAllAppoints").remove();
}

function AccelerateAppointView(nowDate){
    createHead(nowDate);
    createAccelerateTable(nowDate);
    
}

function createAccelerateTable(nowDate) {
    var timelength = parseInt($("#timelength").val());
    var begin = parseInt($("#begin").val());
    var end = parseInt($("#end").val());
    var table = $("#appointTable");
    table.find("tbody").html("");
    var firstDate = new Date(nowDate);
    var DateArray = new Array(7);
    //var DateDetailArray = new Array(7);
    for (var i = 0; i < 7; i++) {
        DateArray[i] = firstDate.Format("yyyyMMdd");
        //DateDetailArray[i] = firstDate.Format("M-d") + num2week(firstDate.getDay());
        firstDate = new Date(firstDate.setDate(firstDate.getDate() + 1));
    }
    var temptime = begin;
    while(temptime < end){
        var tr = '<tr><td>'+ Num2Time(temptime, temptime + timelength) +'</td>';
        for (var i = 0; i < DateArray.length; i++) {
            var td = '<td><span id="'+ DateArray[i] + temptime +'" class="pointer"></span></td>';
            tr += td;
        }
        tr += '</tr>';
        table.find("tbody").append(tr);
        temptime += timelength;
    }
    var AppointmentsURL = "Records/GetInfoForEquipAndAppoint.ashx";
    firstDate = new Date(nowDate);
    var data = {
        equipid:$("#equipment").val(),
        firstday:firstDate.Format("yyyy-MM-dd")
    };
    var returnData = postData(AppointmentsURL, data, false);
    var alldate = $.parseJSON(returnData);
    var appointments = alldate.appointinfo;
    if (appointments == "") {
        return false;
    }
    for (var i = 0; i < appointments.length; i++) {
        var date = new Date(appointments[i].Date);
        var begin = appointments[i].Begin;
        var tdid = date.Format("yyyyMMdd") + begin;
        $("#" + tdid).html(appointments[i].patientname);
        $("#" + tdid).parent().attr("id", appointments[i].patientid + "_" + i);
        var DateDetail = date.Format("M月d日") + " " + num2week(date.getDay());
        $("#" + tdid).parent().attr("title", DateDetail);
    }
    table.find("td").each(function(){
        if ($(this).find("span").html() != "") {
            $(this).unbind("click").bind("click", function(){
                var tdid = $(this).attr("id").split("_")[0];
                var equipid = $("#equipment").val();
                var patientAppointURL = "getAllAppointInfoChildesign.ashx";
                var data = {
                    patientid:tdid,
                    equipid:equipid
                };
                var returnData = postData(patientAppointURL, data, false);
                var alldate = $.parseJSON(returnData);
                var patientAppointments = alldate.backinfo;
                $("#patientid").val(tdid);
                var table = $("#viewAppoints");
                table.find("thead").html("");
                table.find("tbody").html("");
                table.prev().remove();
                var thead = '<tr><th>姓名</th><th>日期</th><th>时间</th><th>计划</th></tr>';
                var btn = '<button id="deleteAllAppoints" class="btn btn-warning btn-flat pull-right" type="button" style="margin-bottom:20px;">删除预约</button>';
                table.find("thead").append(thead);
                table.before(btn);
                for (var i = 0; i < patientAppointments.length; i++) {
                    var childplan = '';
                    for (var j = 0; j < patientAppointments[i].chidinfogroup.length; j++) {
                        if (j == 0) {
                            if (patientAppointments[i].chidinfogroup[j].Completed == "0") {
                                childplan = childplan + '<span class="waiting">' + patientAppointments[i].chidinfogroup[j].designname + '</span>';
                            }else{
                                childplan = childplan + '<span>' + patientAppointments[i].chidinfogroup[j].designname + '</span>';
                            }
                        }else{
                            if (patientAppointments[i].chidinfogroup[j].Completed == "0") {
                                childplan = childplan + "、" + '<span class="waiting">' + patientAppointments[i].chidinfogroup[j].designname + '</span>';
                            }else{
                                childplan = childplan + "、" + '<span>' + patientAppointments[i].chidinfogroup[j].designname + '</span>';
                            }
                        }
                    }
                    var apoint_date = new Date(patientAppointments[i].date);
                    var time = Num2Time(parseInt(patientAppointments[i].begin), parseInt(patientAppointments[i].end));
                    var name = "";
                    if (i == 0) {
                        name = '<td rowspan="'+ patientAppointments.length +'">'+ $(this).find("span").html() +'</td>';
                    }
                    var tr = '<tr>'+ name +'<td>'+ apoint_date.Format("M月d日") +'</td><td>'+ time +'</td><td>'+ childplan +'</td></tr>';
                    table.find("tbody").append(tr);
                }
                $(this).parents(".tab-content").prev().find("li").each(function(index,e){
                    if (index == 1) {
                        $(this).find("a").click();
                    }
                });
                $("#deleteAllAppoints").unbind("click").bind("click", {info:data}, function(e){
                    var deleteAllURL = "deleteAllAccerAppoint.ashx";
                    var deleteinfo = e.data.info;
                    var returnData = postData(deleteAllURL, deleteinfo, false);
                    if (returnData == "success") {
                        if ($("#dates").val() == "") {
                            $("#sureEquipment").click();
                        }else{
                            $("#sureDate").click();
                        }
                        alert("删除成功！");
                    }
                });
            });
        }
    });
}

function Appoint2Patient(){
    var WeekArea = $("#WeekAreaNormal");
    WeekArea.find("table").each(function(index,e){
        $(this).find("td").each(function(index,e){
            $(this).unbind("click").bind("click",function(){
                if ($(this).find("span").length > 0) {
                    var treatID = $(this).find("span").attr("id").split("_")[0];
                    $("#viewAppoints").find("thead").html("");
                    var viewAppointsBody = $("#viewAppoints").find("tbody");
                    viewAppointsBody.html("");
                    var thead = '<tr><th>姓名</th><th>预约项目</th><th>预约时间</th><th>是否完成</th><th>操作</th></tr>';
                    $("#viewAppoints").find("thead").append(thead);
                    temptreatmentID = treatID;
                    var appoints = getAppointments(treatID);
                    var session = getSession();
                    var flag = 1;
                    for (var i = 0; i < appoints.appoint.length; i++) {
                        var appointDate = new Date(appoints.appoint[i].Date);
                        var completed = (appoints.appoint[i].Completed == "1") ? "完成" : "待做";
                        var name = "";
                        if (i == 0) {
                            name = '<td rowspan="'+ appoints.appoint.length +'">'+ $(this).find("span").html() +'</td>';
                        }
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
                            var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '">'+ name +'<td>' + appoints.appoint[i].Task + '</td>'
                             + '<td>' + appointDate.Format("yyyy-MM-dd") + ' , ' + begin + ' - ' + end + '(次日)</td>'
                             + '<td>' + completed + '</td>';
                        } else {
                            var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '">'+ name +'<td>' + appoints.appoint[i].Task + '</td>'
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
                    $(this).parents(".tab-content").prev().find("li").each(function(index,e){
                        if (index == 1) {
                            $(this).find("a").click();
                        }
                    });
                }
            });
        });
    });
    
}

function patientView(){
	var equipmentID = $("#equipment").val();
	var ViewPatient = getViewPatient(equipmentID);
	showEquipmentInfo(ViewPatient.equipmentinfo);
    $("#viewAppoints").find("tbody").html("");
    $("#viewAppoints").find("thead").html("");
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
    var treatID = temptreatmentID;
    var $e = $(e);
    var item = $e.parent().parent().children().first().text();
    var oldappoint = $e.parent().parent().attr("ID").split("_")[1];
    if (item == "体位固定") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Fixed");
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
    }
    if (item == "模拟定位" || item == "CT复查") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Location")
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
    }
    if (item == "加速器") {
        createaccerEquipmachine(document.getElementById("equipmentName"), treatID)
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAccerAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAccerAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAccerAppiontTable(event);
        });
    }
    if (item == "复位模拟") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Replacement")
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
    }
    if (item != "加速器") {
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        CreateNewAppiontTable(e);
    } else {
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
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
    var data = $.parseJSON(Items);
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
    $("#timelength").val(equipmentinfo.Timelength);
    $("#begin").val(equipmentinfo.BeginTimeAM);
    $("#end").val(equipmentinfo.EndTimePM);
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
	EquipmentTime.html("时间间隔：" + equipmentinfo.Timelength + "min");
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
    var options = '<option value="">----选择项目----</option><option value="体位固定">体位固定</option><option value="模拟定位">CT模拟</option><option value="加速器">加速器治疗</option>';
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
    $("#timechoose").hide();
    $("#commonapp1").hide();
    var table = document.getElementById("apptiontTable");
    var table1 = document.getElementById("apptiontTableForPm");
    RemoveAllChild(table);
    RemoveAllChild(table1);
    if (equiment.length != 0) {
        var amlength = 0
        for (var i = 0; i < equiment.length; i++) {
            if (equiment[i].Begin > 720) {
                amlength = i;
                break;
            }
        }
        var pmlength = equiment.length - amlength;
        if (amlength != 0) {
            $("#amlabel").show();
        } else {
            $("#amlabel").hide();
        }
        $("#pmlabel").show();
        var tbody = document.createElement("tbody");
        for (var i = 0; i < Math.ceil(amlength / 5) * 5 ; i++) {
            var count = i % 5;
            var tr;
            if (count == 0) {
                tr = document.createElement("tr");
            }
            if (i <= amlength - 1) {
                var td = document.createElement("td");
                var sign = document.createElement("i");
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
            if (i == amlength) {
                var k;
                for (k = amlength; k <= Math.ceil(amlength / 5) * 5 - 1; k++) {
                    var td = document.createElement("td");
                    tr.appendChild(td);
                }
            }
            if (count == 4) {
                tbody.appendChild(tr);
            }
        }
        table.appendChild(tbody);
        var tbody2 = document.createElement("tbody");
        for (var m = 0; m < Math.ceil(pmlength / 5) * 5 ; m++) {
            var count = m % 5;
            var tr;
            var i = m + amlength;
            if (count == 0) {
                tr = document.createElement("tr");
            }
            if (m <= pmlength - 1) {
                var td = document.createElement("td");
                var sign = document.createElement("i");
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
            if (m == pmlength) {
                var k;
                for (k = pmlength; k <= Math.ceil(pmlength / 5) * 5 - 1; k++) {
                    var td = document.createElement("td");
                    tr.appendChild(td);
                }
            }
            if (count == 4) {
                tbody2.appendChild(tr);
            }
        }
        table1.appendChild(tbody2);
    } else {
        $("#amlabel").hide();
        $("#pmlabel").hide();
        table.innerHTML = "今天已经不可以预约了,改天吧！";

    }
}

function CreateCurrentAccerEquipmentTbale(dateString) {
    $("#timechoose").show();
    $("#amlabel").hide();
    $("#pmappoint").hide();
    $("#commonapp").hide();
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
    var table1 = document.getElementById("apptiontTableForPm");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    for (var i = 0; i < table1.rows.length; i++) {
        for (var j = 0; j < table1.rows[i].cells.length; j++) {
            var cell = table1.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    return td_id;
}

function Clear() {
    var table = document.getElementById("apptiontTable");
    var table1 = document.getElementById("apptiontTableForPm");
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
    for (var i = 0; i < table1.rows.length; i++) {
        for (var j = 0; j < table1.rows[i].cells.length; j++) {
            var cell = table1.rows[i].cells[j];
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

function dateAdd2(dd, n) {
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
    var strdate = strYear + "-" + strMonth + "-" + strDay;
    return strdate;
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