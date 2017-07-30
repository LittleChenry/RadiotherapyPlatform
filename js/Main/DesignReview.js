﻿window.addEventListener("load", Init, false);

var userName;
var userID;
function Init(evt) {

    //获得当前执行人姓名与ID
    getUserName();
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    //此处为分页代码
    //alert("jy");
    //document.getElementById("username").value = userID; 
    var treatID = window.location.search.split("=")[1];


    var patient = getPatientInfo(treatID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    var texthos = hosttext(patient.Hospital_ID);
    document.getElementById("hospitalid").innerHTML = texthos;
    document.getElementById("lightpart").innerHTML = patient.lightpartname;

    var progress = patient.Progress.split(",");
    if (isInArray(progress, '10')) {
        var designInfo = getDesignInfo(treatID);
        var length = designInfo.length;
        for (var i = 0; i < length; i++) {
            if (designInfo[i].Treatmentname == patient.Treatmentname) {
                document.getElementById("Technology").innerHTML = designInfo[i].technology;
                document.getElementById("Equipment").innerHTML = designInfo[i].equipment;
                document.getElementById("PlanSystem").innerHTML = designInfo[i].PlanSystem;
                document.getElementById("IlluminatedNumber").innerHTML = designInfo[i].IlluminatedNumber;
                document.getElementById("Coplanar").innerHTML = charge1(designInfo[i].Coplanar);
                document.getElementById("MachineNumbe").innerHTML = designInfo[i].MachineNumbe;
                document.getElementById("ControlPoint").innerHTML = designInfo[i].ControlPoint;
                document.getElementById("Grid").innerHTML = designInfo[i].Grid_ID;
                document.getElementById("Algorithm").innerHTML = designInfo[i].Algorithm_ID;
                document.getElementById("Feasibility").innerHTML = charge(designInfo[i].Feasibility);
            }
        }
        document.getElementById("userID").value = userID;
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
        if (isInArray(progress, '11')) {
            var reviewInfo = getReviewInfo(treatID);
            for (var i = 0; i < reviewInfo.length; i++) {
                if (reviewInfo[i].Treatmentname == patient.Treatmentname) {
                    document.getElementById("TechnologyConfirm").innerHTML = charge2(reviewInfo[i].TechnologyConfirm);
                    document.getElementById("EquipmentConfirm").innerHTML = charge2(reviewInfo[i].EquipmentConfirm);
                    document.getElementById("PlanSystemConfirm").innerHTML = charge2(reviewInfo[i].PlanSystemConfirm);
                    document.getElementById("AngleConfirm").innerHTML = charge2(reviewInfo[i].AngleConfirm);
                    document.getElementById("CoplanarConfirm").innerHTML = charge2(reviewInfo[i].CoplanarConfirm);
                    document.getElementById("MachineNumbeConfirm").innerHTML = charge2(reviewInfo[i].MachineNumbeConfirm);
                    document.getElementById("ControlPointConfirm").innerHTML = charge2(reviewInfo[i].ControlPointConfirm);
                    document.getElementById("GridConfirm").innerHTML = charge2(reviewInfo[i].GridConfirm);
                    document.getElementById("AlgorithmConfirm").innerHTML = charge2(reviewInfo[i].AlgorithmConfirm);
                    document.getElementById("FeasibilityConfirm").innerHTML = charge(reviewInfo[i].FeasibilityConfirm);
                    document.getElementById("Reoptimization").innerHTML = charge2(reviewInfo[i].Reoptimization);
                    document.getElementById("PlaceInformation").innerHTML = charge2(reviewInfo[i].PlaceInformation);
                    document.getElementById("DRR").innerHTML = charge2(reviewInfo[i].DRR);
                    getreference(reviewInfo[i].ReferenceCenter);
                    gettreatment(reviewInfo[i].TreatmentCenter);
                    getmovement(reviewInfo[i].Movement);

                    document.getElementById("IsExport").innerHTML = charge2(reviewInfo[i].IsExport);
                    document.getElementById("applyuser").innerHTML = reviewInfo[i].name;
                    document.getElementById("time").innerHTML = reviewInfo[i].ReviewTime;
                }
            }
        }
    }
    $('#ReferenceCenterX').bind('input propertychange', function () {
        if (document.getElementById("ReferenceCenterX").value == "") {
            document.getElementById("MovementX").value = "";
        } else {
            document.getElementById("MovementX").value = parseInt(document.getElementById("ReferenceCenterX").value) - parseInt(document.getElementById("TreatmentCenterX").value);
        }
    });
    $('#TreatmentCenterX').bind('input propertychange', function () {
        if (document.getElementById("TreatmentCenterX").value == "") {
            document.getElementById("MovementX").value = "";
        } else {
            document.getElementById("MovementX").value = parseInt(document.getElementById("ReferenceCenterX").value) - parseInt(document.getElementById("TreatmentCenterX").value);
        }
    });
    $('#ReferenceCenterY').bind('input propertychange', function () {
        if (document.getElementById("ReferenceCenterY").value == "") {
            document.getElementById("MovementY").value = "";
        } else {
            document.getElementById("MovementY").value = parseInt(document.getElementById("ReferenceCenterY").value) - parseInt(document.getElementById("TreatmentCenterY").value);
        }
    });
    $('#TreatmentCenterY').bind('input propertychange', function () {
        if (document.getElementById("TreatmentCenterY").value == "") {
            document.getElementById("MovementY").value = "";
        } else {
            document.getElementById("MovementY").value = parseInt(document.getElementById("ReferenceCenterY").value) - parseInt(document.getElementById("TreatmentCenterY").value);
        }
    });
    $('#ReferenceCenterZ').bind('input propertychange', function () {
        if (document.getElementById("ReferenceCenterZ").value == "") {
            document.getElementById("MovementZ").value = "";
        } else {
            document.getElementById("MovementZ").value = parseInt(document.getElementById("ReferenceCenterZ").value) - parseInt(document.getElementById("TreatmentCenterZ").value);
        }
    });
    $('#TreatmentCenterZ').bind('input propertychange', function () {
        if (document.getElementById("TreatmentCenterZ").value == "") {
            document.getElementById("MovementZ").value = "";
        } else {
            document.getElementById("MovementZ").value = parseInt(document.getElementById("ReferenceCenterZ").value) - parseInt(document.getElementById("TreatmentCenterZ").value);
        }
    });
}
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
}
function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}
function getReviewInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "ReviewInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.reviewInfo;
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
}
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}

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


