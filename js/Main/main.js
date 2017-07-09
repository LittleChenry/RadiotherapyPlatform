var currentID = 0;
var currentpage = 1;

$(document).ready(function () {
    $(".frame-content").height($(document).height() - 151);
    $("#patient-content").height($(document).height() - 151);
    $("#record-iframe").width($("#record-content").width());
    $("#progress-iframe").width($("#progress-content").width());
    var patient = getPatient();
    $("#patient-search").bind('input propertychange', function() {
        var Searchedpatients = Search($("#patient-search").val(),patient);
        Paging(Searchedpatients);
    });
    $("#search-button").bind("click", function () {
        var Searchedpatients = Search($("#patient-search").val(),patient);
        Paging(Searchedpatients);
    });
    Paging(patient);
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("../Login/Login.aspx");
    });
    $("#save").click(function(){
        addProgress(patient);
        Paging(patient);
    })
    $("#changeOperator").bind("click", function () {
        changeAssistant();
    });
    $("#saveOperator").bind("click",function(){
        setAssistant();
    });
    //chooseAssistant();
})

/*window.onresize=function(){
    document.location.reload();
}*/

function addProgress(patient){
    var ul = $("#progress-iframe").contents().find("#ul-progress a");
    var sign = 0;
    ul.each(function (index, element) {
        if($(this).find('li').hasClass("progress-active")){
            if(index < 14){
                $(this).find('li').removeClass("progress-active").addClass("progress-finished");
                $(this).find('i').removeClass().addClass("fa fa-fw fa-check");
                $(this).find('span').removeClass();
                $(this).find('li').parent().next().find('li').removeClass("progress-unfinished").addClass("progress-active");
                $(this).find('li').parent().next().find('i').removeClass().addClass("fa fa-fw fa-edit");
                $(this).find('li').parent().next().find('span').removeClass().addClass("fa fa-arrow-circle-right");
                return false;
            }
        }
    });
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        if (patient.PatientInfo[i].treatID  == currentID) {
            patient.PatientInfo[i].Progress = parseInt(patient.PatientInfo[i].Progress) + 1;
        }
    }
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

function removeSession() {
    $.ajax({
        type: "GET",
        url: "../../Root/removeSession.ashx"
    });
}

function Recover(){
    if(currentID != "0"){
        $("#page_" + currentpage).click();
        if ($("#" + currentID).length > 0) {
            $("#" + currentID).addClass("chose");
        }
    }
}

