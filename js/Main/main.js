var currentID = 0;
var functions = new Array();

$(document).ready(function () {
    $(".frame-content").height($(document).height() - 151);
    $("#patient-content").height($(document).height() - 151);
    $("#patient-table-content").height($(document).height() - 190);
    $("#record-iframe").width($("#record-content").width());
    $("#progress-iframe").width($("#progress-content").width());
    var session = getSession();
    functions = session.progress.split(" ");
    var patient = RolesToPatients();
    adjustTable();
    Notice(session.roleName);

    $("#patient-search").bind('input propertychange', function () {
        //alert(patient.PatientInfo.length);
        var Searchedpatients = Search($("#patient-search").val(), patient, session.role);
        Paging(Searchedpatients, session.role, session.userID);
        adjustTable();
    });
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("../Login/Login.aspx");
    });
    $("#save").unbind("click").click(function () {
        var result = $("#record-iframe")[0].contentWindow.save();
        if (result == false) {
            return false;
        }
        $('#save').attr("disabled", "disabled");
        $('#saveTemplate-list').attr("disabled", "disabled");
        RolesToPatients();
        adjustTable();
        Recover();
    });
    $('#edit').unbind("click").click(function () {
        $("#record-iframe")[0].contentWindow.remove();
        $("#save").removeAttr("disabled");
        $("#saveTemplate-list").removeAttr("disabled");
        $("#chooseTemplate").removeAttr("disabled");
        $('#edit').attr("disabled", "disabled");
    });
    $("#saveTreatment").unbind("click").bind("click", function () {
        saveTreatment();
    });
    $("#saveTemplate-button").unbind("click").bind("click", function () {
        Template();
    });
    $("#printIframe").unbind("click").bind("click", function () {
        $("#record-iframe")[0].contentWindow.print();
    });
    $("#changeOperator").unbind("click").bind("click", function () {
        $("#record-iframe")[0].contentWindow.tankuang();
    });
    $("#changeEquipment").unbind("click").bind("click", function () {
        chooseEquipment();
    });
    $("#changeDate").unbind("click").bind("click", function () {
        chooseEquipment();
    });
})

/*window.onresize=function(){
    document.location.reload();
}*/

function RolesToPatients() {
    var patient;
    var session = getSession();
    if (session.role == "模拟技师" || session.role == "治疗技师") {
        if (session.equipmentID == "0") {
            chooseEquipment();
            $("#getSelectedPatient").unbind("click").click(function () {
                var equipmentID = $("#equipment").val();
                var equipmentName = $("#equipment option:selected").html();
                var startdate = $("#startdate").val();
                var enddate = $("#enddate").val();
                var currentTime = new Date().Format("yyyy-MM-dd");
                if (!equipmentID) {
                    alert("设备不能为空！");
                    return false;
                }
                if (!startdate) {
                    alert("开始日期不能为空！");
                    return false;
                }
                if (!enddate) {
                    alert("结束日期不能为空！");
                    return false;
                }
                if (startdate > enddate) {
                    alert("结束日期不能小于开始日期！");
                    return false;
                }
                if (startdate < currentTime) {
                    alert("开始日期不能小于当天日期！");
                    return false;
                }
                $("#chosenEquipment").html(equipmentName);
                $("#dateRange").html(startdate + "~~" + enddate);
                var parameters = new Array();
                parameters[0] = equipmentID;
                parameters[1] = startdate;
                parameters[2] = enddate;
                patient = getPatient(session.userID, session.role, parameters);
                Paging(patient, session.role, session.userID);
                $.ajax({
                    type: "POST",
                    async: false,
                    url: "../../pages/Main/Records/setEquipment.ashx",
                    data: {
                        id: $("#equipment").val(),
                        name: $("#equipment option:selected").html(),
                        beginTime: $("#startdate").val(),
                        endTime: $("#enddate").val()
                    },
                    error: function () {
                        alert("error");
                    }
                });
            });
        } else {
            var parameters = new Array();
            parameters[0] = session.equipmentID;
            parameters[1] = session.beginTime;
            parameters[2] = session.endTime;
            patient = getPatient(session.userID, session.role, parameters);
            var sortPatient = patientSort(patient);
            Paging(sortPatient, session.role, session.userID);
            $("#chosenEquipment").html(session.equipmentName);
            $("#dateRange").html(session.beginTime + "~~" + session.endTime);
        }

    } else {
        var parameters = new Array();
        patient = getPatient(session.userID, session.role, parameters);
        var sortPatient = patientSort(patient);
        Paging(sortPatient, session.role, session.userID);
        if (session.role == "医师" || session.role == "剂量师" || session.role == "物理师") {
            TaskWarning(sortPatient);
        }
    }
    return sortPatient;
}

