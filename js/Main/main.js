/* ***********************************************************
 * FileName: main.js
 * Writer: Chenrry
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 主页面JS
 * **********************************************************/
var currentID = 0;
var functions = new Array();
var username;
var rolename;
var flag = true;
var patientALL;
//如果其他账号登录只承认一个session
window.onfocus = function () {
    var session = getSession2();
    if (session.userName != username || session.roleName != rolename) {
        if (flag == true) {
            alert("此计算机被其他账号登入，请关闭此网页重新登录");
            flag = false;
        }
        window.location.href = "/RadiotherapyPlatform/pages/Main/Records/Error.aspx";
    }
};
$(document).ready(function () {
    adjustPage();
    var session = getSession();
    username = session.userName;
    rolename = session.roleName;
    RolesToPatients(session,0);
    adjustTable();

    functions = session.progress.split(" ");

    //保存键
    $("#save").unbind("click").click(function () {
        var result = $("#record-iframe")[0].contentWindow.save();
        if (result == false) {
            return false;
        }
        $('#save').attr("disabled", "disabled");
        $('#saveTemplate-list').attr("disabled", "disabled");
        var session = getSession();
        RolesToPatients(session,0);
        adjustTable();
        Recover();
    });

    //三个病人筛选按钮
    $('#first_but').unbind("click").click(function () {
        var session = getSession();
        RolesToPatients(session, 0);
        adjustTable();
        $('#first_but').removeClass();
        $("#sec_but").removeClass();
        $("#third_but").removeClass();
        $('#first_but').addClass("btn btn-info");
        $('#sec_but').addClass("btn btn-success");
        $('#third_but').addClass("btn btn-success");
    });
    $('#sec_but').unbind("click").click(function () {
        var session = getSession();
        RolesToPatients(session, 1);
        adjustTable();
        $('#first_but').removeClass();
        $("#sec_but").removeClass();
        $("#third_but").removeClass();
        $('#first_but').addClass("btn btn-success");
        $('#sec_but').addClass("btn btn-info");
        $('#third_but').addClass("btn btn-success");
    });
    $('#third_but').unbind("click").click(function () {
        var session = getSession();
        RolesToPatients(session, 2);
        adjustTable();
        $('#first_but').removeClass();
        $("#sec_but").removeClass();
        $("#third_but").removeClass();
        $('#first_but').addClass("btn btn-success");
        $('#sec_but').addClass("btn btn-success");
        $('#third_but').addClass("btn btn-info");
    });

    //编辑键
    $('#edit').unbind("click").click(function () {
        $("#record-iframe")[0].contentWindow.remove();
        $("#save").removeAttr("disabled");
        $("#saveTemplate-list").removeAttr("disabled");
        $("#chooseTemplate").removeAttr("disabled");
        $('#edit').attr("disabled", "disabled");
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

window.onresize=function(){
    adjustPage();
}

//加载页面或者浏览器页面发生变化时，调整页面元素大小使适应浏览器窗口
function adjustPage(){
    $(".frame-content").height($(document).height() - 151);
    $("#patient-content").height($(document).height() - 151);
    $("#patient-table-content").height($(document).height() - 190);
    $("#record-iframe").width($("#record-content").width());
    $("#progress-iframe").width($("#progress-content").width());
}

//根据角色获取病患纪录
function RolesToPatients(session,type) {
    var patient;
    var sortPatient;
    if (session.role == "模拟技师" || session.role == "治疗技师") {
        if (session.equipmentID == "0") {
            chooseEquipment();
        } else {
            var parameters = new Array();
            parameters[0] = session.equipmentID;
            parameters[1] = session.beginTime;
            parameters[2] = session.endTime;
            patient = getPatient(session.userID, session.role, parameters);
            if (patient) {
                sortPatient = patientSort(patient);
                Paging(sortPatient, session.role, session.userID);
                $("#chosenEquipment").html(session.equipmentName);
                $("#dateRange").html(session.beginTime + "~~" + session.endTime);
            }
        }
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
            }/*
            if (startdate < currentTime) {
                alert("开始日期不能小于当天日期！");
                return false;
            }*/
            $("#chosenEquipment").html(equipmentName);
            $("#dateRange").html(startdate + "~~" + enddate);
            var parameters = new Array();
            parameters[0] = equipmentID;
            parameters[1] = startdate;
            parameters[2] = enddate;
            patient = getPatient(session.userID, session.role, parameters);
            if (patient) {
                sortPatient = patientSort(patient);
                Paging(sortPatient, session.role, session.userID);
                adjustTable();
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
            }
        });
        $("#patient-search").bind('input propertychange', function () {
            var Searchedpatients = SearchTable($("#patient-search").val(), sortPatient, session);
            adjustTable();
        });
    } else {
        var parameters = new Array();
        parameters[0] = type;
        patient = getPatient(session.userID, session.role, parameters);
        if (patient) {
            sortPatient = patientSort(patient);
            Paging(sortPatient, session.role, session.userID);
            $("#patient-search").bind('input propertychange', function (e) {
                var Searchedpatients = SearchTable($("#patient-search").val(), sortPatient, session);
                adjustTable();
            });
            //工作预警
            if (session.role == "医师" || session.role == "剂量师" || session.role == "物理师") {
                Taskwarning(sortPatient);
            }
            //病人治疗完成情况预警
            if (session.role == "医师" || session.role == "科主任") {
                completeWarning(sortPatient);
            }

        }
    }
    return sortPatient;
}

//将病患纪录生成表格
function Paging(patient, role, userID) {
    if (patient.PatientInfo != "") {
        tableheight = $("#patient-content").height() - 160;
        var table = $("#patient-table");
        table.html("");
        $("#patient_info").text("一共" + patient.PatientInfo.length + "条记录");
        switch (role) {
            case "医师":
                $("#legend-patientselect").show();
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname,hasfirst;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    hasfirst = (patient.PatientInfo[i].hasfirst == "1") ? "(首次)" : "";
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    iscommon = patient.PatientInfo[i].iscommon;
                    var stateStr = new Array("","(暂停中)","已结束");
                    state = stateStr[parseInt(patient.PatientInfo[i].state)];
                    var tr = "<tr id='" + TreatmentID + "'class='";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td><td>" + Progress + state + hasfirst
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
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    iscommon = patient.PatientInfo[i].iscommon;
                    var stateStr = new Array("","(暂停中)","已结束");
                    state = stateStr[parseInt(patient.PatientInfo[i].state)];
                    var tr = "<tr id='" + TreatmentID + "'class='";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td><td>" + Progress + state
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
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    iscommon = patient.PatientInfo[i].iscommon;
                    var stateStr = new Array("","(暂停中)","已结束");
                    state = stateStr[parseInt(patient.PatientInfo[i].state)];
                    var tr = "<tr id='" + TreatmentID + "'class='";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td><td>" + Progress + state
                        + "</td><td>" + doctor + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            case "模拟技师":
                $("#legend-waiting").show();
                $("#legend-enhance").show();
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Task, date, begin, end, Completed, doctor;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th>'
                    + '<th>患者姓名</th><th>状态</th><th>诊断结果</th><th>疗程</th><th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    date = patient.PatientInfo[i].date;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    Task = patient.PatientInfo[i].Task;
                    doctor = patient.PatientInfo[i].doctor;
                    Completed = (patient.PatientInfo[i].Completed == "1") ? "完成" : "等待";
                    begin = toTime(patient.PatientInfo[i].begin);
                    end = toTime(patient.PatientInfo[i].end);
                    iscommon = patient.PatientInfo[i].iscommon;
                    Enhance = patient.PatientInfo[i].Enhance;
                    if (patient.PatientInfo[i].Completed == "1") {
                        var tr = "<tr id='" + TreatmentID + "_" + patient.PatientInfo[i].appointid + "'class='";
                    }else {
                        var tr = "<tr id='" + TreatmentID + "_" + patient.PatientInfo[i].appointid + "'class='waiting ";
                    }
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    if (Enhance == "1") {
                        tr += " Enhance";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + Completed+ "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td>"
                        + "<td>" + doctor + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClickforJS(patient, userID);
                break;
            case "治疗技师":
                $("#legend-waiting").show();
                var TreatmentID, Name, Gender, patientid, doctor, begin, end, Age, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>预约时间</th><th>放疗号</th><th>患者姓名</th><th>性别</th><th>年龄</th><th>主治医生</th><th>类型</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].name;
                    Gender = patient.PatientInfo[i].Gender;
                    Ishospital = patient.PatientInfo[i].Ishospital == "0" ? "门诊" : "住院";
                    patientid = patient.PatientInfo[i].patientid;
                    doctor = patient.PatientInfo[i].doctor;
                    begin = patient.PatientInfo[i].begin;
                    end = patient.PatientInfo[i].end;
                    date = new Date(patient.PatientInfo[i].Date);
                    Age = patient.PatientInfo[i].Age;
                    groupname = patient.PatientInfo[i].groupname;
                    Completed = (patient.PatientInfo[i].Completed == "1") ? "完成" : "等待";
                    if (patient.PatientInfo[i].Completed == "1") {
                        var tr = "<tr id='" + TreatmentID + "_" + patient.PatientInfo[i].appointid + "'class='";
                    }else {
                        var tr = "<tr id='" + TreatmentID + "_" + patient.PatientInfo[i].appointid + "'class='waiting ";
                    }
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Num2Time(begin, end) +"</td><td>" + Radiotherapy_ID + "</td><td>"+ Name +"</td><td>" + Gender + "</td>" +
                             "<td>" + Age + "</td><td>" + doctor + "</td><td>"+ Ishospital +"</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClickforJS(patient, userID);
                break;
            case "登记处人员":
                $("#legend-patientselect").show();
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    iscommon = patient.PatientInfo[i].iscommon;
                    var stateStr = new Array("","(暂停中)","已结束");
                    state = stateStr[parseInt(patient.PatientInfo[i].state)];
                    var tr = "<tr id='" + TreatmentID + "'class='";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td><td>" + Progress + state
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            case "科主任":
                $("#legend-patientselect").show();
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    iscommon = patient.PatientInfo[i].iscommon;
                    var stateStr = new Array("","(暂停中)","已结束");
                    state = stateStr[parseInt(patient.PatientInfo[i].state)];
                    var tr = "<tr id='" + TreatmentID + "'class='";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td><td>" + Progress + state
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tr += trtemp;
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient, userID);
                break;
            default:
                $("#legend-patientselect").show();
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ? "无" : patient.PatientInfo[i].diagnosisresult;
                    Progress = (patient.PatientInfo[i].state == 2) ? "" : ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = (patient.PatientInfo[i].groupname == "") ? "未分组" : patient.PatientInfo[i].groupname;
                    iscommon = patient.PatientInfo[i].iscommon;
                    var stateStr = new Array("","(暂停中)","已结束");
                    state = stateStr[parseInt(patient.PatientInfo[i].state)];
                    var tr = "<tr id='" + TreatmentID + "'class='";
                    if (i > 0 && patient.PatientInfo[i].Radiotherapy_ID == patient.PatientInfo[i - 1].Radiotherapy_ID) {
                        tr += "Child";
                    }else{
                        tr += "Parent";
                    }
                    trtemp = "'><td><i></i></td><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td style='max-width:160px;overflow:hidden;text-overflow:ellipsis;'>" + diagnosisresult + "</td><td>" + treat + "</td><td>" + Progress + state
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
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "剂量师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "物理师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "模拟技师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>状态</th><th>诊断结果</th><th>疗程</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="9" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "治疗技师":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>预约时间</th><th>放疗号</th><th>患者姓名</th><th>性别</th><th>年龄</th><th>主治医生</th><th>类型</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "科主任":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "登记处人员":
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            default:
                var thead = '<thead><tr><th id="CollapseSwitch"><i class="fa fa-fw fa-toggle-off"></i></th><th>放疗号</th><th>患者姓名</th><th>诊断结果</th><th>疗程</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="8" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
        }
        $("#patient_info").text("共0条记录");
    }
    Recover();
}

