
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
    
    
    if (patient.Progress >= 10) {
        var designInfo = getDesignInfo(treatID);
        document.getElementById("Remarks").innerHTML = designInfo.RadiotherapyHistory;
        readDosagePriority(designInfo.DosagePriority);
        readDosage(designInfo.Dosage);
        document.getElementById("technology").innerHTML = designInfo.technology;
        document.getElementById("equipment").innerHTML = designInfo.equipment;
        document.getElementById("ApplicationUser").innerHTML = designInfo.doctor;
        document.getElementById("ApplicationTime").innerHTML = designInfo.apptime;
        document.getElementById("receiveUser").innerHTML = designInfo.ReceiveUser;
        document.getElementById("receiveTime").innerHTML = designInfo.ReceiveTime;
        document.getElementById("PlanSystem").innerHTML = designInfo.PlanSystem;
        document.getElementById("IlluminatedNumber").innerHTML = designInfo.IlluminatedNumber;
        document.getElementById("Coplanar").innerHTML = charge1(designInfo.Coplanar);
        document.getElementById("MachineNumbe").innerHTML = designInfo.MachineNumbe;
        document.getElementById("ControlPoint").innerHTML = designInfo.ControlPoint;
        document.getElementById("Grid").innerHTML = designInfo.Grid_ID;
        document.getElementById("Algorithm").innerHTML = designInfo.Algorithm_ID;
        document.getElementById("Feasibility").innerHTML = charge(designInfo.Feasibility);
        document.getElementById("Submituser").innerHTML = designInfo.SubmitUser;
        document.getElementById("Submittime").innerHTML = designInfo.SubmitTime;
        document.getElementById("userID").value = userID;
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
        document.getElementById("confirm").addEventListener("click", function (evt) {
            document.getElementById("state").value = "审核通过";
        }, false);
        document.getElementById("unconfirm").addEventListener("click", function (evt) {
            document.getElementById("state").value = "审核不通过";
        }, false);
        if (patient.Progress >= 11) {
            document.getElementById("advice").value = designInfo.advice;
            document.getElementById("advice").disabled = true;
            document.getElementById("state").value = charge2(designInfo.State);
            document.getElementById("state").disabled = true;
            document.getElementById("confirm").disabled = true;
            document.getElementById("unconfirm").disabled = true;
            document.getElementById("applyuser").innerHTML = designInfo.ConfirmUser;
            document.getElementById("time").innerHTML = designInfo.ConfirmTime;
        }
     }

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
function readDosagePriority(DosagePriority) {
    var table = document.getElementById("Priority");
    var rows = table.rows.length;
    for (var i = rows - 1; i > 0; i--) {
        table.deleteRow(i);
    }

    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var count = 0;
        var row = table.insertRow(1);

        var t1 = row.insertCell(0);
        var t2 = row.insertCell(1);
        var t3 = row.insertCell(2);
        var t4 = row.insertCell(3);
        var t5 = row.insertCell(4);
        var t6 = row.insertCell(5);
        var t7 = row.insertCell(6);
        var t8 = row.insertCell(7);
        var t9 = row.insertCell(8);
        t1.innerHTML = list[count++];
        t2.innerHTML = list[count++];
        t3.innerHTML = list[count++];
        t4.innerHTML = list[count++];
        t5.innerHTML = list[count++];
        t6.innerHTML = list[count++];
        t7.innerHTML = list[count++];
        t8.innerHTML = list[count++];

        rows++;
    }
}
function readDosage(DosagePriority) {
    var table = document.getElementById("Dosage");
    var rows = table.rows.length;
    for (var i = rows - 1; i > 0; i--) {
        table.deleteRow(i);
    }

    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var count = 0;
        var row = table.insertRow(1);

        var t1 = row.insertCell(0);
        var t2 = row.insertCell(1);
        var t3 = row.insertCell(2);
        var t4 = row.insertCell(3);
        var t5 = row.insertCell(4);
        var t6 = row.insertCell(5);
        var t7 = row.insertCell(6);
        var t8 = row.insertCell(7);
        var t9 = row.insertCell(8);
        t1.innerHTML = list[count++];
        t2.innerHTML = list[count++];
        t3.innerHTML = "<";
        t4.innerHTML = list[count++];
        t5.innerHTML = list[count++];
        t6.innerHTML = "<";
        t7.innerHTML = list[count++];
        t8.innerHTML = list[count++];

        rows++;
    }
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
        return "审核不通过";
    else
        return "审核通过";
}
function saveDesignConfirm() {
    if (document.getElementById("state").value == "未审核") {
        window.alert("请审核计划");
        return;
    }
    if (document.getElementById("advice").value == "") {
        window.alert("请填写审核意见");
        return;
    }  
    document.getElementById("saveDesignConfirm").submit();

}
