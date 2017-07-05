window.addEventListener("load", Init, false);

var userName;
var userID;
var SummaryInfo;
var treatID;
function Init(evt) {

    //获得当前执行人姓名与ID
    getUserName();
    getUserID();
    //此处为分页代码
    //alert("jy");
    //document.getElementById("username").value = userID; 
   treatID = window.location.search.split("=")[1];
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
    if (patient.Progress = 16) {
        getSummaryInfo(treatID);
        var summaryinfo = SummaryInfo.summaryInfo;
        var length = summaryinfo.length;
        var summarycontent = document.getElementById("summarycontent");
        for (var i = 0; i < length; i++) {
            var summarydiv = document.createElement("div");
            summarydiv.className = "single-record";
            summarycontent.appendChild(summarydiv);
            summarydiv.innerHTML = '<div class="single-row"><div class="item col-xs-4"><span>' + summaryinfo[i].OperateTime + '</span></div></div>' +
                        '<div class="single-row"><span class="col-xs-2">随访内容：</span><span class="col-xs-10">' + summaryinfo[i].Content +'</span>' +
                        '</div><div class="single-row"><span class="col-xs-2">随访医生：</span><span class="col-xs-4">' + summaryinfo[i].username + '</span></div>';
        }
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
    }
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
function getSummaryInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "SummaryInfo.ashx?treatID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;    
            SummaryInfo = eval("(" + getString + ")");
        }
    }
    xmlHttp.send();
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
function putIn() {
    var remark = document.getElementById("content");
    if (remark.value == "") {
        window.alert("请填写随访记录");
        return;
    }
    var xmlHttp = new XMLHttpRequest();
    var url = "recordSummary.ashx?treatid=" + treatID + "&userid=" + userID + "&content=" + remark.value;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    if (Items == "success") {
        window.alert("保存成功");
        askForBack();
        return;

    }
    else {
        window.alert("保存失败");
        askForBack();
        return;
    }
}
function askForBack() {
    document.location.reload();

}