//病人多疗程折叠布局调整
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
        if ($(this).next().length > 0 && $(this).hasClass("Parent")) {
            if ($(this).next().hasClass("Child")) {
                $(this).find("td").find("i")[0].className = "fa fa-fw fa-angle-double-down";
            }
            $(this).find("td").each(function(index, element){
                if (index == 0 && $(this).find("i")[0].className != "") {
                    $(this).unbind("click").click(function(){
                        stopBubble(this);
                        CollapseTr(this);
                    });
                    return false;
                }
            });
        }else{
            if ($(this).hasClass("Parent") || $(this).hasClass("Child")) {
                if ($(this).next().length > 0) {
                    $(this).css("display","none");
                }
                if (!$(this).hasClass("Parent")) {
                    $(this).css("display","none");
                }
            }
        }
    });
}

//打开合并在一起的患者纪录
function CollapseTr(element){
    if ($(element).find("i")[0].className == "fa fa-fw fa-angle-double-down") {
        $(element).find("i")[0].className = "fa fa-fw fa-angle-double-up";
        $(element).parent().nextAll().each(function(){
            if ($(this).hasClass("Child")) {
                $(this).fadeIn(360);
            }else{
                return false;
            }
        });
    }else{
        $(element).find("i")[0].className = "fa fa-fw fa-angle-double-down";
        $(element).parent().nextAll().each(function(){
            if ($(this).hasClass("Child")) {
                $(this).fadeOut(180);
            }else{
                return false;
            }
        });
    }
}

