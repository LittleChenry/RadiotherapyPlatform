window.addEventListener("load", Init, false);



var userName;
var userID;


function Init(evt) {

    //xubixiao
    //获取入口患者信息界面的div
    getUserID();
    getUserName();

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
    
    if (patient.Progress >= 3) {
        var fixedInfo = getDignoseInfo(treatID);
        document.getElementById("body").innerHTML = fixedInfo.body;
        document.getElementById("requireID").innerHTML = fixedInfo.requireID;
        document.getElementById("modelID").innerHTML = fixedInfo.modelID;
        document.getElementById("fixedEquipment").innerHTML = fixedInfo.fixedEquipment;
        document.getElementById("ApplicationUser").innerHTML = fixedInfo.ApplicationUser;
        document.getElementById("ApplicationTime").innerHTML = fixedInfo.ApplicationTime;
        if (patient.Progress >= 5) {
            document.getElementById("BodyPositionDetail").value = fixedInfo.BodyPositionDetail;
            document.getElementById("AnnexDescription").value = fixedInfo.AnnexDescription;
            document.getElementById("Remarks").value = fixedInfo.Remarks;
            document.getElementById("operator").innerHTML = fixedInfo.operate;
            document.getElementById("date").innerHTML = fixedInfo.OperateTime;
            var boxesgroup = document.getElementsByClassName("boxes");
            boxesgroup[0].style.display = "none";
            var boxes = document.getElementById("multipic");
            var pictures = fixedInfo.Pictures.split(",");
            if (fixedInfo.Pictures == "") {
                boxes.innerHTML = "无";
            } else {
                for (var i = 1; i < pictures.length; i++) {
                    var div = document.createElement("DIV");
                    div.className = "boxes";
                    var div1 = document.createElement("DIV");
                    div1.className = "imgnum";
                    var img = document.createElement("IMG");
                    img.addEventListener("click",showPicture,false);
                    img.className = "img";
                    img.src = pictures[i];
                    img.style.display = "block";
                    div1.appendChild(img);
                    div.appendChild(div1);
                    boxes.appendChild(div);
                }
            }
        }
        else {
            document.getElementById("userID").value = userID;
            document.getElementById("operator").innerHTML = userName;
            document.getElementById("date").innerHTML = getNowFormatDate();
            document.getElementById("hidetreatID").value = treatID;
        }
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
function showPicture(){
    $("#showPic").click();
    $("#pic").attr("src",this.src);
}

function getDignoseInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "fixInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.fixedInfo[0];
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
function postimportFIX() {
    
    if (document.getElementById("BodyPositionDetail").value == "") {
        alert("请填写体位详细描述");
        return;
    }
    if (document.getElementById("AnnexDescription").value == "") {
        alert("请填写附件描述");
        return;
    }
    if (document.getElementById("Remarks").value == "") {
        alert("请填写备注");
        return;
    }
    if (document.getElementById("Remarks").value == "") {
        alert("请填写备注");
        return;
    }
    document.getElementById("saveFixRecord").submit();
}
function remove() {
    document.getElementById("BodyPositionDetail").removeAttribute("disabled");
    document.getElementById("AnnexDescription").removeAttribute("disabled");
    document.getElementById("Remarks").removeAttribute("disabled");
}
