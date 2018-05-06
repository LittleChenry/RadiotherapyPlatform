/* ***********************************************************
 * FileName: LocationApply.js
 * Writer: xubixiao
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 模拟定位申请记录
 * **********************************************************/
window.addEventListener("load", Init, false);
var userName;
var userID;
var ti = 0;
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
    var patient = getLocationPatientInfo(treatmentID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    //document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    //document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    //document.getElementById("address").innerHTML = patient.Address;
    //document.getElementById("hospital").innerHTML = patient.Hospital;
    //document.getElementById("contact").innerHTML = patient.Contact1;
    //document.getElementById("contact2").innerHTML = patient.Contact2;
    //document.getElementById("treatID").value = patient.treatID;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    //document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    //document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
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
    var info = getLocationInfomation(treatmentID);
    $("#current-tab").text(patient.Treatmentdescribe + "模拟定位申请");
    var progress = patient.Progress.split(",");

    if (isInArray(progress, '3')) {
        ti = 1;
        createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2]);
        var date = new Date();
        document.getElementById("applyuser").innerHTML = userName;
        var fixtime = getfixtime(treatmentID);
        var fixtime = JSON.parse(fixtime).fixtime;
        var fixtimebiaozhun = "";
        if (fixtime.length != 0) {
           fixtimebiaozhun = fixtime[0].Date.split(" ")[0].replace(/\//g, "-");
        } else {
            alert("体位固定尚未预约");
            fixtimebiaozhun = new Date();
        }
        document.getElementById("AppiontDate").value = fixtimebiaozhun;
        document.getElementById("chooseappoint").addEventListener("click", function () {
            CreateNewAppiontTable(event);
        }, false);
        //document.getElementById("chooseProject").addEventListener("click", function () {
        //    CreateNewAppiontTable(event);
        //}, false);//根据条件创建预约表
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        document.getElementById("sure").addEventListener("click", checkAllTable, false);
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatname == patient.Treatmentname) {
                document.getElementById("scanmethod").value = info[i].scanmethodID;
                document.getElementById("scanpart").value = info[i].scanpartID;
                document.getElementById("up").value = info[i].UpperBound;
                document.getElementById("down").value = info[i].LowerBound;
                document.getElementById("special").value = info[i].locationrequireID;
                document.getElementById("remark").value = info[i].Remarks;
                var add = document.getElementsByName("add");
                if (info[i].Enhance == "1") {
                    add[0].checked = "true";
                    document.getElementById("addmethod").value = info[i].enhancemethod;
                } else {
                    add[1].checked = "true";
                    document.getElementById("enhancemethod").style.display = "none";
                }
                if (info[i].equipname != "") {
                    if (parseInt(toTime(info[i].End).split(":")[0]) >= 24) {
                        var hour = toTime(info[i].Begin).split(":")[0];
                        var minute = toTime(info[i].Begin).split(":")[1];
                        if (hour >= 24) {
                            var beginhour = parseInt(hour) - 24;
                        } else {
                            var beginhour = hour;
                        }
                        var begin = beginhour + ":" + minute;
                        var endhour = toTime(info[i].End).split(":")[0];
                        var endminute = toTime(info[i].End).split(":")[1];
                        var hourend = parseInt(endhour) - 24;
                        var end = hourend + ":" + endminute;
                        document.getElementById("appointtime").value = info[i].equipname + " " + info[i].Date + " " + begin + "-" + end + "(次日)";
                    } else {
                        document.getElementById("appointtime").value = info[i].equipname + " " + info[i].Date + " " + toTime(info[i].Begin) + "-" + toTime(info[i].End);
                    }
                }
                document.getElementById("applyuser").innerHTML = info[i].username;
                document.getElementById("time").innerHTML = info[i].ApplicationTime;
                var session = getSession();
                var role = session.role;
                if (info[i].userID == userID || role == "科主任") {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
                    if (info[i].equipname != "") {
                        document.getElementById("idforappoint").value = info[i].appointid;
                    } else {
                        document.getElementById("chooseappoint").removeAttribute("disabled");
                    }
                }
            } else {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + '模拟定位申请</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">扫描部位：<span class="underline">' + info[i].scanpartID + '</span></div>'
                    + '<div class="item col-xs-6">扫描方式：<span class="underline">' + info[i].scanmethod + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">上界:<span class="underline">' + info[i].UpperBound + '</span></div>'
                    + '<div class="item col-xs-6">下界：<span class="underline">' + info[i].LowerBound + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">是否增强:<span class="underline">' + trans(info[i].Enhance) + '</span></div>'
                    + '<div class="item col-xs-6">增强方式：<span class="underline">' + transmethod(info[i].methodname) + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">特殊要求:<span class="underline">' + info[i].locationrequire + '</span></div></div>';
                if (info[i].equipname != "") {
                    if (parseInt(toTime(info[i].End).split(":")[0]) >= 24) {
                        var hour = toTime(info[i].Begin).split(":")[0];
                        var minute = toTime(info[i].Begin).split(":")[1];
                        if (hour >= 24) {
                            var beginhour = parseInt(hour) - 24;
                        } else {
                            var beginhour = hour;
                        }
                        var begin = beginhour + ":" + minute;
                        var endhour = toTime(info[i].End).split(":")[0];
                        var endminute = toTime(info[i].End).split(":")[1];
                        var hourend = parseInt(endhour) - 24;
                        var end = hourend + ":" + endminute;
                        content = content + '<div class="single-row"><div class="item col-xs-12">设备与时间：<span class="underline">' + info[i].equipname + '' + info[i].Date + ' ' + begin + '-' + end + '(次日)</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div></div>';
                    } else {
                        content = content + '<div class="single-row"><div class="item col-xs-12">设备与时间：<span class="underline">' + info[i].equipname + '' + info[i].Date + ' ' + toTime(info[i].Begin) + '-' + toTime(info[i].End) + '</span></div></div>'
                         + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div></div>';
                    }
                } else {
                    content = content + '<div class="single-row"><div class="item col-xs-12">设备与时间：<span class="underline">无</span></div></div>'
                         + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div></div>';
                }
                $("#tabs").append(tab);
                $("#tab-content").append(content);
            }
        }
    } else {
        createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2]);
        var date = new Date();
        document.getElementById("applyuser").innerHTML = userName;
        var fixtime = getfixtime(treatmentID);
        var fixtime = JSON.parse(fixtime).fixtime;
        var fixtimebiaozhun = "";
        if (fixtime.length != 0) {
            fixtimebiaozhun = fixtime[0].Date.split(" ")[0].replace(/\//g, "-");
        } else {
            alert("体位固定尚未预约");
            fixtimebiaozhun = new Date();
        }
        document.getElementById("AppiontDate").value = fixtimebiaozhun;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("chooseappoint").addEventListener("click", function () {
            CreateNewAppiontTable(event);
        }, false);
        //document.getElementById("chooseProject").addEventListener("click", function () {
        //    CreateNewAppiontTable(event);
        //}, false);//根据条件创建预约表
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        document.getElementById("sure").addEventListener("click", checkAllTable, false);
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatname != patient.Treatmentname) {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + info[i].Treatmentdescribe + '模拟定位申请</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">扫描部位：<span class="underline">' + info[i].scanpartID + '</span></div>'
                    + '<div class="item col-xs-6">扫描方式：<span class="underline">' + info[i].scanmethod + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">上界:<span class="underline">' + info[i].UpperBound + '</span></div>'
                    + '<div class="item col-xs-6">下界：<span class="underline">' + info[i].LowerBound + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">是否增强:<span class="underline">' + trans(info[i].Enhance) + '</span></div>'
                    + '<div class="item col-xs-6">增强方式：<span class="underline">' + transmethod(info[i].methodname) + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">特殊要求:<span class="underline">' + info[i].locationrequire + '</span></div></div>';
                if (info[i].equipname != "") {
                    if (parseInt(toTime(info[i].End).split(":")[0]) >= 24) {
                        var hour = toTime(info[i].Begin).split(":")[0];
                        var minute = toTime(info[i].Begin).split(":")[1];
                        if (hour >= 24) {
                            var beginhour = parseInt(hour) - 24;
                        } else {
                            var beginhour = hour;
                        }
                        var begin = beginhour + ":" + minute;
                        var endhour = toTime(info[i].End).split(":")[0];
                        var endminute = toTime(info[i].End).split(":")[1];
                        var hourend = parseInt(endhour) - 24;
                        var end = hourend + ":" + endminute;
                        content = content + '<div class="single-row"><div class="item col-xs-12">设备与时间：<span class="underline">' + info[i].equipname + '' + info[i].Date + ' ' + begin + '-' + end + '(次日)</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button"  id="' + i + '">载入历史信息</button></div></div></div>';
                    } else {
                        content = content + '<div class="single-row"><div class="item col-xs-12">设备与时间：<span class="underline">' + info[i].equipname + '' + info[i].Date + ' ' + toTime(info[i].Begin) + '-' + toTime(info[i].End) + '</span></div></div>'
                         + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button"  id="' + i + '">载入历史信息</button></div></div></div>';
                    }
                } else {

                    content = content + '<div class="single-row"><div class="item col-xs-12">设备与时间：<span class="underline">无</span></div></div>'
                        + '<div class="single-row"><div class="item col-xs-8">备注：<span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button"  id="' + i + '">载入历史信息</button></div></div></div>';
                }
                $("#tabs").append(tab);
                $("#tab-content").append(content);
               
            }
        }

    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            if (k != "chooseappoint") {
                document.getElementById("scanmethod").value = info[k].scanmethodID;
                document.getElementById("scanpart").value = info[k].scanpartID;
                document.getElementById("up").value = info[k].UpperBound;
                document.getElementById("down").value = info[k].LowerBound;
                document.getElementById("special").value = info[k].locationrequireID;
                document.getElementById("remark").value = info[k].Remarks;
                var add = document.getElementsByName("add");
                if (info[k].Enhance == "1") {
                    add[0].checked = true;
                    document.getElementById("enhancemethod").style.display = "block";
                    document.getElementById("addmethod").value = info[k].enhancemethod;
                } else {
                    add[1].checked = true;
                    document.getElementById("enhancemethod").style.display = "none";
                }
            }
        });
    });
    var $radio1 = $('input[name="add"]:eq(0)');
    var $radio2 = $('input[name="add"]:eq(1)');
    $radio2.bind('click', function () {
        document.getElementById("enhancemethod").style.display = "none";
    });
    $radio1.bind('click', function () {
        document.getElementById("enhancemethod").style.display = "block";
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
function trans(s)
{
    if(s=="1")
    {
        return "是";
    }else
    {
        return "否";
    }
}
function transmethod(s)
{
    if(s=="")
    {
        return "无";
    }else
    {
        return s;
    }
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
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.info;
}
//选择模板
function chooseTempalte(templateID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetTemplateLocationApply.ashx?templateID=" + templateID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    document.getElementById("scanmethod").value = obj1.templateInfo[0].scanmethodID;
    document.getElementById("scanpart").value = obj1.templateInfo[0].scanpartID;
    document.getElementById("up").value = obj1.templateInfo[0].UpperBound;
    document.getElementById("down").value = obj1.templateInfo[0].LowerBound;
    document.getElementById("special").value = obj1.templateInfo[0].locationrequireID;
    document.getElementById("remark").value = obj1.templateInfo[0].Remarks;
    var add = document.getElementsByName("add");
    if (obj1.templateInfo[0].Enhance == "1") {
        add[0].checked = true;
        document.getElementById("enhancemethod").style.display = "block";
        document.getElementById("addmethod").value = obj1.templateInfo[0].enhancemethod;
    } else {
        add[1].checked = true;
        document.getElementById("enhancemethod").style.display = "none";
    }
}
//保存提交
function save() {
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
    var scanpart = document.getElementById("scanpart").value;
    var scanmethod = document.getElementById("scanmethod").value;
    var special = document.getElementById("special").value;
    var addgroup = document.getElementsByName("add");
    var add;
    if (addgroup[0].checked == true) {
        add = addgroup[0].value;
        if (!confirm("确定需要增强？")) {
            return false;
        }
       
    } else {
        add = addgroup[1].value;
    }
    var up = document.getElementById("up").value;
    var down = document.getElementById("down").value;
    var addmethod = document.getElementById("addmethod").value;
    var appointid = document.getElementById("idforappoint").value;
    var remark = document.getElementById("remark").value;
    if (document.getElementById("scanpart").value == " ") {
        window.alert("请选择扫描部位");
        return false;
    }
    if (document.getElementById("scanmethod").value == "allItem") {
        window.alert("请选择扫描方式");
        return false;
    }
    if (document.getElementById("up").value == "") {
        window.alert("请填写上界");
        return false;
    }
    if (document.getElementById("down").value == "") {
        window.alert("请填写下界");
        return false;
    }
    if (add== "1") {
        if (document.getElementById("addmethod").value == "allItem") {
            window.alert("请选择增强方式");
            return false;
        }
    }
    if (special == "allItem") {
        window.alert("请选择特殊要求");
        return false;
    }
    if (document.getElementById("idforappoint").value == "0") {
        window.alert("请预约时间与设备");
        return false;
    }
    $.ajax({
        type: "POST",
        url: "LocationApplyRecord.ashx",
        async: false,
        data: {
            id: appointid,
            treatid: treatmentid,
            scanpart: scanpart,
            scanmethod: scanmethod,
            user: userID,
            addmethod: addmethod,
            up: up,
            down: down,
            remark: remark,
            requirement: special,
            add:add
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
        error: function () {
            alert("error");
        }
    });

   
}
//保存模板
function saveTemplate(TemplateName) {  
    var scanpart = document.getElementById("scanpart").value;
    var scanmethod = document.getElementById("scanmethod").value;
    var special = document.getElementById("special").value;
    var addgroup = document.getElementsByName("add");
    var add;
    if (addgroup[0].checked == true) {
        add = addgroup[0].value;
    } else {
        add = addgroup[1].value;
    }
    var up = document.getElementById("up").value;
    var down = document.getElementById("down").value;
    var addmethod = document.getElementById("addmethod").value;   
    var remark = document.getElementById("remark").value;
    if (document.getElementById("scanpart").value == "") {
        window.alert("请选择扫描部位");
        return false;
    }
    if (document.getElementById("scanmethod").value == "allItem") {
        window.alert("请选择扫描方式");
        return false;
    }
    if (document.getElementById("up").value == "") {
        window.alert("请填写上界");
        return false;
    }
    if (document.getElementById("down").value == "") {
        window.alert("请填写下界");
        return false;
    }
    if (add == "1") {
        if (document.getElementById("addmethod").value == "allItem") {
            window.alert("请选择增强方式");
            return false;
        }
    }
    if (special == "allItem") {
        window.alert("请选择特殊要求");
        return false;
    }   
    var xmlHttp = new XMLHttpRequest();
    var url = "LocationApplytemplate.ashx?templatename=" + TemplateName + "&scanpart=" + scanpart + "&scanmethod=" + scanmethod + "&user=" + userID + "&add=" + add + "&addmethod=" + addmethod + "&up=" + up + "&down=" + down + "&remark=" + remark + "&requirement=" + special;
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
    var table1 = document.getElementById("apptiontTableForPm");
    RemoveAllChild(table);
    RemoveAllChild(table1);
    if (equiment.length != 0) {
        var amlength = 0
        for (var i = 0; i < equiment.length; i++) {
            if (equiment[i].Begin > 720) {
                amlength = i;
                break;
            }
        }
        var pmlength = equiment.length - amlength;
        if (amlength != 0) {
            $("#amlabel").show();
        } else {
            $("#amlabel").hide();
        }
        $("#pmlabel").show();
    var tbody = document.createElement("tbody");
    for (var i = 0; i < Math.ceil(amlength / 5) * 5 ; i++) {
        var count = i % 5;
        var tr;
        if (count == 0) {
            tr = document.createElement("tr");
        }
        if (i <= amlength - 1) {
            var td = document.createElement("td");
            var sign = document.createElement("i");
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
                if (getFixApplyTime(equiment[i], dateString)) {
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
        if (i == amlength) {
            var k;
            for (k = amlength; k <= Math.ceil(amlength / 5) * 5 - 1; k++) {
                var td = document.createElement("td");
                tr.appendChild(td);
            }
        }
        if (count == 4) {
            tbody.appendChild(tr);
        }
    }
    table.appendChild(tbody);
    var tbody2 = document.createElement("tbody");
    for (var m = 0; m < Math.ceil(pmlength / 5) * 5 ; m++) {
        var count = m % 5;
        var i = m + amlength;
        var tr;
        if (count == 0) {
            tr = document.createElement("tr");
        }
        if (m <= pmlength - 1) {
            var td = document.createElement("td");
            var sign = document.createElement("i");
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
                if (getFixApplyTime(equiment[i], dateString)) {
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
        if (m == pmlength) {
            var k;
            for (k = pmlength; k <= Math.ceil(pmlength / 5) * 5 - 1; k++) {
                var td = document.createElement("td");
                tr.appendChild(td);
            }
        }
        if (count == 4) {
            tbody2.appendChild(tr);
        }
    }
    table1.appendChild(tbody2);
    } else {
        $("#amlabel").hide();
        $("#pmlabel").hide();
        table.innerHTML = "今天已经不可以预约了,改天吧！";

    }
}

function getFixApplyTime(equiment, dateString){
    var treatid = window.location.search.split("=")[1];
    var fixtime = getfixtime(treatid);
    var fixtime = JSON.parse(fixtime).fixtime;
    if (fixtime.length != 0) {
        var begintime = toTime(fixtime[0].Begin);
        var endtime = toTime(fixtime[0].End);
        var fixtimebiaozhun = fixtime[0].Date.split(" ")[0] + " " + begintime + "-" + endtime;
        var datedate = dateString.split("-");
        var groupstring = "-" + datedate[1] + "-" + datedate[2] + "-" + equiment.Begin + "-" + equiment.End;
        var group = groupstring.split("-");
        return compare(fixtimebiaozhun, group);
    } else {
         return true;
    }
  
}

function chooseItem() {
    var ID = ChoseID();
    if (ID == null) {
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
            document.getElementById("" + ID).className = "";
            document.getElementById("" + ID).lastChild.className = "";
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    }

}

function ChoseID() {
    var td_id = null;
    var table = document.getElementById("apptiontTable");
    var table1 = document.getElementById("apptiontTableForPm");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    for (var i = 0; i < table1.rows.length; i++) {
        for (var j = 0; j < table1.rows[i].cells.length; j++) {
            var cell = table1.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    return td_id;
}


function hasChosen(){
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
function getLocationPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
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
    document.getElementById("appointtime").value = appoint[3] + " " + appoint[1].split(" ")[0] + " " + appoint[2];
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
    var PartItem = JSON.parse(getscanpartItem()).Item;
    var defaultItem = JSON.parse(getscanpartItem()).defaultItem;
    if (defaultItem == "") {
        $(thiselement).attr("value", "");
    } else {
        $(thiselement).attr("value", defaultItem.Name);
    }
    $(thiselement).bind("click", function () {
        event.stopPropagation();
        autoList(this, PartItem);
    });
}
function autoList(e, data) {
    if ($(e).next().length == 0) {
        var position = $(e).offset();
        var parentelement = $(e).parent();
        var pickerTop = position.top + 30;
        var pickerLeft = position.left;
        var pickerWidth = $(e).width() + 12;
        $(document).click(function () {
            $(e).next().fadeOut(200);
        });
        var selectArea = "<div class='pickerarea'><ul class='auto_ul'>";
        for (var i = 0; i < data.length; i++) {
            li = "<li id='" + data[i].ID + "' class='auto_list'>" + data[i].Name + "</li>";
            selectArea += li;
        }
        selectArea += "</ul></div>";
        $(parentelement).append(selectArea);
        $(e).next().css({ minWidth: pickerWidth });
        $(e).next().offset({ top: pickerTop, left: pickerLeft });
        $(e).next().find("ul").find("li").each(function () {
            $(this).mouseover(function () {
                $(this).css("color", "#FFFFFF");
                $(this).css("background", "#3C8DBC");
            });
            $(this).mouseout(function () {
                $(this).css("color", "#333333");
                $(this).css("background", "#FFFFFF");
            });
            $(this).bind("click", function () {
                event.stopPropagation();
                if ($(this).find("i").length == 0) {
                    var ispan = "<i class='pull-right fa fa-fw fa-check'></i>"
                    $(this).append(ispan);
                } else {
                    $(this).find("i")[0].remove();
                }
                $(this).parent().parent().prev().val("");
                $(this).parent().find("li").each(function (index, element) {
                    if ($(this).find("i").length != 0) {
                        var text = $(this).parent().parent().prev().val() + $(this).text().split("<")[0] + "，";
                        $(this).parent().parent().prev().val(text);
                    }
                });
                if ($(this).parent().parent().prev().val()) {
                    var temp = $(this).parent().parent().prev().val();
                    $(this).parent().parent().prev().val(temp.substring(0, temp.length - 1));
                }
            });
        });
    }
    $(e).next().fadeIn(200);
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
    var PartItem = JSON.parse(getscanmethodItem()).Item;
    var defaultItem = JSON.parse(getscanmethodItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Method);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
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
    var PartItem = JSON.parse(getspecialItem()).Item;
    var defaultItem = JSON.parse(getspecialItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Requirements);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
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
    var PartItem = JSON.parse(getaddmethodItem()).Item;
    var defaultItem = JSON.parse(getaddmethodItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Method);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
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
        if ((parseInt(evt2[3]) - Min) >= 10) {
            return true;
        }
        else {
            return false;
        }

    }
    return true;

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
    var strdate = strYear + "-" + strMonth + "-" + strDay;
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
    document.getElementById("scanmethod").removeAttribute("disabled");
    document.getElementById("scanpart").removeAttribute("disabled");
    document.getElementById("up").removeAttribute("disabled");
    document.getElementById("down").removeAttribute("disabled");
    document.getElementById("special").removeAttribute("disabled");
    document.getElementById("remark").removeAttribute("disabled");
    document.getElementById("yes").removeAttribute("disabled");
    document.getElementById("No").removeAttribute("disabled");
    document.getElementById("addmethod").removeAttribute("disabled");
    if (ti == 0) {
        document.getElementById("appointtime").removeAttribute("disabled");
        document.getElementById("chooseappoint").removeAttribute("disabled");
    }
}
//获取session
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}