function Paging(patient, role, userID) {
    if (patient.PatientInfo != "") {
        tableheight = $("#patient-content").height() - 160;
        var table = $("#patient-table");
        table.html("");
        $("#patient_info").text("一共" + patient.PatientInfo.length + "条记录");
        switch (role) {
            case "医师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            case "剂量师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            case "物理师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            case "模拟技师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Task, date, begin, end, Completed, doctor;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>预约项目</th><th>预约时间</th><th>是否完成</th><th>疗程</th><th>诊断结果</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    date = patient.PatientInfo[i].date;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    Task = patient.PatientInfo[i].Task;
                    doctor = patient.PatientInfo[i].doctor;
                    Completed = (patient.PatientInfo[i].Completed == "1") ? "已完成" : "未完成";
                    begin = toTime(patient.PatientInfo[i].begin);
                    end = toTime(patient.PatientInfo[i].end);
                    var tr = "<tr id='" + TreatmentID + "_" + patient.PatientInfo[i].appointid + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + Task + "</td><td>" + date + "," + begin + "-" + end + "</td><td>" + Completed+ "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td>"
                        + "<td>" + doctor + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClickforJS(patient, userID);
                break;
            case "治疗技师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, date, begin, end, Completed, doctor, finishedtimes, totalnumber, totaltimes;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>预约时间</th><th>是否完成</th><th>完成次数</th><th>累次剂量</th>'
                    + '<th>总次数</th><th>疗程</th><th>诊断结果</th><th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    date = patient.PatientInfo[i].date;
                    doctor = patient.PatientInfo[i].doctor;
                    Completed = (patient.PatientInfo[i].Completed == "1") ? "已完成" : "未完成";
                    begin = toTime(patient.PatientInfo[i].begin);
                    end = toTime(patient.PatientInfo[i].end);
                    finishedtimes = patient.PatientInfo[i].finishedtimes;
                    totalnumber = patient.PatientInfo[i].totalnumber;
                    totaltimes = patient.PatientInfo[i].totaltimes;
                    var tr = "<tr id='" + TreatmentID + "_" + patient.PatientInfo[i].appointid + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + date + "," + begin + "-" + end + "</td><td>" + Completed+ "</td><td>" + finishedtimes + "</td><td>" + totalnumber + "</td>"
                        + "<td>" + totaltimes + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + doctor + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClickforJS(patient, userID);
                break;
            case "登记处人员":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            case "科主任":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            default:
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'class='" + TreatmentID + "_";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
        }
    } else {
        var table = $("#patient-table");
        table.html("");
        switch (role) {
            case "医师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "剂量师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "物理师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "模拟技师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>预约项目</th><th>预约时间</th><th>是否完成</th><th>疗程</th><th>诊断结果</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="9" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "治疗技师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>预约时间</th><th>是否完成</th><th>完成次数</th><th>累次剂量</th>'
                    + '<th>总次数</th><th>疗程</th><th>诊断结果</th><th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="11" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "科主任":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "登记处人员":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            default:
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
        }
        $("#patient_info").text("共0条记录");
    }
    Recover();
}

function adjustTable(){
    var table = $("#patient-table");
    var tbody = table.find("tbody");
    var trs = tbody.find("tr");
    var CollapseSwitch = $("#CollapseSwitch");
    CollapseSwitch.unbind("click").click(function(){
        if ($(this).find("i")[0].className == "fa fa-fw fa-toggle-off") {
            openTr();
            $(this).find("i")[0].className = "fa fa-fw fa-toggle-on";
        }else{
            closeTr();
            $(this).find("i")[0].className = "fa fa-fw fa-toggle-off";
        }
    });
    trs.each(function(index, element){
        if ($(this).attr("class").split("_")[1] == "Parent") {
            if ($(this).next().attr("class").split("_")[1] == "Child") {
                $(this).find("td").find("i")[0].className = "fa fa-fw fa-angle-double-down";
            }
            $(this).find("td").each(function(index, element){
                if (index == 0) {
                    $(this).unbind("click").click(function(){
                        stopBubble(this);
                        CollapseTr(this);
                    });
                    return false;
                }
            });
        }else{
            $(this).css("display","none");
        }
    });
}

function CollapseTr(element){
    if ($(element).find("i")[0].className == "fa fa-fw fa-angle-double-down") {
        $(element).find("i")[0].className = "fa fa-fw fa-angle-double-up";
        $(element).parent().nextAll().each(function(){
            if ($(this).attr("class").split("_")[1] == "Child") {
                $(this).fadeIn(360);
            }else{
                return false;
            }
        });
    }else{
        $(element).find("i")[0].className = "fa fa-fw fa-angle-double-down";
        $(element).parent().nextAll().each(function(){
            if ($(this).attr("class").split("_")[1] == "Child") {
                $(this).fadeOut(180);
            }else{
                return false;
            }
        });
    }
}

function openTr(){
    var table = $("#patient-table");
    tbody = table.find("tbody");
    trs = tbody.find("tr");
    trs.each(function(index, element){
        $(this).fadeIn(360);
        if ($(this).find("td").find("i")[0].className != ""){
            $(this).find("td").find("i")[0].className = "fa fa-fw fa-angle-double-up";
        }
    });
}

function closeTr(){
    var table = $("#patient-table");
    tbody = table.find("tbody");
    trs = tbody.find("tr");
    trs.each(function(index, element){
        if ($(this).attr("class").split("_")[1] == "Child") {
            $(this).fadeOut(180);
        }
        if ($(this).find("td").find("i")[0].className != ""){
            $(this).find("td").find("i")[0].className = "fa fa-fw fa-angle-double-down";
        }
    });
}

