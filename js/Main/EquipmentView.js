$(document).ready(function () {
	chooseEquipment();
	$("#sureEquipment").unbind("click").click(function(){
		appointView();
		patientView();
	});
});

function patientView(){
	var equipmentID = $("#equipment").val();
	var ViewPatient = getViewPatient(equipmentID);
	showEquipmentInfo(ViewPatient.equipmentinfo);
}

function showEquipmentInfo(equipmentinfo){
	var EquipmentInfo = $("#EquipmentInfo");
	var EquipmentState = $("#EquipmentState");
	var EquipmentTime = $("#EquipmentTime");
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

function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
}