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
    document.getElementById("treatmentID").value = treatmentID;
    document.getElementById("userID").value = userID;
    var patient = getfixPatientInfo(treatmentID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    //document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    //document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    //document.getElementById("address").innerHTML = patient.Address;
    //document.getElementById("hospital").innerHTML = patient.Hospital;
    //document.getElementById("contact").innerHTML = patient.Contact1;
    //document.getElementById("contact2").innerHTML = patient.Contact2;
    //document.getElementById("treatID").innerHTML = patient.treatID;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    //document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    //document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    var select1 = document.getElementById("DensityConversion");
    createDnsityItem(select1);
    var info = getimportCTInfomation(treatmentID);    
    $("#current-tab").text(patient.Treatmentdescribe + "CT图像信息填写");
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '6')) {
        for (var i = 0; i < info.length; i++) {
            if (info[i].Treatmentname == patient.Treatmentname) {
                
                document.getElementById("DensityConversion").value = info[i].DensityConversion_ID;
                document.getElementById("SequenceNaming").value = info[i].SequenceNaming;;
                document.getElementById("Thickness").value = info[i].Thickness;
                document.getElementById("MultimodalImage").value = info[i].MultimodalImage;
                document.getElementById("ReferenceScale").value = info[i].ReferenceScale;
                document.getElementById("Remarks").value = info[i].Remarks;
                document.getElementById("Number").value = info[i].Number;
                document.getElementById("applyuser").innerHTML = info[i].username;
                document.getElementById("time").innerHTML = info[i].OperateTime;
                if (info[i].userID == userID || info[i].userID == "") {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");                   
                }

            } else {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + 'CT图像信息填写</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">CT-电子密度转换：<span class="underline">' + info[i].DensityConversionName + '</span></div>'
                    + '<div class="item col-xs-6">CT序列命名：<span class="underline">' + info[i].SequenceNaming + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">层厚：<span class="underline">' + info[i].Thickness + '</span></div>'
                    + '<div class="item col-xs-6">层数：<span class="underline">' + info[i].Number + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">参考中心层面：<span class="underline">' + info[i].ReferenceScale + '</span></div>'
                    + '<div class="item col-xs-6">多模态图像：<span class="underline">' + info[i].MultimodalImage + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" disabled="disabled" type="button" id="' + i + '">载入历史信息</button></div></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);

            }
        }
    } else {
        var location = getLocation(treatmentID);
        document.getElementById("Thickness").value = location.Thickness;
        document.getElementById("ReferenceScale").value = location.ReferenceScale;
        document.getElementById("Number").value = location.Number;
        var date = new Date();
        document.getElementById("treatmentID").value = treatmentID;
        document.getElementById("userID").value = userID;
        document.getElementById("time").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        document.getElementById("applyuser").innerHTML = userName;
        for (var i = 0; i < info.length; i++) {
            if (info[i].Treatmentname != patient.Treatmentname) {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + 'CT图像信息填写</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">CT-电子密度转换：<span class="underline">' + info[i].DensityConversionName + '</span></div>'
                    + '<div class="item col-xs-6">CT序列命名：<span class="underline">' + info[i].SequenceNaming + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">层厚：<span class="underline">' + info[i].Thickness + '</span></div>'
                    + '<div class="item col-xs-6">层数：<span class="underline">' + info[i].Number + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">参考中心层面：<span class="underline">' + info[i].ReferenceScale + '</span></div>'
                    + '<div class="item col-xs-6">多模态图像：<span class="underline">' + info[i].MultimodalImage + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" id="' + i + '">载入历史信息</button></div></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
            }
        }

    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            document.getElementById("DensityConversion").value = info[k].DensityConversion_ID;
            document.getElementById("SequenceNaming").value = info[k].SequenceNaming;;
            document.getElementById("Thickness").value = info[k].Thickness;
            document.getElementById("MultimodalImage").value = info[k].MultimodalImage;
            document.getElementById("ReferenceScale").value = info[k].ReferenceScale;
            document.getElementById("Remarks").value = info[k].Remarks;
            document.getElementById("Number").value = info[k].Number;
        });
    });
}
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
}
function getimportCTInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetfinishedimportCT.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.info;

}
function getLocation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetLocation.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r\n/g, "\\n");
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
    json = json.replace(/\r\n/g, "\\n");
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
    if (PartItem[0].defaultItem != "") {
        thiselement.value = PartItem[0].defaultItem;
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
function save() {
    if (document.getElementById("DensityConversion").value == "allItem") {
        alert("请选择CT电子密度转换方式");
        return false;
    }
    if (document.getElementById("SequenceNaming").value == "") {
        alert("请填写CT序列命名");
        return false;
    }
    if (document.getElementById("Thickness").value == "") {
        alert("请填写层厚");
        return false;
    }
    if (document.getElementById("Number").value == "") {
        alert("请填写层数");
        return false;
    }
    if (document.getElementById("ReferenceScale").value == "") {
        alert("请选择参考中心层面");
        return false;
    }
    if (document.getElementById("MultimodalImage").value == "allItem") {
        alert("请选择多模态图像");
        return false;
    }
    var form = new FormData(document.getElementById("saveImportCT"));
    $.ajax({
        url: "importCTRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        async: false,
        success: function (data) {
            if (data == "success") {
                alert("保存成功");
            } else {
                alert("保存失败");
                return false;
            }
            window.location.reload();
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        }  
    });
}
function remove() {
    document.getElementById("Remarks").removeAttribute("disabled");
    document.getElementById("DensityConversion").removeAttribute("disabled");
    document.getElementById("SequenceNaming").removeAttribute("disabled");
    document.getElementById("Thickness").removeAttribute("disabled");
    document.getElementById("MultimodalImage").removeAttribute("disabled");
    document.getElementById("ReferenceScale").removeAttribute("disabled");
    document.getElementById("Number").removeAttribute("disabled");
}
