$(document).ready(function () {
	chooseEquipment();
	$("#sureEquipment").unbind("click").click(function(){
		var equipmentID = $("#equipment").val();
		if (equipmentID == null) {
			alert("请选择设备！");
			return false;
		}
		appointView();
		patientView();
	});
});

function patientView(){
	var equipmentID = $("#equipment").val();
	var ViewPatient = getViewPatient(equipmentID);
	var viewPatientsBody = $("#viewPatients").find("tbody");
	viewPatientsBody.html("");
	var viewAppointsBody = $("#viewAppoints").find("tbody");
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
				for (var i = 0; i < appoints.appoint.length; i++) {
					var appointDate = new Date(appoints.appoint[i].Date);
					var completed = (appoints.appoint[i].Completed == "1") ? "已完成" : "未完成";
					var tr = '<tr id="apoint_'+ appoints.appoint[i].appointid +'"><td>'+ appoints.appoint[i].Task + '</td>'
						+'<td>' + appointDate.Format("yyyy-MM-dd") + ' ' + toTime(appoints.appoint[i].Begin) + ' - ' + toTime(appoints.appoint[i].End) + '</td>'
						+'<td>' + completed +'</td><td></td></tr>';
					viewAppointsBody.append(tr);
				}
			});
		}
	});
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
	var TimeRangePM = '<p class="text-muted" style="padding-left:20px;margin-top:10px;">下午工作时间：'+ toTime(equipmentinfo.BegTimePM) + ' - ' + toTime(equipmentinfo.EndTimePM) +'</p>';
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
            //alert(data);
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