function trAddClick(patient, userID) {
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        $("#" + patient.PatientInfo[i].treatID + "").click({ appointid: patient.PatientInfo[i].appointid, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, ID: patient.PatientInfo[i].treatID, treat: patient.PatientInfo[i].treat, count: patient.PatientInfo[i].Progress }, function (e) {
            currentID = e.data.ID;
            checkAddTreatment(e.data.Radiotherapy_ID);
            OperateAttrDisabled();
            //$("#addTreatment").removeAttr("disabled");
            var ul = $("#progress-iframe").contents().find("#ul-progress a");
            ul.each(function (index, element) {
                $(this).find('span').removeClass();
            });
            $("#record-iframe").attr('src', "Records/Blank.aspx");
            //$("#patient-status").text(e.data.state);
            var tr = $("#patient-table tbody tr");
            tr.each(function (index, element) {
                if ($(this).hasClass("chose")) {
                    $(this).removeClass("chose");
                }
            });
            $(this).addClass("chose");
            Progresses = e.data.count.split(",");
            ul.each(function (index, element) {
                switch (index) {
                    case 0:
                        $(this).find('li').removeClass().addClass("progress-finished");
                        $(this).find('i').removeClass().addClass("fa fa-fw fa-check");
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/PatientRegister.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("0");
                        });
                        break;
                    case 1:
                        if (LightLi(this, Progresses, "1", "0", "-1")) {
                            var url = "Records/Diagnose.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("1");
                        });
                        break;
                    case 2:
                        if (LightLi(this, Progresses, "2", "1", "-1")) {
                            var url = "Records/FixedApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Fixed";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("2");
                            tem(userID, 2);
                        });
                        break;
                    case 3:
                        if (LightLi(this, Progresses, "3", "2", "-1")) {
                            var url = "Records/LocationApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("3");
                            tem(userID, 3);
                        });
                        break;
                    case 4:
                        if (LightLi(this, Progresses, "4", "2", "-1")) {
                            var url = "Records/FixedRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("4");
                        });
                        break;
                    case 5:
                        if (LightLi(this, Progresses, "5", "4", "3")) {
                            var url = "Records/LocationRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("5");
                        });
                        break;
                    case 6:
                        if (LightLi(this, Progresses, "6", "5", "-1")) {
                            var url = "Records/ImportCT.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("6");
                        });
                        break;
                    case 7:
                        if (LightLi(this, Progresses, "7", "6", "-1")) {
                            var url = "Records/DesignApply.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("7");
                            tem(userID, 7);
                        });
                        break;
                    case 8:
                        if (LightLi(this, Progresses, "8", "7", "-1")) {
                            var url = "Records/DesignReceive.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("8");
                        });
                        break;
                    case 9:
                        if (LightLi(this, Progresses, "9", "8", "-1")) {
                            var url = "Records/DesignSubmit.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("9");
                        });
                        break;
                    case 10:
                        if (LightLi(this, Progresses, "10", "9", "-1")) {
                            var url = "Records/DesignConfirm.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("10");
                        });
                        break;
                    case 11:
                        if (LightLi(this, Progresses, "11", "10", "-1")) {
                            var url = "Records/DesignReview.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("11");
                        });
                        break;
                    case 12:
                        if (LightLi(this, Progresses, "12", "10", "-1")) {
                            var url = "Records/ReplacementApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Replacement";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("12");
                        });
                        break;
                    case 13:
                        if (LightLi(this, Progresses, "13", "12", "-1")) {
                            var url = "Records/ReplacementRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("13");
                        });
                        break;
                    case 14:
                        if (LightLi(this, Progresses, "14", "13", "-1")) {
                            var url = "Records/FirstAccelerator.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Accelerator";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("14");
                        });
                        break;
                    case 15:
                        if (LightLi(this, Progresses, "15", "13", "-1")) {
                            var url = "Records/TreatmentRecord.aspx?TreatmentID=" + e.data.ID + "&appointid=" + e.data.appointid;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("15");
                        });
                        break;
                    case 16:
                        if (LightLi(this, Progresses, "16", "15", "-1")) {
                            var url = "Records/Summary.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("16");
                        });
                        break;
                    default:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/Error.aspx");
                        });
                }
            });

        });
    }
}

function trAddClickforJS(patient, userID) {
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        $("#" + patient.PatientInfo[i].treatID + "_" + patient.PatientInfo[i].appointid).click({ appointid: patient.PatientInfo[i].appointid, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, ID: patient.PatientInfo[i].treatID, treat: patient.PatientInfo[i].treat, count: patient.PatientInfo[i].Progress }, function (e) {
            currentID = e.data.ID;
            checkAddTreatment(e.data.Radiotherapy_ID);
            OperateAttrDisabled();
            //$("#addTreatment").removeAttr("disabled");
            var ul = $("#progress-iframe").contents().find("#ul-progress a");
            ul.each(function (index, element) {
                $(this).find('span').removeClass();
            });
            $("#record-iframe").attr('src', "Records/Blank.aspx");
            //$("#patient-status").text(e.data.state);
            var tr = $("#patient-table tbody tr");
            tr.each(function (index, element) {
                if ($(this).hasClass("chose")) {
                    $(this).removeClass("chose");
                }
            });
            $(this).addClass("chose");
            Progresses = e.data.count.split(",");
            ul.each(function (index, element) {
                switch (index) {
                    case 0:
                        $(this).find('li').removeClass().addClass("progress-finished");
                        $(this).find('i').removeClass().addClass("fa fa-fw fa-check");
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/PatientRegister.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("0");
                        });
                        break;
                    case 1:
                        if (LightLi(this, Progresses, "1", "0", "-1")) {
                            var url = "Records/Diagnose.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("1");
                        });
                        break;
                    case 2:
                        if (LightLi(this, Progresses, "2", "1", "-1")) {
                            var url = "Records/FixedApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Fixed";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("2");
                            tem(userID, 2);
                        });
                        break;
                    case 3:
                        if (LightLi(this, Progresses, "3", "2", "-1")) {
                            var url = "Records/LocationApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("3");
                            tem(userID, 3);
                        });
                        break;
                    case 4:
                        if (LightLi(this, Progresses, "4", "2", "-1")) {
                            var url = "Records/FixedRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("4");
                        });
                        break;
                    case 5:
                        if (LightLi(this, Progresses, "5", "4", "3")) {
                            var url = "Records/LocationRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("5");
                        });
                        break;
                    case 6:
                        if (LightLi(this, Progresses, "6", "5", "-1")) {
                            var url = "Records/ImportCT.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("6");
                        });
                        break;
                    case 7:
                        if (LightLi(this, Progresses, "7", "6", "-1")) {
                            var url = "Records/DesignApply.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("7");
                            tem(userID, 7);
                        });
                        break;
                    case 8:
                        if (LightLi(this, Progresses, "8", "7", "-1")) {
                            var url = "Records/DesignReceive.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("8");
                        });
                        break;
                    case 9:
                        if (LightLi(this, Progresses, "9", "8", "-1")) {
                            var url = "Records/DesignSubmit.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("9");
                        });
                        break;
                    case 10:
                        if (LightLi(this, Progresses, "10", "9", "-1")) {
                            var url = "Records/DesignConfirm.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("10");
                        });
                        break;
                    case 11:
                        if (LightLi(this, Progresses, "11", "10", "-1")) {
                            var url = "Records/DesignReview.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("11");
                        });
                        break;
                    case 12:
                        if (LightLi(this, Progresses, "12", "10", "-1")) {
                            var url = "Records/ReplacementApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Replacement";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("12");
                        });
                        break;
                    case 13:
                        if (LightLi(this, Progresses, "13", "12", "-1")) {
                            var url = "Records/ReplacementRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("13");
                        });
                        break;
                    case 14:
                        if (LightLi(this, Progresses, "14", "13", "-1")) {
                            var url = "Records/FirstAccelerator.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Accelerator";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("14");
                        });
                        break;
                    case 15:
                        if (LightLi(this, Progresses, "15", "13", "-1")) {
                            var url = "Records/TreatmentRecord.aspx?TreatmentID=" + e.data.ID + "&appointid=" + e.data.appointid;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("15");
                        });
                        break;
                    case 16:
                        if (LightLi(this, Progresses, "16", "15", "-1")) {
                            var url = "Records/Summary.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("16");
                        });
                        break;
                    default:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/Error.aspx");
                        });
                }
            });

        });
    }
}

