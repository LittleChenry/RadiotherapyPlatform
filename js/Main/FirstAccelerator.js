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
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var patient = getFAPatientInfo(treatmentID);
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
    var groupprogress = patient.Progress.split(",");
    var i = 0;
    var designInfo = getDesignInfo(treatmentID);
    document.getElementById("Remarks").innerHTML = designInfo[i].RadiotherapyHistory;
    readDosagePriority(designInfo[i].DosagePriority);
    readDosage(designInfo[i].Dosage);
    document.getElementById("technology").innerHTML = designInfo[i].technology;
    document.getElementById("equipment").innerHTML = designInfo[i].equipment;
    document.getElementById("PlanSystem").innerHTML = designInfo[i].PlanSystem;
    document.getElementById("IlluminatedNumber").innerHTML = designInfo[i].IlluminatedNumber;
    document.getElementById("Coplanar").innerHTML = charge1(designInfo[i].Coplanar);
    document.getElementById("MachineNumbe").innerHTML = designInfo[i].MachineNumbe;
    document.getElementById("ControlPoint").innerHTML = designInfo[i].ControlPoint;
    document.getElementById("Grid").innerHTML = designInfo[i].Grid_ID;
    document.getElementById("Algorithm").innerHTML = designInfo[i].Algorithm_ID;
    document.getElementById("Feasibility").innerHTML = charge(designInfo[i].Feasibility);
    createSplitway(document.getElementById("splitway"));
    var total = gettotalnumber(treatmentID);
    var totalnumber = total.split(",")[0];
    var finshedtimes = total.split(",")[1];
    if (totalnumber != "") {
        document.getElementById("totalnumber").value = totalnumber;
        if (finshedtimes != "") {
            document.getElementById("finishedtimes").innerHTML = finshedtimes;
        } else {
            document.getElementById("finishedtimes").innerHTML = "0";
        }

    } else {
        document.getElementById("totalnumber").value = 0;
        document.getElementById("finishedtimes").innerHTML ="0";
    }
    var logjson = getLog(treatmentID);

    var log = logjson.ChangeLog;
    
   if (log == "") {
       document.getElementById("logholder").style.display = "none";
   } else {
       var loggroup = log.split(";");
       var content = '';
       for (var k = 1; k < loggroup.length; k++) {
           var loggroupk = loggroup[k].split(",");
           content = content + '<tr style="text-align:center">';
           content = content + '<td>' + loggroupk[2] + '</td><td>' + loggroupk[1] + '</td><td>' + loggroupk[0] + '</td>';
           content = content + '</tr>';
          
       }
       $("#log").append(content);
   }
   document.getElementById("splitway").value = logjson.SplitWay_ID;
   document.getElementById("remarks").value = logjson.SpecialEnjoin;
    if (contains(groupprogress, "14")) {
        var info = getfirstaccelerateInfomation(treatmentID);
        if (parseInt(toTime(info.End).split(":")[0]) >= 24) {
            var hour = toTime(info.Begin).split(":")[0];
            var minute = toTime(info.Begin).split(":")[1];
            if (hour >= 24) {
                var beginhour = parseInt(hour) - 24;
            } else {
                var beginhour = hour;
            }
            var begin = beginhour + ":" + minute;
            var endhour = toTime(info.End).split(":")[0];
            var endminute = toTime(info.End).split(":")[1];
            var hourend = parseInt(endhour) - 24;
            var end = hourend + ":" + endminute;
            document.getElementById("appointtime").value = info.equipname + " " + info.Date.split(" ")[0] + " " + begin + "-" + end+"(次日)";
        } else {
            document.getElementById("appointtime").value = info.equipname + " " + info.Date.split(" ")[0] + " " + toTime(info.Begin) + "-" + toTime(info.End);
        }
        document.getElementById("chooseappoint").disabled = "disabled";
        document.getElementById("operator").innerHTML = info.username;
        document.getElementById("date").innerHTML = info.ApplyTime;

    } else {
           var type  = geteuqipmenttype(treatmentID);
          createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2], type);
          var info = getfirstaccelerateInfomation(treatmentID);
          if ((typeof (info) != "undefined")) {
              if (parseInt(toTime(info.End).split(":")[0]) >= 24) {
                  var hour = toTime(info.Begin).split(":")[0];
                  var minute = toTime(info.Begin).split(":")[1];
                  if (hour >= 24) {
                      var beginhour = parseInt(hour) - 24;
                  } else {
                      var beginhour = hour;
                  }
                  var begin = beginhour + ":" + minute;
                  var endhour = toTime(info.End).split(":")[0];
                  var endminute = toTime(info.End).split(":")[1];
                  var hourend = parseInt(endhour) - 24;
                  var end = hourend + ":" + endminute;
                  document.getElementById("appointtime").value = info.equipname + " " + info.Date.split(" ")[0] + " " + begin + "-" + end + "(次日)";
              } else {
                  document.getElementById("appointtime").value = info.equipname + " " + info.Date.split(" ")[0] + " " + toTime(info.Begin) + "-" + toTime(info.End);
              }
              document.getElementById("idforappoint").value = info.appointid;
          }
            var date = new Date();
            document.getElementById("operator").innerHTML = userName;
            document.getElementById("date").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            document.getElementById("AppiontDate").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
            document.getElementById("chooseappoint").addEventListener("click", function () {
                CreateNewAppiontTable(event);
            }, false);
            document.getElementById("chooseProject").addEventListener("click", function () {
                CreateNewAppiontTable(event);
            }, false);//根据条件创建预约表
            document.getElementById("sure").addEventListener("click", checkAllTable, false);
            $("#changetotalnumber").bind("click", function () {
                if ($(this).html() == "更改") {
                    $(this).text("保存");
                    document.getElementById("totalnumber").removeAttribute("disabled");

                } else {
                    $(this).text("更改");
                    document.getElementById("totalnumber").disabled = "disabled";
                }
            });
            $("#finish").click(function () {
                if (document.getElementById("finish").innerHTML == "结束治疗") {
                    document.getElementById("finishthistreat").value = "1";
                    document.getElementById("finish").innerHTML = "取消";
                } else {
                    document.getElementById("finishthistreat").value = "0";
                    document.getElementById("finish").innerHTML = "结束治疗"
                }
            });  
    }
}
function geteuqipmenttype(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "geteuqipmenttype.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;

}
function createSplitway(thiselement) {
    var getsplitwayItem = JSON.parse(getsplitway()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-- 分割方式--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < getsplitwayItem.length; i++) {
        if (getsplitwayItem[i] != "") {
            thiselement.options[i+1] = new Option(getsplitwayItem[i].Ways);
            thiselement.options[i+1].value = parseInt(getsplitwayItem[i].ID);
        }
    }
}
function getsplitway() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getsplitwayItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}