//打开同一患者多条纪录
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

//关闭同一患者多条纪录
function closeTr(){
    var table = $("#patient-table");
    tbody = table.find("tbody");
    trs = tbody.find("tr");
    trs.each(function(index, element){
        if ($(this).hasClass("Child")) {
            $(this).fadeOut(180);
        }
        if ($(this).find("td").find("i")[0].className != ""){
            $(this).find("td").find("i")[0].className = "fa fa-fw fa-angle-double-down";
        }
    });
}

function ShowUl(ul, iscommon){
    if (iscommon == 0) {
        ul.each(function (index, element) {
            $(this).show();
            if ((index > 1 && index < 7) || (index >8 && index < 11)) {
                $(this).hide();
            }
            if (index == 12) {
                $(this).hide();
            }
        });
    }else{
        ul.each(function (index, element) {
            $(this).show();
        });
    }
}

//为患者纪录增加点击事件，角色为非技师
function trAddClick(patient, userID) {
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        $("#" + patient.PatientInfo[i].treatID + "").click({iscommon:patient.PatientInfo[i].iscommon, Radiotherapy_ID:patient.PatientInfo[i].Radiotherapy_ID, state:patient.PatientInfo[i].state, appointid: patient.PatientInfo[i].appointid, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, ID: patient.PatientInfo[i].treatID, treat: patient.PatientInfo[i].treat, count: patient.PatientInfo[i].Progress }, function (e) {
            currentID = e.data.ID;
            //checkAddTreatment(e.data.Radiotherapy_ID);
            OperateAttrDisabled();
            //$("#addTreatment").removeAttr("disabled");
            var ul = $("#progress-iframe").contents().find("#ul-progress a");
            ShowUl(ul, e.data.iscommon);
            ul.each(function (index, element) {
                $(this).find('span').removeClass();
            });
            $("#record-iframe").attr('src', "Records/Blank.aspx");
            $("#patient-status").html(StateNumToString(e.data.state));
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
                        $(this).find('li').removeClass().addClass("progress-info");
                        $(this).find('i').removeClass().addClass("fa fa-fw fa-info-circle");
                        var url = "Records/PatientRegister.aspx?TreatmentID=" + e.data.ID + "&Radiotherapy_ID=" + e.data.Radiotherapy_ID;
                        $(this).unbind("click").click(function () {
                            $("#record-iframe").attr('src', url);
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
                        $(this).unbind("click").click(function () {
                            $("#record-iframe").attr('src', url);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                            checkEdit("1");
                            tem(userID, 1);
                        });
                        break;
                    case 2:
                        if (LightLi(this, Progresses, "2", "1", "-1")) {
                            var url = "Records/FixedApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Fixed";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "3", "1", "-1")) {
                            var url = "Records/LocationApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "5", "3", "-1")) {
                            var url = "Records/LocationRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                            var url = "Records/FieldInput.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "12", "11", "-1")) {
                            var url = "Records/DesignReview.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                            var url = "Records/FirstAccelerator.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Accelerator";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "14", "12", "-1")) {
                            var url = "Records/TreatmentRecord.aspx?TreatmentID=" + e.data.ID + "&appointid=" + e.data.appointid;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "15", "14", "-1")) {
                            var url = "Records/Summary.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "16", "1", "-1")) {
                            var url = "Records/TreatmentReview.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
                            $("#record-iframe").attr('src', "Records/Error.aspx");
                        });
                }
            });

        });
    }
}

