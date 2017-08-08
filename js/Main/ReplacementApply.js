window.addEventListener("load", Init, false);
var userName;
var userID;
var number = 0;
var obj = [];
var flag = 0;
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var patient = getReplacePatientInfo(treatmentID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    var texthos = hosttext(patient.Hospital_ID);
    document.getElementById("hospitalid").innerHTML = texthos;
    document.getElementById("lightpart").innerHTML = patient.lightpartname;
    createrequireItem(document.getElementById("replacementrequire"));
    var info = getReplaceInfomation(treatmentID);
    $("#current-tab").text(patient.Treatmentdescribe + "复位申请");
    var groupprogress = patient.Progress.split(",");
    if (contains(groupprogress, "12")) {
        flag = 1;
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatmentname == patient.Treatmentname) {
                document.getElementById("replacementrequire").value = info[i].requirement;
                document.getElementById("appointtime").value = info[i].equipname + " " + info[i].Date.split(" ")[0] + " " + toTime(info[i].Begin) + "-" + toTime(info[i].End);
                document.getElementById("applyuser").innerHTML = info[i].username;
                document.getElementById("time").innerHTML = info[i].ApplicationTime;
                if (info[i].userid == userID) {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
                    document.getElementById("idforappoint").value = info[i].appointid;
                }
            } else {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + '复位申请</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-5">复位要求：<span class="underline">' + info[i].require + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8">设备与时间：<span class="underline">' + info[i].equipname + ' ' + info[i].Date.split(" ")[0] + ' ' + toTime(info[i].Begin) + '-' + toTime(info[i].End) + '</span></div><div class="item col-xs-4"><button disabled="disabled" type="button" class="btn btn-success" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);

            }
        }
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
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatmentname != patient.Treatmentname) {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + '复位申请</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-5">复位要求：<span class="underline">' + info[i].require + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8">设备与时间：<span class="underline">' + info[i].equipname + ' ' + info[i].Date.split(" ")[0] + ' ' + toTime(info[i].Begin) + '-' + toTime(info[i].End) + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
            }
        }

    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            if (k != "chooseappoint") {
                document.getElementById("replacementrequire").value = info[k].requirement;
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
function hosttext(str) {
    if (str =="") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
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
    return obj1.info;
}
function save() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
    var appointid = document.getElementById("idforappoint").value;
    var require = document.getElementById("replacementrequire").value;
    if (require == "allItem") {
        window.alert("请填写复位要求");
        return false;
    }
    if (document.getElementById("idforappoint").value == "") {
        window.alert("请预约时间与设备");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    $.ajax({
        type: "POST",
        url: "ReplacementApply.ashx",
        async: false,
        data: {
            id: appointid,
            treatid: treatmentid,
            replacementrequire: require,
            user: userID
        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
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
        error: function (data) {
            alert("error");
        }
    });
  
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
function remove() {
    document.getElementById("replacementrequire").removeAttribute("disabled");
    if (flag == 0) {
        document.getElementById("chooseappoint").removeAttribute("disabled");
    }
}