window.addEventListener("load", Init, false);
var userName;
var userID;
var require;
var rowcount = 1;
var obj = [];
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    var appoint = window.location.search.split("&")[1];//?后第一个变量信息
    var appointid = appoint.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var patient = getPatientInfo(treatmentID);
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
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    var session = getSession();
    var flag = judge(appointid, treatmentID);
    var progress = patient.Progress.split(",");
    if (flag == "success" && !contains(progress, "15")) {
        if (session.assistant == "") {
            $("#operatorModal").modal({ backdrop: 'static' });
        }
    } else {
        $("#edit", window.parent.document).attr("disabled", true);
    }
    refresh(treatmentID);
    refresh1(treatmentID);
    $("#validate").click(function () {
        $.ajax({
            type: "POST",
            url: "validateOperator.ashx",
            async: false,
            data: {
                Number: $("#OperatorNumber").val(),
                Password: $("#OperatorPassword").val()
            },
            dateType: "json",
            success: function (data) {
                if (data != "fail") {
                    alert("验证成功！");
                    $.ajax({
                        type: "POST",
                        url: "setAssistant.ashx",
                        data: { assistant: data },
                        success: function()
                        {
                            $("#operator", window.parent.document).html(data);
                        },
                        error: function () {
                            alert("error");
                        }
                    });
                } else {
                    alert("验证失败，请重新验证！");
                    $("#operatorModal").modal({ backdrop: 'static' });
                }
            },
            error: function () {
                alert("error");
            }
        });
    });
    var totalnumber = gettotalnumber(treatmentID);
    var firstdate = getfirstday(treatmentID).split(" ")[0];
    var date=new Date();
    var today=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
    var dis = GetDateDiff(firstdate, today);
    if (isNaN(dis)) {
        dis = 1;
    }
    if (parseInt(totalnumber) != 0) {
        document.getElementById("totalnumber").value = totalnumber;
    }
    var allfirstnumber = parseInt(getallfirst(treatmentID));
    if (parseInt(totalnumber) - allfirstnumber <= 0) {
        document.getElementById("rest").innerHTML = "剩余加速器预约(剩0次)";
        document.getElementById("rest").disabled = "disabled";
    } else {
        document.getElementById("rest").innerHTML = "剩余加速器预约(剩" + (parseInt(totalnumber) - allfirstnumber) + "次)";
        document.getElementById("rest").removeAttribute("disabled");
    }
    $("#totalnumber").bind("input propertychange", function () {

        var allfirstnumber = parseInt(getallfirst(treatmentID));
        var totalnumber = document.getElementById("totalnumber").value;
       
        if (parseInt(totalnumber) - allfirstnumber <= 0) {
            document.getElementById("rest").innerHTML = "剩余加速器预约(剩0次)";
            document.getElementById("rest").disabled = "disabled";
        } else {
            document.getElementById("rest").innerHTML = "剩余加速器预约(剩" + (parseInt(totalnumber) - allfirstnumber) + "次)";
            document.getElementById("rest").removeAttribute("disabled");
        }
    });


    $("#finish").click(function () {
        if (document.getElementById("finish").innerHTML == "结束") {
            document.getElementById("finishthistreat").value = "1";
            document.getElementById("finish").innerHTML = "取消";
        } else {
            document.getElementById("finishthistreat").value = "0";
            document.getElementById("finish").innerHTML = "结束"
        }
    });
    $("#treatmentedit").click(function()
    {
        var allfirstnumber = parseInt(getotheraccer(treatmentID));
        if (allfirstnumber <=0){
            alert("此病人已经没有预约,如果想结束治疗请点击结束再保存!");
            evt.preventDefault();
            return;
        }
        if (allfirstnumber == 1) {
            if (confirm("此病人还剩下一次治疗机会,如果想继续预约请增加总次数!")) {

            } else {
                $.ajax({
                    type: "POST",
                    url: "treatmentRecordRecord.ashx",
                    async: false,
                    data: {
                        treatmentID: treatmentID
                    },
                    dateType: "json",
                    success: function (data) {

                    },
                    error: function () {
                        alert("error");
                    }
                });

                var session = getSession();
                if (session.assistant != "") {
                    $.ajax({
                        type: "POST",
                        url: "TreatmentRecord.ashx",
                        async: false,
                        data: {
                            assistant: session.assistant,
                            user: userID,
                            totalnumber: document.getElementById("totalnumber").value,
                            treatmentID: treatmentID,
                            appoint: appointid,
                            treatdays: dis,
                            patientid: patient.ID
                        },
                        dateType: "json",
                        success: function (data) {
                            if (data == "success") {
                                alert("记录成功！");
                                document.getElementById("treatmentedit").disabled = "disabled";
                                refresh(treatmentID);
                                parent.window.location.reload();
                            } else {
                                alert("上传失败！");
                            }
                        },
                        error: function () {
                            alert("error");
                        }
                    });
                } else {
                    alert("没有选择协助操作者");
                }
            }
        } else {
            var session = getSession();
            if (session.assistant != "") {
                $.ajax({
                    type: "POST",
                    url: "TreatmentRecord.ashx",
                    async: false,
                    data: {
                        assistant: session.assistant,
                        user: userID,
                        totalnumber: document.getElementById("totalnumber").value,
                        treatmentID: treatmentID,
                        appoint: appointid,
                        treatdays: dis,
                        patientid: patient.ID
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            alert("记录成功！");
                            document.getElementById("treatmentedit").disabled = "disabled";
                            refresh(treatmentID);
                            parent.window.location.reload();
                        } else {
                            alert("上传失败！");
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            } else {
                alert("没有选择协助操作者");
            }
        }
    });
    $("#recordigrt").click(function()
    {
        var session = getSession();
        if (session.assistant != "") {
            $.ajax({
                type: "POST",
                url: "igrtrecord.ashx",
                async: false,
                data: {
                    assistant: session.assistant,
                    user: userID,
                    xvalue: document.getElementById("xvalue").value,
                    yvalue: document.getElementById("yvalue").value,
                    zvalue: document.getElementById("zvalue").value,
                    treatmentID: treatmentID
                },
                dateType: "json",
                success: function (data) {
                    if (data == "success") {
                        alert("记录成功！");
                        refresh1(treatmentID);
                    } else {
                        alert("上传失败！");
                    }
                },
                error: function () {
                    alert("error");
                }
            });
        } else {
            alert("没有选择协助操作者");
        }
    });
    createfixEquipmachine(document.getElementById("equipmentName"), "Accelerator");
    var date = new Date();
    document.getElementById("AppiontDate").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate()
    document.getElementById("rest").addEventListener("click", function () {
        CreateNewAppiontTable(event);
    }, false);
    document.getElementById("chooseProject").addEventListener("click", function () {
        CreateNewAppiontTable(event);
    }, false);//根据条件创建预约表
    document.getElementById("sure").addEventListener("click", function () {
        checkAllTable(treatmentID);
    }, false);

}
function getallfirst(treatmentID)
{
    var xmlHttp = new XMLHttpRequest();
    var url = "getallfirstappoint.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}
function getotheraccer(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getotheraccer.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}
function refresh(treatmentID) {
    var data = getalltreatmentrecord(treatmentID);
    RemoveAllChild(document.getElementById("treatment"));
    var content = "";
    var num = 0;
    for (var i = 0; i <= data.length - 1; i++) {
        num = num + parseInt(data[i].Singlenumber);
        content = content + '<tr>';
        content = content + '<td>' + data[i].TreatTime.split(" ")[0] + '</td><td>' + data[i].TreatedDays + '</td><td>' + data[i].TreatedTimes + '</td><td>' + data[i].IlluminatedNumber
                  + '</td><td>' + data[i].MachineNumber + '</td><td>' + data[i].Singlenumber + '</td><td>' + num + '</td><td>' + data[i].treatusername + '</td><td>' + data[i].Assist_User + '</td>';
        if (data[i].checkusername != "") {
            content = content + '<td>' + data[i].checkusername + '已审核</td>';
        } else {
            if ((i + 1) % 5 != 0) {
                content = content + '<td>待审核</td>';
            } else {
                var id=data[i].ID+"-"+data[i-1].ID+"-"+data[i-2].ID+"-"+data[i-3].ID+"-"+data[i-4].ID;
                content = content + '<td><button class="btn btn-success btn-xs" type="button" id="' + id+'">周计量核对</button></td>';
            }

        }
        content = content + "</tr>";
    }
    $("#treatment").append(content);
    $("#treatment").find("button").each(function () {
        $(this).bind("click", function () {
            if ((typeof (userID) == "undefined")) {
                if (confirm("用户身份已经失效,是否选择重新登录?")) {
                    parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
                }
            }
         var xmlHttp = new XMLHttpRequest();
         var url = "changeweekcheck.ashx?ID=" + $(this).attr("id")+"&user="+userID;
        xmlHttp.open("GET", url, false);
        xmlHttp.send(null);
        var json = xmlHttp.responseText;
        if (json == "success") {
            refresh(treatmentID);
            alert("成功核对!");
        } else {
            alert("核对失败!");
        }

        });
    }); 

}
function getalltreatmentrecord(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getalltreatmentrecord.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.Item;
}
function refresh1(treatmentID) {
    var data = getalligrt(treatmentID);
    RemoveAllChild(document.getElementById("IGRT"));
    var content = "";
    for (var i = 0; i <= data.length - 1; i++) {
        content = content + '<tr>';
        content = content + '<td>' + data[i].OperateTime.split(" ")[0] + '</td><td>' + data[i].X_System + '</td><td>' + data[i].Y_System + '</td><td>' + data[i].Z_System
                  + '</td><td>' + data[i].treatusername + '</td><td>' + data[i].Assist + '</td>';
         content = content + "</tr>";
    }
       $("#IGRT").append(content);
    }

function getalligrt(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getalligrt.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.Item;
}
function getfirstday(treatmentID)
{
    var xmlHttp = new XMLHttpRequest();
    var url = "getfirstday.ashx?treatmentID=" +treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}
function GetDateDiff(startDate, endDate) {
    var startTime = new Date(Date.parse(startDate.replace(/-/g, "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g, "/"))).getTime();
    var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
    return dates+1;
}

function contains(group, s) {
    for (var k = 0; k <= group.length - 1; k++) {
        if (group[k] == s) {
            return true;
        }
    }
    return false;
}
function tankuang() {
    $("#operatorModal").modal({ backdrop: 'static' });
}
function getSession(){
    var Session;
    $.ajax({
        type: "GET",
        url: "getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            Session = $.parseJSON(data);
        },
        error: function(){
            alert("error");
        }
    });
    return Session;
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
function gettotalnumber(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "gettreatmentnumber.ashx?treatmentID=" +treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
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

//获取所有待等待模拟定位申请疗程号以及所属患者ID与其他信息
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
                //alert(userID);                
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
function remove() {
    document.getElementById("totalnumber").removeAttribute("disabled");
    document.getElementById("finish").removeAttribute("disabled");
    document.getElementById("treatmentedit").removeAttribute("disabled");
    document.getElementById("finishigrt").removeAttribute("disabled");

}
function save() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    if (document.getElementById("finishthistreat").value != "1") {
        window.alert("如需结束疗程治疗请先点击结束按钮,谢谢！");
    } else {
        $.ajax({
            type: "POST",
            url: "treatmentRecordRecord.ashx",
            async: false,
            data: {
                treatmentID: treatmentID
            },
            dateType: "json",
            success: function (data) {
                if (data == "success") {
                    alert("成功！");
                } else {
                    alert("失败！");
                }
            },
            error: function () {
                alert("error");
            }
        });
        
    }
}
//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(equiment, dateString) {
    var table = document.getElementById("apptiontTable");
    RemoveAllChild1(table);
    var tbody = document.createElement("tbody");
    var i;
    for (i = 0; i < Math.ceil(equiment.length / 5) * 5 ; i++) {
        var count = i % 5;
        var tr;
        if (count == 0) {
            tr = document.createElement("tr");
        }
        var td = document.createElement("td");
        var sign = document.createElement("i");
        if (i <= equiment.length - 1) {
            td.setAttribute("id", equiment[i].ID + "_" + dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Euqipment);
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
}
function compareWithToday(time) {
    var year = time.split("-")[0];
    var month = time.split("-")[1];
    var day = time.split("-")[2];
    var date = new Date();
    if (parseInt(year) < parseInt(date.getFullYear())) {
        return false;
    } else {
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

//清楚所有子节点
function RemoveAllChild1(area) {
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
function checkAllTable(treatmentID) {
    var choseid = ChoseID();
    var appoint = choseid.split("_");
    var appointid = appoint[0];
    $.ajax({
        type: "POST",
        url: "AccerateAppoint.ashx",
        async: false,
        data: {
            id: appointid,
            treatid: treatmentID

        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                window.alert("申请成功");
                var allfirstnumber = parseInt(getallfirst(treatmentID));
                var totalnumber = document.getElementById("totalnumber").value;

                if (parseInt(totalnumber) - allfirstnumber <= 0) {
                    document.getElementById("rest").innerHTML = "剩余加速器预约(剩0次)";
                    document.getElementById("rest").disabled = "disabled";
                } else {
                    document.getElementById("rest").innerHTML = "剩余加速器预约(剩" + (parseInt(totalnumber) - allfirstnumber) + "次)";
                    document.getElementById("rest").removeAttribute("disabled");
                }
            }
            if (data == "busy") {
                window.alert("预约时间被占,需要重新预约");
            }
            if (data == "failure") {
                window.alert("申请失败");
            }
        },
        error: function () {
            alert("error");
        }
    });
    
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
        if ((parseInt(evt2[3]) - Min) >= 120) {
            return true;
        }
        else {
            return false;
        }

    }
    return true;

}
function judge(appointid,treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "judge.ashx?appointid=" + appointid+"&treat="+treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}