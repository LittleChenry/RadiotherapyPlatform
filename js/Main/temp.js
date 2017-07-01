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
    var patient = getLocationPatientInfo(treatmentID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("address").innerHTML = patient.Address;
    document.getElementById("hospital").innerHTML = patient.Hospital;
    document.getElementById("contact").innerHTML = patient.Contact1;
    document.getElementById("contact2").innerHTML = patient.Contact2;
    document.getElementById("treatID").value = patient.treatID;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("treatID").innerHTML = treatmentID;
    document.getElementById("part").innerHTML = patient.partname;
    document.getElementById("diaguser").innerHTML = patient.RegisterDoctor;
    var select1 = document.getElementById("scanpart");
    createscanpartItem(select1);
    var select2 = document.getElementById("scanmethod");
    createscanmethodItem(select2);
    var select3 = document.getElementById("special");
    createspecialItem(select3);
    var add = document.getElementsByName("add");
    if (add[0].checked) {
        var select4 = document.getElementById("addmethod");
        createaddmethodItem(select4);
    } else {
        document.getElementById("addmethod").disabled = "true";

    }
    if (patient.Progress >= 4) {
        
        var info = getLocationInfomation(treatmentID);
        document.getElementById("scanmethod").value = info.scanmethod;
        document.getElementById("scanmethod").disabled = "true";
        document.getElementById("scanpart").value = info.scanpartname;
        document.getElementById("scanpart").disabled = "true";
        document.getElementById("up").value = info.UpperBound;
        document.getElementById("up").disabled = "true";
        document.getElementById("down").value = info.LowerBound;
        document.getElementById("down").disabled = "true";
        document.getElementById("special").value = info.locationrequire;
        document.getElementById("special").disabled = "true";
        document.getElementById("remark").value = info.Remarks;
        document.getElementById("remark").disabled = "true";
        var add = document.getElementsByName("add");
        document.getElementById("yes").disabled = "disabled";
        document.getElementById("No").disabled = "disabled";
        if (info.Enhance == "1") {
            add[0].checked = "true";
            document.getElementById("addmethod").value = info.enhancemethod;
            document.getElementById("addmethod").disabled = "disabled";
        } else {
            add[1].checked = "true";
            document.getElementById("addmethod").value = "allItem";
            document.getElementById("addmethod").disabled = "true";
        }
        document.getElementById("appointtime").value = info.equipname + " " + info.Date + " " + toTime(info.Begin) + "-" + toTime(info.End);
        document.getElementById("chooseappoint").disabled = "disabled";
        document.getElementById("applyuser").innerHTML = info.username;
        document.getElementById("time").innerHTML = info.ApplicationTime;

    } else {
        createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2]);
        var date = new Date();
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("AppiontDate").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()
        document.getElementById("time").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        document.getElementById("chooseappoint").addEventListener("click", function () {
            CreateNewAppiontTable(event);
        }, false);
        document.getElementById("chooseProject").addEventListener("click", function () {
            CreateNewAppiontTable(event);
        }, false);//根据条件创建预约表
        document.getElementById("sure").addEventListener("click", checkAllTable, false);

    }
}
//设备下拉菜单
function createfixEquipmachine(thiselement, item) {
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
    var url = "getfixmachine.ashx?item=" + item;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}
//调取数据库申请信息
function getLocationInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getfinishedlocation.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[0];
}
function postlocation() {
    var treatmentid = document.getElementById("treatID").value;
    var scanpart = document.getElementById("scanpart").value;
    var scanmethod = document.getElementById("scanmethod").value;
    var special = document.getElementById("special").value;
    var addgroup = document.getElementsByName("add");
    var add;
    if (addgroup[0].checked = "true") {
        add = addgroup[0].value;
    } else {
        add = addgroup[1].value;
    }
    var up = document.getElementById("up").value;
    var down = document.getElementById("down").value;
    var addmethod = document.getElementById("addmethod").value;
    var appointid = document.getElementById("idforappoint").value;
    var remark = document.getElementById("remark").value;
    if (document.getElementById("scanpart").value == "allItem") {
        window.alert("请选择扫描部位");
        return;
    }
    if (document.getElementById("scanmethod").value == "allItem") {
        window.alert("请选择扫描方式");
        return;
    }
    if (document.getElementById("up").value == "") {
        window.alert("请填写上界");
        return;
    }
    if (document.getElementById("down").value == "") {
        window.alert("请填写下界");
        return;
    }
    if (add== "1") {
        if (document.getElementById("addmethod").value == "allItem") {
            window.alert("请选择增强方式");
            return;
        }
    }
    if (special == "allItem") {
        window.alert("请选择特殊要求");
        return;
    }
    if (document.getElementById("idforappoint").value == "0") {
        window.alert("请预约时间与设备");
        return;
    }
    var xmlHttp = new XMLHttpRequest();
    var url = "LocationApplyRecord.ashx?id=" + appointid + "&treatid=" + treatmentid + "&scanpart=" + scanpart + "&scanmethod=" + scanmethod + "&user=" + userID + "&add=" + add + "&addmethod=" + addmethod + "&up=" + up + "&down=" + down + "&remark=" + remark + "&requirement=" + special;
 
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    
    var result = xmlHttp.responseText;
    if (result == "success") {
        window.alert("申请成功");
        window.location.Reload();
    }
    if (result == "busy") {
        window.alert("预约时间被占,需要重新预约");
    }
    if (result == "failure") {
        window.alert("申请失败");
    }
}

