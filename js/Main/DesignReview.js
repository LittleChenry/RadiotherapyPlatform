window.addEventListener("load", Init, false);

var userName;
var userID;
function Init(evt) {

    //获得当前执行人姓名与ID
    getUserName();
    getUserID();
    //此处为分页代码
    //alert("jy");
    //document.getElementById("username").value = userID; 
    var treatID = window.location.search.split("=")[1];
    document.getElementById("treatID").innerHTML = treatID;

    var patient = getPatientInfo(treatID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("address").innerHTML = patient.Address;
    document.getElementById("hospital").innerHTML = patient.Hospital;
    document.getElementById("contact").innerHTML = patient.Contact1;
    document.getElementById("contact2").innerHTML = patient.Contact2;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("part").innerHTML = patient.partname;


    if (patient.Progress >= 13) {
        var designInfo = getDesignInfo(treatID);      
        document.getElementById("Technology").innerHTML = designInfo.technology;
        document.getElementById("Equipment").innerHTML = designInfo.equipment;      
        document.getElementById("PlanSystem").innerHTML = designInfo.PlanSystem;
        document.getElementById("IlluminatedNumber").innerHTML = designInfo.IlluminatedNumber;
        document.getElementById("Coplanar").innerHTML = charge1(designInfo.Coplanar);
        document.getElementById("MachineNumbe").innerHTML = designInfo.MachineNumbe;
        document.getElementById("ControlPoint").innerHTML = designInfo.ControlPoint;
        document.getElementById("Grid").innerHTML = designInfo.Grid_ID;
        document.getElementById("Algorithm").innerHTML = designInfo.Algorithm_ID;
        document.getElementById("Feasibility").innerHTML = charge(designInfo.Feasibility);       
        document.getElementById("userID").value = userID;
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
   
        if (patient.Progress >= 14) {
            var reviewInfo = getReviewInfo(treatID);
            document.getElementById("TechnologyConfirm").innerHTML = charge2(reviewInfo.TechnologyConfirm);
            document.getElementById("EquipmentConfirm").innerHTML = charge2(reviewInfo.EquipmentConfirm);
            document.getElementById("PlanSystemConfirm").innerHTML = charge2(reviewInfo.PlanSystemConfirm);
            document.getElementById("AngleConfirm").innerHTML = charge2(reviewInfo.AngleConfirm);
            document.getElementById("CoplanarConfirm").innerHTML = charge2(reviewInfo.CoplanarConfirm);
            document.getElementById("MachineNumbeConfirm").innerHTML = charge2(reviewInfo.MachineNumbeConfirm);
            document.getElementById("ControlPointConfirm").innerHTML = charge2(reviewInfo.ControlPointConfirm);
            document.getElementById("GridConfirm").innerHTML = charge2(reviewInfo.GridConfirm);
            document.getElementById("AlgorithmConfirm").innerHTML = charge2(reviewInfo.AlgorithmConfirm);
            document.getElementById("FeasibilityConfirm").innerHTML = charge2(reviewInfo.FeasibilityConfirm);
            document.getElementById("Reoptimization").innerHTML = charge2(reviewInfo.Reoptimization);
            document.getElementById("PlaceInformation").innerHTML = charge2(reviewInfo.PlaceInformation);
            document.getElementById("DRR").innerHTML = charge2(reviewInfo.DRR);
            getreference(reviewInfo.ReferenceCenter);
            gettreatment(reviewInfo.TreatmentCenter);
            getmovement(reviewInfo.Movement);
            document.getElementById("confirmTechnology").disabled = true;
            document.getElementById("confirmEquipment").disabled = true;
            document.getElementById("confirmPlanSystem").disabled = true;
            document.getElementById("confirmAngle").disabled = true;
            document.getElementById("confirmCoplanar").disabled = true;
            document.getElementById("confirmMachineNumbe").disabled = true;
            document.getElementById("confirmControlPoint").disabled = true;
            document.getElementById("confirmGrid").disabled = true;
            document.getElementById("confirmAlgorithm").disabled = true;
            document.getElementById("confirmFeasibility").disabled = true;
            document.getElementById("confirmReoptimization").disabled = true;
            document.getElementById("confirmPlaceInformation").disabled = true;
            document.getElementById("confirmIsExport").disabled = true;
            document.getElementById("confirmDRR").disabled = true;
            document.getElementById("ReferenceCenterX").disabled=true;
            document.getElementById("ReferenceCenterY").disabled = true;
            document.getElementById("ReferenceCenterZ").disabled = true;
            document.getElementById("TreatmentCenterX").disabled = true;
            document.getElementById("TreatmentCenterY").disabled = true;
            document.getElementById("TreatmentCenterZ").disabled = true;
            document.getElementById("MovementX").disabled = true;
            document.getElementById("MovementY").disabled = true;
            document.getElementById("MovementZ").disabled = true;
            document.getElementById("IsExport").innerHTML = charge2(reviewInfo.IsExport);
            document.getElementById("applyuser").innerHTML = reviewInfo.name;
            document.getElementById("time").innerHTML = reviewInfo.ReviewTime;
        }
    }

}


function getReviewInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "ReviewInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.reviewInfo[0];
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo[0];
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
        return "不可行";
    else
        return "可行";
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
function saveDesignReview() {
    document.getElementById("saveReview").submit();

}