function LightLi(e, Progresses, currentProgress, preProgress, preProgress2) {
    var flag = 0;
    for (var i = 0; i < Progresses.length; i++) {
        if (Progresses[i] == currentProgress) {
            flag = 3;
            break;
        } else {
            if (preProgress2 != -1) {
                if (Progresses[i] == preProgress) {
                    flag++;
                }
                if (Progresses[i] == preProgress2) {
                    flag++;
                }
            } else {
                if (Progresses[i] == preProgress) {
                    flag = 2;
                }
            }
        }
    }
    switch (flag) {
        case 0:
            $(e).find('li').removeClass().addClass("progress-unfinished");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-ban");
            return false;
        case 1:
            $(e).find('li').removeClass().addClass("progress-unfinished");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-ban");
            return false;
        case 2:
            $(e).find('li').removeClass().addClass("progress-active");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-edit");
            return true;
        case 3:
            $(e).find('li').removeClass().addClass("progress-finished");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-check");
            return true;
        default:
            return false;
    }
}

function BubbleSort(arr) {
    for (var i = 0; i < arr.length - 1; i++) {
        for (var j = 0; j < arr.length - 1 - i; j++) {
            if (arr[j] > arr[j + 1]) {
                var temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
    return arr;
}

function ProgressToString(pro) {
    var Progress = "";
    var currentProgress = new Array();
    var count = 0;
    for (var i = 0; i < pro.length; i++) {
        pro[i] = parseInt(pro[i]);
    }
    length = pro.length;
    pro = BubbleSort(pro);
    if (pro[length - 1] == (length - 1)) {
        currentProgress[count++] = length;
    }
    switch (length) {
        case 3:
            currentProgress[count++] = 4;
            break;
        case 4:
            if (pro[length - 1] != (length - 1)) {
                currentProgress[count++] = 3;
            }
            break;
        case 11:
            currentProgress[count++] = 12;
            break;
        case 12:
            if (pro[length - 1] != (length - 1)) {
                currentProgress[count++] = 11;
                currentProgress[count++] = 13;
            }
            break;
        case 13:
            if (pro[length - 1] != (length - 1)) {
                currentProgress[count++] = 11;
            }
            break;
    }
    for (var i = 0; i < currentProgress.length; i++) {
        switch (currentProgress[i]) {
            case 0:
                Progress += "登记信息、";
                break;
            case 1:
                Progress += "病情诊断、";
                break;
            case 2:
                Progress += "体位固定申请、";
                break;
            case 3:
                Progress += "模拟定位申请、";
                break;
            case 4:
                Progress += "体位固定、";
                break;
            case 5:
                Progress += "模拟定位、";
                break;
            case 6:
                Progress += "CT图像导入、";
                break;
            case 7:
                Progress += "计划申请、";
                break;
            case 8:
                Progress += "计划领取、";
                break;
            case 9:
                Progress += "计划提交、";
                break;
            case 10:
                Progress += "计划确认、";
                break;
            case 11:
                Progress += "计划复核、";
                break;
            case 12:
                Progress += "复位申请、";
                break;
            case 13:
                Progress += "复位验证、";
                break;
            case 14:
                Progress += "加速器治疗、";
                break;
            case 15:
                Progress += "加速器治疗、";
                break;
            case 16:
                Progress += "总结随访、";
                break;
            default:
                Progress += "无、";

        }
    }
    return Progress.substring(0, Progress.length - 1);
}

function ProgressNumToName(progressNum){
    var Progress;
    switch (progressNum) {
        case 0:
            Progress = "登记信息";
            break;
        case 1:
            Progress = "病情诊断";
            break;
        case 2:
            Progress = "体位固定申请";
            break;
        case 3:
            Progress = "模拟定位申请";
            break;
        case 4:
            Progress = "体位固定";
            break;
        case 5:
            Progress = "模拟定位";
            break;
        case 6:
            Progress = "CT图像导入";
            break;
        case 7:
            Progress = "计划申请";
            break;
        case 8:
            Progress = "计划领取";
            break;
        case 9:
            Progress = "计划提交";
            break;
        case 10:
            Progress = "计划确认";
            break;
        case 11:
            Progress = "计划复核";
            break;
        case 12:
            Progress = "复位申请";
            break;
        case 13:
            Progress = "复位验证";
            break;
        case 14:
            Progress = "加速器治疗";
            break;
        case 15:
            Progress = "加速器治疗";
            break;
        case 16:
            Progress = "总结随访";
            break;
        default:
            Progress = "无";
    }
    return Progress;
}

function saveTreatment() {
    var diagnose = "";
    var fixed = "";
    var location = "";
    var design = ""
    var replace = "";
    var treatmentname = "";
    var review = "";
    var group = "";
    var Radiotherapy_ID = $("#Radiotherapy_ID").val();
    var Treatmentdescribe = $("#newname").val();
    $("#diagnose").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            diagnose = temp[1];
            group = temp[2];
        }
    });
    $("#fixed").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            fixed = temp[1];
        }
    });
    $("#location").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            location = temp[1];
        }
    });
    $("#design").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            design = temp[1];
            review = temp[2];
        }
    });
    $("#replace").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            replace = temp[1];
        }
    });
    treatmentname = $("#register").find("td").length;
    //alert("diagnose:" + diagnose + ",fixed:" + fixed + ",location:" + location + ",design:" + design + ",replace:" + replace + ",treatmentname:" + treatmentname + ",review:" + review + ",group:" + group + ",Radiotherapy_ID:" + Radiotherapy_ID);
    $("#addTreatmentRecord").html("");
    $.ajax({
        type: "post",
        url: "../../pages/main/records/AddTreatment.ashx",
        async: true,
        datetype: "json",
        data: {
            diagnose: diagnose,
            fixed: fixed,
            location: location,
            design: design,
            replace: replace,
            treatmentname: treatmentname,
            Treatmentdescribe: Treatmentdescribe,
            review: review,
            group: group,
            Radiotherapy_ID: Radiotherapy_ID

        },
        success: function (data) {
            alert("新增成功！");
            $("#addTreatmentRecord").html("");
            var patient = getpatient();
            paging(patient);
        },
        error: function () {
            alert("error");
        }
    });
}

