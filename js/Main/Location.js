window.addEventListener("load", Init, false);
var userName;
var userID;

function Init(evt) {

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

    if (patient.Progress >= 5) {
        var locationInfo = getDignoseInfo(treatID);
        document.getElementById("modelID").innerHTML = locationInfo.modelID;
        document.getElementById("fixedEquipment").innerHTML = locationInfo.fixedEquipment;
        document.getElementById("body").innerHTML = locationInfo.body + "，" + locationInfo.BodyPositionDetail;
        document.getElementById("AnnexDescription").innerHTML = locationInfo.AnnexDescription;
        //
        document.getElementById("ScanPart").innerHTML = locationInfo.ScanPart;
        document.getElementById("ScanMethod").innerHTML = locationInfo.ScanMethod;
        document.getElementById("requireID").innerHTML = locationInfo.requireID;
        document.getElementById("UpperBound").innerHTML = locationInfo.UpperBound;
        document.getElementById("LowerBound").innerHTML = locationInfo.LowerBound;

        if (locationInfo.Enhance == 1) {
            document.getElementById("Enhance").innerHTML = "增强，" + locationInfo.EnhanceMethod;
        } else {
            document.getElementById("Enhance").innerHTML = "不增强";
        }

        document.getElementById("ApplicationUser").innerHTML = locationInfo.ApplicationUser;
        document.getElementById("ApplicationTime").innerHTML = locationInfo.ApplicationTime;
        document.getElementById("Remarks").innerHTML = locationInfo.Remarks;
        if (patient.Progress >= 6) {
            document.getElementById("Thickness").value = locationInfo.Thickness;
            document.getElementById("Thickness").disabled = "true";
            document.getElementById("Number").value = locationInfo.Number;
            document.getElementById("Number").disabled = "true";
            document.getElementById("ReferenceNumber").value = locationInfo.ReferenceNumber;
            document.getElementById("ReferenceNumber").disabled = "true"; ReferenceScale
            document.getElementById("ReferenceScale").value = locationInfo.ReferenceScale;
            document.getElementById("ReferenceScale").disabled = "true";
            document.getElementById("operator").innerHTML = locationInfo.operate;
            document.getElementById("date").innerHTML = locationInfo.OperateTime;
            var boxesgroup = document.getElementsByClassName("boxes");
            boxesgroup[0].style.display = "none";
            var boxes = document.getElementById("multipic");
            var pictures = locationInfo.CTPictures.split(",");
            if (locationInfo.CTPictures == "") {
                boxes.innerHTML = "无";
            } else {
                for (var i = 1; i < pictures.length; i++) {
                    var div = document.createElement("DIV");
                    div.className = "boxes";
                    var div1 = document.createElement("DIV");
                    div1.className = "imgnum";
                    var img = document.createElement("IMG");
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
            var date = new Date();
            document.getElementById("date").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            document.getElementById("hidetreatID").value = treatID;
        }
    }
}
function getDignoseInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "LocationInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.locationInfo[0];
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
                //alert(userID);                
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