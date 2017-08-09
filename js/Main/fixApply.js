window.addEventListener("load", Init, false);
var userName;
var userID;
var number = 0;
var obj = [];
var treatID;
var ti = 0;
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    treatID = treatmentID;
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
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
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    //document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    //document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    createmodelselectItem(document.getElementById("modelselect"));
    createspecialrequestItem(document.getElementById("specialrequest"));
    createfixEquipItem(document.getElementById("fixEquip"));
    var info = getfixInfomation(treatmentID);
    $("#current-tab").text(patient.Treatmentdescribe + "体位固定申请");
    var groupprogress = patient.Progress.split(",");
    if (contains(groupprogress, "2")) {
        ti = 1;
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatmentname == patient.Treatmentname) {
                document.getElementById("modelselect").value = info[i].materialID;
                document.getElementById("specialrequest").value = info[i].require;
                document.getElementById("fixEquip").value = info[i].fixedequipid;
                document.getElementById("bodyPost").value = info[i].BodyPosition;
                document.getElementById("Remarks").value = info[i].Remarks;
                document.getElementById("appointtime").value = info[i].equipname + " " + info[i].Date + " " + toTime(info[i].Begin) + "-" + toTime(info[i].End);
                document.getElementById("applyuser").innerHTML = info[i].username;
                document.getElementById("time").innerHTML = info[i].ApplicationTime;
                
                if (info[i].userID == userID) {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
                    document.getElementById("idforappoint").value = info[i].appointid;
                }
            } else {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + '体位固定申请</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">模具：<span class="underline">' + info[i].materialName + '</span></div>'
                    + '<div class="item col-xs-6">固定装置：<span class="underline">' + info[i].fixedequipname + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">体位:<span class="underline">' + info[i].BodyPosition + '</span></div>'
                    + '<div class="item col-xs-6">特殊要求：<span class="underline">' + info[i].fixedrequire + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8">设备与时间：<span class="underline">' + info[i].equipname + '' + info[i].Date + ' ' + toTime(info[i].Begin) + '-' + toTime(info[i].End) + '</span></div>'
                    + '<div class="single-row"><div class="item col-xs-12">备注：<span class="underline">' + info[i].Remarks + '</span></div></div>'
                    + '<div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
            }
        }
    } else {
        createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2]);
        var date = new Date();
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("AppiontDate").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("chooseappoint").addEventListener("click", function () {
            CreateNewAppiontTable(event);
        }, false);
        document.getElementById("chooseProject").addEventListener("click", function () {
            CreateNewAppiontTable(event);
        }, false);//根据条件创建预约表
        document.getElementById("sure").addEventListener("click", checkAllTable, false);
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatmentname != patient.Treatmentname) {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + '体位固定申请</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">模具：<span class="underline">' + info[i].materialName + '</span></div>'
                    + '<div class="item col-xs-6">固定装置：<span class="underline">' + info[i].fixedequipname + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">体位:<span class="underline">' + info[i].BodyPosition + '</span></div>'
                    + '<div class="item col-xs-6">特殊要求：<span class="underline">' + info[i].fixedrequire + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8">设备与时间：<span class="underline">' + info[i].equipname + '' + info[i].Date + ' ' + toTime(info[i].Begin) + '-' + toTime(info[i].End) + '</span></div>'
                    + '<div class="single-row"><div class="item col-xs-12">备注：<span class="underline">' + info[i].Remarks + '</span></div></div>'
                    + '<div class="item col-xs-4"><button class="btn btn-success" type="button" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
            }
        }

    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            if (k != "chooseappoint") {
                document.getElementById("modelselect").value = info[k].materialID;
                document.getElementById("specialrequest").value = info[k].require;
                document.getElementById("fixEquip").value = info[k].fixedequipid;
                document.getElementById("bodyPost").value = info[k].BodyPosition;
                document.getElementById("Remarks").value = info[k].Remarks;
            }
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
//设备下拉菜单
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

