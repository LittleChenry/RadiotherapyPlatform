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
    var patient = getfixPatientInfo(treatmentID);
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
    document.getElementById("diaguser").innerHTML = patient.RegisterDoctor;
    var select1 = document.getElementById("DensityConversion");
    createDnsityItem(select1);
    if (patient.Progress >= 7) {
        var info = getimportCTInfomation(treatmentID);
        document.getElementById("DensityConversion").value = info.DensityConversion_ID;
        document.getElementById("DensityConversion").disabled = "true";
        document.getElementById("SequenceNaming").value = info.SequenceNaming;
        document.getElementById("SequenceNaming").disabled = "true";
        document.getElementById("Thickness").value = info.Thickness;
        document.getElementById("Thickness").disabled = "true";
        document.getElementById("MultimodalImage").value = info.MultimodalImage;
        document.getElementById("MultimodalImage").disabled = "true";
        document.getElementById("ReferenceScale").value = info.ReferenceScale;
        document.getElementById("ReferenceScale").disabled = "true";
        document.getElementById("Remarks").value = info.Remarks;
        document.getElementById("Remarks").disabled = "true";
        document.getElementById("Number").value = info.Number;
        document.getElementById("Number").disabled = "true";
        document.getElementById("applyuser").innerHTML = info.username;
        document.getElementById("time").innerHTML = info.OperateTime;

    } else {
        var date = new Date();
        document.getElementById("treatmentID").value = treatmentID;
        document.getElementById("userID").value = userID;
        document.getElementById("time").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        document.getElementById("applyuser").innerHTML = userName;
    }

}
function getimportCTInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetfinishedimportCT.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[0];

}
//获取所有待等待体位固定申请疗程号以及所属患者ID与其他信息
function getfixPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}
function createDnsityItem(thiselement) {
    var PartItem = JSON.parse(getPartItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--CT电子密度转换选择--");
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
    var url = "getDnsity.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

//清楚所有子节点
function RemoveAllChild(area) {
    while (area.hasChildNodes()) {
        var first = area.firstChild;
        if (first != null && first != undefined)
            area.removeChild(first);
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
function postimportCT() {
    if (document.getElementById("DensityConversion").value == "allItem") {
        alert("请选择CT电子密度转换方式");
        return;
    }
    if (document.getElementById("SequenceNaming").value == "") {
        alert("请填写CT序列命名");
        return;
    }
    if (document.getElementById("Thickness").value == "") {
        alert("请填写层厚");
        return;
    }
    if (document.getElementById("Number").value == "") {
        alert("请填写层数");
        return;
    }
    if (document.getElementById("ReferenceScale").value == "") {
        alert("请选择参考中心层面");
        return;
    }
    if (document.getElementById("MultimodalImage").value == "allItem") {
        alert("请选择多模态图像");
        return;
    }
    document.getElementById("saveImportCT").submit();
}