function checkAddTreatment(Radiotherapy_ID) {
    $("#manageTreatment").attr("disabled", "disabled");
    for (var i = 0; i < functions.length; i++) {
        if (functions[i].toString() == "18") {
            $("#manageTreatment").removeAttr("disabled");
            $("#Radiotherapy_ID").val(Radiotherapy_ID);
            $("#addTreatment").unbind("click").click({ Radiotherapy_ID: Radiotherapy_ID }, function (e) {
                $("#registerDetail").html("未选择");
                $("#diagnoseDetail").html("未选择");
                $("#fixedDetail").html("未选择");
                $("#locationDetail").html("未选择");
                $("#designDetail").html("未选择");
                $("#replaceDetail").html("未选择");
                $.ajax({
                    type: "POST",
                    url: "../../pages/Main/Records/getallcompletedtreat.ashx",
                    async: true,
                    dateType: "text",
                    data: { Radiotherapy_ID: e.data.Radiotherapy_ID },
                    success: function (data) {
                        var table = $("#addTreatmentRecord");
                        table.html("");
                        var thead = '<thead><tr id="progress"><th>流程</th></tr></thead>';
                        var tbody = '<tbody><tr id="register"><td>患者登记<i></i></td></tr>' +
                            '<tr id="diagnose"><td>病情诊断<i></i></td></tr>' +
                            '<tr id="fixed"><td>体位固定<i></i></td></tr><tr id="location"><td>CT模拟<i></i></td></tr>' +
                            '<tr id="design"><td>计划设计<i></i></td></tr><tr id="replace"><td>复位验证<i></i></td></tr></tbody>';
                        table.append(thead);
                        table.append(tbody);
                        obj = $.parseJSON(data);
                        var newTreatname = obj.treatinfo.length + 1;
                        $("#newname").val("疗程" + newTreatname);
                        for (var i = 0; i < obj.treatinfo.length; i++) {
                            var th = '<th>疗程' + obj.treatinfo[i].Treatmentdescribe + '</th>';
                            $("#progress").append(th);

                            var td0 = '<td id="register_' + i + '"><i></i></td>';
                            $("#register").append(td0);
                            $("#register_" + i).click({ i: i }, function (e) {
                                if ($(this).find("i")[0].className != "") {
                                    $(this).find("i").removeClass();
                                    $(this).parent().nextAll().each(function () {
                                        $(this).find("td").each(function () {
                                            $(this).find("i").removeClass();
                                        });
                                    });
                                    $("#registerDetail").html("未选择");
                                    $("#diagnoseDetail").html("未选择");
                                    $("#fixedDetail").html("未选择");
                                    $("#locationDetail").html("未选择");
                                    $("#designDetail").html("未选择");
                                    $("#replaceDetail").html("未选择");
                                } else {
                                    var currentrowselected = 0;
                                    $(this).parent().find("td").each(function () {
                                        if ($(this).find("i")[0].className != "") {
                                            currentrowselected = 1;
                                        }
                                    });
                                    if (currentrowselected == 0) {
                                        $(this).find("i").addClass("fa fa-fw fa-check");
                                        $("#registerDetail").html("");
                                        var details = obj.treatinfo[e.data.i].rigester.split("。");
                                        for (var i = 0; i < details.length; i++) {
                                            var p = '<p>' + details[i] + '</p>';
                                            $("#registerDetail").append(p);
                                        }
                                    } else {
                                        alert("每一行只能选择一个模块复用！");
                                    }
                                }
                            });

                            if (obj.treatinfo[i].diagnose != "") {
                                var td1 = '<td id="diagnose_' + obj.treatinfo[i].diagnose + '_' + obj.treatinfo[i].group + '_' + i + '"><i></i></td>';
                                $("#diagnose").append(td1);
                                $("#diagnose_" + obj.treatinfo[i].diagnose + "_" + obj.treatinfo[i].group + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                        $("#diagnoseDetail").html("未选择");
                                        $("#fixedDetail").html("未选择");
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                                $("#diagnoseDetail").html("");
                                                var details = obj.treatinfo[e.data.i].diagnosecomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#diagnoseDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td1 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#diagnose").append(td1);
                            }

                            if (obj.treatinfo[i].fixed != "") {
                                var td2 = '<td id="fixed_' + obj.treatinfo[i].fixed + '_' + i + '"><i></i></td>';
                                $("#fixed").append(td2);
                                $("#fixed_" + obj.treatinfo[i].fixed + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                        $("#fixedDetail").html("未选择");
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                                $("#fixedDetail").html("");
                                                var details = obj.treatinfo[e.data.i].fixcomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#fixedDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td2 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#fixed").append(td2);
                            }

                            if (obj.treatinfo[i].location != "") {
                                var td3 = '<td id="location_' + obj.treatinfo[i].location + '_' + i + '"><i></i></td>';
                                $("#location").append(td3);
                                $("#location_" + obj.treatinfo[i].location + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                                $("#locationDetail").html("");
                                                var details = obj.treatinfo[e.data.i].locationcomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#locationDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td3 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#location").append(td3);
                            }

                            if (obj.treatinfo[i].design != "") {
                                var td4 = '<td id="design_' + obj.treatinfo[i].design + '_' + obj.treatinfo[i].review + '_' + i + '"><i></i></td>';
                                $("#design").append(td4);
                                $("#design_" + obj.treatinfo[i].design + "_" + obj.treatinfo[i].review + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                                $("#designDetail").html("");
                                                var details = obj.treatinfo[e.data.i].designcomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#designDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td4 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#design").append(td4);
                            }

                            if (obj.treatinfo[i].replace != "") {
                                var td5 = '<td id="replace_' + obj.treatinfo[i].replace + '_' + i + '"><i></i></td>';
                                $("#replace").append(td5);
                                $("#replace_" + obj.treatinfo[i].replace + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                                $("#replaceDetail").html("");
                                                var details = obj.treatinfo[e.data.i].replacecomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#replaceDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td5 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#replace").append(td5);
                            }
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            });
            return true;
        }
    }
    return false;
}

function checkEdit(str) {
    $('#edit').attr("disabled", "disabled");
    $('#save').attr("disabled", "disabled");
    $('#saveTemplate-list').attr("disabled", "disabled");
    $("#chooseTemplate").attr("disabled", "disabled");
    $("#Template-List").attr("disabled", "disabled");
    var activeProgress = getProgressActive();
    for (var i = 0; i < functions.length; i++) {
        if (functions[i] == str) {
            for (var j = 0; j < activeProgress.length; j++) {
                if (activeProgress[j].toString() == str || "0" == str) {
                    $("#edit").removeAttr("disabled");
                    return true;
                }
            }
        }
    }
    return false;
}

function Template() {
    $("#Template").modal({ backdrop: 'static' });
    $("#saveTemplate").unbind("click").click(function () {
        var TemplateName = $("#templateName").val();
        $("#record-iframe")[0].contentWindow.saveTemplate(TemplateName);
    });
}

function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
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

function removeSession() {
    $.ajax({
        type: "GET",
        url: "../../Root/removeSession.ashx"
    });
}

function Recover() {
    if (currentID != "0" && $("#" + currentID).length > 0) {
        $("#" + currentID).click();
    }
}

function Search(str, patient, role) {
    var Searchedpatient = new Array();
    var count = 0;
    switch (role) {
        case "医师":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                doctor = patient.PatientInfo[i].doctor;
                groupname = patient.PatientInfo[i].groupname;
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || Progress.search(str) >= 0 || doctor.search(str) >= 0 || groupname.search(str) >= 0) {
                    var singlepatient = { treat: treat, treatID: TreatmentID, Name: Name, Radiotherapy_ID: Radiotherapy_ID, doctor: doctor, Progress: patient.PatientInfo[i].Progress, groupname: groupname, diagnosisresult: patient.PatientInfo[i].diagnosisresult };
                    Searchedpatient[count++] = singlepatient;
                }
            }
            break;
        case "剂量师":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                doctor = patient.PatientInfo[i].doctor;
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || Progress.search(str) >= 0 || doctor.search(str) >= 0) {
                    var singlepatient = { treat: treat, treatID: TreatmentID, Name: Name, Radiotherapy_ID: Radiotherapy_ID, doctor: doctor, Progress: patient.PatientInfo[i].Progress, diagnosisresult: patient.PatientInfo[i].diagnosisresult };
                    Searchedpatient[count++] = singlepatient;
                }
            }
            break;
        case "物理师":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                doctor = patient.PatientInfo[i].doctor;
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || Progress.search(str) >= 0 || doctor.search(str) >= 0) {
                    var singlepatient = { treat: treat, treatID: TreatmentID, Name: Name, Radiotherapy_ID: Radiotherapy_ID, doctor: doctor, Progress: patient.PatientInfo[i].Progress, diagnosisresult: patient.PatientInfo[i].diagnosisresult };
                    Searchedpatient[count++] = singlepatient;
                }
            }
            break;
        case "模拟技师":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                if (i < patient.PatientInfo.length - 1) {
                    if (patient.PatientInfo[i].treatID == patient.PatientInfo[i + 1].treatID) {
                        TreatmentID = patient.PatientInfo[i].treatID;
                        Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                        Name = patient.PatientInfo[i].Name;
                        treat = patient.PatientInfo[i].treat;
                        diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                        Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                        Task = "复位验证";
                        date = patient.PatientInfo[i].date;
                        doctor = patient.PatientInfo[i].doctor;
                        Completed = (patient.PatientInfo[i].Completed == "1") ? "已完成" : "未完成";
                        begin = toTime(patient.PatientInfo[i].begin);
                        end = toTime(patient.PatientInfo[i + 1].end);
                        if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || date.search(str) >= 0 || Task.search(str) >= 0 || begin.search(str) >= 0 || end.search(str) >= 0 || doctor.search(str) >= 0 || Completed.search(str) >= 0) {
                            var singlepatient1 = { treat: patient.PatientInfo[i].treat, treatID: patient.PatientInfo[i].treatID, date: patient.PatientInfo[i].date, Name: patient.PatientInfo[i].Name, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, doctor: patient.PatientInfo[i].doctor, Progress: patient.PatientInfo[i].Progress, begin: patient.PatientInfo[i].begin, end: patient.PatientInfo[i].end, diagnosisresult: patient.PatientInfo[i].diagnosisresult, Completed: patient.PatientInfo[i].Completed, Task:patient.PatientInfo[i].Task };
                            var singlepatient2 = { treat: patient.PatientInfo[i].treat, treatID: patient.PatientInfo[i].treatID, date: patient.PatientInfo[i].date, Name: patient.PatientInfo[i].Name, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, doctor: patient.PatientInfo[i].doctor, Progress: patient.PatientInfo[i].Progress, begin: patient.PatientInfo[i].begin, end: patient.PatientInfo[i].end, diagnosisresult: patient.PatientInfo[i].diagnosisresult, Completed: patient.PatientInfo[i].Completed, Task:patient.PatientInfo[i].Task };
                            Searchedpatient[count++] = singlepatient1;
                            Searchedpatient[count++] = singlepatient2;
                        }
                        i++;
                        continue;
                    }
                }
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                date = patient.PatientInfo[i].date;
                Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                Task = patient.PatientInfo[i].Task;
                doctor = patient.PatientInfo[i].doctor;
                Completed = (patient.PatientInfo[i].Completed == "1") ? "已完成" : "未完成";
                begin = toTime(patient.PatientInfo[i].begin);
                end = toTime(patient.PatientInfo[i].end);
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || date.search(str) >= 0 || Task.search(str) >= 0 || begin.search(str) >= 0 || end.search(str) >= 0 || doctor.search(str) >= 0 || Completed.search(str) >= 0) {
                    var singlepatient = { treat: patient.PatientInfo[i].treat, treatID: patient.PatientInfo[i].treatID, date: patient.PatientInfo[i].date, Name: patient.PatientInfo[i].Name, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, doctor: patient.PatientInfo[i].doctor, Progress: patient.PatientInfo[i].Progress, begin: patient.PatientInfo[i].begin, end: patient.PatientInfo[i].end, diagnosisresult: patient.PatientInfo[i].diagnosisresult, Completed: patient.PatientInfo[i].Completed, Task:patient.PatientInfo[i].Task };
                    Searchedpatient[count++] = singlepatient;
                }
            }
            break;
        case "科主任":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                doctor = patient.PatientInfo[i].doctor;
                groupname = patient.PatientInfo[i].groupname;
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || Progress.search(str) >= 0 || doctor.search(str) >= 0 || groupname.search(str) >= 0) {
                    var singlepatient = { treat: treat, treatID: TreatmentID, Name: Name, Radiotherapy_ID: Radiotherapy_ID, doctor: doctor, Progress: patient.PatientInfo[i].Progress, groupname: groupname, diagnosisresult: patient.PatientInfo[i].diagnosisresult };
                    Searchedpatient[count++] = singlepatient;
                }
            }
            break;
    }
    var patientGroup = { PatientInfo: Searchedpatient };
    return patientGroup;
}