function Search(str,patient){
    var TreatmentID, treatID, Name, treat, doctor, Progress;
    var Searchedpatient = new Array();
    var count = 0;
    for (var i = 0; i < patient.PatientInfo.length; i++) {
        Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
        treat = patient.PatientInfo[i].treat;
        TreatmentID = patient.PatientInfo[i].treatID;
        Name = patient.PatientInfo[i].Name;
        Progress = patient.PatientInfo[i].Progress;
        doctor = patient.PatientInfo[i].doctor;
        if (Radiotherapy_ID.search(str) >= 0 || Name.search(str) >= 0 || treat.search(str) >= 0 || Progress.search(str) >= 0 || doctor.search(str) >= 0) {
            var singlepatient = {treat:treat, treatID:TreatmentID, Name:Name, Radiotherapy_ID:Radiotherapy_ID, doctor:doctor, Progress:Progress};
            Searchedpatient[count++] = singlepatient;
        }
    }
    var patientGroup = {PatientInfo:Searchedpatient};
    return patientGroup;
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

function adjustPage(pages) {
    var active = getActive();
    switch (active) {
        case 1:
            $("#table_omitted_previous").css("display", "none");
            $("#table_omitted_next").css("display", "inline");
            for (var i = 1; i <= pages; i++) {
                $("#page_" + i + "").css("display", "inline");
            }
            for (var i = 4; i <= pages; i++) {
                $("#page_" + i + "").css("display", "none");
            }
            break;
        case 2:
            $("#table_omitted_previous").css("display", "none");
            $("#table_omitted_next").css("display", "inline");
            for (var i = 1; i <= pages; i++) {
                $("#page_" + i + "").css("display", "inline");
            }
            for (var i = 4; i <= pages; i++) {
                $("#page_" + i + "").css("display", "none");
            }
            break;
        case pages - 1:
            $("#table_omitted_next").css("display", "none");
            $("#table_omitted_previous").css("display", "inline");
            for (var i = 1; i <= pages; i++) {
                $("#page_" + i + "").css("display", "inline");
            }
            for (var i = pages - 3; i > 0 ; i--) {
                $("#page_" + i + "").css("display", "none");
            }
            break;
        case pages:
            $("#table_omitted_next").css("display", "none");
            $("#table_omitted_previous").css("display", "inline");
            for (var i = 1; i <= pages; i++) {
                $("#page_" + i + "").css("display", "inline");
            }
            for (var i = pages - 2; i > 0 ; i--) {
                $("#page_" + i + "").css("display", "none");
            }
            break;
        default:
            $("#table_omitted_next").css("display", "inline");
            $("#table_omitted_previous").css("display", "inline");
            for (var i = 1; i <= pages; i++) {
                $("#page_" + i + "").css("display", "inline");
            }
            for (var i = 1; i < active - 1 ; i++) {
                $("#page_" + i + "").css("display", "none");
            }
            for (var i = active + 2; i <= pages ; i++) {
                $("#page_" + i + "").css("display", "none");
            }
    }
}

function CreateTable(start, end, patient) {
    var tbody = $("#patient-table-body");
    tbody.html("");
    var num = end - start;
    $("#patient_info").text("本页" + +num + "条记录 / 共" + patient.PatientInfo.length + "条记录");
    var TreatmentID, treatID, Name, treat, doctor, Progress;
    for (var i = start; i < end; i++) {
        Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
        treat = patient.PatientInfo[i].treat;
        TreatmentID = patient.PatientInfo[i].treatID;
        Name = patient.PatientInfo[i].Name;
        switch(patient.PatientInfo[i].Progress){
            case "0":
                Progress = "登记信息";
                break;
            case "1":
                Progress = "病情诊断";
                break;
            case "2":
                Progress = "体位固定申请";
                break;
            case "3":
                Progress = "模拟定位申请";
                break;
            case "4":
                Progress = "体位固定";
                break;
            case "5":
                Progress = "模拟定位";
                break;
            case "6":
                Progress = "CT图像导入";
                break;
            case "7":
                Progress = "计划申请";
                break;
            case "8":
                Progress = "计划领取";
                break;
            case "9":
                Progress = "计划提交";
                break;
            case "10":
                Progress = "计划确认";
                break;
            case "11":
                Progress = "计划复核";
                break;
            case "12":
                Progress = "复位申请";
                break;
            case "13":
                Progress = "复位验证";
                break;
            case "14":
                Progress = "首次治疗预约";
                break;
            case "15":
                Progress = "加速器治疗";
                break;
            case "16":
                Progress = "总结随访";
                break;
            default:
                Progress = "无";

        }
        doctor = patient.PatientInfo[i].doctor;
        /*var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
        +"</td><td>"+doctor+"</td><td>"+date+"</td><td>"+age+"</td></tr>";*/
        var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + "疗程"+ treat + "</td><td>" + Progress
        + "</td><td>" + doctor + "</td></tr>";
        tbody.append(tr);
    }
    for (var i = start; i < end; i++) {
        $("#" + patient.PatientInfo[i].treatID + "").click({ ID: patient.PatientInfo[i].treatID, treat: patient.PatientInfo[i].treat, count: patient.PatientInfo[i].Progress }, function (e) {
            currentID = e.data.ID;
            var ul = $("#progress-iframe").contents().find("#ul-progress a");
            ul.each(function (index, element) {
                $(this).find('span').removeClass();
            });
            $("#record-iframe").attr('src', "Records/Blank.aspx");
            $("#patient-status").text(e.data.state);
            var tr = $("#patient-table-body tr");
            tr.each(function (index, element) {
                if ($(this).hasClass("chose")) {
                    $(this).removeClass("chose");
                }
            });
            $(this).addClass("chose");
            var ul = $("#progress-iframe").contents().find("#ul-progress a");
            ul.each(function (index, element) {
                if (index < e.data.count) {
                    $(this).find('li').removeClass().addClass("progress-finished");
                    $(this).find('i').removeClass().addClass("fa fa-fw fa-check");
                } else if (index == e.data.count) {
                    $(this).find('li').removeClass().addClass("progress-active");
                    $(this).find('i').removeClass().addClass("fa fa-fw fa-edit");
                } else {
                    $(this).find('li').removeClass().addClass("progress-unfinished");
                    $(this).find('i').removeClass().addClass("fa fa-fw fa-ban");
                }
                switch (index + 1) {
                    case 1:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/PatientRegister.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 2:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/Diagnose.aspx?Radiotherapy_ID=" + e.data.Radiotherapy_ID +"&treat=" + e.data.treat);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 3:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/FixedApply.aspx?TreatmentID=" + e.data.ID  +"&TreatmentItem=Fixed");
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 4:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/LocationApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location");
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 5:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/FixedRecord.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 6:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/LocationRecord.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 7:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/ImportCT.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 8:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/DesignApply.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 9:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/DesignReceive.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 10:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/DesignSubmit.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 11:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/DesignConfirm.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 12:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/DesignReview.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 13:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/ReplacementApply.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Location");
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 14:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/ReplacementRecord.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 15:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/FirstAccelerator.aspx?TreatmentID=" + e.data.ID + "&TreatmentItem=Accelerator");
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 16:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/TreatmentRecord.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
                        });
                        break;
                    case 17:
                        $(this).click(function () {
                            $("#record-iframe").attr('src', "Records/Summary.aspx?TreatmentID=" + e.data.ID);
                            var ul = $("#progress-iframe").contents().find("#ul-progress a");
                            ul.each(function (index, element) {
                                $(this).find('span').removeClass();
                            });
                            $(this).find('span').removeClass().addClass("fa fa-arrow-circle-right");
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

function getPatient(){
    var xmlHttp = new XMLHttpRequest();
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetPatientInfo.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var patient = eval("(" + json + ")");
    return patient;
}

function Paging(patient) {
    if (patient.PatientInfo != "") {
        var pageindex = new Array();
        tableheight = $("#patient-content").height() - 160;
        var pagecount = 0;
        var tbody = $("#patient-table-body");
        tbody.html("");
        var ul = $("#page-index-content");
        ul.html("");
        var TreatmentID, treatID, Name, treat, doctor, Progress;
        for (var i = 0; i < patient.PatientInfo.length; i++) {
            if (tbody.height() > tableheight) {
                pageindex[pagecount] = i;
                tbody.html("");
                pagecount++;
            }
            if (i == patient.PatientInfo.length - 1) {
                pageindex[pagecount] = i + 1;
                tbody.html("");
                break;
            }
            TreatmentID = patient.PatientInfo[i].treatID;
            if (currentID == TreatmentID) {
                currentpage = pagecount + 1;
            }
            Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
            treat = patient.PatientInfo[i].treat;
            Name = patient.PatientInfo[i].Name;
            switch(patient.PatientInfo[i].Progress){
                case "0":
                    Progress = "登记信息";
                    break;
                case "1":
                    Progress = "病情诊断";
                    break;
                case "2":
                    Progress = "体位固定申请";
                    break;
                case "3":
                    Progress = "模拟定位申请";
                    break;
                case "4":
                    Progress = "体位固定";
                    break;
                case "5":
                    Progress = "模拟定位";
                    break;
                case "6":
                    Progress = "CT图像导入";
                    break;
                case "7":
                    Progress = "计划申请";
                    break;
                case "8":
                    Progress = "计划领取";
                    break;
                case "9":
                    Progress = "计划提交";
                    break;
                case "10":
                    Progress = "计划确认";
                    break;
                case "11":
                    Progress = "计划复核";
                    break;
                case "12":
                    Progress = "复位申请";
                    break;
                case "13":
                    Progress = "复位验证";
                    break;
                case "14":
                    Progress = "首次治疗预约";
                    break;
                case "15":
                    Progress = "加速器治疗";
                    break;
                case "16":
                    Progress = "总结随访";
                    break;
                default:
                    Progress = "无";

            }
            doctor = patient.PatientInfo[i].doctor;
            var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + "疗程"+ treat + "</td><td>" + Progress
            + "</td><td>" + doctor + "</td></tr>";
            /*var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
            +"</td><td>"+doctor+"</td><td>"+date+"</td><td>"+age+"</td></tr>";*/
            tbody.append(tr);
        }
        /*for (var i = 0; i < pageindex.length; i++) {
            alert(pageindex[i]);
        }*/
        var ul = $("#page-index-content");
        var ul_content = "<li class='paginate_button previous' id='table_previous'><a href='javascript:;'><i class='fa fa-fw fa-arrow-left'></i></a></li><li class='paginate_button previous disabled' id='table_previous_prevent' style='display:none;'><a href='javascript:;'><i class='fa fa-fw fa-arrow-left'></i></a></li>";
        var omitted_previous = "<li class='paginate_button' id='table_omitted_previous'><a><i>···</i></a></li>";
        var omitted_next = "<li class='paginate_button' id='table_omitted_next'><a><i>···</i></a></li>";
        ul_content = ul_content + omitted_previous;
        for (var i = 0; i < pageindex.length; i++) {
            var page = i + 1;
            var li = "<li id='page_" + page + "' class='paginate_button'><a href='javascript:;'>" + page + "</a></li>";
            ul_content = ul_content + li;
        }
        ul_content = ul_content + omitted_next;
        ul_content = ul_content + "<li class='paginate_button next' id='table_next'><a href='javascript:;'><i class='fa fa-fw fa-arrow-right'></i></a></li><li class='paginate_button next disabled' id='table_next_prevent' style='display:none;'><a href='javascript:;'><i class='fa fa-fw fa-arrow-right'></i></a></li>";
        ul.append(ul_content);
        $("#table_previous").click({ pageindex_length: pageindex.length }, function (e) {
            var currentactive = getActive();
            $("#page_" + currentactive + "").removeClass("active");
            var active = currentactive - 1;
            $("#page_" + active + "").addClass("active");
            if (currentactive == e.data.pageindex_length) {
                $("#table_next").css("display","inline");
                $("#table_next_prevent").css("display","none");
            }
            if (active == 1) {
                $("#table_previous").css("display","none");
                $("#table_previous_prevent").css("display","inline");
            }
            var k, j;
            j = pageindex[currentactive - 2];
            if (currentactive == 2) {
                k = 0;
            } else {
                k = pageindex[currentactive - 3];
            }
            CreateTable(k, j, patient);
            if (pageindex.length > 5) {
                adjustPage(pageindex.length);
            } else {
                $("#table_omitted_previous").css("display", "none");
                $("#table_omitted_next").css("display", "none");
            }
        });
        $("#table_next").click({ pageindex_length: pageindex.length }, function (e) {
            var currentactive = getActive();
            $("#page_" + currentactive + "").removeClass("active");
            var active = currentactive + 1;
            $("#page_" + active + "").addClass("active");
            if (currentactive == 1) {
                $("#table_previous").css("display","inline");
                $("#table_previous_prevent").css("display","none");
            }
            if (active == e.data.pageindex_length) {
                $("#table_next").css("display","none");
                $("#table_next_prevent").css("display","inline");
            }
            var k, j;
            j = pageindex[currentactive];
            k = pageindex[currentactive - 1];
            CreateTable(k, j, patient);
            if (pageindex.length > 5) {
                adjustPage(pageindex.length);
            } else {
                $("#table_omitted_previous").css("display", "none");
                $("#table_omitted_next").css("display", "none");
            }
        });
        CreateTable(0, pageindex[0], patient);
        $("#page_1").addClass("active");
        if (pageindex.length == 1) {
            $("#table_next").css("display","none");
            $("#table_previous").css("display","none");
            $("#table_next_prevent").css("display","inline");
            $("#table_previous_prevent").css("display","inline");
        }
        for (var i = 0; i < pageindex.length; i++) {
            var page = i + 1;
            $("#page_" + page + "").click({ i: i, page: page, pageindex_length: pageindex.length }, function (e) {
                var k, j;
                j = pageindex[e.data.i];
                if (e.data.i == 0) {
                    k = 0;
                } else {
                    k = pageindex[e.data.i - 1];
                }
                CreateTable(k, j, patient);
                for (var m = 0; m < e.data.pageindex_length; m++) {
                    var n = m + 1;
                    $("#page_" + n + "").removeClass("active");
                }
                $("#table_previous").css("display","inline");
                $("#table_previous_prevent").css("display","none");
                $("#table_next").css("display","inline");
                $("#table_next_prevent").css("display","none");
                $("#page_" + e.data.page + "").addClass("active");
                if (e.data.i == e.data.pageindex_length - 1) {
                    $("#table_previous").css("display","inline");
                    $("#table_previous_prevent").css("display","none");
                    $("#table_next").css("display","none");
                    $("#table_next_prevent").css("display","inline");
                }
                if (e.data.i == 0) {
                    $("#table_previous").css("display","none");
                    $("#table_previous_prevent").css("display","inline");
                    $("#table_next").css("display","inline");
                    $("#table_next_prevent").css("display","none");
                }
                if (pageindex.length > 5) {
                    adjustPage(pageindex.length);
                } else {
                    $("#table_omitted_previous").css("display", "none");
                    $("#table_omitted_next").css("display", "none");
                }
            });
        }
        if (pageindex.length > 5) {
            adjustPage(pageindex.length);
        } else {
            $("#table_omitted_previous").css("display", "none");
            $("#table_omitted_next").css("display", "none");
        }
    } else {
        var tbody = $("#patient-table-body");
        tbody.html("");
        var tr = "<tr><td colspan='5' style='text-align:center'>没有病人信息</td></tr>";
        tbody.append(tr);
        $("#patient_info").text("本页0条记录 / 共0条记录");
    }
    Recover();
}