//为患者纪录增加点击事件，角色为技师
function trAddClickforJS(patient, userID) {
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        $("#" + patient.PatientInfo[i].treatID + "_" + patient.PatientInfo[i].appointid).click({appointid:patient.PatientInfo[i].appointid,iscommon:patient.PatientInfo[i].iscommon, Radiotherapy_ID:patient.PatientInfo[i].Radiotherapy_ID, state:patient.PatientInfo[i].state, appointid: patient.PatientInfo[i].appointid, Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, ID: patient.PatientInfo[i].treatID, treat: patient.PatientInfo[i].treat, count: patient.PatientInfo[i].Progress }, function (e) {
            currentID = e.data.ID + "_" + e.data.appointid;
            //checkAddTreatment(e.data.Radiotherapy_ID);
            OperateAttrDisabled();
            //$("#addTreatment").removeAttr("disabled");
            var ul = $("#progress-iframe").contents().find("#ul-progress a");
            ShowUl(ul, e.data.iscommon);
            ul.each(function (index, element) {
                $(this).find('span').removeClass();
            });
            $("#record-iframe").attr('src', "Records/Blank.aspx");
            $("#patient-status").html(StateNumToString(e.data.state));
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
                        $(this).find('li').removeClass().addClass("progress-info");
                        $(this).find('i').removeClass().addClass("fa fa-fw fa-info-circle");
                        $(this).unbind("click").click(function () {
                            $("#record-iframe").attr('src', "Records/PatientRegister.aspx?TreatmentID=" + e.data.ID + "&Radiotherapy_ID=" + e.data.Radiotherapy_ID);
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "3", "1", "-1")) {
                            var url = "Records/LocationApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "5", "3", "-1")) {
                            var url = "Records/LocationRecord.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
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
                            var url = "Records/FieldInput.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "12", "11", "-1")) {
                            var url = "Records/DesignReview.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                            var url = "Records/FirstAccelerator.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Accelerator";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "14", "12", "-1")) {
                            var url = "Records/TreatmentRecord.aspx?TreatmentID=" + e.data.ID + "&appointid=" + e.data.appointid;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "15", "14", "-1")) {
                            var url = "Records/Summary.aspx?TreatmentID=" + e.data.ID;
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        if (LightLi(this, Progresses, "16", "1", "-1")) {
                            var url = "Records/TreatmentReview.aspx?TreatmentID=" + e.data.ID + "&appointid=" + e.data.appointid + "&TreatmentItem=Location";
                        } else {
                            var url = "Records/Blank.aspx";
                        }
                        $(this).unbind("click").click(function () {
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
                        $(this).unbind("click").click(function () {
                            $("#record-iframe").attr('src', "Records/Error.aspx");
                        });
                }
            });

        });
    }
}

