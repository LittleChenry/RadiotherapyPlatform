
window.addEventListener("load", Init, false);

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
    document.getElementById("lightpart").innerHTML = patient.LightPart_ID;
 
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '9')) {
        var designInfo = getDesignInfo(treatID);
        for (var i = 0; i < designInfo.length; i++) {
            if (patient.Treatmentname == designInfo[i].Treatmentname) {
                document.getElementById("Remarks").innerHTML = designInfo[i].RadiotherapyHistory;
                readDosagePriority(designInfo[i].DosagePriority);
                readDosage(designInfo[i].Dosage);
                document.getElementById("technology").innerHTML = designInfo[i].technology;
                document.getElementById("equipment").innerHTML = designInfo[i].equipment;
                document.getElementById("ApplicationUser").innerHTML = designInfo[i].doctor;
                document.getElementById("ApplicationTime").innerHTML = designInfo[i].apptime;
                document.getElementById("receiveUser").innerHTML = designInfo[i].ReceiveUser;
                document.getElementById("receiveTime").innerHTML = designInfo[i].ReceiveTime;
                document.getElementById("PlanSystem").innerHTML = designInfo[i].PlanSystem;
                document.getElementById("Raytype").innerHTML = designInfo[i].Raytype;
                document.getElementById("Submituser").innerHTML = designInfo[i].SubmitUser;
                document.getElementById("Submittime").innerHTML = designInfo[i].SubmitTime;
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
                if (isInArray(progress, '10')) {
                    document.getElementById("advice").value = designInfo[i].advice;
                    document.getElementById("state").value = charge2(designInfo[i].State);
                    document.getElementById("applyuser").innerHTML = designInfo[i].ConfirmUser;
                    document.getElementById("time").innerHTML = designInfo[i].ConfirmTime;
                    if (designInfo[i].userID == userID) {
                        window.parent.document.getElementById("edit").removeAttribute("disabled");

                    }
                }
            }
        }
    }
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
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
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
function save() {
    if (document.getElementById("state").value == "未审核") {
        window.alert("请审核计划");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveDesignConfirm"));
    $.ajax({
        url: "designConfirmRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        async: false,
        contentType: false,
        success: function (data) {
            if (data == "success") {
                alert("保存成功");
                window.location.reload();
            }
            if (data == "back") {
                alert("已回退到计划领取");
                window.location.reload();
            }
            if (data == "failure" || data == "error") {
                alert("操作失败");
                window.location.reload();
            }
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
    document.getElementById("unconfirm").removeAttribute("disabled");
    document.getElementById("confirm").removeAttribute("disabled");
    document.getElementById("advice").removeAttribute("disabled");
}
