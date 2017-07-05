window.addEventListener("load", Init, false);
var userName;
var userID;
var number = 0;
var obj = [];
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    getUserID();
    getUserName();
    var patient = getPatientInfo(treatmentID);
    document.getElementById("hidetreatID").value = treatmentID;
    document.getElementById("userID").value = userID;
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("address").innerHTML = patient.Address;
    document.getElementById("hospital").innerHTML = patient.Hospital;
    document.getElementById("contact").innerHTML = patient.Contact1;
    document.getElementById("contact2").innerHTML = patient.Contact2;
    document.getElementById("treatID").innerHTML = patient.treatID;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("treatID").innerHTML = treatmentID;
    document.getElementById("part").innerHTML = patient.partname;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    var replacerecordinfo = getreplacerecordInfo(treatmentID);
    document.getElementById("requireID").innerHTML = replacerecordinfo.replacerequire;
    document.getElementById("ApplicationUser").innerHTML = replacerecordinfo.ApplicationUser;
    document.getElementById("ApplicationTime").innerHTML = replacerecordinfo.ApplicationTime;
    if (patient.Progress >= 15) {
        var info = getreplacerecordInfomation(treatmentID);
        var ReplacementRecord = document.getElementById("ReplacementRecord")
        for (var i = 0; i < 3; i++) {
            ReplacementRecord.rows[i+1].cells[1].innerHTML = info.OriginCenter.split(",")[i];
            ReplacementRecord.rows[i+1].cells[2].innerHTML = info.PlanCenter.split(",")[i];
            ReplacementRecord.rows[i+1].cells[3].innerHTML = info.Movement.split(",")[i];
            ReplacementRecord.rows[i+1].cells[4].innerHTML = info.Result.split(",")[i];
        }
        var boxes = document.getElementById("multipic_DRR");
        var firstdrr = document.getElementById("firstdrr");
        firstdrr.style.display = "none";
        var pictures = info.ReferenceDRRPicture.split(",");
        if (info.ReferenceDRRPicture == "") {
            boxes.innerHTML = "无";
        } else {
            for (var i = 1; i < pictures.length; i++) {
                var div = document.createElement("DIV");
                div.className = "boxes";
                var div1 = document.createElement("DIV");
                div1.className = "imgnum";
                var img = document.createElement("IMG");
                img.addEventListener("click", showPicture, false);
                img.className = "img";
                img.src = pictures[i];
                img.style.display = "block";
                div1.appendChild(img);
                div.appendChild(div1);
                boxes.appendChild(div);
            }
        }
        var boxes1 = document.getElementById("multipic_yanzheng");
        var firstyanzheng = document.getElementById("firstyanzheng");
        firstyanzheng.style.display = "none";
        var pictures = info.VerificationPicture.split(",");
        if (info.VerificationPicture == "") {
            boxes.innerHTML = "无";
        } else {
            for (var i = 1; i < pictures.length; i++) {
                var div = document.createElement("DIV");
                div.className = "boxes";
                var div1 = document.createElement("DIV");
                div1.className = "imgnum";
                var img = document.createElement("IMG");
                img.addEventListener("click", showPicture, false);
                img.className = "img";
                img.src = pictures[i];
                img.style.display = "block";
                div1.appendChild(img);
                div.appendChild(div1);
                boxes1.appendChild(div);
            }
        }
        document.getElementById("Remarks").value = info.remark;
        document.getElementById("Remarks").disabled = "true";
        document.getElementById("operator").innerHTML = info.username;
        document.getElementById("date").innerHTML = info.OperateTime;


    } else {
        var date = new Date();
        document.getElementById("date").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        document.getElementById("operator").innerHTML = userName;
    }
}
function showPicture() {
    $("#showPic").click();
    $("#pic").attr("src", this.src);
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

function getreplacerecordInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getfinishedreplacerecord.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[0];
}
function getreplacerecordInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getreplaceApply.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.replace[0];
}

function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
}

//清楚所有子节点
function RemoveAllChild(area) {
    while (area.hasChildNodes()) {
        var first = area.firstChild;
        if (first != null && first != undefined)
            area.removeChild(first);
    }
}

//获取所有待等待体位固定申请疗程号以及所属患者ID与其他信息
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
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

//建立入口病患表

function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}
function dateformat(format) {
    var year = format.getFullYear();
    var month = format.getMonth() + 1;
    var day = format.getDate();
    var hour = format.getHours();
    var minute = format.getMinutes();
    if (minute < 10) {
        minute = "0" + minute;
    }
    var time = year + "年" + month + "月" + day + "日 " + hour + "：" + minute;
    return time;
}
function postimportReplaceRecord() {
    var boxgroup = document.getElementById("multipic_DRR");
    var boxgroup1 = document.getElementById("multipic_yanzheng");
    document.getElementById("cankaodrr").value = boxgroup.children.length - 1;
    document.getElementById("yanzheng").value = boxgroup1.children.length - 1;
    if (document.getElementById("OriginCenter1").value == "" || document.getElementById("OriginCenter2").value == "" || document.getElementById("OriginCenter3").value == "") {
        window.alert("原始中心没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("PlanCenter1").value == "" || document.getElementById("PlanCenter2").value == "" || document.getElementById("PlanCenter3").value == "") {
        window.alert("计划中心没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("Movement1").value == "" || document.getElementById("Movement2").value == "" || document.getElementById("Movement3").value == "") {
        window.alert("移床参数没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("Result1").value == "" || document.getElementById("Result2").value == "" || document.getElementById("Result3").value == "") {
        window.alert("复位结果没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("cankaodrr").value == "0" || document.getElementById("yanzheng").value == "0") {
        window.alert("参考DRR和验证图像未完善");
        evt.preventDefault();
        return;
    }
    document.getElementById("saveRepalceRecord").submit();
}
function getchildNumber(boxgroup) {
    var r = [];
    var n = boxgroup.firstChild;
    for (; n; n = n.nextSibling) {
        if (n.nodeType === 1 && n !== elem) {
            r.push(n);
        }
    }
    return r.length ;
}