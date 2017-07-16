
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
    document.getElementById("treatID").innerHTML = "疗程" + patient.Treatmentname;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;

    var select1 = document.getElementById("PlanSystem");
    createPlanSystemItem(select1);
    var select2 = document.getElementById("Grid");
    createGridItem(select2);
    var select3 = document.getElementById("Algorithm");
    createAlgorithmItem(select3);
    var designInfo = getDesignInfo(treatID);
    $("#current-tab").text("疗程" + patient.Treatmentname + "计划提交");
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '9')) {
        for (var i = 0; i < designInfo.length; i++) {
            if (designInfo[i].Treatmentname == patient.Treatmentname) {
                document.getElementById("Remarks").innerHTML = designInfo[i].RadiotherapyHistory;
                readDosagePriority(designInfo[i].DosagePriority);
                readDosage(designInfo[i].Dosage);
                document.getElementById("technology").innerHTML = designInfo[i].technology;
                document.getElementById("equipment").innerHTML = designInfo[i].equipment;
                document.getElementById("ApplicationUser").innerHTML = designInfo[i].doctor;
                document.getElementById("ApplicationTime").innerHTML = designInfo[i].apptime;
                document.getElementById("receiveUser").innerHTML = designInfo[i].ReceiveUser;
                document.getElementById("receiveTime").innerHTML = designInfo[i].ReceiveTime;
                
                document.getElementById("PlanSystem").value = designInfo[i].PlanSystem;
                document.getElementById("IlluminatedNumber").value = designInfo[i].IlluminatedNumber;
                document.getElementById("Coplanar").value = designInfo[i].Coplanar;
                document.getElementById("MachineNumbe").value = designInfo[i].MachineNumbe;
                document.getElementById("ControlPoint").value = designInfo[i].ControlPoint;
                document.getElementById("Grid").value = designInfo[i].Grid_ID;
                document.getElementById("Algorithm").value = designInfo[i].Algorithm_ID;
                document.getElementById("Feasibility").value = designInfo[i].Feasibility;
                document.getElementById("applyuser").innerHTML = designInfo[i].SubmitUser;
                document.getElementById("time").innerHTML = designInfo[i].SubmitTime;
                } else {
                    var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">疗程' + designInfo[i].Treatmentname + '计划提交信息</a></li>';
                    var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                        + '<div class="item col-xs-6">计划系统：<span class="underline">' + designInfo[i].PlanSystemname + '</span></div>'
                        + '<div class="item col-xs-6">射野数量：<span class="underline">' + designInfo[i].IlluminatedNumber + '</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-6">非共面照射：<span class="underline">' + trans(designInfo[i].Coplanar) + '</span></div>'
                        + '<div class="item col-xs-6">机器跳数：<span class="underline">' + designInfo[i].MachineNumbe + '</span></div></div>'
                         + '<div class="single-row"><div class="item col-xs-6">控制点数量：<span class="underline">' + designInfo[i].ControlPoint + '</span></div>'
                        + '<div class="item col-xs-6">计算网络：<span class="underline">' + designInfo[i].gridname + '</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-6">优化算法：<span class="underline">' + designInfo[i].algorithmname + '</span></div>'
                        + '<div class="item col-xs-6">计划可执行度：<span class="underline">' + transfer(designInfo[i].Feasibility) + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div></div>'
                    $("#tabs").append(tab);
                    $("#tab-content").append(content);
                }
            }
    } else {
        document.getElementById("userID").value = userID;
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
            for (var i = 0; i < designInfo.length; i++) {
                if (designInfo[i].Treatmentname != patient.Treatmentname) {

                    var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">疗程' + designInfo[i].Treatmentname + '计划提交信息</a></li>';
                    var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                        + '<div class="item col-xs-6">计划系统：<span class="underline">' + designInfo[i].PlanSystemname + '</span></div>'
                        + '<div class="item col-xs-6">射野数量：<span class="underline">' + designInfo[i].IlluminatedNumber + '</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-6">非共面照射：<span class="underline">' + trans(designInfo[i].Coplanar) + '</span></div>'
                        + '<div class="item col-xs-6">机器跳数：<span class="underline">' + designInfo[i].MachineNumbe + '</span></div></div>'
                         + '<div class="single-row"><div class="item col-xs-6">控制点数量：<span class="underline">' + designInfo[i].ControlPoint + '</span></div>'
                        + '<div class="item col-xs-6">计算网络：<span class="underline">' + designInfo[i].gridname + '</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-6">优化算法：<span class="underline">' + designInfo[i].algorithmname + '</span></div>'
                        + '<div class="item col-xs-6">计划可执行度：<span class="underline">' + transfer(designInfo[i].Feasibility) + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" id="' + i + '">载入历史信息</button></div></div></div>'
                    $("#tabs").append(tab);
                    $("#tab-content").append(content);
                } else {
                    document.getElementById("Remarks").innerHTML = designInfo[i].RadiotherapyHistory;
                    readDosagePriority(designInfo[i].DosagePriority);
                    readDosage(designInfo[i].Dosage);
                    document.getElementById("technology").innerHTML = designInfo[i].technology;
                    document.getElementById("equipment").innerHTML = designInfo[i].equipment;
                    document.getElementById("ApplicationUser").innerHTML = designInfo[i].doctor;
                    document.getElementById("ApplicationTime").innerHTML = designInfo[i].apptime;
                    document.getElementById("receiveUser").innerHTML = designInfo[i].ReceiveUser;
                    document.getElementById("receiveTime").innerHTML = designInfo[i].ReceiveTime;                   
                }
            }
        }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            document.getElementById("PlanSystem").value = designInfo[k].PlanSystem;
            document.getElementById("IlluminatedNumber").value = designInfo[k].IlluminatedNumber;
            document.getElementById("Coplanar").value = designInfo[k].Coplanar;
            document.getElementById("MachineNumbe").value = designInfo[k].MachineNumbe;
            document.getElementById("ControlPoint").value = designInfo[k].ControlPoint;
            document.getElementById("Grid").value = designInfo[k].Grid_ID;
            document.getElementById("Algorithm").value = designInfo[k].Algorithm_ID;
            document.getElementById("Feasibility").value = designInfo[k].Feasibility;
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
function trans(number) {
    if (number == "1") {
        return "是";
    }
    if (number == "0") {
        return "否";
    }

}
function transfer(number) {
    if (number == "1") {
        return "可执行";
    }
    if (number == "0") {
        return "不可执行";
    }

}

