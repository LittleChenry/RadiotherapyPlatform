window.addEventListener("load", Init, false);
var userName;
var userID;
var require;
var rowcount = 1;
var obj = [];
var interal=1;
var times=20;
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    var appoint = window.location.search.split("&")[1];//?后第一个变量信息
    var appointid = appoint.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    getUserID();
    getUserName();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var special= getsplitandyizhu(treatmentID);
    document.getElementById("enjoin").value = special.SpecialEnjoin;
    document.getElementById("split").innerHTML = special.SplitWay;
    var patient = getPatientInfo(treatmentID);
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
    var i = 0;
    var replacerecordinfo = getreplacerecordInfo(treatmentID);
    var boxes = document.getElementById("multipic");
    var pictures = replacerecordinfo.picture.split(",");
    if (replacerecordinfo.picture == "") {
        boxes.innerHTML = "无";
    } else {
        for (var k = 1; k < pictures.length; k++) {
            var div = document.createElement("DIV");
            div.className = "boxes";
            var div1 = document.createElement("DIV");
            div1.className = "imgnum";
            var img = document.createElement("IMG");
            img.addEventListener("click", showPicture, false);
            img.className = "img";
            img.src = pictures[k];
            img.style.display = "block";
            div1.appendChild(img);
            div.appendChild(div1);
            boxes.appendChild(div);
        }
    }
    var designInfo = getDesignInfo(treatmentID);
    readDosagePriority(designInfo[i].DosagePriority);
    
    var pdfgroup = getpdfgroup(treatmentID);
    var pdf1 = pdfgroup.split(",")[0];
    var pdf2 = pdfgroup.split(",")[1];
    if (pdf1 != "") {
        document.getElementById("viewpdf").href = pdf1;
    }
    if (pdf2 != "") {
        document.getElementById("viewpdf2").href = pdf2;
    }
    var session = getSession();
   
    var flag;
    if (appointid!= "undefined") {
        flag = judge(appointid, treatmentID);
    } else {
        flag = "success";
    }
    var progress = patient.Progress.split(",");
    if (flag == "success" && !contains(progress, "15")) {
        if (session.assistant == "" && (session.role == "治疗技师" || session.role == "科主任")) {
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
                    document.getElementById("assist").innerHTML = data;
                    document.getElementById("chief").innerHTML = userName;
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
    var total = gettotalnumber(treatmentID);
    var totalnumber = total.split(",")[0];
    var firstdate = getfirstday(treatmentID).split(" ")[0];
    var date=new Date();
    var today=date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
    var dis = GetDateDiff(firstdate, today);
    if (isNaN(dis)) {
        dis = 1;
    }
    if (appointid != "undefined") {
        var treatconfirm = getconfirminfomation(treatmentID, appointid);
        document.getElementById("treatdays").innerHTML = dis;
        document.getElementById("treattimes").innerHTML = parseInt(treatconfirm.finishedtimes) + 1;
        document.getElementById("treatnumber").innerHTML = treatconfirm.IlluminatedNumber;
        document.getElementById("machinenumber").innerHTML = treatconfirm.MachineNumbe;
        document.getElementById("singlenumber").innerHTML = treatconfirm.DosagePriority;
        document.getElementById("sumnumber").innerHTML = parseInt(treatconfirm.DosagePriority)*(parseInt(treatconfirm.finishedtimes)+1);
        document.getElementById("chief").innerHTML = userName;
        document.getElementById("assist").innerHTML = session.assistant;
    }
    if (totalnumber!="") {
        document.getElementById("totalnumber").value = parseInt(totalnumber);
    }
    var allfirstnumber = parseInt(getallfirst(treatmentID));
    if ((parseInt(totalnumber) - allfirstnumber <= 0) || totalnumber=="") {
        document.getElementById("rest").innerHTML = "剩余加速器预约(剩0次)";
        $("#ask").css("display", "none");
        document.getElementById("rest").disabled = "disabled";
    } else {
        document.getElementById("rest").innerHTML = "剩余加速器预约(剩" + (parseInt(totalnumber) - allfirstnumber) + "次)";
        $("#ask").css("display", "block");
        if (session.roleName == "ZLJS") {
           document.getElementById("rest").removeAttribute("disabled");
        }
   
    }

    $("#confirm").click(function ()
    {
        var allfirstnumber = parseInt(getallfirst(treatmentID));
        if ((parseInt(totalnumber) - allfirstnumber <= 0) || totalnumber == "") {
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
                        patientid: patient.ID,
                        remark: document.getElementById("remarks").value
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            alert("记录成功！");
                            document.getElementById("treatmentedit").disabled = "disabled";
                            refresh(treatmentID);

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
        } else {
            alert("请预约完所有加速治疗再进行治疗");
            return false;
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
    var type = geteuqipmenttype(treatmentID);
    createfixEquipmachine(document.getElementById("equipmentName"), "Accelerator",type);
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
function geteuqipmenttype(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "geteuqipmenttype.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;

}
function getsplitandyizhu(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getalllog.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.Item[0];
}
function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}
function getreplacerecordInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getreplaceApply.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.replace[0];
}
function getpdfgroup(treatmentID)
{
    var xmlHttp = new XMLHttpRequest();
    var url = "getallpdf.ashx?treatID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}
function getconfirminfomation(treatmentID, appointid) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getconfirminfomation.ashx?treatID=" + treatmentID + "&appoint=" + appointid;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.Item[0];
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
                  + '</td><td>' + data[i].MachineNumber + '</td><td>' + data[i].Singlenumber + '</td><td>' + num + '</td><td>' + data[i].treatusername + '</td><td>' + data[i].Assist_User + '</td><td>' + data[i].Remarks + '</td>';
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
function getmachineItem(item, type) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getaccermachine.ashx?item=" + item + "&type=" + type;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}
function remove() {
    document.getElementById("treatmentedit").removeAttribute("disabled");
    document.getElementById("finishigrt").removeAttribute("disabled");

}
function save() {
   
}
//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(equiment, dateString,times) {
    var table = document.getElementById("apptiontTable");
    RemoveAllChild1(table);
    var $table = $("#apptiontTable");
    $table.css("width", times * 100 + "px");
    var context='<thead><tr><th>时刻/日期</th>'
    for (var k = 0; k < times; k++) {
        var datetemp = dateAdd(dateString, k);
        context = context + '<th>' + datetemp + '</th>';
    }
    context = context + '</tr></thead>' ;
    $table.append(context);
    var timeinfo = equiment.timeinfo;
    var length = timeinfo.length;
    var context2='<tbody>';
    for (var i = 0; i < length; i++) {
        context2 = context2 + '<tr id="rows_' + i + '"  ><td  onclick="clickrow(this)">' + toTime(timeinfo[i].Begin) + ' - ' + toTime(timeinfo[i].End) + '</td></tr>';
    }
    context2 = context2 + '</tbody>';
    $table.append(context2);
    var equip = equiment.equipmentinfo;
    var length2=equip.length;
    for (var k = 0; k < length2; k++) {
        var rest = k % length;
        var $tr = $("#rows_" + rest);
        if (k < length) {
            if (equip[k].State == "0") {
                var date=dataconverse(equip[k].Date);
                var text = '<td id="' + equip[k].ID +'_'+date+'" onclick="chooseItem(this)"><i></i></td>';
            } else {
                var date = dataconverse(equip[k].Date);
                var text = '<td style="backgroundColor:#C1C1C1" onclick="choosebadItem(this)" id="' + equip[k].ID + '_' + date + '">已预约<i class="fa fa-fw fa-ban td-sign"></i></td>';
            }
        } else {
            if (equip[k].State == "0") {
                var date = dataconverse(equip[k].Date);
                var text = '<td id="' + equip[k].ID + '_' + date + '" onclick="chooseotherItem(this)"><i></i></td>';
            } else {
                var date = dataconverse(equip[k].Date);
                var text = '<td style="backgroundColor:#C1C1C1" onclick="chooseotherItem(this)" id="' + equip[k].ID + '_' + date + '">已预约<i class="fa fa-fw fa-ban td-sign"></i></td>';
            }
        }
        $tr.append(text);
    }

}
function choosebadItem() {
    alert("此处不能预约");
   
}
function dataconverse(date) {
    var date = date.split(" ")[0];
    date = date.replace( /\//g,"-");
    return date;
}
function chooseotherItem() {
   alert("只能点击初始天的预约");
}
function clickrow(element)
{
    $this = $(element);
    $this.parent().siblings().removeClass("trchose");
    $this.parent().addClass("trchose");
    
}
function dateAdd(dd, n) {
    var strs = new Array();
    strs = dd.split("-");
    var y = strs[0];
    var m = strs[1];
    var d = strs[2];
    var t = new Date(y, m - 1, d);
    var str = t.getTime() + n * (1000 * 60 * 60 * 24);
    var newdate = new Date();
    newdate.setTime(str);
    var strYear = newdate.getFullYear();
    var strDay = newdate.getDate();
    if (strDay < 10) {
        strDay = "0" + strDay;
    }
    var strMonth = newdate.getMonth() + 1;
    if (strMonth < 10) {
        strMonth = "0" + strMonth;
    }
    var strdate = strMonth + "-" + strDay;
    return strdate;
}
function dateAdd2(dd, n) {
    var strs = new Array();
    strs = dd.split("-");
    var y = strs[0];
    var m = strs[1];
    var d = strs[2];
    var t = new Date(y, m - 1, d);
    var str = t.getTime() + n * (1000 * 60 * 60 * 24);
    var newdate = new Date();
    newdate.setTime(str);
    var strYear = newdate.getFullYear();
    var strDay = newdate.getDate();
    if (strDay < 10) {
        strDay = "0" + strDay;
    }
    var strMonth = newdate.getMonth() + 1;
    if (strMonth < 10) {
        strMonth = "0" + strMonth;
    }
    var strdate = strYear+"-"+strMonth + "-" + strDay;
    return strdate;
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

function chooseItem(thiselement) {
    var $element = $(thiselement);
    if (ChoseID() == null) {
        if (thiselement.lastChild.className) {
            thiselement.className = "";
            thiselement.lastChild.className = "";
            var k=interal-1;
            while(k<times-1)
            {
                $element.nextAll().eq(k).removeClass();
                $element.nextAll().eq(k).children(":last").removeClass();
                k++;
            }
        
        } else {
            var k = interal - 1;
            while (k < times-1) {
                if ($element.nextAll().eq(k).children(":last").hasClass("fa fa-fw fa-ban td-sign")) {
                    alert("不能在此外预约，请保证滚动预约没有障碍!");
                    return;
                }
              
                 k = k + interal;
            }
            k = interal - 1;
            thiselement.className = "chosen";
            thiselement.lastChild.className = "fa fa-fw fa-check td-sign";
            while (k < times-1) {
                var isweek=new Date($element.nextAll().eq(k).attr("ID").split("_")[1]).getDay();
                if (!(isweek == 0 || isweek == 6)) {
                    $element.nextAll().eq(k).addClass("chosen");
                    $element.nextAll().eq(k).children(":last").addClass("fa fa-fw fa-check td-sign");
                } else {
                    if (isweek == 0) {
                        k = k + 1;
                        continue;
                    }else
                    {
                        k = k + 2;
                        continue;
                    }
                }
                k=k + interal;
            }
        }
    } else {
        if (thiselement.lastChild.className) {
            thiselement.className = "";
            thiselement.lastChild.className = "";
            var k = interal - 1;
            while (k < times-1) {
                $element.nextAll().eq(k).removeClass();
                $element.nextAll().eq(k).children(":last").removeClass();
                k = k + interal;
            }
        } else {
            alert("请先取消其他选择！");
        }
    }

}
function ChoseID() {
    var td_id = null;
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
            var cell = table.rows[i].cells[1];
            if (cell.className != "") {
                td_id = cell.id;
            }
    }
   return td_id;
}
function ChoseAllID() {
    var td_id = "";
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className == "chosen") {
                td_id = td_id + "," + cell.id.split("_")[0];
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
    if (!compareWithToday(AppiontDate.value)) {
        alert("不能选择小于当天的日期");
        return;
    }
    var isweek = new Date(AppiontDate.value).getDay();
    if (isweek == 0 || isweek == 6) {
        alert("不能选择周六日作为起始天");
        return;
    }
    var date = AppiontDate.value;
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    var allfirstnumber = parseInt(getallfirst(treatmentID));
    var totalnumber = document.getElementById("totalnumber").value;
    var rest = parseInt(totalnumber) - allfirstnumber;
    var splitday = getsplitday(treatmentID);
    interal = parseInt(splitday);
    times = computetimes(date, rest, splitday);
    var xmlHttp = new XMLHttpRequest();
    var url = "GetEquipmentAppointmentForAccer.ashx?equipmentID=" + equipmentID + "&date=" + date + "&times=" + times;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    thisObj = eval("(" + json + ")");
    CreateCurrentEquipmentTbale(thisObj, date,times);
}
function computetimes(date, rest, splitday) {
    var k = 1;
    splitday = parseInt(splitday);
    var count = 1;
    date = dateAdd2(date, splitday);
    while (k < rest) {
        var isweek = new Date(date).getDay();
        if (!(isweek == 0 || isweek == 6)) {
            k = k + 1;
            count = count + splitday;
            date = dateAdd2(date, splitday);
        } else {
            if (isweek == 0) {
                count=count+1;
                date = dateAdd2(date, 1);
            } else 
            {
                count = count + 2;
                date =dateAdd2(date, 2);
            }
        }

    }
    return count;

}
function getsplitday(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getsplitday.ashx?treatid=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    return json;
}
function checkAllTable(treatmentID) {
    var choseid = ChoseAllID();
    $.ajax({
        type: "POST",
        url: "AccerateAppoint.ashx",
        async: false,
        data: {
            appoint: choseid,
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
                    $("#ask").css("display", "none");
                    document.getElementById("rest").disabled = "disabled";
                } else {
                    document.getElementById("rest").innerHTML = "剩余加速器预约(剩" + (parseInt(totalnumber) - allfirstnumber) + "次)";
                    $("#ask").css("display", "block");
                    document.getElementById("rest").removeAttribute("disabled");
                }
            }
            if (data == "busy") {
                window.alert("预约部分被占,需要重新预约");
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
function showPicture() {
    $("#myModal").modal("show");
    $("#pic").attr("src", this.src);
}