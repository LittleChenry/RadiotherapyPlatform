window.addEventListener("load", createPatient, false)

var userID;
var treatID;
var userName;
var radioID;
//JS入口主函数
function createPatient(evt) {
    //获取入口患者信息界面的div
    //获得当前执行人姓名与ID
    getUserID();
    if ((typeof(userID)=="undefined")) {
        if(confirm("用户身份已经失效,是否选择重新登录?"))
        {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var treatID = window.location.search.split("=")[1];
    document.getElementById("treatID").innerHTML = treatID;
    var patient = getPatientInfo(treatID);
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
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
    document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    //调取后台所有等待就诊的疗程号及其对应的病人
    document.getElementById("test").addEventListener("click", remove, false);
    var select3 = document.getElementById("part");
    createPartItem(select3);
    var select4 = document.getElementById("diagresult");
    createDiagResultItem(select4);
    var diagnosisInfo = getDignoseInfo(treatID);
    $("#current-tab").text(patient.Treatmentdescribe + "诊断");
    var groupprogress = patient.Progress.split(",");
    if (contains(groupprogress,"1")) {
        for (var i = 0; i < diagnosisInfo.diagnosisInfo.length; i++) {
            if (patient.Treatmentname == diagnosisInfo.diagnosisInfo[i].Treatmentname) {
                document.getElementById("operator").innerHTML = diagnosisInfo.diagnosisInfo[i].username;
                document.getElementById("remark").value = diagnosisInfo.diagnosisInfo[i].Remarks;
                document.getElementById("part").value = diagnosisInfo.diagnosisInfo[i].partID;
                document.getElementById("diagresult").value = diagnosisInfo.diagnosisInfo[i].diagnosisresultID;
                document.getElementById("date").innerHTML = diagnosisInfo.diagnosisInfo[i].Time;
                
            } else {
                var tab = '<li class=""><a href="#tab'+ i +'" data-toggle="tab" aria-expanded="false">'+ diagnosisInfo.diagnosisInfo[i].Treatmentdescribe +'诊断</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                   + '<div class="item col-xs-4">患病部位：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].partname + '</span></div>'
                   + '<div class="item col-xs-4">诊断结果：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].diagnosisresultName + '</span></div>'
                   + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" disabled="disabled" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
               
            }
        }
    } else {
        document.getElementById("date").innerHTML = getNowFormatDate();
        document.getElementById("operator").innerHTML = userName;
        document.getElementById("diaguserid").value = userID;
        for (var i = 0; i < diagnosisInfo.diagnosisInfo.length; i++) {
            if (patient.Treatmentname != diagnosisInfo.diagnosisInfo[i].Treatmentname) {
                var tab = '<li class=""><a href="#tab'+ i +'" data-toggle="tab" aria-expanded="false">'+ diagnosisInfo.diagnosisInfo[i].Treatmentdescribe +'诊断</a></li>';
                var content = '<div class="tab-pane" id="tab'+ i +'"><div class="single-row">'
                    + '<div class="item col-xs-4">患病部位：<span class="underline">'+ diagnosisInfo.diagnosisInfo[i].partname +'</span></div>'
                    + '<div class="item col-xs-4">诊断结果：<span class="underline">'+ diagnosisInfo.diagnosisInfo[i].diagnosisresultName +'</span></div>'  
                    + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
            }
        }
    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            document.getElementById("remark").value = diagnosisInfo.diagnosisInfo[k].Remarks;
            document.getElementById("part").value = diagnosisInfo.diagnosisInfo[k].partID;
            document.getElementById("diagresult").value = diagnosisInfo.diagnosisInfo[k].diagnosisresultID;
            
        });
    });
}
function contains(group, s) {
    for (var k = 0; k <= group.length - 1; k++) {
        if (group[k] == s) {
            return true;
        }
    }
    return false;
    }
function transfer(res) {
    if (res == "") {
        return "暂无分组";
    } else {
        return res;
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
    var min = date.getMinutes();
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
    return obj1;
}

//获取病人基本信息
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientForDiagnose.ashx?treatmentID=" + treatmentID;
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
function save() {
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var treatID = window.location.search.split("=")[1];
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
  
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    $.ajax({
        type: "POST",
        url: "recordDiag.ashx",
        async: false,
        data: {
            treatid: treatID,
            diaguserid: diaguserid.value,
            remark: remark.value,
            part: select3.value,
            diagresult: select4.value
        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                window.alert("诊断成功");
                askForBack();
            } else {
                window.alert("诊断失败");
            }
        },
        error: function () {
            alert("error");
        }
    });

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
function remove() {
    document.getElementById("remark").removeAttribute("disabled");
    document.getElementById("part").removeAttribute("disabled");
    document.getElementById("diagresult").removeAttribute("disabled");
}
