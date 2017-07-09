﻿window.addEventListener("load", createPatient, false)

var userID;
var treatID;
var userName;
var radioID;
//JS入口主函数
function createPatient(evt) {
    //获取入口患者信息界面的div

    //获得当前执行人姓名与ID
    getUserID();
    getUserName();
    var treatmentgroup = window.location.search.split("&")[1];
    treatID = treatmentgroup.split("=")[1];
    var treatmentgroup1 = window.location.search.split("&")[0];
    radioID = treatmentgroup1.split("=")[1];
    document.getElementById("treatID").innerHTML = treatID;
    var patient = getPatientInfo(treatID, radioID);    
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
    //调取后台所有等待就诊的疗程号及其对应的病人
    document.getElementById("test").addEventListener("click", removeDisabled, false);
    var select3 = document.getElementById("part");
    createPartItem(select3);
    var select4 = document.getElementById("diagresult");
    createDiagResultItem(select4);  
    var diagnosisInfo = getDignoseInfo(patient.treatID);        
        if (patient.Progress >= 2) {
            document.getElementById("operator").innerHTML = diagnosisInfo.username;
            document.getElementById("remark").value = diagnosisInfo.Remarks;
           
            document.getElementById("part").value =  diagnosisInfo.partID;
            document.getElementById("diagresult").value = diagnosisInfo.diagnosisresultID;
            // diagnosisresultID = DiagnoseInfo.diagnosisInfo[0].diagnosisresultID;
            //doctor = DiagnoseInfo.DiagnoseInfo[0].doctor;

            document.getElementById("date").innerHTML = diagnosisInfo.Time;

        } else {
            document.getElementById("date").innerHTML = getNowFormatDate();
            document.getElementById("operator").innerHTML = userName;
            document.getElementById("diaguserid").value = userID;
            

        }
    
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
    var min=date.getMinutes();
    if (min < 10) {
        min = "0" + min;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + min;
           
    return currentdate;
}
function getDignoseInfo(treatid) {

    var xmlHttp = new XMLHttpRequest();

    var url = "diagnoseInfo.ashx?treatID=" + treatid;

    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.diagnosisInfo[0];
}

//获取病人基本信息
function getPatientInfo(treatmentID,RadiotherapyID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientForDiagnose.ashx?treatmentID=" + treatmentID + "&RadiotherapyID=" + RadiotherapyID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}

//首页判断

//生成基本信息确认DIV

//第二步部位下拉项建立
function createPartItem(thiselement) {
    var PartItem = JSON.parse(getPartItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----部位选择-----");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//第二步诊断结果下拉建立
function createDiagResultItem(thiselement) {
    var DiagResultItem = JSON.parse(getDiagResultItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----结果选择-----");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < DiagResultItem.length; i++) {
        if (DiagResultItem[i] != "") {
            thiselement.options[i + 1] = new Option(DiagResultItem[i].Name);
            thiselement.options[i + 1].value = parseInt(DiagResultItem[i].ID);
        }
    }


}
//第二步诊断结果下拉选项获取
function getDiagResultItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getDiagResult.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function checkAll() {
    
    var time = document.getElementById("time");
    var diaguserid = document.getElementById("diaguserid");
    var remark = document.getElementById("remark");
    var select3 = document.getElementById("part");
    var select4 = document.getElementById("diagresult");

    if (select3.value == "allItem") {
        window.alert("请选择部位");
        return;
    }
    if (select4.value == "allItem") {
        window.alert("请选择诊断结果");
        return;
    }
    var xmlHttp = new XMLHttpRequest();
    var url = "recordDiag.ashx?treatid=" + treatID +"&radioid=" + radioID+ "&diaguserid=" + diaguserid.value + "&remark=" + remark.value;
    url = url + "&part=" + select3.value + "&diagresult=" + select4.value;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    if (Items == "success") {
        window.alert("诊断成功");
        askForBack();
        return;

    }
    else {
        window.alert("诊断失败");
        return;
    }
}

//检查填写情况
/*
function getUserName() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../Root/GetUserName.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userName = xmlHttp.responseText;
            }
        }
    }
    xmlHttp.send();
}*/
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
//下面是jquery流程条实现代码

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
function askForBack() {
    document.location.reload();

}
function removeDisabled() {
    document.getElementById("remark").removeAttribute("disabled");
    document.getElementById("part").removeAttribute("disabled");
    document.getElementById("diagresult").removeAttribute("disabled");
}