/*
根据当前疗程的Progress
@param Progresses:数据库progress字段;currentProgress:需要判断状态的流程编号;
preProgress:该流程为编辑状态的必要条件1;preProgress2:该流程为编辑状态的必要条件2
*/
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
    var currentProgress;
    for (var i = 0; i < pro.length; i++) {
        pro[i] = parseInt(pro[i]);
    }
    length = pro.length;
    pro = BubbleSort(pro);
    if (pro[length - 1] == (length - 1)) {
        currentProgress = length;
    }
    switch (length) {
        case 3:
            if (pro[length - 1] != (length - 1)) {
                currentProgress = 2;
            }
            break;
        case 4:
            switch(pro[length - 1]){
                case 4:
                    currentProgress = 3;
                    break;
                case 5:
                    currentProgress = 2;
                    break;
            }
            break;
        case 5:
            switch(pro[length - 1]){
                case 2:
                    currentProgress = 4;
                    break;
                case 5:
                    currentProgress = 4;
                    break;
            }
            break;
    }
    switch (currentProgress) {
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
            Progress += "放疗计划导入、";
            break;
        case 12:
            Progress += "计划复核、";
            break;
        case 13:
            Progress += "加速器治疗、";
            break;
        case 14:
            Progress += "加速器治疗、";
            break;
        case 15:
            Progress += "总结随访、";
            break;
        case 16:
            Progress += "CT扫描、";
            break;
        default:
            Progress += "无、";

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
            Progress = "放疗计划导入";
            break;
        case 12:
            Progress = "计划复核";
            break;
        case 13:
            Progress = "加速器治疗";
            break;
        case 14:
            Progress = "加速器治疗";
            break;
        case 15:
            Progress = "总结随访";
            break;
        case 16:
            Progress = "CT扫描";
            break;
        default:
            Progress = "无";
    }
    return Progress;
}

//判断该角色对这一步流程有没有编辑权限
function checkEdit(str) {
    var session = getSession();
    var role = session.role;
    $('#edit').attr("disabled", "disabled");
    $('#save').attr("disabled", "disabled");
    $('#saveTemplate-list').attr("disabled", "disabled");
    $("#chooseTemplate").attr("disabled", "disabled");
    $("#Template-List").attr("disabled", "disabled");
    if (role != "科主任") {
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
    }else{
        $("#edit").removeAttr("disabled");
        return true;
    }
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
function getSession2() {
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

//重新加载患者纪录时恢复原来的点击状态
function Recover() {
    if (currentID != "0" && $("#" + currentID).length > 0) {
        $("#" + currentID).click();
    }
}

//搜索
function SearchTable(str, sortPatient, session) {
    var table = $("#patient-table");
    var filtered;
    switch(session.role)
    {
        case "科主任":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForKZR, str);
            break;
        case "治疗技师":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForZLJS, str);
            break;
        case "模拟技师":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForMNJS, str);
            break;
        case "物理师":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForWLS, str);
            break;
        case "剂量师":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForJLS, str);
            break;
        case "医师":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForYS, str);
            break;
        case "登记处人员":
            filtered = sortPatient.PatientInfo.filter(filterFunctionForDJC, str);
            break;
        default:
            filtered = sortPatient.PatientInfo.filter(filterFunctionForKZR, str);
            break;

    }

    var patientGroup = { PatientInfo: filtered };
    Paging(patientGroup, session.role, session.userID);
    //table.find("tbody tr").hide().filter(":contains('"+ str +"')").show();
    //$("#patient_info").html("一共"+ table.find("tbody tr").filter(":contains('"+ str +"')").length +"条记录");
}


//科主任json过滤函数
function filterFunctionForKZR(element, index, array) {
    var text1 = element.Radiotherapy_ID;
    var text2 = element.Name;
    var text3 = (element.diagnosisresult == "") ? "无" : element.diagnosisresult;
    var text4 = element.treat;
    var text5 = element.doctor;
    var text6 = (element.groupname == "") ? "未分组" : element.groupname;
    var stateStr = new Array("", "(暂停中)", "已结束");
    var state = stateStr[parseInt(element.state)];
    var progress = (element.state == 2) ? "" : ProgressToString(element.Progress.split(","));
    var finalProgress = progress + state;
    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0 || text6.indexOf(this) >= 0) {
        return true;
    }
    if (finalProgress.indexOf(this) >= 0) {
        return true;
    }
    return false;
}

