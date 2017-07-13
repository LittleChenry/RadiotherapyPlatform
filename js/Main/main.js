var currentID = 0;
var functions = new Array();

$(document).ready(function () {
    $(".frame-content").height($(document).height() - 151);
    $("#patient-content").height($(document).height() - 151);
    $("#patient-table-content").height($(document).height() - 190);
    $("#record-iframe").width($("#record-content").width());
    $("#progress-iframe").width($("#progress-content").width());
    var session = getSession();
    var patient = getPatient(session.userID, session.role);
    $("#patient-search").bind('input propertychange', function() {
        var Searchedpatients = Search($("#patient-search").val(),patient);
        Paging(Searchedpatients);
    });
    Paging(patient,session.role);
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("../Login/Login.aspx");
    });
    $("#save").click(function(){
        addProgress(patient);
        Paging(patient);
        $('#save').attr("disabled","disabled");
    });
    $('#edit').click(function(){
        $("#save").removeAttr("disabled");
        $('#edit').attr("disabled","disabled");
    });
    $("#saveTreatment").bind("click",saveTreatment);
    //chooseAssistant();
    getFunctions();
})

/*window.onresize=function(){
    document.location.reload();
}*/

function ProgressToString(pro){
    var Progress = "";
    switch(pro){
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
}

function Paging(patient,role){
    if (patient.PatientInfo != "") {
        tableheight = $("#patient-content").height() - 160;
        var table = $("#patient-table");
        table.html("");
        switch(role){
            case "医师":
                var Radiotherapy_ID, Name, treat, diagnosisresult, Progress, doctor, groupname;
                var thead = '<thead><tr><th>放疗号</th><th>姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody>';
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    TreatmentID = patient.PatientInfo[i].treatID;
                    Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
                    Name = patient.PatientInfo[i].Name;
                    treat = patient.PatientInfo[i].treat;
                    diagnosisresult = patient.PatientInfo[i].diagnosisresult;
                    Progress = ProgressToString(patient.PatientInfo[i].Progress);
                    doctor = patient.PatientInfo[i].doctor;
                    groupname = patient.PatientInfo[i].groupname;
                    var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + "疗程"+ treat + "</td><td>" + diagnosisresult + "</td><td>" + Progress
                        + "</td><td>" + doctor + "</td><td>" + groupname + "</td></tr>";
                    tbody += tr;
                }
                tbody += '</tbody>';
                table.append(tbody);
                for (var i = 0; i < patient.PatientInfo.length; i++) {
                    Things[i]
                }
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
        var TreatmentID, treatID, Name, treat, doctor, Progress;
        $("#patient_info").text("共" + patient.PatientInfo.length + "条记录");
        for (var i = 0; i < patient.PatientInfo.length; i++) {
            TreatmentID = patient.PatientInfo[i].treatID;
            Radiotherapy_ID = patient.PatientInfo[i].Radiotherapy_ID;
            treat = patient.PatientInfo[i].treat;
            Name = patient.PatientInfo[i].Name;
            
            doctor = patient.PatientInfo[i].doctor;
            var tr = "<tr id='" + TreatmentID + "'><td>" + Radiotherapy_ID + "</td><td>" + Name + "</td><td>" + "疗程"+ treat + "</td><td>" + Progress
            + "</td><td>" + doctor + "</td></tr>";
            /*var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
            +"</td><td>"+doctor+"</td><td>"+date+"</td><td>"+age+"</td></tr>";*/
            tbody.append(tr);

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
                                checkEdit("0");
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
                                checkEdit("1");
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
                                checkEdit("2");
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
                                checkEdit("3");
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
                                checkEdit("4");
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
                                checkEdit("5");
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
                                checkEdit("6");
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
                                checkEdit("7");
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
                                checkEdit("8");
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
                                checkEdit("9");
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
                                checkEdit("10");
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
                                checkEdit("11");
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
                                checkEdit("12");
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
                                checkEdit("13");
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
                                checkEdit("14");
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
                                checkEdit("15");
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
        
    } else {
        var table = $("#patient-table");
        table.html("");
        switch(role){
            case "医师":
                var thead = '<thead><tr><th>放疗号</th><th>姓名</th><th>疗程</th><th>诊断结果</th><th>当前进度</th>'
                    + '<th>主治医生</th><th>医疗组</th></tr></thead>';
                table.append(thead);
                var tbody = '<tbody><tr><td colspan="7" style="text-align:left;padding-left:250px;">没有病人信息</td></tr></tbody>';
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
        var tbody = $("#patient-table");
        tbody.html("");
        
        tbody.append(tr);
        $("#patient_info").text("本页0条记录 / 共0条记录");
    }
    Recover();
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
    alert("diagnose:" + diagnose + ",fixed:" + fixed + ",location:" + location + ",design:" + design + ",replace:" + replace + ",treatmentname:" + treatmentname + ",review:" + review + ",group:" + group + ",Radiotherapy_ID:" + Radiotherapy_ID);
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
    $("#addTreatment").attr("disabled","disabled");
    for (var i = 0; i < functions.length; i++) {
        if(functions[i].toString() == "18"){
            $("#addTreatment").removeAttr("disabled");
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

function getFunctions(){
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            obj = $.parseJSON(data);
            functions = obj.progress.split(" ");
        },
        error: function(){
            alert("error");
        }
    });
}

function getSession(){
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
        error: function(){
            alert("error");
        }
    });
    return Session;
}

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
    if(currentID != "0" && $("#" + currentID).length > 0){
        $("#" + currentID).addClass("chose");
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
                            checkEdit("0");
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
                            checkEdit("1");
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
                            checkEdit("2");
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
                            checkEdit("3");
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
                            checkEdit("4");
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
                            checkEdit("5");
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
                            checkEdit("6");
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
                            checkEdit("7");
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
                            checkEdit("8");
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
                            checkEdit("9");
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
                            checkEdit("10");
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
                            checkEdit("11");
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
                            checkEdit("12");
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
                            checkEdit("13");
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
                            checkEdit("14");
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
                            checkEdit("15");
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

function getPatient(userID,role){
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
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var patient = eval("(" + json + ")");
    return patient;
}

function PagingTemp(patient) {
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
