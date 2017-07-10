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
    var patient = getReplacePatientInfo(treatmentID);
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
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = "疗程" + patient.Treatmentname;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    createrequireItem(document.getElementById("replacementrequire"));
    if (patient.Progress >=12) {
        var info = getReplaceInfomation(treatmentID);
        document.getElementById("replacementrequire").value = info.require;
        document.getElementById("replacementrequire").disabled = "true";
        document.getElementById("appointtime").value = info.equipname + " " + info.Date.split(" ")[0] + " " + toTime(info.Begin) + "-" + toTime(info.End);
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
function getReplaceInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getfinishedreplace.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[0];
}
function postreplace() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
    var appointid = document.getElementById("idforappoint").value;
    var require = document.getElementById("replacementrequire").value;
    if (require == "allItem") {
        window.alert("请填写复位要求");
        return;
    }
    if (document.getElementById("idforappoint").value == "0") {
        window.alert("请预约时间与设备");
        return;
    }
    var xmlHttp = new XMLHttpRequest();
    var url = "ReplacementApply.ashx?id=" + appointid + "&treatid=" + treatmentid + "&replacementrequire=" + require +"&user="+userID;
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
    var tbody = document.createElement("tbody");
    var temp_count = 0;
    for (var i = 0; i < equiment.length; i++) {
        var count = temp_count % 5;
        var tr;
        if (count == 0) {
            tr = document.createElement("tr");
        }
        var td = document.createElement("td");
        var sign = document.createElement("i");
         var text;
        if (equiment[i].State == "0") {
            if (compareWithToday(dateString)) {
                if (((i <= equiment.length - 2) && (equiment[i + 1].State == "1")) || (i == equiment.length - 1)) {
                    td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
                    text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                    td.style.backgroundColor = "#C1C1C1";
                    sign.className = "fa fa-fw fa-exclamation-circle";text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                    td.addEventListener("click", hasChosen, false);
                } else {
                    td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i + 1].End) + "_" + equiment[i].Euqipment);
                    text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i + 1].End));
                    sign.className = "";
                    td.addEventListener("click", chooseItem, false);
                    i = i + 1;
                }
            } else {
                td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
                text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                td.style.backgroundColor = "#C1C1C1";
                sign.className = "fa fa-fw fa-exclamation-circle";
                td.addEventListener("click", hasChosen, false);
            }

        } else {
            td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
            text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
            td.style.backgroundColor = "#C1C1C1";
            sign.className = "fa fa-fw fa-exclamation-circle";
            td.addEventListener("click", hasChosen, false);
        }  
        td.appendChild(text);
        td.appendChild(sign);
        tr.appendChild(td);
        if (i >= equiment.length - 1) {
            var k = temp_count+1;
            while (k % 5 != 0) {
                var td = document.createElement("td");
                tr.appendChild(td);
                k++;
            }
            tbody.appendChild(tr);
        }
        if (count== 4) {
            tbody.appendChild(tr);
        }
        temp_count++;
    }
    table.appendChild(tbody);
}
function compareWithToday(time) {
    var year = time.split("-")[0];
    var month = time.split("-")[1];
    var day = time.split("-")[2];
    var date=new Date();
    if (parseInt(year) < parseInt(date.getFullYear())) {
        return false;
    }else
    {
        if (parseInt(month) < parseInt(date.getMonth() + 1)) {
            return false;
        } else {
            if (parseInt(day) < parseInt(date.getDate())) {
                return false;
            } else {
                return true;
            }
        }
    }
}

function chooseItem() {
    if (ChoseID() == null) {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        } else {
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    } else {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        } else {
            alert("只能选择一个时间段！");
        }
    }

}

function ChoseID() {
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

function hasChosen() {
    alert("该时间段不能预约！");
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
function getReplacePatientInfo(treatmentID) {
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
    var choseid = ChoseID();
    var appoint = choseid.split("_");
    document.getElementById("idforappoint").value = appoint[0];
    document.getElementById("appointtime").value = appoint[3] + " " + appoint[1].split(" ")[0] + " " + appoint[2];
}

//第二页的复位要求选择下拉菜单
function createrequireItem(thiselement) {
    var requireItem = JSON.parse(getrequireItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--复位要求--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < requireItem.length; i++) {
        if (requireItem[i] != "") {
            thiselement.options[i + 1] = new Option(requireItem[i].Requirements);
            thiselement.options[i + 1].value = parseInt(requireItem[i].ID);
        }
    }

}
function getrequireItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getrequire.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