function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}
function getLog(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getalllog.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.Item[0];
}
function gettotalnumber(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "gettreatmentnumber.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}
function contains(group, s) {
    for (var k = 0; k <= group.length - 1; k++) {
        if (group[k] == s) {
            return true;
        }
    }
    return false;
}
function charge1(evt) {
    if (evt == "0")
        return "不是";
    else
        return "是";
}
function charge(evt) {
    if (evt == "0")
        return "不可行";
    else
        return "可行";
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
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
            } else {
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
//设备下拉菜单
function createfixEquipmachine(thiselement, item,type) {
    var machineItem = JSON.parse(getmachineItem(item,type)).Item;
    thiselement.options.length = 0;
    for (var i = 0; i < machineItem.length; i++) {
        if (machineItem[i] != "") {
            thiselement.options[i] = new Option(machineItem[i].Name);
            thiselement.options[i].value = parseInt(machineItem[i].ID);
        }
    }
}
function getmachineItem(item,type) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getaccermachine.ashx?item=" + item+"&type="+type;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}
//调取数据库申请信息
function getfirstaccelerateInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getfinishedfirstaccelerate.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[obj1.info.length-1];
}
function save() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
        var appointid = document.getElementById("idforappoint").value;
        var totalnumber = document.getElementById("totalnumber").value;
        var finish = document.getElementById("finishthistreat").value;
     
        if (document.getElementById("splitway").value == "allItem") {
            window.alert("请选择分割方式");
            return false;
        }
        if (document.getElementById("idforappoint").value == "0") {
            window.alert("请预约时间与设备");
            return false;
        }
        if (document.getElementById("totalnumber").value == 0) {
            window.alert("总次数不能为0");
            return false;
        }
        if ((typeof (userID) == "undefined")) {
            if (confirm("用户身份已经失效,是否选择重新登录?")) {
                parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
            }
        }
        $.ajax({
            type: "POST",
            url: "FirstAcclerateRecord.ashx",
            async: false,
            data: {
                id: appointid,
                treatid: treatmentid,
                isfinished: finish,
                totalnumber: totalnumber,
                user: userID,
                username: userName,
                splitway: document.getElementById("splitway").value,
                remarks: document.getElementById("remarks").value

            },
            dateType: "json",
            success: function (data) {
                if (data == "success") {
                    window.alert("申请成功");
                    window.location.reload();
                }
                if (data == "busy") {
                    window.alert("预约时间被占,需要重新预约");
                }
                if (data == "failure") {
                    window.alert("申请失败");
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
    var i;
    for (i=0; i < Math.ceil(equiment.length / 5) * 5 ; i++) {
        var count = i % 5;
        var tr;
        if (count == 0) {
            tr = document.createElement("tr");
        } 
        var td = document.createElement("td");
        var sign = document.createElement("i");
        if (i <= equiment.length - 1) {
            if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
                var hour = toTime(equiment[i].Begin).split(":")[0];
                var minute = toTime(equiment[i].Begin).split(":")[1];
                if (hour >= 24) {
                    var beginhour = parseInt(hour) - 24;
                } else {
                    var beginhour = hour;
                }
                var begin = beginhour + ":" + minute;
                var endhour = toTime(equiment[i].End).split(":")[0];
                var endminute = toTime(equiment[i].End).split(":")[1];
                var hourend = parseInt(endhour) - 24;
                var end = hourend + ":" + endminute;
                td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + begin + "-" + end + "(次日)" + "_" + equiment[i].Euqipment);
            } else {
                td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
            }
            if (equiment[i].State == "0") {
                if (getReplace(equiment[i], dateString)) {
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
                    sign.className = "fa fa-fw fa-exclamation-circle";
                    td.addEventListener("click", hasChosen, false);
                }
            } else {
                td.style.backgroundColor = "#C1C1C1";
                sign.className = "fa fa-fw fa-ban td-sign";
                td.addEventListener("click", hasChosen, false);
            }
            if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
                var hour = toTime(equiment[i].Begin).split(":")[0];
                var minute = toTime(equiment[i].Begin).split(":")[1];
                if (hour >= 24) {
                    var beginhour = parseInt(hour) - 24;
                } else {
                    var beginhour = hour;
                }
                var begin = beginhour + ":" + minute;
                var endhour = toTime(equiment[i].End).split(":")[0];
                var endminute = toTime(equiment[i].End).split(":")[1];
                var hourend = parseInt(endhour) - 24;
                var end = hourend + ":" + endminute;
                var text = document.createTextNode(begin + " - " + end + "(次日)");
            } else {
                var text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
            }
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
function getReplace(equiment, dateString) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatid = treatmentgroup.split("=")[1];
    var fixtime = getreplacetime(treatid);
    var fixtime = JSON.parse(fixtime).fixtime;
    var begintime = toTime(fixtime[0].Begin);
    var endtime = toTime(fixtime[0].End);
    var fixtimebiaozhun = fixtime[0].Date.split(" ")[0] + " " + begintime + "-" + endtime;
    var datedate = dateString.split("-");
    var groupstring = "-" + datedate[1] + "-" + datedate[2] + "-" + equiment.Begin + "-" + equiment.End;
    var group = groupstring.split("-");
    return compare(fixtimebiaozhun, group);
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
function getFAPatientInfo(treatmentID) {
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

function getreplacetime(treatid) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getreplacetime.ashx?treatid=" + treatid;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;

}
//比较加速器与复位申请时间
function compare(evt1, evt2) {
    var year = evt1.split(" ")[0];
    var hour = evt1.split(" ")[1];
    var end = hour.split("-")[1];
    var minute = end.split(":")[0];
    var minute2 = end.split(":")[1];
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
        if ((parseInt(evt2[3]) - Min) >= 30) {
            return true;
        }
        else {
            return false;
        }

    }
    return true;

}
function remove() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
    var total = gettotalnumber(treatmentid);
    var totalnumber = total.split(",")[0];
    var finshedtimes = total.split(",")[1];
    if (document.getElementById("appointtime").value==""){
        document.getElementById("chooseappoint").removeAttribute("disabled");
    }
    document.getElementById("changetotalnumber").removeAttribute("disabled");
    document.getElementById("finish").removeAttribute("disabled");
    document.getElementById("splitway").removeAttribute("disabled");
    document.getElementById("remarks").removeAttribute("disabled");
}