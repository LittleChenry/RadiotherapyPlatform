window.addEventListener("load", Init, false);



var userName;
var userID;


function Init(evt) {

    //xubixiao
    //获取入口患者信息界面的div
    getUserID();

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
            document.getElementById("BodyPositionDetail").disabled = "true";
            document.getElementById("AnnexDescription").value = fixedInfo.AnnexDescription;
            document.getElementById("AnnexDescription").disabled = "true";
            document.getElementById("Remarks").value = fixedInfo.Remarks;
            document.getElementById("Remarks").disabled = "true";
            document.getElementById("operator").innerHTML = fixedInfo.operate;
            document.getElementById("date").innerHTML = fixedInfo.OperateTime;
        }
        else {
            document.getElementById("userID").value = userID;
            document.getElementById("hidetreatID").value = treatID;
        }
    }
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
                //alert(userID);                
            }

        }
    }
    
    xmlHttp.send();
}

//建立入口病患表




/*
//请求固定记录
function askForFix(FixedID) {
    var panel = document.getElementById("patientspanelbody");
    var paneltemp = document.getElementById("singlepatientpanelbody");
    panel.style.display = "none";
    paneltemp.style.display = "block";
    var xmlHttp = new XMLHttpRequest();
    var url = "FixInfo.ashx?FixedID=" + FixedID;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            FixPatientChosen = eval("(" + getString + ")");
        }
    }
    xmlHttp.send();
    
    writeFixInfo(FixPatientChosen);
    askFor();
}
function askFor() {   
    var xmlHttp = new XMLHttpRequest();
    var url = "template.ashx?userID="+userID;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            FixTemplateChosen = eval("(" + getString + ")");
        }
    }
    
    xmlHttp.send();   
    writetemplateInfo(FixTemplateChosen);
}
function writetemplateInfo(FixTemplateChosen) {
    
    document.getElementById("BodyPositionDetail").value = FixTemplateChosen.templateInfo[0].BodyPositionDetail;
    document.getElementById("AnnexDescription").value = FixTemplateChosen.templateInfo[0].AnnexDescription;
    document.getElementById("Remarks").value = FixTemplateChosen.templateInfo[0].Remarks;
}
function writeFixInfo(FixPatientChosen) {
    
    document.getElementById("hidetreatID").value = FixPatientChosen.fixedInfo[0].treatID;
    document.getElementById("Name").innerHTML = FixPatientChosen.fixedInfo[0].Name;
    document.getElementById("Gender").innerHTML = sex(FixPatientChosen.fixedInfo[0].Gender);
    document.getElementById("Age").innerHTML = FixPatientChosen.fixedInfo[0].Age;
    document.getElementById("Address").innerHTML = FixPatientChosen.fixedInfo[0].Address;
    var Contact = "";
    if (FixPatientChosen.fixedInfo[0].Contact1 != "" && FixPatientChosen.fixedInfo[0].Contact2 != "") {
        Contact = FixPatientChosen.fixedInfo[0].Contact1 + "、" + FixPatientChosen.fixedInfo[0].Contact2;
    } else {
        Contact = FixPatientChosen.fixedInfo[0].Contact1 + FixPatientChosen.fixedInfo[0].Contact2;
    }
    document.getElementById("Contact").innerHTML = Contact;
    document.getElementById("treatID").innerHTML = FixPatientChosen.fixedInfo[0].treatID;
    document.getElementById("modelID").innerHTML = FixPatientChosen.fixedInfo[0].modelID;
    document.getElementById("requireID").innerHTML = FixPatientChosen.fixedInfo[0].requireID;
    document.getElementById("diagnosisresult").innerHTML = FixPatientChosen.fixedInfo[0].diagnosisresult;
    document.getElementById("doctor").innerHTML = FixPatientChosen.fixedInfo[0].doctor;
    document.getElementById("body").innerHTML = FixPatientChosen.fixedInfo[0].body;
    document.getElementById("fixedEquipment").innerHTML = FixPatientChosen.fixedInfo[0].fixedEquipment;
    document.getElementById("ApplicationUser").innerHTML = FixPatientChosen.fixedInfo[0].ApplicationUser;
    document.getElementById("ApplicationTime").innerHTML = FixPatientChosen.fixedInfo[0].ApplicationTime;
    document.getElementById("userID").value = userID;
}
*/
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}

//回退按钮
function askForBack() {
    document.location.reload();

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