function getProgressActive() {
    var ul = $("#progress-iframe").contents().find("#ul-progress a");
    var indexs = new Array();
    var count = 0;
    var activeProgress = ul.each(function (index, element) {
        if ($(this).find('li').hasClass("progress-active")) {
            indexs[count++] = index;
        }
    });
    return indexs;
}

function getActive() {
    var ul = $("#page-index-content li");
    var active;
    ul.each(function (index, element) {
        if ($(this).hasClass("active")) {
            active = index - 2;
        }
    });
    return active;
}

function getChose() {
    var tr = $("#patient-table-body tr");
    tr.each(function (index, element) {
        if ($(this).hasClass("chose")) {
            return index;
        } else {
            return null;
        }
    });
}

function getPatient(userID, role, parameters) {
    var xmlHttp = new XMLHttpRequest();
    var xmlHttp = new XMLHttpRequest();
    switch (role) {
        case "医师":
            var url = "Records/patientInfoForDoctor.ashx?userID=" + userID;
            break;
        case "剂量师":
            var url = "Records/patientInfoForJLS.ashx?userID=" + userID;
            break;
        case "物理师":
            var url = "Records/patientInfoForWLS.ashx?userID=" + userID;
            break;
        case "模拟技师":
            var url = "Records/patientInfoForMNJS.ashx?equipmentid=" + parameters[0] + "&date1=" + parameters[1] + "&date2=" + parameters[2];
            break;
        case "治疗技师":
            var url = "Records/patientInfoForZLJS.ashx?equipmentid=" + parameters[0] + "&date1=" + parameters[1] + "&date2=" + parameters[2];
            break;
        case "登记处人员":
            var url = "Records/GetPatientInfo.ashx?";
            break;
        case "科主任":
            var url = "Records/GetPatientInfo.ashx?";
            break;
        default:
            var url = "Records/GetPatientInfo.ashx?";
    }
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var patient = eval("(" + json + ")");
    return patient;
}