function confirm(input, Confirm, Confirm1, Button, cancelButton) {
    var content = input.innerHTML;
    switch (content) {
        case "通过":
            Confirm.innerHTML = "通过";
            Confirm1.value = "1";
            break;
        case "可执行":
            Confirm.innerHTML = "可执行";
            Confirm1.value = "1";
            break;
        case "不可再优化":
            Confirm.innerHTML = "不可再优化";
            Confirm1.value = "1";
            break;
        case "是":
            Confirm.innerHTML = "是";
            Confirm1.value = "1";
            break;
    }
    Button.style.display = "none";
    cancelButton.style.display = "block";
}

function cancelconfirm(input, Confirm, Confirm1, Button, cancelButton) {
    var content = input.innerHTML;
    switch (content) {
        case "取消通过":
            Confirm.innerHTML = "不通过";
            Confirm1.value = "0";
            break;
        case "不可执行":
            Confirm.innerHTML = "不可执行";
            Confirm1.value = "0";
            break;
        case "可再优化":
            Confirm.innerHTML = "可再优化";
            Confirm1.value = "0";
            break;
        case "否":
            Confirm.innerHTML = "否";
            Confirm1.value = "0";
            break;
    }
    Button.style.display = "block";
    cancelButton.style.display = "none";
}
function getUserName() {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetUserName.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userName = xmlHttp.responseText;
            }
        }
    }
    xmlHttp.send();
}
function getUserID() {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetUserID.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userID = xmlHttp.responseText;
            }
        }
    }
    xmlHttp.send();
}
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}
function charge(evt) {
    if (evt == "0")
        return "不可执行";
    else
        return "可执行";
}
function charge1(evt) {
    if (evt == "0")
        return "不是";
    else
        return "是";
}
function charge2(evt) {
    if (evt == "0")
        return "不通过";
    else
        return "通过";
}
function getreference(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("ReferenceCenterX").value = Reference[0];
    document.getElementById("ReferenceCenterY").value = Reference[1];
    document.getElementById("ReferenceCenterZ").value = Reference[2];
}
function gettreatment(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("TreatmentCenterX").value = Reference[0];
    document.getElementById("TreatmentCenterY").value = Reference[1];
    document.getElementById("TreatmentCenterZ").value = Reference[2];
}
function getmovement(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("MovementX").value = Reference[0];
    document.getElementById("MovementY").value = Reference[1];
    document.getElementById("MovementZ").value = Reference[2];
}
function save() {
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveReview"));
    $.ajax({
        url: "designReviewRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        async: false,
        contentType: false,
        success: function (data) {
            alert("保存成功");
            window.location.reload();
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        },
        failure: function (e) {
            window.location.href = "Error.aspx";
        }
    });
}
function remove() {   
    document.getElementById("confirmTechnology").removeAttribute("disabled");
    document.getElementById("confirmEquipment").removeAttribute("disabled");
    document.getElementById("confirmPlanSystem").removeAttribute("disabled");
    document.getElementById("confirmAngle").removeAttribute("disabled");
    document.getElementById("confirmCoplanar").removeAttribute("disabled");
    document.getElementById("confirmMachineNumbe").removeAttribute("disabled");
    document.getElementById("confirmControlPoint").removeAttribute("disabled");
    document.getElementById("confirmGrid").removeAttribute("disabled");
    document.getElementById("confirmAlgorithm").removeAttribute("disabled");
    document.getElementById("confirmFeasibility").removeAttribute("disabled");
    document.getElementById("confirmReoptimization").removeAttribute("disabled");
    document.getElementById("confirmPlaceInformation").removeAttribute("disabled");
    document.getElementById("confirmIsExport").removeAttribute("disabled");
    document.getElementById("confirmDRR").removeAttribute("disabled");
    document.getElementById("ReferenceCenterX").removeAttribute("disabled");
    document.getElementById("ReferenceCenterY").removeAttribute("disabled");
    document.getElementById("ReferenceCenterZ").removeAttribute("disabled");
    document.getElementById("TreatmentCenterX").removeAttribute("disabled");
    document.getElementById("TreatmentCenterY").removeAttribute("disabled");
    document.getElementById("TreatmentCenterZ").removeAttribute("disabled");
    document.getElementById("MovementX").removeAttribute("disabled");
    document.getElementById("MovementY").removeAttribute("disabled");
    document.getElementById("MovementZ").removeAttribute("disabled");
    document.getElementById("fp_upload").removeAttribute("disabled");
    document.getElementById("fp_upload1").removeAttribute("disabled");
}