function createfixEquipmachine(thiselement,item) {
    var machineItem = JSON.parse(getmachineItem(item)).Item;
    thiselement.options.length = 0;
    for (var i = 0; i < machineItem.length; i++) {
        if (machineItem[i] != "") {
            thiselement.options[i] = new Option(machineItem[i].Name);
            thiselement.options[i].value = parseInt(machineItem[i].ID);
        }
    }
}
function getmachineItem(item) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getfixmachine.ashx?item="+item;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}
//调取数据库申请信息
function getfixInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getfinishedfix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.info;
}
function chooseTempalte(templateID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetTemplateFixApply.ashx?templateID=" + templateID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    document.getElementById("modelselect").value = obj1.templateInfo[0].Model_ID;
    document.getElementById("specialrequest").value = obj1.templateInfo[0].FixedRequirements_ID;
    document.getElementById("fixEquip").value = obj1.templateInfo[0].FixedEquipment_ID;
    document.getElementById("bodyPost").value = obj1.templateInfo[0].BodyPosition;
    document.getElementById("Remarks").value = obj1.templateInfo[0].RemarksApply;
}
function save() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
    var model = document.getElementById("modelselect").value;
    var special=document.getElementById("specialrequest").value;
    var time=document.getElementById("time").value;
    var bodypost = document.getElementById("bodyPost").value;
    var Remarks = document.getElementById("Remarks").value;
    var fixequip = document.getElementById("fixEquip").value;
    var appointid = document.getElementById("idforappoint").value;
    if (document.getElementById("modelselect").value == "allItem") {
        window.alert("模具没有选择");
        return false;
    }
    if (document.getElementById("specialrequest").value == "allItem") {
        window.alert("特殊要求没有选择");
        return false;
    }
    if (document.getElementById("bodyPost").value == "allItem") {
        window.alert("体位没有选择");
        return false;
    }
    if (document.getElementById("fixEquip").value == "allItem") {
        window.alert("固定装置没有选择");
        return false;
    }
    if (document.getElementById("idforappoint").value == "allItem") {
        window.alert("设备没有预约");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    $.ajax({
        type: "POST",
        url: "fixedApplyRecord.ashx",
        async: false,
        data: {
            id: appointid,
            treatid: treatmentid,
            model: model,
            fixreq: special,
            user: userID,
            Remarks:Remarks,
            fixequip: fixequip,
            bodypost: bodypost
        },
        dateType: "json",
        success: function (data) {
            if (data== "success") {
                window.alert("申请成功");
                window.location.reload();
            }
            if (data == "busy") {
                window.alert("预约时间被占,需要重新预约");
                return false;
            }
            if (data == "failure") {
                window.alert("申请失败");
                return false;
            }
        },
        error: function () {
            alert("error");
        }
    });

    
}
function saveTemplate(TemplateName) {
    var model = document.getElementById("modelselect").value;
    var special = document.getElementById("specialrequest").value;  
    var bodypost = document.getElementById("bodyPost").value;
    var fixequip = document.getElementById("fixEquip").value;
    var Remarks = document.getElementById("Remarks").value;
    if (document.getElementById("modelselect").value == "allItem") {
        window.alert("模具没有选择");
        return false;
    }
    if (document.getElementById("specialrequest").value == "allItem") {
        window.alert("特殊要求没有选择");
        return false;
    }
    if (document.getElementById("bodyPost").value == "allItem") {
        window.alert("体位没有选择");
        return false;
    }
    if (document.getElementById("fixEquip").value == "allItem") {
        window.alert("固定装置没有选择");
        return false;
    } 
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var xmlHttp = new XMLHttpRequest();
    var url = "fixedApplytemplate.ashx?templatename=" + TemplateName + "&model=" + model + "&fixreq=" + special + "&user=" + userID + "&fixequip=" + fixequip + "&bodypost=" + bodypost + "&Remarks=" + Remarks;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var result = xmlHttp.responseText;
    if (result == "success") {
        window.alert("模板保存成功");   
    }   
    if (result == "failure") {
        window.alert("模板保存失败");
    }
}
//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(equiment, dateString) {
    var table = document.getElementById("apptiontTable");
    RemoveAllChild(table);
    if (equiment.length != 0) {
    var tbody = document.createElement("tbody");
        for (var i = 0; i < Math.ceil(equiment.length / 5) * 5 ; i++) {
            var count = i % 5;
            var tr;
            if (count == 0) {
                tr = document.createElement("tr");
            }
            if (i <= equiment.length - 1) {
                var td = document.createElement("td");
                var sign = document.createElement("i");
                td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
                if (equiment[i].State == "0") {
                    if (compareWithToday(dateString)) {
                        sign.className = "";
                        td.addEventListener("click", chooseItem, false);
                    } else {
                        td.style.backgroundColor = "#C1C1C1";
                        sign.className = "fa fa-fw fa-ban td-sign";
                        td.addEventListener("click", hasChosen, false);
                    }
                } else {
                    td.style.backgroundColor = "#C1C1C1";
                    sign.className = "fa fa-fw fa-ban td-sign";
                    td.addEventListener("click", hasChosen, false);
                }
                var text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                td.appendChild(text);
                td.appendChild(sign);
                tr.appendChild(td);
            }
            if (i == equiment.length) {
                var k;
                for (k = equiment.length; k <= Math.ceil(equiment.length / 5) * 5 - 1; k++) {
                    var td = document.createElement("td");

                    tr.appendChild(td);
                }
            }
            if (count == 4) {
                tbody.appendChild(tr);
            }
        }
        table.appendChild(tbody);
    } else {
        table.innerHTML = "今天已经不可以预约了,改天吧！";

    }
}