function getTaskWarning(){
    var taskwarning;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getallwarning.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            taskwarning = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return taskwarning;
}

function TaskWarning(patient){
    var TaskWarning = getTaskWarning();
    var WarningTaskContent = $("#TaskWarning-content");
    var WarningTask = $("#WarningTask");
    var WarningNum = $("#WarningNum");
    WarningTaskContent.html("");
    if (patient.PatientInfo != "") {
        for (var i = 0; i < patient.PatientInfo.length; i++) {
            var progress = patient.PatientInfo[i].Progress.split(",");
            for (var j = 0; j < progress.length; j++) {
                progress[j] = parseInt(progress[j]);
            }
            var progressInt = BubbleSort(progress)
            var currentProgress = progressInt[progressInt.length - 1];
            for (var k = 0; k < TaskWarning.Item.length; k++) {
                if (currentProgress == TaskWarning.Item[k].Progress) {
                    SingleTask(TaskWarning.Item[k].light, TaskWarning.Item[k].serious, patient.PatientInfo[i], currentProgress);
                }
            }
        }
    }
    var TaskWarningNum = WarningTaskContent.find("li").length;
    WarningTask.html("你有"+ TaskWarningNum +"条工作任务预警");
    WarningNum.html(TaskWarningNum);
}

function SingleTask(light, serious, singlepatient, currentProgress){
    var WarningTaskContent = $("#TaskWarning-content");
    var singletask;
    var currentTime = new Date();
    var completedTime;
    switch(currentProgress){
        case 5:
            completedTime = new Date(singlepatient.locationTime);
            break;
        case 6:
            completedTime = new Date(singlepatient.LoadCTTime);
            break;
        case 7:
            completedTime = new Date(singlepatient.designApplyTime);
            break;
        case 8:
            completedTime = new Date(singlepatient.receiveTime);
            break;
        case 9:
            completedTime = new Date(singlepatient.designSubmitTime);
            break;
        case 10:
            completedTime = new Date(singlepatient.confirmTime);
            break;
    }
    var TimeDifference = (currentTime.getTime() - completedTime.getTime())/3600000;
    if (TimeDifference > light) {
        if (TimeDifference < serious) {
            singletask = '<li><a href="javascript:;"><i class="fa fa-warning text-yellow"></i>'
                + singlepatient.Name + '，' + singlepatient.treat + '，' + ProgressNumToName(currentProgress + 1) + '，已搁置' + TimeDifference.toFixed(1) + '小时'
                + '</a></li>';
        }else{
            singletask = '<li><a href="javascript:;"><i class="fa fa-warning text-red"></i>'
                + singlepatient.Name + '，' + singlepatient.treat + '，' + ProgressNumToName(currentProgress + 1) + '，已搁置' + TimeDifference.toFixed(1) + '小时'
                + '</a></li>';
        }
    }
    WarningTaskContent.append(singletask);
}