//治疗技师json过滤
function filterFunctionForZLJS(element, index, array) {
    var text1 = Num2Time(element.begin, element.end);
    var text2 = element.Radiotherapy_ID;
    var text3 = element.name;
    var text4 = element.Gender;
    var text5 = element.Age;
    var text6 = element.doctor;
    var text7 = (element.Completed == "1") ? "完成" : "等待";
    var text8 = (element.Ishospital == "0") ? "门诊" : "住院";
    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0 || text8.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0 || text6.indexOf(this) >= 0 || text7.indexOf(this) >= 0) {
        return true;
    }
 
    return false;
}

//模拟技师json过滤
function filterFunctionForMNJS(element, index, array) {
    var text1 = element.Radiotherapy_ID;
    var text2 = element.Name;
    var text3 = (element.Completed == "1") ? "完成" : "等待";
    var text4 = (element.diagnosisresult == "") ? "无" : element.diagnosisresult;
    var text5 = element.treat;
    var text6 = element.doctor;

    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0 || text6.indexOf(this) >= 0) {
        return true;
    }

    return false;
}

//物理师json过滤
function filterFunctionForWLS(element, index, array) {
    var text1 = element.Radiotherapy_ID;
    var text2 = element.Name;
    var text3 = (element.diagnosisresult == "") ? "无" : element.diagnosisresult;
    var text4 = element.treat;
    var text5 = element.doctor;
    var stateStr = new Array("", "(暂停中)", "已结束");
    var state = stateStr[parseInt(element.state)];
    var progress = (element.state == 2) ? "" : ProgressToString(element.Progress.split(","));
    var finalProgress = progress + state;

    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0) {
        return true;
    }
    if (finalProgress.indexOf(this) >= 0) {
        return true;
    }

    return false;
}

//剂量师json过滤
function filterFunctionForJLS(element, index, array) {
    var text1 = element.Radiotherapy_ID;
    var text2 = element.Name;
    var text3 = (element.diagnosisresult == "") ? "无" : element.diagnosisresult;
    var text4 = element.treat;
    var text5 = element.doctor;
    var stateStr = new Array("", "(暂停中)", "已结束");
    var state = stateStr[parseInt(element.state)];
    var progress = (element.state == 2) ? "" : ProgressToString(element.Progress.split(","));
    var finalProgress = progress + state;

    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0) {
        return true;
    }
    if (finalProgress.indexOf(this) >= 0) {
        return true;
    }

    return false;
}


//医师json过滤
function filterFunctionForYS(element, index, array) {
    var text1 = element.Radiotherapy_ID;
    var text2 = element.Name;
    var text3 = (element.diagnosisresult == "") ? "无" : element.diagnosisresult;
    var text4 = element.treat;
    var text5 = element.doctor;
    var text6 = (element.groupname == "") ? "未分组" : element.groupname;
    var stateStr = new Array("", "(暂停中)", "已结束");
    var state = stateStr[parseInt(element.state)];
    var progress = (element.state == 2) ? "" : ProgressToString(element.Progress.split(","));
    var hasfirst = (element.hasfirst == "1") ? "(首次)" : "";
    var finalProgress = progress + state + hasfirst;

    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0 || text6.indexOf(this) >= 0) {
        return true;
    }
    if (finalProgress.indexOf(this) >= 0) {
        return true;
    }

    return false;
}


//登记处人员
function filterFunctionForDJC(element, index, array) {
    var text1 = element.Radiotherapy_ID;
    var text2 = element.Name;
    var text3 = (element.diagnosisresult == "") ? "无" : element.diagnosisresult;
    var text4 = element.treat;
    var text5 = element.doctor;
    var text6 = (element.groupname == "") ? "未分组" : element.groupname;
    var stateStr = new Array("", "(暂停中)", "已结束");
    var state = stateStr[parseInt(element.state)];
    var progress = (element.state == 2) ? "" : ProgressToString(element.Progress.split(","));
    var finalProgress = progress + state;

    if (text1.indexOf(this) >= 0 || text2.indexOf(this) >= 0 || text3.indexOf(this) >= 0) {
        return true;
    }
    if (text4.indexOf(this) >= 0 || text5.indexOf(this) >= 0 || text6.indexOf(this) >= 0) {
        return true;
    }
    if (finalProgress.indexOf(this) >= 0) {
        return true;
    }

    return false;
}

