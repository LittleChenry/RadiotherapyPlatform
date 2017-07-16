var currentID = 0;
var functions = new Array();

$(document).ready(function () {
    $(".frame-content").height($(document).height() - 151);
    $("#patient-content").height($(document).height() - 151);
    $("#patient-table-content").height($(document).height() - 190);
    $("#record-iframe").width($("#record-content").width());
    $("#progress-iframe").width($("#progress-content").width());
    var session = getSession();
    var patient;
    functions = session.progress.split(" ");
    RolesToPatients(session);
    $("#patient-search").bind('input propertychange', function() {
        var Searchedpatients = Search($("#patient-search").val(), patient, session.role);
        Paging(Searchedpatients,session.role);
    });
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("../Login/Login.aspx");
    });
    $("#save").click(function(){
        //$("#record-iframe")[0].contentWindow.save();
        RolesToPatients(session);
        Recover();
        $('#save').attr("disabled","disabled");
    });
    $('#edit').click(function(){
        $("#save").removeAttr("disabled");
        $('#edit').attr("disabled","disabled");
    });
    $("#saveTreatment").bind("click",function(){
        saveTreatment();
    });
    //chooseAssistant();
    
})

/*window.onresize=function(){
    document.location.reload();
}*/

function RolesToPatients(session){
    if (session.role == "模拟技师" || session.role == "放疗技师") {
        if (session.equipmentID == "0") {
            chooseEquipment();
            $("#getSelectedPatient").click(function(){
                var equipmentID = $("#equipment").val();
                var equipmentName = $("#equipment option:selected").html();
                var startdate = $("#startdate").val();
                var enddate = $("#enddate").val();
                $("#chosenEquipment").html(equipmentName);
                $("#dateRange").html(startdate + "~~" + enddate);
                var parameters = new Array();
                parameters[0] = equipmentID;
                parameters[1] = startdate;
                parameters[2] = enddate;
                patient = getPatient(session.userID, session.role, parameters);
                Paging(patient,session.role);
                $.ajax({
                    type: "POST",
                    url: "../../pages/Main/Records/setEquipment.ashx",
                    data:{
                        id : $("#equipment").val(),
                        name : $("#equipment option:selected").html(),
                        beginTime : $("#startdate").val(),
                        endTime : $("#enddate").val()
                    },
                    error:function(){
                        alert("error");
                    }
                });
            });
        }else{
            var parameters = new Array();
            parameters[0] = session.equipmentID;
            parameters[1] = session.beginTime;
            parameters[2] = session.endTime;
            patient = getPatient(session.userID, session.role, parameters);
            Paging(patient,session.role);
            $("#chosenEquipment").html(session.equipmentName);
            $("#dateRange").html(session.beginTime + "~~" + session.endTime);
        }
        
    }else{
        var parameters = new Array();
        patient = getPatient(session.userID, session.role, parameters);
        Paging(patient,session.role);
    }
}

function Paging(patient,role){
    if (patient.PatientInfo != "") {
        tableheight = $("#patient-content").height() - 160;
        var table = $("#patient-table");
        table.html("");
        $("#patient_info").text("一共" +  patient.PatientInfo.length +"条记录");
        switch(role){
            case "医师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th>放疗号</th><th>姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ?"无":patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + "疗程"+ treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient);
                break;
            case "计量师":
                var url = "";
                break;
            case "物理师":
                var url = "";
                break;
            case "模拟技师":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, date, begin, end, doctor;
                var thead = '<thead><tr><th>放疗号</th><th>姓名</th><th>预约时间</th><th>疗程</th><th>诊断结果</th>'
                    + '<th>主治医生</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ?"无":patient.PatientInfo[i].diagnosisresult;
                    date = patient.PatientInfo[i].date;
                    doctor = patient.PatientInfo[i].doctor;
                    begin = toTime(patient.PatientInfo[i].begin);
                    end = toTime(patient.PatientInfo[i].end);
                    var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + date + "," + begin + "-" + end + "</td><td>" + "疗程"+ treat + "</td><td>" + diagnosisresult + "</td>"
                        + "<td>" + doctor + "</td></tr>";
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient);
                break;
            case "放疗技师":
                var url = "";
                break;
            case "登记处人员":
                var url = "";
                break;
            case "科主任":
                var TreatmentID, Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th>放疗号</th><th>姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ?"无":patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + "疗程"+ treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                trAddClick(patient);
                break;
            default:
                var url = "";
        }
    } else {
        var table = $("#patient-table");
        table.html("");
        switch(role){
            case "医师":
                var thead = '<thead><tr><th>放疗号</th><th>姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:45%;">没有病人信息</td></tr></tbody>';
                table.append(tbody);
                break;
            case "计量师":
                var url = "";
                break;
            case "物理师":
                var url = "";
                break;
            case "模拟技师":
                var url = "";
                break;
            case "放疗技师":
                var url = "";
                break;
            case "登记处人员":
                var url = "";
                break;
            default:
                var url = "";
        }
        $("#patient_info").text("共0条记录");
    }
    Recover();
}

