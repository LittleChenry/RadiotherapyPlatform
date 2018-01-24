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
            Paging(alldate.patientinfo);
            drawAppointTable(alldate.basicinfo);
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
            Paging(alldate.patientinfo);
            drawAppointTable(alldate.basicinfo);
            var datasession = {
                id: $("#equipment").val(),
                name: $("#equipment option:selected").html()
            };
            var setEquipmentURL = "../../pages/Main/Records/setEquipment.ashx"
            postData(setEquipmentURL, datasession, false);
        });

        $("#patient-search").bind('input propertychange', function () {
            var Searchedpatients = Search($("#patient-search").val(), alldate.patientinfo);
            Paging(Searchedpatients);
        });
    }
}

function getSession() {
    var sessionurl = "../../pages/Main/Records/getSession.ashx";
    var Session = getData(sessionurl, false);
    return Session;
}

function Paging(patients) {
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
            var tr = '<tr id="'+ patientid +'"><td>'+ Name +'</td><td>'+ Gender +'</td>'+
            		 '<td>'+ Age +'</td><td>'+ doctor +'</td><td>'+ groupname +'</td></tr>';
            tbody += tr;
        }
        tbody += '</tbody>';
        table.append(tbody);
        //trAddClickforJS(patient, userID);
    } else {
        var table = $("#patient-table");
        table.html("");
        var thead = '<thead><tr><th>患者姓名</th><th>性别</th><th>年龄</th><th>主治医生</th><th>医疗组</th></tr></thead>';
        table.append(thead);
        var tbody = '<tbody><tr><td colspan="5" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
        table.append(tbody);
        $("#patient_info").text("共0条记录");
    }
    Recover();
}

function Recover() {
    if (currentID != "0" && $("#" + currentID).length > 0) {
        $("#" + currentID).click();
    }
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
    equipInfo = $.parseJSON(returnData);
    var equipment = $("#equipment");
    equipment.html("");
    if (equipInfo) {
    	for (var i = 0; i < equipInfo.machine.length; i++) {
    		var equipmentOption = '<option value="'+ equipInfo.machine[i].ID +'">'+ equipInfo.machine[i].Name +'</option>';
    		equipment.append(equipmentOption);
    	}
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

function drawAppointTable(basicinfo) {
	drawDateTable();
	drawTimeTable(basicinfo);
	RoleToClick();
}

function drawDateTable() {
	var table = $("#AppointDate");
	var thead = '<thead><tr>';
	var tbody = '<tbody><tr>';

	var beginDate = new Date();
	var weekday=new Array("日","一","二","三","四","五","六");
	for (var i = 0; i < 7; i++) {
		th = '<th>'+ weekday[beginDate.getDay()] +'</th>';
		td = '<td><span class="appoint-date">'+ (beginDate.getMonth() + 1) + '月' + beginDate.getDate() + '日' +'</span></td>';
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

function drawTimeTable(basicinfo) {
	var table = $("#AppointTime");
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
						var td = '<td>'+ Num2Time(temptime, temptime + _TimeLength) +'</td>';
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

function RoleToClick() {

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