function getNotice(role){
    var notice;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getNews.ashx?role=" + role,
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            notice = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return notice;
}

function Notice(role){
    var notice = getNotice(role);
    var NoticeContent = $("#Notice");
    var NoticeNum = $("#NoticeNum");
    var allNotice = $("#allNotice");
    NoticeContent.html("");
    for (var i = 0; i < notice.patientInfo.length; i++) {
        var singleNotice = '<li><a href="Notice.aspx?ID=' + notice.patientInfo[i].ID + '" target="_blank"><h4>';
        if (notice.patientInfo[i].Important == '1') {
            singleNotice += '<i class="fa fa-hand-pointer-o"></i>';
        }else{
            singleNotice +='<i class="fa fa-tag"></i>';
        }
        singleNotice += limitString(notice.patientInfo[i].Title, 18);
        singleNotice += '</h4><p class="pull-right"><i class="fa fa-user"></i>'
        singleNotice += notice.patientInfo[i].Release_User_Name;
        singleNotice += '&nbsp;<i class="fa fa-clock-o"></i>';
        singleNotice += formatTime(notice.patientInfo[i].Releasetime);
        singleNotice += '</p>';
        NoticeContent.append(singleNotice);
    }
    NoticeNum.html(NoticeContent.find("li").length);
    allNotice.attr("href", "newsList.aspx?role=" + role);
}

function formatTime(time){
    NoticeTime = new Date(time).Format("yyyy-MM-dd");
    currentTime = new Date().Format("yyyy-MM-dd");
    preDate = new Date(new Date().getTime() - 24*60*60*1000).Format("yyyy-MM-dd");
    if (NoticeTime == currentTime) {
        return "今天";
    }else{
        if (NoticeTime == preDate) {
            return "昨天";
        }
    }
    return NoticeTime;
}

function limitString(str, num){
    var ls;
    if (str.length > num) {
        ls = str.substring(0, num -1) + "…";
        return ls;
    }else{
        return str;
    }
}

function chooseEquipment() {
    $("#chooseMachine").modal({ backdrop: 'static' });
    var session = getSession();
    $("#equipmentType").html("");
    switch (session.role) {
        case "模拟技师":
            var options = '<option value="">----选择项目----</option><option value="体位固定">体位固定</option><option value="模拟定位">CT模拟</option><option value="复位模拟">复位验证</option>';
            $("#equipmentType").append(options);
            break;
        case "治疗技师":
            var options = '<option value="">----选择项目----</option><option value="加速器">加速器治疗</option>';
            $("#equipmentType").append(options);
            break;
    }
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


    var currentTime = new Date().Format("yyyy-MM-dd");
    $("#startdate").val(currentTime);
    $("#enddate").val(currentTime);
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

function OperateAttrDisabled() {
    $("#save").attr("disabled", "disabled");
    $("#saveTemplate-list").attr("disabled", "disabled");
    $("#chooseTemplate").attr("disabled", "disabled");
    $('#edit').attr("disabled", "disabled");
}

function tem(userID, type) {
    var template = Templatechoose(userID, type);
    var tbody = $("#TemplateTable tbody");
    tbody.html("");
    for (var i = 0; i < template.length; i++) {
        var tr = '<tr id="Template_'+ template[i].ID +'"><td style="text-align:center;"><label><input type="radio" name="singleTemplate" class="minimal"></label></td><td>'+ template[i].Name +'</td></tr>';
        tbody.append(tr);
    }
    var tr = '<tr><td></td><td></td></tr>';
    tbody.append(tr);
    $('input[type="radio"].minimal').iCheck({
        checkboxClass: 'icheckbox_minimal-blue',
        radioClass: 'iradio_minimal-blue'
    });
    $("#confirm-Template").click(function(){
        var tbody = $("#TemplateTable tbody");
        $("#record-iframe")[0].contentWindow.chooseTempalte($(".checked").parent().parent().parent().attr("id").split("_")[1]);
    });
}

function Templatechoose(userID, type) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getTemplateType.ashx?userID=" + userID + "&type=" + type;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.templateInfo;
}

function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i].toString()) {
            return true;
        }
    }
    return false;
}

function patientSort(patient){
    var sortPatient = new Array();
    var count = 0;
    for (var j = 0; j < patient.PatientInfo.length; j++) {
        var flag = 0;
        for (var k = 0; k < sortPatient.length; k++) {
            if (sortPatient[k].Radiotherapy_ID == patient.PatientInfo[j].Radiotherapy_ID) {
                flag = 1;
            }
        }
        if (flag == 0) {
            sortPatient[count++] = patient.PatientInfo[j];
            for (var i = j + 1; i < patient.PatientInfo.length; i++) {
                
                if (flag == 0 && sortPatient[count - 1].Radiotherapy_ID == patient.PatientInfo[i].Radiotherapy_ID) {
                    sortPatient[count++] = patient.PatientInfo[i];
                }
            }
        }
    }
    var patientGroup = { PatientInfo: sortPatient };
    return patientGroup;
}

function stopBubble(e) {
    if (e && e.stopPropagation) {//非IE浏览器
    　　e.stopPropagation();
    }
    else {//IE浏览器
    window.event.cancelBubble = true;
    }
}