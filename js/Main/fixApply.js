﻿window.addEventListener("load", Init, false);
var userName;
var userID;
var number = 0;
var obj = [];
function Init(evt) {
    var treatmentID = window.location.search.split("=")[1];//?后第一个变量信息
    //调取后台所有等待就诊的疗程号及其对应的病人
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
    document.getElementById("treatID").value = patient.treatID;
    createmodelselectItem(document.getElementById("modelselect"));
    createspecialrequestItem(document.getElementById("specialrequest"));
    createfixEquipItem(document.getElementById("fixEquip"));
    if (patient.Progress>= 4) {
        var info = getfixInfomation(treatmentID);
        document.getElementById("modelselect").value = info.materialName;
        document.getElementById("modelselect").disabled = "true";
        document.getElementById("specialrequest").value = info.require;
        document.getElementById("specialrequest").disabled = "true";
        document.getElementById("fixEquip").value = info.fixedequipname;
        document.getElementById("fixEquip").disabled = "true";
        document.getElementById("bodyPost").value = info.BodyPosition;
        document.getElementById("bodyPost").disabled="true"; 
        document.getElementById("appointtime").value = info.equipname + " " + info.Date + " " + toTime(info.Begin) + "-" + toTime(info.End);
        document.getElementById("chooseappoint").disabled = "disabled";
        document.getElementById("applyuser").value = info.username;
        document.getElementById("time").value = info.ApplicationTime;

    } else {
    
    createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2]);
    var date = new Date();
    document.getElementById("time").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
    document.getElementById("AppiontDate").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
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
    var obj1 = eval("(" + json + ")");
    return obj1.info[0];
}
function postfix() {
    var basefixinfo = [];
    basefixinfo[0] = document.getElementById("modelselect").value;
    basefixinfo[1] = document.getElementById("specialrequest").value;
    basefixinfo[2] = userID;
    basefixinfo[3] = document.getElementById("time").value;
    basefixinfo[4] = document.getElementById("bodyPost").value;
    basefixinfo[5] = document.getElementById("fixEquip").value;
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
    for (var i = 0; i < equiment.length; i++) {
        var beg = equiment[i].Begin;
        var end = equiment[i].End;
        var state = equiment[i].State;
        var id = equiment[i].ID;
        if (state == 0) {
            var timeText = document.createTextNode(toTime(beg) + " - " + toTime(end));
            var th = document.createElement("TH");
            var check = document.createElement("INPUT");
            check.setAttribute("type", "checkbox");
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
    var temp = 1;
    var total = 0;
    var id;
    var domList = document.getElementsByTagName("input");
    var checkBoxList = [];
    var len = domList.length;
    while (len--) {
        if (domList[len].type == "checkbox") {
            checkBoxList.push(domList[len]);
        }
    }
    for (temp = 0; temp < checkBoxList.length; temp++) {
        if (checkBoxList[temp].checked == true) {
            id = checkBoxList[temp].id;
            total++;
        }
    }
    if (total >= 2) {
        window.alert("只能选择一个时间段");
    }
    if (total == 0) {
        window.alert("尚未预约时间");
    }
    if (total == 1) {
        var appoint = id.split("_");
        document.getElementById("idforappoint").value = appoint[0];
        document.getElementById("appointtime").value = appoint[3] + " " + appoint[1] + " " + appoint[2];
    }
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