//病人疗程完成情况预警
function completeWarning(patient) {
    var patientidlist = "";
    var boolfirst = true;
    patientALL = patient;
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        if (patient.PatientInfo[i].state != "2") {
            if (boolfirst == true) {
                patientidlist = patientidlist + patient.PatientInfo[i].treatID;
                boolfirst = false;
            } else {
                patientidlist = patientidlist +","+patient.PatientInfo[i].treatID;
            }
        }

    }

    $.ajax({
        type: "POST",
        url: "../../pages/Main/Records/getCompleteWarning.ashx",
        data: {patientidlist: patientidlist},
        async: true,
        dateType: "json",
        success: function (data) {
            completewarn = $.parseJSON(data);
            var CompleteList = $("#CompleteList");
            var CompleteTask = $("#CompleteTask");
            var patientCompleteInfo = $("#patientCompleteInfo");
            CompleteList.html("");
            var content = "";
            for (var i = 0; i < completewarn.length; i++) {
                if (completewarn[i].childname == "all") {
                    content = content + '<li onclick="searPatient('+completewarn[i].radio+')"><a href="javascript:;"><i class="fa fa-warning text-yellow"></i>'
                    +completewarn[i].radio + '，' + completewarn[i].pname + '，' + completewarn[i].treatname + '，' + completewarn[i].info
                       + '</a></li>';
                } else {
                    content = content + '<li  onclick="searPatient('+completewarn[i].radio+')"><a href="javascript:;"><i class="fa fa-warning text-yellow"></i>'
                     +completewarn[i].radio + '，' + completewarn[i].pname + '，' + completewarn[i].treatname + '，' + completewarn[i].childname + '，' + completewarn[i].info;
                       + '</a></li>';
                }
               
            }
            CompleteList.append(content);
            var TaskWarningNum = CompleteList.find("li").length;
            patientCompleteInfo.html(TaskWarningNum);
        }
    });
}

//搜索预警病人
function searPatient(str) {
    $("#patient-search").val(str);
    var session = getSession();
    var Searchedpatients = SearchTable($("#patient-search").val(), patientALL, session);
    adjustTable();

}


//流程预警
function Taskwarning(patient) {
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getallwarning.ashx",
        async: true,
        dateType: "text",
        success: function (data) {
            TaskWarning = $.parseJSON(data);
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
    });
}

function SingleTask(light, serious, singlepatient, currentProgress){
    if (singlepatient.state == "0") {
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
        var TimeDifference = CalculateWeekDay(completedTime,currentTime);
        if (TimeDifference > light) {
            $.ajax({
                type: "POST",
                url: "../../pages/Main/Records/getWarningInfo.ashx",
                async: false,
                data:{
                    treatID:singlepatient.treatID,
                    state:singlepatient.state,
                    progress:currentProgress
                },
                dateType: "json",
                success: function (data) {
                    var stoprecord = $.parseJSON(data).warningInfo;
                    var holidayrecord = $.parseJSON(data).holidayDate;
                    var stoplength = 0;
                    for (var i = 0; i < stoprecord.length; i++) {
                        if (stoprecord[i].RestartTime != "") {
                            var stoptime = new Date(stoprecord[i].StopTime);
                            var restarttime = new Date(stoprecord[i].RestartTime);
                            stoplength += CalculateWeekDay(stoptime,restarttime);
                        }
                    }
                    TimeDifference = TimeDifference - stoplength;
                }
            });
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
                WarningTaskContent.append(singletask);
            }
        }
    }
}