function createGridItem(thiselement) {
    var PartItem = JSON.parse(getPartItem3()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--计算网格选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem3() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getGrid.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function createPlanSystemItem(thiselement) {
    var PartItem = JSON.parse(getPartItem2()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--计划系统选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem2() {
    var xmlHttp = new XMLHttpRequest();
    var url = "PlanSystem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function createAlgorithmItem(thiselement) {
    var PartItem = JSON.parse(getPartItem1()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--优化算法选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getPartItem1() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getAlgorithm.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designSubmitInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
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
function save() {
    if (document.getElementById("PlanSystem").value == "allItem") {
        window.alert("计划系统没有选择");
        return;
    }
    if (document.getElementById("Grid").value == "allItem") {
        window.alert("计算网格没有选择");
        return;
    }
    if (document.getElementById("Algorithm").value == "allItem") {
        window.alert("优化算法没有选择");
        return;
    }
    if (document.getElementById("IlluminatedNumber").value == "") {
        window.alert("请填写射野数量");
        return;
    }
    if (document.getElementById("MachineNumbe").value == "") {
        window.alert("请填写机器跳数");
        return;
    }
    if (document.getElementById("ControlPoint").value == "") {
        window.alert("请填写控制点数量");
        return;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveDesignSubmit"));
    $.ajax({
        url: "designSubmitRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        success: function (data) {
            if (data == "success") {
                alert("保存成功");
                window.location.reload();
            }
            if (data == "messsage") {
                alert("您不是领取人");
                window.location.reload();
            }

        },
        error: function (e) {
            window.location.href = "Error.aspx";
        }
    });
}
function remove() {
    document.getElementById("PlanSystem").removeAttribute("disabled");
    document.getElementById("IlluminatedNumber").removeAttribute("disabled");
    document.getElementById("Coplanar").removeAttribute("disabled");
    document.getElementById("MachineNumbe").removeAttribute("disabled");
    document.getElementById("ControlPoint").removeAttribute("disabled");
    document.getElementById("Grid").removeAttribute("disabled");
    document.getElementById("Algorithm").removeAttribute("disabled");
    document.getElementById("Feasibility").removeAttribute("disabled");    
}