function trAddClick(patient){
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        $("#" + patient.PatientInfo[i].treatID + "").click({ Radiotherapy_ID: patient.PatientInfo[i].Radiotherapy_ID, ID: patient.PatientInfo[i].treatID, treat: patient.PatientInfo[i].treat, count: patient.PatientInfo[i].Progress }, function (e) {
            currentID = e.data.ID;
            checkAddTreatment(e.data.Radiotherapy_ID);
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
                        if (LightLi(this,Progresses, "1", "0", "-1")) {
                            var url = "Records/Diagnose.aspx?Radiotherapy_ID=" + e.data.Radiotherapy_ID +"&treat=" + e.data.treat;
                        }else{
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
                        if (LightLi(this,Progresses, "2", "1", "-1")) {
                            var url = "Records/FixedApply.aspx?TreatmentID=" + e.data.ID  +"&TreatmentItem=Fixed";
                        }else{
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
                        });
                        break;
                    case 3:
                        if (LightLi(this,Progresses, "3", "2", "-1")) {
                            var url = "Records/LocationApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        }else{
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
                        });
                        break;
                    case 4:
                        if (LightLi(this,Progresses, "4", "2", "-1")) {
                            var url = "Records/FixedRecord.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "5", "4", "3")) {
                            var url = "Records/LocationRecord.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "6", "5", "-1")) {
                            var url = "Records/ImportCT.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "7", "6", "-1")) {
                            var url = "Records/DesignApply.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        });
                        break;
                    case 8:
                        if (LightLi(this,Progresses, "8", "7", "-1")) {
                            var url = "Records/DesignReceive.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "9", "8", "-1")) {
                            var url = "Records/DesignSubmit.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "10", "9", "-1")) {
                            var url = "Records/DesignConfirm.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "11", "10", "-1")) {
                            var url = "Records/DesignReview.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "12", "10", "-1")) {
                            var url = "Records/ReplacementApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location";
                        }else{
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
                        if (LightLi(this,Progresses, "13", "12", "-1")) {
                            var url = "Records/ReplacementRecord.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "14", "13", "-1")) {
                            var url = "Records/FirstAccelerator.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Accelerator";
                        }else{
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
                        if (LightLi(this,Progresses, "15", "14", "-1")) {
                            var url = "Records/TreatmentRecord.aspx?TreatmentID=" + e.data.ID;
                        }else{
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
                        if (LightLi(this,Progresses, "16", "15", "-1")) {
                            var url = "Records/Summary.aspx?TreatmentID=" + e.data.ID;
                        }else{
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

function LightLi(e, Progresses, currentProgress, preProgress, preProgress2){
    var flag = 0;
    for (var i = 0; i < Progresses.length; i++) {
        if (Progresses[i] == currentProgress) {
            flag = 2;
            break;
        }else{
            if (preProgress2 != -1) {
                if (Progresses[i] == preProgress && Progresses[i] == preProgress2) {
                    flag = 1;
                }
            }else{
                if (Progresses[i] == preProgress) {
                    flag = 1;
                }
            }
        }
    }
    switch(flag){
        case 0:
            $(e).find('li').removeClass().addClass("progress-unfinished");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-ban");
            return false;
        case 1:
            $(e).find('li').removeClass().addClass("progress-active");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-edit");
            return true;
        case 2:
            $(e).find('li').removeClass().addClass("progress-finished");
            $(e).find('i').removeClass().addClass("fa fa-fw fa-check");
            return true;
        default:
            return false;
    }
}

function BubbleSort(arr){
    for(var i = 0; i < arr.length - 1;i++){
        for(var j = 0; j < arr.length - 1 - i; j++){
            if(arr[j] > arr[j + 1]){
                var temp = arr[j];
                arr[j] = arr[j+1];
                arr[j+1] = temp;
            }
        }
    }
    return arr;
}

function ProgressToString(pro){
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
    switch(length){
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
            currentProgress[count++] = 11;
            currentProgress[count++] = 13;
            break;
        case 13:
            currentProgress[count++] = 11;
            break;
    }
    for (var i = 0; i < currentProgress.length; i++) {
        switch(currentProgress[i]){
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
                Progress += "首次治疗预约、";
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

function saveTreatment(){
    var diagnose = "";
    var fixed = "";
    var location = "";
    var design = ""
    var replace = "";
    var treatmentname = "";
    var review = "";
    var group = "";
    var Radiotherapy_ID = $("#Radiotherapy_ID").val();
    $("#diagnose").find("td").each(function(){
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            diagnose = temp[1];
            group = temp[2];
        }
    });
    $("#fixed").find("td").each(function(){
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            fixed = temp[1];
        }
    });
    $("#location").find("td").each(function(){
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            location = temp[1];
        }
    });
    $("#design").find("td").each(function(){
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            design = temp[1];
            review = temp[2];
        }
    });
    $("#replace").find("td").each(function(){
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
        data:{
            diagnose:diagnose,
            fixed:fixed,
            location:location,
            design:design,
            replace:replace,
            treatmentname:treatmentname,
            review:review,
            group: group,
            Radiotherapy_ID:Radiotherapy_ID

        },
        success: function (data) {
            alert("新增成功！");
            $("#addtreatmentrecord").html("");
            var patient = getpatient();
            paging(patient);
        },
        error: function(){
            alert("error");
        }
    });
}

function checkAddTreatment(Radiotherapy_ID){
    $("#manageTreatment").attr("disabled","disabled");
    for (var i = 0; i < functions.length; i++) {
        if(functions[i].toString() == "18"){
            $("#manageTreatment").removeAttr("disabled");
            $("#Radiotherapy_ID").val(Radiotherapy_ID);
            $("#addTreatment").click({Radiotherapy_ID:Radiotherapy_ID},function(e){
                $.ajax({
                    type: "POST",
                    url: "../../pages/Main/Records/getallcompletedtreat.ashx",
                    async: true,
                    dateType: "text",
                    data:{Radiotherapy_ID:e.data.Radiotherapy_ID},
                    success: function (data) {
                        var table = $("#addTreatmentRecord");
                        table.html("");
                        var thead = '<thead><tr id="progress"><th>流程</th></tr></thead>';
                        var tbody = '<tbody><tr id="register"><td>患者登记<i></i></td></tr>'+
                            '<tr id="diagnose"><td>病情诊断<i></i></td></tr>'+
                            '<tr id="fixed"><td>体位固定<i></i></td></tr><tr id="location"><td>CT模拟<i></i></td></tr>'+
                            '<tr id="design"><td>计划设计<i></i></td></tr><tr id="replace"><td>复位验证<i></i></td></tr></tbody>';
                        table.append(thead);
                        table.append(tbody);
                        obj = $.parseJSON(data);
                        var newTreatname = obj.treatinfo.length + 1;
                        $("#newname").val("疗程" + newTreatname);
                        for (var i = 0; i < obj.treatinfo.length; i++) {
                            var th = '<th>疗程'+ obj.treatinfo[i].treatmentname +'</th>';
                            $("#progress").append(th);

                            var td0 = '<td id="register_'+ i +'"><i></i></td>';
                            $("#register").append(td0);
                            $("#register_"+i).click(function(){
                                if ($(this).find("i")[0].className != "") {
                                    $(this).find("i").removeClass();
                                    $(this).parent().nextAll().each(function(){
                                        $(this).find("td").each(function(){
                                            $(this).find("i").removeClass();
                                        });
                                    });
                                }else{
                                    var currentrowselected = 0;
                                    $(this).parent().find("td").each(function(){
                                        if ($(this).find("i")[0].className != "") {
                                            currentrowselected = 1;
                                        }
                                    });
                                    if (currentrowselected == 0) {
                                        $(this).find("i").addClass("fa fa-fw fa-check");
                                    }else{
                                        alert("每一行只能选择一个模块复用！");
                                    }
                                }
                            });

                            if (obj.treatinfo[i].diagnose != "") {
                                var td1 = '<td id="diagnose_'+ obj.treatinfo[i].diagnose +'_' + obj.treatinfo[i].group + '_' + i +'"><i></i></td>';
                                $("#diagnose").append(td1);
                                $("#diagnose_"+ obj.treatinfo[i].diagnose + "_" + obj.treatinfo[i].group + "_" + i).click(function(){
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function(){
                                            $(this).find("td").each(function(){
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                    }else{
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                            }else{
                                                alert("上一行还未选择复用模块！");
                                            }
                                        }else{
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            }else{
                                var td1 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#diagnose").append(td1);
                            }

                            if (obj.treatinfo[i].fixed != "") {
                                var td2 = '<td id="fixed_'+ obj.treatinfo[i].fixed +'_' + i +'"><i></i></td>';
                                $("#fixed").append(td2);
                                $("#fixed_"+ obj.treatinfo[i].fixed + "_" + i).click(function(){
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function(){
                                            $(this).find("td").each(function(){
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                    }else{
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                            }else{
                                                alert("上一行还未选择复用模块！");
                                            }
                                        }else{
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            }else{
                                var td2 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#fixed").append(td2);
                            }
                            
                            if (obj.treatinfo[i].location != "") {
                                var td3 = '<td id="location_'+ obj.treatinfo[i].location +'_' + i +'"><i></i></td>';
                                $("#location").append(td3);
                                $("#location_"+ obj.treatinfo[i].location + "_" + i).click(function(){
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function(){
                                            $(this).find("td").each(function(){
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                    }else{
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                            }else{
                                                alert("上一行还未选择复用模块！");
                                            }
                                        }else{
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            }else{
                                var td3 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#location").append(td3);
                            }

                            if (obj.treatinfo[i].design != "") {
                                var td4 = '<td id="design_'+ obj.treatinfo[i].design + '_' + obj.treatinfo[i].review + '_' + i +'"><i></i></td>';
                                $("#design").append(td4);
                                $("#design_"+ obj.treatinfo[i].design + "_" + obj.treatinfo[i].review + "_" + i).click(function(){
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function(){
                                            $(this).find("td").each(function(){
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                    }else{
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                            }else{
                                                alert("上一行还未选择复用模块！");
                                            }
                                        }else{
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            }else{
                                var td4 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#design").append(td4);
                            }

                            if (obj.treatinfo[i].replace != "") {
                                var td5 = '<td id="replace_'+ obj.treatinfo[i].replace +'_' + i +'"><i></i></td>';
                                $("#replace").append(td5);
                                $("#replace_"+ obj.treatinfo[i].replace + "_" + i).click(function(){
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                    }else{
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function(){
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
                                            }else{
                                                alert("上一行还未选择复用模块！");
                                            }
                                        }else{
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            }else{
                                var td5 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#replace").append(td4);
                            }
                        }
                    },
                    error: function(){
                        alert("error");
                    }
                });
            });
            return true;
        }
    }
    return false;
}

function checkEdit(str){
    $('#edit').attr("disabled","disabled");
    $('#save').attr("disabled","disabled");
    var activeProgress = getProgressActive();
    for (var i = 0; i < functions.length; i++) {
        if (functions[i] == str) {
            for (var j = 0; j < activeProgress.length; j++) {
                if(activeProgress[j].toString() == str || "0" == str){
                    $("#edit").removeAttr("disabled");
                    return true;
                }
            }
        }
    }
    return false;
}

function getSession(){
    var Session;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            alert(data);
            Session = $.parseJSON(data);
        },
        error: function(){
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

function Recover(){
    if(currentID != "0" && $("#" + currentID).length > 0){
        $("#" + currentID).click();
    }
}

function Search(str, patient, role){
    //var Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
    var Searchedpatient = new Array();
    var count = 0;
    switch(role){
        case "医师":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ?"无":patient.PatientInfo[i].diagnosisresult;
                Progress = ProgressToString(patient.PatientInfo[i].Progress.split(","));
                doctor = patient.PatientInfo[i].doctor;
                groupname = patient.PatientInfo[i].groupname;
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || Progress.search(str) >= 0 || doctor.search(str) >= 0 || groupname.search(str) >= 0) {
                    var singlepatient = {treat:treat, treatID:TreatmentID, Name:Name, Radiotherapy_ID:Radiotherapy_ID, doctor:doctor, Progress:patient.PatientInfo[i].Progress, groupname:groupname, diagnosisresult:patient.PatientInfo[i].diagnosisresult};
                    Searchedpatient[count++] = singlepatient;
                }
            }
            break;
        case "模拟技师":
            for (var i = 0; i < patient.PatientInfo.length; i++) {
                TreatmentID = patient.PatientInfo[i].treatID;
                Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                Name = patient.PatientInfo[i].Name;
                treat = patient.PatientInfo[i].treat;
                diagnosisresult = (patient.PatientInfo[i].diagnosisresult == "") ?"无":patient.PatientInfo[i].diagnosisresult;
                date = patient.PatientInfo[i].date;
                doctor = patient.PatientInfo[i].doctor;
                begin = toTime(patient.PatientInfo[i].begin);
                end = toTime(patient.PatientInfo[i].end);
                if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || diagnosisresult.search(str) >= 0 || date.search(str) >= 0 || begin.search(str) >= 0 || end.search(str) >= 0 || doctor.search(str) >= 0) {
                    var singlepatient = {treat:treat, treatID:TreatmentID,date:date, Name:Name, Radiotherapy_ID:Radiotherapy_ID, doctor:doctor, Progress:patient.PatientInfo[i].Progress,begin:patient.PatientInfo[i].begin,end:patient.PatientInfo[i].end, diagnosisresult:patient.PatientInfo[i].diagnosisresult};
                    Searchedpatient[count++] = singlepatient;
                }
            }
    }
    var patientGroup = {PatientInfo:Searchedpatient};
    return patientGroup;
}

function getProgressActive(){
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

function getPatient(userID,role,parameters){
    var xmlHttp = new XMLHttpRequest();
    var xmlHttp = new XMLHttpRequest();
    switch(role){
        case "医师":
            var url = "Records/patientInfoForDoctor.ashx?userID=" + userID;
            break;
        case "计量师":
            var url = "";
            break;
        case "物理师":
            var url = "";
            break;
        case "模拟技师":
            var url = "Records/patientInfoForMNJS.ashx?equipmentid=" + parameters[0] + "&date1=" + parameters[1] + "&date2=" + parameters[2];
            break;
        case "放疗技师":
            var url = "";
            break;
        case "登记处人员":
            var url = "";
            break;
        case "科主任":
            var url = "Records/GetPatientInfo.ashx?";
            break;
        default:
            var url = "";
    }
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var patient = eval("(" + json + ")");
    return patient;
}

function chooseEquipment(){
    $("#chooseMachine").modal({backdrop: 'static'});
    
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getEquipment.ashx",
        async: false,
        dateType: "json",
        success: function (data) {
            var Equipment = $.parseJSON(data);
            var options;
            for (var i = 0; i < Equipment.EquipmentInfo.length; i++) {
                options += '<option value="'+ Equipment.EquipmentInfo[i].equipmentID +'">'+ Equipment.EquipmentInfo[i].equipmentName +'</option>';
            }
            $("#equipment").append(options);
            $("#equipmentType").change(function(){
                if($("#equipmentType").val() == "all"){
                    options ="";
                    for (var i = 0; i < Equipment.EquipmentInfo.length; i++) {
                        options += '<option value="'+ Equipment.EquipmentInfo[i].equipmentID +'">'+ Equipment.EquipmentInfo[i].equipmentName +'</option>';
                    }
                }else{
                    options = "";
                    for (var i = 0; i < Equipment.EquipmentInfo.length; i++) {
                        if ($("#equipmentType").val() == Equipment.EquipmentInfo[i].TreatmentItem) {
                            options += '<option value="'+ Equipment.EquipmentInfo[i].equipmentID +'">'+ Equipment.EquipmentInfo[i].equipmentName +'</option>';
                        }
                    }
                }
                $("#equipment").html("").append(options);
            });
        },
        error: function(){
            alert("error");
        }
    });
    
    
    var currentTime = new Date().Format("yyyy-MM-dd");
    $("#startdate").val(currentTime);
    $("#enddate").val(currentTime);
}

Date.prototype.Format = function(fmt){
    var o = {
        "M+" : this.getMonth()+1,
        "d+" : this.getDate(),
        "h+" : this.getHours(),
        "m+" : this.getMinutes(),
        "s+" : this.getSeconds(),
        "q+" : Math.floor((this.getMonth()+3)/3),
        "S"  : this.getMilliseconds()
    };
    if(/(y+)/.test(fmt))
        fmt=fmt.replace(RegExp.$1, (this.getFullYear()+"").substr(4 - RegExp.$1.length));
    for(var k in o)
    if(new RegExp("("+ k +")").test(fmt))
        fmt = fmt.replace(RegExp.$1, (RegExp.$1.length==1) ? (o[k]) : (("00"+ o[k]).substr((""+ o[k]).length)));
    return fmt;
}

function chooseAssistant() {
    var operator1 = $("#operator1");
    var operator2 = $("#operator2");
    var operator3 = $("#operator3");
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            obj = $.parseJSON(data);
            if (obj.assistant == "") {
                $.ajax({
                    type: "GET",
                    url: "../../pages/Main/Records/getoperator.ashx",
                    async: false,
                    dateType: "text",
                    success: function (data) {
                        operatorUsers = $.parseJSON(data);
                        operator1.empty();
                        operator2.empty();
                        operator3.empty();
                        var option_empty_1 = "<option value=''>----选择操作成员1----</option>";
                        var option_empty_2 = "<option value=''>----选择操作成员2----</option>";
                        var option_empty_3 = "<option value=''>----选择操作成员3----</option>";
                        operator1.append(option_empty_1);
                        operator2.append(option_empty_2);
                        operator3.append(option_empty_3);
                        for (var i = 0; i < operatorUsers.operator.length; i++) {
                            if(obj.userID != operatorUsers.operator[i].ID){
                                var option = "<option id='"+  operatorUsers.operator[i].ID +"' value='"+ operatorUsers.operator[i].ID +"'>"+ operatorUsers.operator[i].Name +"</option>";
                                operator1.append(option);
                            }
                        }
                        operator1.change(function(){
                            operator2.empty();
                            operator3.empty();
                            var option_empty_2 = "<option value=''>----选择操作成员2----</option>";
                            var option_empty_3 = "<option value=''>----选择操作成员3----</option>";
                            operator2.append(option_empty_2);
                            operator3.append(option_empty_3);
                            for (var i = 0; i < operatorUsers.operator.length; i++) {
                                if(this.value != operatorUsers.operator[i].ID && obj.userID != operatorUsers.operator[i].ID){
                                    var option = "<option id='"+  operatorUsers.operator[i].ID +"' value='"+ operatorUsers.operator[i].ID +"'>"+ operatorUsers.operator[i].Name +"</option>";
                                    operator2.append(option);
                                }
                            }
                            operator2.change({operator2:this.value},function(e){
                                operator3.empty();
                                var option_empty_3 = "<option value=''>----选择操作成员3----</option>";
                                operator3.append(option_empty_3);
                                for (var i = 0; i < operatorUsers.operator.length; i++) {
                                    if(e.data.operator2 != operatorUsers.operator[i].ID && this.value != operatorUsers.operator[i].ID && obj.userID != operatorUsers.operator[i].ID){
                                        var option = "<option id='"+  operatorUsers.operator[i].ID +"' value='"+ operatorUsers.operator[i].ID +"'>"+ operatorUsers.operator[i].Name +"</option>";
                                        operator3.append(option);
                                    }
                                }
                            });
                        });
                    },
                    error: function () {
                        alert("error");
                    }
                });
                $('#chooseOperator').modal({ backdrop: 'static', keyboard: false });
            }else{
                $("#operator").html(obj.assistant);
            }
        },
        error: function(){
            alert("error");
        }
    });
}

function changeAssistant(){
    var operator1 = $("#operator1");
    var operator2 = $("#operator2");
    var operator3 = $("#operator3");
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            obj = $.parseJSON(data);
            $.ajax({
                type: "GET",
                url: "../../pages/Main/Records/getoperator.ashx",
                async: false,
                dateType: "text",
                success: function (data) {
                    operatorUsers = $.parseJSON(data);
                    operator1.empty();
                    operator2.empty();
                    operator3.empty();
                    var option_empty_1 = "<option value=''>----选择操作成员1----</option>";
                    var option_empty_2 = "<option value=''>----选择操作成员2----</option>";
                    var option_empty_3 = "<option value=''>----选择操作成员3----</option>";
                    operator1.append(option_empty_1);
                    operator2.append(option_empty_2);
                    operator3.append(option_empty_3);
                    for (var i = 0; i < operatorUsers.operator.length; i++) {
                        if(obj.userID != operatorUsers.operator[i].ID){
                            var option = "<option id='"+  operatorUsers.operator[i].ID +"' value='"+ operatorUsers.operator[i].ID +"'>"+ operatorUsers.operator[i].Name +"</option>";
                            operator1.append(option);
                        }
                    }
                    operator1.change(function(){
                        operator2.empty();
                        operator3.empty();
                        var option_empty_2 = "<option value=''>----选择操作成员2----</option>";
                        var option_empty_3 = "<option value=''>----选择操作成员3----</option>";
                        operator2.append(option_empty_2);
                        operator3.append(option_empty_3);
                        for (var i = 0; i < operatorUsers.operator.length; i++) {
                            if(this.value != operatorUsers.operator[i].ID && obj.userID != operatorUsers.operator[i].ID){
                                var option = "<option id='"+  operatorUsers.operator[i].ID +"' value='"+ operatorUsers.operator[i].ID +"'>"+ operatorUsers.operator[i].Name +"</option>";
                                operator2.append(option);
                            }
                        }
                        operator2.change({operator2:this.value},function(e){
                            operator3.empty();
                            var option_empty_3 = "<option value=''>----选择操作成员3----</option>";
                            operator3.append(option_empty_3);
                            for (var i = 0; i < operatorUsers.operator.length; i++) {
                                if(e.data.operator2 != operatorUsers.operator[i].ID && this.value != operatorUsers.operator[i].ID && obj.userID != operatorUsers.operator[i].ID){
                                    var option = "<option id='"+  operatorUsers.operator[i].ID +"' value='"+ operatorUsers.operator[i].ID +"'>"+ operatorUsers.operator[i].Name +"</option>";
                                    operator3.append(option);
                                }
                            }
                        });
                    });
                },
                error: function () {
                    alert("error");
                }
            });
            $('#chooseOperator').modal({ backdrop: 'static', keyboard: false });
        },
        error: function(){
            alert("error");
        }
    });
}

function setAssistant(){
    var operators = "";
    for (var i = 1; i < 4; i++) {
        if($("#operator"+ i +" option:selected").val() != ""){
            operators += $("#operator"+ i +" option:selected").html();
            var next = i + 1;
            if ($("#operator" + next).val() != "" && $("#operator" + next).length != 0) {
                operators += ","
            }else{
                break;
            }
        }else{
            break;
        } 
    }
    if (operators == "") {
        operators = "无";
    }
    $("#operator").html(operators);
    $.ajax({
        type: "POST",
        url: "../../pages/Main/Records/setAssistant.ashx",
        data:{assistant : operators},
        error:function(){
            alert("error");
        }
    });
}

function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
}