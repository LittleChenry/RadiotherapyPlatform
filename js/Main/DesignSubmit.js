﻿
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

    var select1 = document.getElementById("PlanSystem");
    createPlanSystemItem(select1);
    var select2 = document.getElementById("Grid");
    createGridItem(select2);
    var select3 = document.getElementById("Algorithm");
    createAlgorithmItem(select3);
    if (patient.Progress >= 9) {
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
        document.getElementById("userID").value = userID;
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
    
        if (patient.Progress >=10) {
            document.getElementById("PlanSystem").value = designInfo.PlanSystem;
            document.getElementById("PlanSystem").disabled = true;
            document.getElementById("IlluminatedNumber").value = designInfo.IlluminatedNumber;
            document.getElementById("IlluminatedNumber").disabled = true;
            document.getElementById("Coplanar").value = designInfo.Coplanar;
            document.getElementById("Coplanar").disabled = true;
            document.getElementById("MachineNumbe").value = designInfo.MachineNumbe;
            document.getElementById("MachineNumbe").disabled = true;
            document.getElementById("ControlPoint").value = designInfo.ControlPoint;
            document.getElementById("ControlPoint").disabled = true;
            document.getElementById("Grid").value = designInfo.Grid_ID;
            document.getElementById("Grid").disabled = true;
            document.getElementById("Algorithm").value = designInfo.Algorithm_ID;
            document.getElementById("Algorithm").disabled = true;
            document.getElementById("Feasibility").value = designInfo.Feasibility;
            document.getElementById("Feasibility").disabled = true;
            document.getElementById("applyuser").innerHTML = designInfo.SubmitUser;
            document.getElementById("time").innerHTML = designInfo.SubmitTime;
        }
   }

}

function createGridItem(thiselement) {
    var PartItem = JSON.parse(getPartItem3()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--计算网格选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem3() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getGrid.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function createPlanSystemItem(thiselement) {
    var PartItem = JSON.parse(getPartItem2()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--计划系统选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem2() {
    var xmlHttp = new XMLHttpRequest();
    var url = "PlanSystem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function createAlgorithmItem(thiselement) {
    var PartItem = JSON.parse(getPartItem1()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--优化算法选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem1() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getAlgorithm.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designSubmitInfo.ashx?treatID=" + treatID;
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
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var tr = document.createElement("tr");
        for (var j = 0; j < list.length; j++) {
            var td = document.createElement("td");
            var textNode = document.createTextNode(list[j]);
            td.appendChild(textNode);
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    tbody.style.textAlign = "center";
    table.appendChild(tbody);
}

function RemoveAllChild(area) {
    while (area.hasChildNodes()) {
        var first = area.firstChild;
        if (first != null && first != undefined)
            area.removeChild(first);
    }
}

function readDosage(DosagePriority) {
    var table = document.getElementById("Dosage");
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var tr = document.createElement("tr");
        for (var j = 0; j < list.length; j++) {
            var td = document.createElement("td");
            if (j == 2) {
                var textNode = document.createTextNode("<");
                td.appendChild(textNode);
                tr.appendChild(td);
            }else{
                var textNode = document.createTextNode(list[j]);
            }
            td.appendChild(textNode);
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    tbody.style.textAlign = "center";
    table.appendChild(tbody);
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
function saveDesignSubmit() {
    if (document.getElementById("PlanSystem").value == "allItem") {
        window.alert("计划系统没有选择");
        return;
    }
    if (document.getElementById("Grid").value == "allItem") {
        window.alert("计算网格没有选择");
        return;
    }
    if (document.getElementById("Algorithm").value == "allItem") {
        window.alert("优化算法没有选择");
        return;
    }
    if (document.getElementById("IlluminatedNumber").value == "") {
        window.alert("请填写射野数量");
        return;
    }
    if (document.getElementById("MachineNumbe").value == "") {
        window.alert("请填写机器跳数");
        return;
    }
    if (document.getElementById("ControlPoint").value == "") {
        window.alert("请填写控制点数量");
        return;
    }
   
    document.getElementById("saveDesignSubmit").submit();

}