function CalculateWeekDay(beginDate,endDate){
    var temp = new Date(beginDate);
    var countdays = 0;
    var prevtime = 0;
    var nexttime = 0;
    temp.setDate(temp.getDate() + 1);
    while((temp.getDate() < endDate.getDate() && temp.getMonth() == endDate.getMonth()) || temp.getMonth() < endDate.getMonth()){
        if (temp.getDay() != 0 && temp.getDay() != 6) {
            countdays ++;
        }
        /*if (temp≠后台配置日期) {
            countdays++;
            //该函数增加参数：后台配置日期数组
        }*/
        temp.setDate(temp.getDate() + 1);
    }
    if (beginDate.getDay() != 0 && beginDate.getDay() != 6) {
        var tempend = new Date(beginDate);
        tempend.setDate(tempend.getDate() + 1);
        tempend.setHours(0);
        tempend.setMinutes(0);
        tempend.setSeconds(0);
        tempend.setMilliseconds(0);
        prevtime = (tempend.getTime() - beginDate.getTime())/3600000;
    }
    if (endDate.getDay() != 0 && endDate.getDay() != 6) {
        var tempstart = new Date(endDate);
        tempstart.setHours(0);
        tempstart.setMinutes(0);
        tempstart.setSeconds(0);
        tempstart.setMilliseconds(0);
        nexttime = (endDate.getTime() - tempstart.getTime())/3600000;
    }
    return countdays * 24 + prevtime + nexttime;
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

//获取患者纪录
function getPatient(userID, role, parameters) {
    var xmlHttp = new XMLHttpRequest();
    var xmlHttp = new XMLHttpRequest();
    switch (role) {
        case "医师":
            var url = "Records/patientInfoForDoctor.ashx?userID=" + userID + "&type=" + parameters[0];
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
            var url = "Records/GetPatientInfo.ashx?type="+ parameters[0];
            break;
        case "科主任":
            var url = "Records/GetPatientInfo.ashx?type=" + parameters[0];
            break;
        default:
            var url = "Records/GetPatientInfo.ashx?type=" + parameters[0];
    }
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var patient = eval("(" + json + ")");
    return patient;
}

//技师进入页面选择设备
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
    if (template != "") {
        for (var i = 0; i < template.length; i++) {
            if (template[i].Ispublic != 0) {
                var tr = '<tr id="Template_'+ template[i].ID +'"><td style="text-align:center;"><label><input type="radio" name="singleTemplate" class="minimal"></label></td><td style="text-align:center;">'+ template[i].Name +'</td><td style="text-align:center;"><button class="btn btn-info" onclick="deleteTemplate(this,'+ template[i].ID +')">删除</button></td></tr>';
            }else{
                var tr = '<tr id="Template_'+ template[i].ID +'"><td style="text-align:center;"><label><input type="radio" name="singleTemplate" class="minimal"></label></td><td style="text-align:center;">'+ template[i].Name +'</td><td style="text-align:center;"><button class="btn btn-info disabled" disabled="disabled">删除</button></td></tr>';
            }
            tbody.append(tr);
        }
        tbody.find("tr").each(function(){
            $(this).find("td").each(function(index, element){
                if (index == 1) {
                    $(this).unbind("click").click(function(){
                        $(this).prev().find(".iCheck-helper").click();
                    });
                }
            });
        });
    }else{
        var tr = '<tr><td colspan="2" style="text-align:center;">无模板</td></tr>';
        tbody.append(tr);
    }
    var tr = '<tr><td></td><td></td><td></td></tr>';
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

function deleteTemplate(e,templateID){
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/deleteTemplate.ashx?templateID=" + templateID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    if(json=="success"){
        alert("删除成功");
        $(e).parent().parent().remove();
    }else{
        alert("删除失败");
    }
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

//将同一个患者的不同疗程纪录排列到一起
//function patientSort(patient){
//    var sortPatient = new Array();
//    var count = 0;
//    for (var j = 0; j < patient.PatientInfo.length; j++) {
//        if (patient.PatientInfo[j].state == "0") {
//            var flag = 0;
//            for (var k = 0; k < sortPatient.length; k++) {
//                if (sortPatient[k].Radiotherapy_ID == patient.PatientInfo[j].Radiotherapy_ID) {
//                    flag = 1;
//                }
//            }
//            if (flag == 0) {
//                sortPatient[count++] = patient.PatientInfo[j];
//                for (var i = j + 1; i < patient.PatientInfo.length; i++) {
//                    if (patient.PatientInfo[i].state == "0" && flag == 0 && sortPatient[count - 1].Radiotherapy_ID == patient.PatientInfo[i].Radiotherapy_ID) {
//                        sortPatient[count++] = patient.PatientInfo[i];
//                    }
//                }
//            }
//        }
//    }
//    for (var j = 0; j < patient.PatientInfo.length; j++) {
//        if (patient.PatientInfo[j].state == "1") {
//            sortPatient[count++] = patient.PatientInfo[j];
//        }
//    }
//    for (var j = 0; j < patient.PatientInfo.length; j++) {
//        if (patient.PatientInfo[j].state == "2") {
//            sortPatient[count++] = patient.PatientInfo[j];
//        }
//    }
//    var patientGroup = { PatientInfo: sortPatient };
//    return patientGroup;
//}
function patientSort(patient){
    var sortPatient = new Array();
    var count = 0;
    for (var j = 0; j < patient.PatientInfo.length; j++) {
        if (patient.PatientInfo[j].state == "0") {
            var flag = 0;
            for (var k = 0; k < sortPatient.length; k++) {
                if (sortPatient[k].Radiotherapy_ID == patient.PatientInfo[j].Radiotherapy_ID) {
                    flag = 1;
                }
            }
            if (flag == 0) {
                var num = [];
                num.push(j);
                for (var i = j + 1; i < patient.PatientInfo.length; i++) {
                    if (patient.PatientInfo[i].state == "0" && flag == 0 && patient.PatientInfo[j].Radiotherapy_ID == patient.PatientInfo[i].Radiotherapy_ID) {
                        num.push(i);
                    }
                }
                for (var m = num.length - 1; m >= 0; m--) {
                    sortPatient[count++] = patient.PatientInfo[num[m]];
                }
            }
        }
    }
    for (var j = 0; j < patient.PatientInfo.length; j++) {
        if (patient.PatientInfo[j].state == "1") {
            sortPatient[count++] = patient.PatientInfo[j];
        }
    }
    for (var j = 0; j < patient.PatientInfo.length; j++) {
        if (patient.PatientInfo[j].state == "2") {
            sortPatient[count++] = patient.PatientInfo[j];
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

function StateNumToString(str){
    var state;
    switch(str){
        case "0":
            state = "进行中";
            break;
        case "1":
            state = "暂停中";
            break;
        case "2":
            state = "已结束";
            break;
        default:
            state = "无";
    }
    return state;
}