function chooseItem(){
    if (ChoseID() == null) {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        }else{
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    }else{
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        }else{
            alert("只能选择一个时间段！");
        }
    }
    
}

function ChoseID(){
    var td_id = null;
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    return td_id;
}

function hasChosen(){
    alert("该时间段已被预约！");
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

//根据日期创建新表
function CreateNewAppiontTable(evt) {
    evt.preventDefault();
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipmentID = equipmentName.options[currentIndex].value;
    var AppiontDate = document.getElementById("AppiontDate");
    if (!compareWithToday(AppiontDate.value)) {
        alert("不能选择小于当天的日期");
        return;
    }
    var date = AppiontDate.value;
    var xmlHttp = new XMLHttpRequest();
    var url = "GetEquipmentAppointment.ashx?equipmentID=" + equipmentID + "&date=" + date;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    thisObj = eval("(" + json + ")");
    CreateCurrentEquipmentTbale(thisObj, date);
}
//获取所有待等待体位固定申请疗程号以及所属患者ID与其他信息
function getfixPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID="+treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}
//删除某节点的所有子节点
function removeUlAllChild(evt) {
    while (evt.hasChildNodes()) {
        evt.removeChild(evt.firstChild);
    }
}

//性别换算
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}


function checkAllTable() {
    var choseid =  ChoseID();
    var appoint = choseid.split("_");
    document.getElementById("idforappoint").value = appoint[0];
    document.getElementById("appointtime").value = appoint[3] + " " + appoint[1] + " " + appoint[2];
}
//第二页的模具选择下拉菜单
function createmodelselectItem(thiselement) {
    var modelItem = JSON.parse(getmodelItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-------模具选择-------");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < modelItem.length; i++) {
        if (modelItem[i] != "") {
            thiselement.options[i + 1] = new Option(modelItem[i].Name);
            thiselement.options[i + 1].value = parseInt(modelItem[i].ID);
        }
    }

}
function getmodelItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getmodel.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//第二页的特殊要求下拉菜单
function createspecialrequestItem(thiselement) {
    var specialItem = JSON.parse(getspecialItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-------特殊要求-------");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < specialItem.length; i++) {
        if (specialItem[i] != "") {
            thiselement.options[i + 1] = new Option(specialItem[i].Requirements);
            thiselement.options[i + 1].value = parseInt(specialItem[i].ID);
        }
    }

}
function getspecialItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getspecial.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//第二页获取固定装置下拉菜单
function createfixEquipItem(thiselement) {
    var fixequipItem = JSON.parse(getfixequipItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-------固定装置-------");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < fixequipItem.length; i++) {
        if (fixequipItem[i] != "") {
            thiselement.options[i + 1] = new Option(fixequipItem[i].Name);
            thiselement.options[i + 1].value = parseInt(fixequipItem[i].ID);
        }
    }

}
function getfixequipItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getfixequip.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function compareWithToday(time) {
    var year = time.split("-")[0];
    var month = time.split("-")[1];
    var day = time.split("-")[2];
    var date = new Date();
    if (parseInt(year) < parseInt(date.getFullYear())) {
        return false;
    } else {
        if (parseInt(year) == parseInt(date.getFullYear())) {
            if (parseInt(month) < parseInt(date.getMonth() + 1)) {
                return false;
            } else {
                if (parseInt(month) == parseInt(date.getMonth() + 1)) {
                    if (parseInt(day) < parseInt(date.getDate())) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return true;
                }
            }
        } else {
            return true;
        }
    }
}
function remove() {
    document.getElementById("modelselect").removeAttribute("disabled");
    document.getElementById("specialrequest").removeAttribute("disabled");
    document.getElementById("fixEquip").removeAttribute("disabled");
    document.getElementById("Remarks").removeAttribute("disabled");
    document.getElementById("bodyPost").removeAttribute("disabled");
    if (ti == 0) {
        document.getElementById("appointtime").removeAttribute("disabled");
        document.getElementById("chooseappoint").removeAttribute("disabled");
    }
}