//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(equiment, dateString) {
    var table = document.getElementById("apptiontTable");
    RemoveAllChild(table);
    var thead = document.createElement("THEAD");
    var headRow = document.createElement("TR");
    thead.appendChild(headRow);
    table.appendChild(thead);
    var tbody = document.createElement("TBODY");
    var bodyRow1 = document.createElement("TR");
    tbody.appendChild(bodyRow1);
    table.appendChild(tbody);
    var cols = 0;//该行有几列了
    var treatid = window.location.search.split("=")[1];
    var fixtime = getfixtime(treatid);
    var fixtime = JSON.parse(fixtime).fixtime;
    var begintime = toTime(fixtime[0].Begin);
    var endtime = toTime(fixtime[0].End);
    var fixtimebiaozhun = fixtime[0].Date.split(" ")[0] + " " + begintime + "-" + endtime;
    for (var i = 0; i < equiment.length; i++) {
        var beg = equiment[i].Begin;
        var end = equiment[i].End;
        var state = equiment[i].State;
        var id = equiment[i].ID;
        var datedate = dateString.split("-");
        var groupstring = "-" + datedate[1] + "-" + datedate[2] + "-" + beg + "-" + end;
        var group = groupstring.split("-");
        var flag = compare(fixtimebiaozhun, group);
        if (state == 0 && flag) {
            var timeText = document.createTextNode(toTime(beg) + " - " + toTime(end));
            var th = document.createElement("TH");
            var check = document.createElement("INPUT");
            check.setAttribute("type", "radio");
            check.setAttribute("name", "app");
            check.setAttribute("id", id + "_" + dateString + "_" + toTime(beg) + "-" + toTime(end) + "_" + equiment[i].Euqipment);
            th.appendChild(check);
            th.appendChild(timeText);
            if (cols < 5) {
                headRow.appendChild(th);
                ++cols;
            } else {
                cols = 1;
                var newHead = document.createElement("THEAD");
                headRow = document.createElement("TR");
                newHead.appendChild(headRow);
                table.appendChild(newHead);
                var newBody = document.createElement("TBODY");
                table.appendChild(newBody);
                headRow.appendChild(th);
            }
        }
    }
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
function getLocationPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
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
    var temp = 1;
    var total = 0;
    var id;
    var domList = document.getElementsByName("app");
    var len = domList.length;
    for (temp = 0; temp < domList.length; temp++) {
        if (domList[temp].checked == true) {
            id = domList[temp].id;
            total++;
        }
    }

    if (total == 0) {
        window.alert("尚未预约时间");
        document.getElementById("appointtime").value = "";
        document.getElementById("idforappoint").value = 0;
    }
    if (total == 1) {
        var appoint = id.split("_");
        document.getElementById("idforappoint").value = appoint[0];
        document.getElementById("appointtime").value = appoint[3] + " " + appoint[1] + " " + appoint[2];
    }
}
function getfixtime(treatid) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetFixtime.ashx?treatid=" + treatid;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;

}
//扫描部位
function createscanpartItem(thiselement) {
    var scanpartItem = JSON.parse(getscanpartItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--扫描部位--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < scanpartItem.length; i++) {
        if (scanpartItem[i] != "") {
            thiselement.options[i + 1] = new Option(scanpartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(scanpartItem[i].ID);
        }
    }
}
function getscanpartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getscanpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//扫描部位
function createscanmethodItem(thiselement) {
    var scanmethodItem = JSON.parse(getscanmethodItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--扫描方式--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < scanmethodItem.length; i++) {
        if (scanmethodItem[i] != "") {
            thiselement.options[i + 1] = new Option(scanmethodItem[i].Method);
            thiselement.options[i + 1].value = parseInt(scanmethodItem[i].ID);
        }
    }
}
function getscanmethodItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getscanmethod.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//扫描特殊要求
function createspecialItem(thiselement) {
    var specialItem = JSON.parse(getspecialItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--特殊要求--");
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
    var url = "getscanspecial.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//增强方式
function createaddmethodItem(thiselement) {
    var addmethodItem = JSON.parse(getaddmethodItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--增强方式--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < addmethodItem.length; i++) {
        if (addmethodItem[i] != "") {
            thiselement.options[i + 1] = new Option(addmethodItem[i].Method);
            thiselement.options[i + 1].value = parseInt(addmethodItem[i].ID);
        }
    }
}
function getaddmethodItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getaddmethod.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function forchange() {
    var add = document.getElementsByName("add");
    if (add[0].checked) {
        var select4 = document.getElementById("addmethod");
        select4.removeAttribute("disabled");
        createaddmethodItem(select4);
    }
    if (add[1].checked) {
        document.getElementById("addmethod").disabled = "true";

    }
}
//比较体位固定与模拟定位申请时间
function compare(evt1, evt2) {
    var year = evt1.split(" ")[0];
    var hour = evt1.split(" ")[1];
    var begin = hour.split("-")[0];
    var minute = begin.split(":")[0];
    var minute2 = begin.split(":")[1];
    Min = parseInt(minute) * 60 + parseInt(minute2);
    var month = year.split("/")[1];
    var day = year.split("/")[2];
    if (parseInt(month) > parseInt(evt2[1])) {

        return false;
    }
    if (parseInt(month) == parseInt(evt2[1]) && parseInt(day) > parseInt(evt2[2])) {
        return false;
    }
    if (parseInt(month) == parseInt(evt2[1]) && parseInt(day) == parseInt(evt2[2])) {
        if ((parseInt(evt2[3]) - Min) >= 120) {
            return true;
        }
        else {
            return false;
        }

    }
    return true;

}