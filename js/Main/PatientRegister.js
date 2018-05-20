/* ***********************************************************
 * FileName: PatientRegister.js
 * Writer: xubixiao
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 病人信息登记js
 * **********************************************************/
var isAllGood;//所有检查是否通过
var docandgroup;
window.addEventListener("load", Init, false);
//初始化 
var userID;
var Radiotherapy_ID;
var equipmentfrominfo = "";
var patientInfo = "";

function Init(evt) {
    var treatID = window.location.search.split("&")[0].split("=")[1];
    Radiotherapy_ID = window.location.search.split("&")[1].split("=")[1];
    getdoctorandgroup();
    var select4 = document.getElementById("doctor");
    createdoctorItem(select4);
    select4.addEventListener("change", function () {
        createselect2(select4.selectedIndex);
    }, false);
    //document.getElementById("chooseProject").addEventListener("click", function () {
    //    CreateNewAppiontTable(event);
    //}, false);//根据条件创建预约表
    getPatientInfo(treatID);
    document.getElementById("treatID").value = treatID;
    document.forms[0].addEventListener("reset", resetForm, false);//添加表单rest事件函数
    var viewAppointsBody = $("#viewAppoints").find("tbody");
    var appoints = getAppointments(treatID);
    var session = getSession();
    if ((typeof (session) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var flag=1;
    for (var i = 0; i < appoints.appoint.length; i++) {
        var appointDate = new Date(appoints.appoint[i].Date);
        var completed = (appoints.appoint[i].Completed == "1") ? "已完成" : "未完成";
        if (parseInt(toTime(appoints.appoint[i].End).split(":")[0]) >= 24) {
            var hour = toTime(appoints.appoint[i].Begin).split(":")[0];
            var minute = toTime(appoints.appoint[i].Begin).split(":")[1];
            if (hour >= 24) {
                var beginhour = parseInt(hour) - 24;
            } else {
                var beginhour = hour;
            }
            var begin = beginhour + ":" + minute;
            var endhour = toTime(appoints.appoint[i].End).split(":")[0];
            var endminute = toTime(appoints.appoint[i].End).split(":")[1];
            var hourend = parseInt(endhour) - 24;
            var end = hourend + ":" + endminute;
            var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '"><td>' + appoints.appoint[i].Task + '</td>'
             + '<td>' + appointDate.Format("yyyy-MM-dd") + ' , ' + begin + ' - ' + end + '(次日)</td>'
             + '<td>' + completed + '</td>';
        } else {
            var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '"><td>' + appoints.appoint[i].Task + '</td>'
            + '<td>' + appointDate.Format("yyyy-MM-dd") + ' , ' + toTime(appoints.appoint[i].Begin) + ' - ' + toTime(appoints.appoint[i].End) + '</td>'
            + '<td>' + completed + '</td>';
        }
       
        if (appoints.appoint[i].Task != "加速器" && session.roleName == "YS") {
            if (appoints.appoint[i].Completed == "1") {
                tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
            } else {
                tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
            }
        } else {
            if (appoints.appoint[i].Task == "加速器" && session.roleName == "ZLJS" && flag == 0) {
                if (appoints.appoint[i].Completed == "1") {
                    tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
                } else {
                    tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
                }
            } else {
                if (appoints.appoint[i].Task == "加速器" && session.roleName == "YS" && flag == 1) {
                    if (appoints.appoint[i].Completed == "1") {
                        tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
                    } else {
                        tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
                    }
                    flag = 0;
                } else {
                    tr = tr + '<td><button disabled="disabled"  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
                }
            }
        }
        if (appoints.appoint[i].Task == "加速器") {
            flag = 0;
        }
        viewAppointsBody.append(tr);
    }
    var tr2 = '<tr><td>加速器</td><td></td><td></td><td><button class="btn btn-success" type="button" data-toggle="modal" data-target="#checkappointmodal" onclick="chakan('+treatID+')">查看</button></td></tr>';
    viewAppointsBody.append(tr2);
    $("#saveTreatment").unbind("click").bind("click", function () {
        saveTreatment();
    });
    checkAddTreatment(Radiotherapy_ID);
    $("#radionumber").bind("input propertychange", function () {
        var isradio1 = isradio();
 
        if (isradio1 == 0) {
            $(this).css("background", "yellow");
        } else {

            if (isradio1 == 1) {
                $(this).css("background", "white");
            } else {
                $(this).css("background", "red");
            }
        }
        if ($(this).prop("value") == "") {
            $(this).css("background", "white");
        }
    });
    $("#timeselect").bind("change", function () {
    var dateString = document.getElementById("AppiontDate").value;
    CreateCurrentAccerEquipmentTbale(dateString);
    });
    //查看照片
    $("#self-photo").unbind("click").click(function (e) {
        $("#mypic").click();
    });
    //导入个人照片
    $("#importPhoto").bind("click",function(){
        $("#cutphoto").modal({ backdrop: 'static' });
    });
}

function isradio() {
    var radio = document.getElementById("radionumber").value;
    var reg = /^(\d{8})$/;
    if (!reg.test(radio)) {
        return 0;
    } else {
        var returndata;
        if (Radiotherapy_ID == radio) {
            return 1;
        }
        $.ajax({
            url: "../recheck.ashx",
            type: "post",
            data: {
                radionumber: document.getElementById("radionumber").value,
            },
            dateType: "json",
            async: false,
            success: function (data) {
                returndata = data;
            },
            error: function (e) {

            }
        });
        if (returndata == "success") {
            return 1;
        } else {
            return 2;
        }
    }
}
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}
//获取预约
function getAppointments(treatmentID) {
    var appoints;
    $.ajax({
        type: "GET",
        url: "getappointinfo.ashx?treatID=" + treatmentID,
        async: false,
        dateType: "text",
        success: function (data) {
           //alert(data);
            appoints = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return appoints;
}
//修改预约
function changeAppoint(e) {
     var treatID = window.location.search.split("&")[0].split("=")[1];
    var $e = $(e);
    var item = $e.parent().parent().children().first().text();
    var oldappoint = $e.parent().parent().attr("ID").split("_")[1];
    if (item == "体位固定") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Fixed");
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
    }
    if (item == "模拟定位" || item == "CT复查") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Location")
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
    }
    if (item == "加速器") {
        createaccerEquipmachine(document.getElementById("equipmentName"), treatID)
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAccerAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAccerAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAccerAppiontTable(event);
        });
    }
    if (item == "复位模拟") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Replacement")
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        $("#AppiontDate").unbind("change").change(function () {
            if ($("#AppiontDate").val() == "") {
                var date = new Date();
                $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
            }
            CreateNewAppiontTable(event);
        });
        $("#previousday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, -1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
        $("#nextday").unbind("click").click(function () {
            var date = $("#AppiontDate").val();
            var newdate = dateAdd2(date, 1);
            $("#AppiontDate").val(newdate);
            CreateNewAppiontTable(event);
        });
    }
    //var date = new Date();
    //var date = date.Format('yyyy-MM-dd');
    //document.getElementById("AppiontDate").value = date;
    if (item != "加速器") {
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        CreateNewAppiontTable(e);
    } else {
        var datetext = $e.parent().parent().children().eq(1).text();
        var date = datetext.split(",")[0];
        $("#AppiontDate").val(date);
        CreateNewAccerAppiontTable(e);
    }
    $("#sure").unbind("click").bind("click", function () {
        var choseid = ChoseID();
        var appoint = choseid.split("_");
        var newappoint = appoint[0];
        
        if (choseid != null) {
            if (item == "体位固定") {
                $.ajax({
                    type: "POST",
                    url: "changeFixAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newappoint: newappoint
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(appoint[1] + "," + appoint[2]);
                            $e.parent().parent().attr("ID", "apoint" + "_" + newappoint)
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
            if (item == "模拟定位") {
                $.ajax({
                    type: "POST",
                    url: "changeLocateAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newappoint: newappoint
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(appoint[1] + "," + appoint[2]);
                            $e.parent().parent().attr("ID", "apoint" + "_" + newappoint)
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
            if (item == "复位模拟") {
                $.ajax({
                    type: "POST",
                    url: "changeReplaceAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newappoint: newappoint
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(appoint[1] + "," + appoint[2]);
                            $e.parent().parent().attr("ID", "apoint" + "_" + newappoint)
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
            if (item == "加速器") {
                var choseid = ChoseID();
                var appoint = choseid.split("_");
                var newdate = appoint[0].split(" ")[0];
                var newbegin = appoint[2];
                var newend = appoint[3];
                $.ajax({
                    type: "POST",
                    url: "changeAccerateAppoint.ashx",
                    async: false,
                    data: {
                        oldappoint: oldappoint,
                        newdate: newdate,
                        newbegin: newbegin,
                        newend: newend,
                    },
                    dateType: "json",
                    success: function (data) {
                        if (data == "success") {
                            window.alert("修改成功");
                            $e.parent().parent().children().first().next().text(newdate + "," + appoint[1]);
                        }
                        if (data == "busy") {
                            window.alert("预约时间被占,需要重新预约");
                            return false;
                        }
                        if (data == "failure") {
                            window.alert("修改失败");
                            return false;
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            }
        }
    });
    $("#changeAppoint").modal({ backdrop: 'static' });
}
Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}
//获取设备
function geteuqipmenttype(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "geteuqipmenttype.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;

}
function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
}

//获取病人信息
function getPatientInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var getString = xmlHttp.responseText;
            patientInfo = eval("(" + getString + ")");
        }
    }
    
    xmlHttp.send();
    writePatientInfo(patientInfo);
}

//填写病人信息
function writePatientInfo(PatientInfo) {
    document.getElementById("userName").value = PatientInfo.patientInfo[0].Name;
    $('input[name="RecordNumber"]:eq(1)').bind("click", function () {
        $("#ishospital").css("display", "none");
    });
    $('input[name="RecordNumber"]:eq(0)').bind("click", function () {
        $("#ishospital").css("display", "block");
      
    });
    if (PatientInfo.patientInfo[0].Ishospital == "0") {
        $('input[name="RecordNumber"]:eq(1)').attr("checked", true);
        $("#ishospital").css("display", "none");
    } else {
        $('input[name="RecordNumber"]:eq(0)').attr("checked", true);
        $("#hospitalnumber").attr("value", PatientInfo.patientInfo[0].Hospital_ID);
    }
    document.getElementById(sex(PatientInfo.patientInfo[0].Gender)).checked = true;
    document.getElementById("IDcardNumber").value =  PatientInfo.patientInfo[0].IDcardNumber;
    document.getElementById("Address").value =  PatientInfo.patientInfo[0].Address;   
    document.getElementById("Number1").value =  PatientInfo.patientInfo[0].Contact1;
    document.getElementById("Number2").value =  PatientInfo.patientInfo[0].Contact2;
    document.getElementById("patientID").value =  PatientInfo.patientInfo[0].ID;
    document.getElementById("doctor").value = PatientInfo.patientInfo[0].doctor;
    document.getElementById("usernamepingyin").value = PatientInfo.patientInfo[0].usernamepingyin;
    var select4 = document.getElementById("doctor");
    createselect2(select4.selectedIndex);
    if (PatientInfo.patientInfo[0].group == "") {
        document.getElementById("group").value = "allItem";
    } else {
        document.getElementById("group").value =PatientInfo.patientInfo[0].group;
    }
    document.getElementById("radionumber").value = PatientInfo.patientInfo[0].Radiotherapy_ID;
    document.getElementById("picture1").value = PatientInfo.patientInfo[0].Picture;   
    document.getElementById("Sub").value = PatientInfo.patientInfo[0].Sub;;
    document.getElementById("Hospital").value =  PatientInfo.patientInfo[0].Hospital;
    document.getElementById("Nation").value =  PatientInfo.patientInfo[0].Nation;
    document.getElementById("Birthday").value =  PatientInfo.patientInfo[0].Birthday;
    document.getElementById("Birthday").placeholder = PatientInfo.patientInfo[0].Birthday;
    document.getElementById("height").value =  PatientInfo.patientInfo[0].Height;
    document.getElementById("weight").value = PatientInfo.patientInfo[0].Weight;
    if (PatientInfo.patientInfo[0].Picture != "") {
        //document.getElementById("photo").style.display = "inline";
        document.getElementById("self-photo").src = PatientInfo.patientInfo[0].Picture;
        document.getElementById("pic").value = PatientInfo.patientInfo[0].Picture;
    }
    document.getElementById("operator").innerHTML = PatientInfo.patientInfo[0].Registeruser;
    document.getElementById("date").innerHTML = PatientInfo.patientInfo[0].date;
    document.getElementById("date").disabled = "true";
    document.getElementById("currentTreatment").innerHTML = PatientInfo.patientInfo[0].Treatmentdescribe;
    document.getElementById("treatmentState").innerHTML = StateNumToString(PatientInfo.patientInfo[0].State);
    showTreatmentManageButton(PatientInfo.patientInfo[0].State);
}
function sex(evt) {
    if (evt == "F")
        return "female";
    else
        return "male";
}
//第二步诊断单中的分中心负责人选择项建立
function createdoctorItem(thiselement) {
    var doctorItem = docandgroup;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----医生选择-----");
    thiselement.options[0].value = "allItem";
    var i = 0;
    for (var jsondata in doctorItem) {
        thiselement.options[i + 1] = new Option(doctorItem[jsondata][0].username);
        thiselement.options[i + 1].value = parseInt(doctorItem[jsondata][0].userid);
        i++;
    }
}
//选择分组下拉菜单
function createselect2(index) {
    var thiselement = document.getElementById("group");
    var groups = docandgroup;
    var groupitem = "";
    var k = 0;
    for (var jsondata in groups) {
        if (k == index - 1) {
            groupitem = groups[jsondata];
        }
        k++;
    }
    if (groupitem == "") {
        thiselement.options.length = 0;
        thiselement.options[0] = new Option("----分组选择-----");
        thiselement.options[0].value = "allItem";
    } else {
        for (var i = 0; i < groupitem.length - 1; i++) {
            thiselement.options[i] = new Option(groupitem[i+1].groupname);
            thiselement.options[i].value = parseInt(groupitem[i+1].groupid);
        }
    }

}
//获取医师与其组名称
function getdoctorandgroup() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getdoctorandgroup.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    docandgroup = JSON.parse(Items).Item;
}

//表单reset函数
function resetForm(evt) {
    //所有提示清空
    document.getElementById("error").innerHTML = "";

    var allInput = document.getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("invalid") > -1) {
            resetInput(allInput[i]);//恢复Input样式
        }
    }
}
//第二步部位下拉项建立

//检查各个输入项内容
function CheckInput(evt) {
    isAllGood = true;//初始默认全为通过
    //各个提示项每次初始清空
    document.getElementById("error").innerHTML = "";
    //所有元素节点数组
    var allElements = document.forms[0].getElementsByTagName("*");
    for (var i = 0; i < allElements.length; i++) {
        if (!CheckEmpty(allElements[i])) {
            isAllGood = false;
        }
    }
    if (!isAllGood) {
        evt.preventDefault();//阻止事件进行
    }
}
//检查是否为空
function save() {   
    var $radio1 = $('input[name="RecordNumber"]:eq(0)');
    if ($radio1.prop("checked") && document.getElementById("hospitalnumber").value == "") {
        window.alert("住院号不能为空");
        return;
    }
    if (document.getElementById("radionumber").value == "") {
        window.alert("放疗号不能为空");
        return;
    }
    if (isradio() != 1) {
        window.alert("放疗号设置不合格");
        return;
    }
    if (document.getElementById("userName").value=="") {
        window.alert("姓名不能为空");
        return false; 
    }
    if (document.getElementById("usernamepingyin").value == "") {
        window.alert("姓名拼音不能为空");
        return false;
    }
    if (document.getElementById("IDcardNumber").value=="") {
        window.alert("身份证不能为空");
        return false;            
    }
 
    if (document.getElementById("userName").value=="") {
        window.alert("姓名不能为空");
        return false;   
    }
      
    if (document.getElementById("Birthday").value=="") {
        window.alert("出生日期不能为空");
        return false;   
               
    }
    if (document.getElementById("Nation").value=="") {
        window.alert("民族不能为空");
        return false;                  
    }
    if (document.getElementById("Address").value=="") {
        window.alert("地址不能为空");
        return false;                
    }
    if (document.getElementById("Number1").value=="") {
        window.alert("电话1不能为空");
        return false;                  
    } 
    if (isCardNo()) {
        window.alert("身份证格式不正确");
        return false;
    }      


    if (document.getElementById("doctor").value == "allItem") {
        window.alert("请选择医生");        
        return false;   
    }
    var form = new FormData(document.getElementById("frmRegist"));
    $.ajax({
        url: "patientRegister.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        async: false,
        success: function (data) {
            alert("更新成功");
            window.location.reload();
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        }
 
    });
}
    
//根据classname做对应的各项检查

function AlertLabel(thisNode) {
    if (thisNode.nodeName == "LABEL")
        thisNode.className += "invalid ";
}
//电话号码验证
function checkPhone() {
    var strPhoneNumber = document.getElementById("Number1").value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (!rep.test(strPhoneNumber)) {
        return true;
    }
    return false;
}
function checkPhone2() {
    var strPhoneNumber = document.getElementById("Number2").value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (!rep.test(strPhoneNumber)) {
        return true;
    }
    return false;
}
//电话号码格式规范
function phoneFormat() {
    var thisPhone = this.value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (rep.test(thisPhone)) {
        rep.exec(thisPhone);
        this.value = RegExp.$1 + "-" + RegExp.$2 + "-" + RegExp.$3;
    }
}
function isCardNo() {
    // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X  
    var card = document.getElementById("IDcardNumber").value;
    var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
    if (!reg.test(card)) {
        return true;
    }
    return false;
} 
//reset时Input样式恢复
function resetInput(thisElement) {
    var allClassName = thisElement.className.split(" ");
    var resetClassName = "";
    for (var i = 0; i < allClassName.length; i++) {
        if (allClassName[i] != "invalid") {
            resetClassName += allClassName[i] + " ";
        }
    }
    thisElement.className = resetClassName;
}
//恢复样式（取消invalid）
function recoverClassName(thisElement) {
    var returnClassName = "";
    var className = thisElement.className.split(" ");
    for (var i = 0; i < className.length; i++) {
        if (className[i] != "invalid") {
            returnClassName += className[i] + " ";
        }
    }
    thisElement.className = returnClassName;
}
function remove() {
}

//机器选择下拉菜单
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
function createaccerEquipmachine(thiselement, treatmentid) {
    var machineItem = JSON.parse(getmachineItem1(treatmentid)).Item;
    thiselement.options.length = 0;
    for (var i = 0; i < machineItem.length; i++) {
        if (machineItem[i] != "") {
            thiselement.options[i] = new Option(machineItem[i].Name);
            thiselement.options[i].value = parseInt(machineItem[i].ID);
        }
    }
}

//获取设备
function getmachineItem1(treatmentid) {
        var xmlHttp = new XMLHttpRequest();
        var url = "getfirstaccermachine.ashx?treatmentid=" + treatmentid;
        xmlHttp.open("GET", url, false);
        xmlHttp.send(null);
        var Items = xmlHttp.responseText;
        return Items;
}
//function getmachineItem1(item, type) {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getaccermachine.ashx?item=" + item + "&type=" + type;
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send(null);
//    var Items = xmlHttp.responseText;
//    return Items;
//}
function getmachineItem(item) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getfixmachine.ashx?item=" + item;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}

//构建预约表
function CreateCurrentEquipmentTbale(equiment, dateString) {
    $("#timechoose").hide();
    $("#commonapp1").hide();
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
            var tr;
            var i = m + amlength;
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
function CreateCurrentAccerEquipmentTbale(dateString) {
    $("#timechoose").show();
    $("#amlabel").hide();
    $("#pmappoint").hide();
    $("#commonapp").hide();
    var table = document.getElementById("apptiontTable");
    var equiment;
    if (equipmentfrominfo != "") {
        equiment = [].concat(equipmentfrominfo.Equipment);
    } else {
        equiment = [];
    }
    if (equiment.length != 0) {
        var appointinfo = equipmentfrominfo.appointinfo;
        for (var temp = 0; temp < equiment.length; temp++) {
            for (var temp2 = 0; temp2 < appointinfo.length; temp2++) {
                if (parseInt(equiment[temp].Begin) == parseInt(appointinfo[temp2].Begin)) {
                    equiment[temp].state = "1";
                }
            }
        }
    }
    RemoveAllChild(table);
    var selecttime = document.getElementById("timeselect");
    var currentIndex = selecttime.selectedIndex;
    var selecttimevalue = selecttime.options[currentIndex].value;
    var beginxianzhi = selecttimevalue.split("-")[0];
    var endxianzhi = selecttimevalue.split("-")[1];
    var isspecial = document.getElementById("isspecial");
    var currentIndex1 = isspecial.selectedIndex;
    var isspecialvalue = isspecial.options[currentIndex1].value;
    if (equiment.length == 0) {
        table.innerHTML = "今天已经不可以预约了,改天吧！";
        return;
    }
    var tempcount = 0;
    for (tempcount = 0; tempcount < equiment.length;) {
        if (!(parseInt(equiment[tempcount].Begin) >= parseInt(beginxianzhi) && parseInt(equiment[tempcount].End) <= parseInt(endxianzhi))) {
            equiment.splice(tempcount, 1);
        } else {
            tempcount++;
        }
    }
    if (isspecialvalue == "0") {
        var tbody = document.createElement("tbody");
        var i;
        for (i = 0; i < Math.ceil(equiment.length / 6) * 6 ; i++) {
            var count = i % 6;
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
                    td.setAttribute("id", dateString + "_" + begin + "-" + end + "(次日)" + "_" + equiment[i].Begin + "_" + equiment[i].End);
                } else {
                    td.setAttribute("id", dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Begin + "_" + equiment[i].End);
                }
                if (equiment[i].state == "0") {
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
                for (k = equiment.length; k <= Math.ceil(equiment.length / 6) * 6 - 1; k++) {
                    var td = document.createElement("td");
                    tr.appendChild(td);
                }
            }
            if (count == 5) {
                tbody.appendChild(tr);
            }
        }
        table.appendChild(tbody);
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
            Clear();
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

function Clear() {
    var table = document.getElementById("apptiontTable");
    var table1 = document.getElementById("apptiontTableForPm");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                cell.className = "";
                cell.lastChild.className = "";
                return;
            }
        }
    }
    for (var i = 0; i < table1.rows.length; i++) {
        for (var j = 0; j < table1.rows[i].cells.length; j++) {
            var cell = table1.rows[i].cells[j];
            if (cell.className != "") {
                cell.className = "";
                cell.lastChild.className = "";
                return;
            }
        }
    }
}
function hasChosen() {
    alert("该时间段已被预约！");
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
function CreateNewAccerAppiontTable(evt) {
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipmentID = equipmentName.options[currentIndex].value;
    var AppiontDate = document.getElementById("AppiontDate");
    var date = AppiontDate.value;
    var xmlHttp = new XMLHttpRequest();
    var url = "GetEquipmentWorktime.ashx?equipmentID=" + equipmentID + "&date=" + date;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    equipmentfrominfo = eval("(" + json + ")");
    CreateCurrentAccerEquipmentTbale(date);

}

//与今天比较
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

//根据数据显示疗程状态
function StateNumToString(str){
    var state;
    switch(str){
        case "0":
            state = "进行中";
            break;
        case "1":
            state = "暂停中";
            break;
        case "2":
            state = "已结束";
            break;
        default:
            state = "无";
    }
    return state;
}

//展示状态按钮
function showTreatmentManageButton(State){
    var addTreatmentButton = $("#addTreatment");
    switch(State){
        case "0":
            var pauseTreatmentButton = '<button id="pauseTreatment" class="btn btn-warning" type="button" onclick="changeState(this)" style="margin-left:4px;">暂停疗程</button>';
            var stopTreatmentButton = '<button id="stopTreatment" class="btn btn-danger" type="button" onclick="changeState(this)" style="margin-left:4px;">结束疗程</button>';
            addTreatmentButton.after(stopTreatmentButton);
            addTreatmentButton.after(pauseTreatmentButton);
            break;
        case "1":
            var startTreatmentButton = '<button id="startTreatment" class="btn btn-success" type="button" onclick="changeState(this)" style="margin-left:4px;">继续疗程</button>';
            var stopTreatmentButton = '<button id="stopTreatment" class="btn btn-danger" type="button" onclick="changeState(this)" style="margin-left:4px;">结束疗程</button>';
            addTreatmentButton.after(stopTreatmentButton);
            addTreatmentButton.after(startTreatmentButton);
            break;
        default:
            //var restartTreatmentButton = '<button  id="restartTreatment" class="btn btn-default" type="button" style="margin-left:5px;">疗程已经结束</button>';
            //addTreatmentButton.after(restartTreatmentButton);
      
    }
   
}
//改变按钮触发事件
function changeState(e){
    var changestate = $(e).html();
    var state;
    switch(changestate){
        case "继续疗程":
            state = 0;
            break;
        case "暂停疗程":
            state = 1;
            break;
        case "结束疗程":
            state = 2;
            break;
        //case "恢复疗程":
        //    state = 0;
        //    break;
    }
    var session = getSession();
    var userid = session.userID;
    $.ajax({
        type: "POST",
        url: "../changeLog.ashx",
        async: false,
        data: {
            user: userid,
            treatid: document.getElementById("treatID").value,
            state: state,
            logactor:1
        },
        dateType: "json",
        success: function (data) {
           
        },
        error: function () {
            alert("error");
        }
    });

    $.ajax({
        type: "GET",
        url: "changeTreatmentState.ashx?state=" + state +"&treatID=" + document.getElementById("treatID").value,
        async: false,
        dateType: "text",
        success: function (data) {
            alert("修改成功！");
            var session = getSession();
            window.parent.RolesToPatients(session, window.parent.askstate);
            window.parent.adjustTable();
            window.parent.Recover();
        },
        error: function () {
            alert("error");
        }
    });
}

//新增疗程
function saveTreatment() {
    var diagnose = "";
    var fixed = "";
    var location = "";
    var design = ""
    var replace = "";
    var treatmentname = "";
    var review = "";
    var group = "";
    var Radiotherapy_ID = $("#Radiotherapy_ID").val();
    var Treatmentdescribe = $("#newname").val();
    $("#diagnose").find("td").each(function () {
        if ($(this).find("i").hasClass("fa-check-square-o")) {
            var temp = $(this).attr("id").split("_");
            diagnose = temp[1];
            group = temp[2];
        } else {
            if ($(this).attr("id") != undefined) {
                var temp = $(this).attr("id").split("_");
                group = temp[2];
            }
        }
    });
    $("#fixed").find("td").each(function () {
        if ($(this).find("i").hasClass("fa-check-square-o")) {
            var temp = $(this).attr("id").split("_");
            fixed = temp[1];
        }
    });
    $("#location").find("td").each(function () {
        if ($(this).find("i").hasClass("fa-check-square-o")) {
            var temp = $(this).attr("id").split("_");
            location = temp[1];
        }
    });
    $("#design").find("td").each(function () {
        if ($(this).find("i").hasClass("fa-check-square-o")) {
            var temp = $(this).attr("id").split("_");
            design = temp[1];
            review = temp[2];
        }
    });
    $("#replace").find("td").each(function () {
        if ($(this).find("i").hasClass("fa-check-square-o")) {
            var temp = $(this).attr("id").split("_");
            replace = temp[1];
        }
    });
    treatmentname = $("#register").find("td").length;
    //alert("diagnose:" + diagnose + ",fixed:" + fixed + ",location:" + location + ",design:" + design + ",replace:" + replace + ",treatmentname:" + treatmentname + ",review:" + review + ",group:" + group + ",Radiotherapy_ID:" + Radiotherapy_ID);
    $("#addTreatmentRecord").html("");
    $.ajax({
        type: "post",
        url: "AddTreatment.ashx",
        async: false,
        datetype: "json",
        data: {
            diagnose: diagnose,
            fixed: fixed,
            location: location,
            design: design,
            replace: replace,
            treatmentname: treatmentname,
            Treatmentdescribe: Treatmentdescribe,
            review: review,
            group: group,
            Radiotherapy_ID: Radiotherapy_ID

        },
        success: function (data) {
            alert("新增成功！");
            parent.location.reload();
        },
        error: function () {
            alert("error");
        }
    });
}
//新增疗程弹框
function checkAddTreatment(Radiotherapy_ID) {
    $("#addTreatment").attr("disabled", "disabled");
    $("#addTreatment").nextAll().each(function(){
        $(this).attr("disabled", "disabled");
    });
    var functions = window.parent.functions;
    for (var i = 0; i < functions.length; i++) {
        if (functions[i].toString() == "17") {
            $("#addTreatment").removeAttr("disabled");
            $("#addTreatment").nextAll().each(function(){
                $(this).removeAttr("disabled");
            });
            $("#Radiotherapy_ID").val(Radiotherapy_ID);
            $("#addTreatment").unbind("click").click({ Radiotherapy_ID: Radiotherapy_ID }, function (e) {
                $("#myModal").modal({ backdrop: 'static' });
                $("#registerDetail").html("未选择");
                $("#diagnoseDetail").html("未选择");
                $("#fixedDetail").html("未选择");
                $("#locationDetail").html("未选择");
                $("#designDetail").html("未选择");
                $("#replaceDetail").html("未选择");
                $.ajax({
                    type: "POST",
                    url: "getallcompletedtreat.ashx",
                    async: true,
                    dateType: "text",
                    data: { Radiotherapy_ID: e.data.Radiotherapy_ID },
                    success: function (data) {
                        var table = $("#addTreatmentRecord");
                        table.html("");
                        var thead = '<thead><tr id="progress"><th>流程</th></tr></thead>';
                        var tbody = '<tbody><tr id="register"><td>患者登记</td></tr>' +
                            '<tr id="diagnose"><td>病情诊断</td></tr>' +
                            '<tr id="fixed"><td>体位固定</td></tr><tr id="location"><td>CT模拟</td></tr>' +
                            '<tr id="design"><td>计划设计</td></tr><tr id="replace"><td>复位验证</td></tr></tbody>';
                        table.append(thead);
                        table.append(tbody);
                        data = data.replace(/\r/g, "");
                        data = data.replace(/\t/g, "");
                        data = data.replace(/\n/g, "\\n");
                        obj = $.parseJSON(data);
                        var newTreatname = obj.treatinfo.length + 1;
                        $("#newname").val("疗程" + newTreatname);
                        for (var i = 0; i < obj.treatinfo.length; i++) {
                            var th = '<th>' + obj.treatinfo[i].Treatmentdescribe + '</th>';
                            table.find("thead").find("tr").append(th);
                            var td0 = '<td id="register_' + i + '"><i class="fa fa-fw fa-square-o"></i></td>';
                            $("#register").append(td0);
                            $("#register_" + i).click({ i: i }, function (e) {
                                if ($(this).find("i").hasClass("fa-check-square-o")) {
                                    $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                    $(this).parent().nextAll().each(function () {
                                        $(this).find("td").each(function () {
                                            $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                        });
                                    });
                                    $("#registerDetail").html("未选择");
                                    $("#diagnoseDetail").html("未选择");
                                    $("#fixedDetail").html("未选择");
                                    $("#locationDetail").html("未选择");
                                    $("#designDetail").html("未选择");
                                    $("#replaceDetail").html("未选择");
                                } else {
                                    var currentrowselected = 0;
                                    $(this).parent().find("td").each(function () {
                                        if ($(this).find("i").hasClass("fa-check-square-o")) {
                                            currentrowselected = 1;
                                        }
                                    });
                                    if (currentrowselected == 0) {
                                        $(this).find("i").removeClass("fa-square-o").addClass("fa-check-square-o");
                                        $("#registerDetail").html("");
                                        var details = obj.treatinfo[e.data.i].rigester.split("。");
                                        for (var i = 0; i < details.length; i++) {
                                            var p = '<p>' + details[i] + '</p>';
                                            $("#registerDetail").append(p);
                                        }
                                    } else {
                                        alert("每一行只能选择一个模块复用！");
                                    }
                                }
                            });

                            if (obj.treatinfo[i].diagnose != "") {
                                var td1 = '<td id="diagnose_' + obj.treatinfo[i].diagnose + '_' + obj.treatinfo[i].group + '_' + i + '"><i class="fa fa-fw fa-square-o"></i></td>';
                                $("#diagnose").append(td1);
                                $("#diagnose_" + obj.treatinfo[i].diagnose + "_" + obj.treatinfo[i].group + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i").hasClass("fa-check-square-o")) {
                                        $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                            });
                                        });
                                        $("#diagnoseDetail").html("未选择");
                                        $("#fixedDetail").html("未选择");
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").removeClass("fa-square-o").addClass("fa-check-square-o");
                                                $("#diagnoseDetail").html("");
                                                var details = obj.treatinfo[e.data.i].diagnosecomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#diagnoseDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td1 = '<td style="background-color:#E1E4E6"></td>';
                                $("#diagnose").append(td1);
                            }

                            if (obj.treatinfo[i].fixed != "") {
                                var td2 = '<td id="fixed_' + obj.treatinfo[i].fixed + '_' + i + '"><i class="fa fa-fw fa-square-o"></i></td>';
                                $("#fixed").append(td2);
                                $("#fixed_" + obj.treatinfo[i].fixed + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i").hasClass("fa-check-square-o")) {
                                        $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                            });
                                        });
                                        $("#fixedDetail").html("未选择");
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").removeClass("fa-square-o").addClass("fa-check-square-o");
                                                $("#fixedDetail").html("");
                                                var details = obj.treatinfo[e.data.i].fixcomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#fixedDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td2 = '<td style="background-color:#E1E4E6"></td>';
                                $("#fixed").append(td2);
                            }

                            if (obj.treatinfo[i].location != "") {
                                var td3 = '<td id="location_' + obj.treatinfo[i].location + '_' + i + '"><i class="fa fa-fw fa-square-o"></i></td>';
                                $("#location").append(td3);
                                $("#location_" + obj.treatinfo[i].location + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i").hasClass("fa-check-square-o")) {
                                        $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                            });
                                        });
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").removeClass("fa-square-o").addClass("fa-check-square-o");
                                                $("#locationDetail").html("");
                                                var details = obj.treatinfo[e.data.i].locationcomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#locationDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td3 = '<td style="background-color:#E1E4E6"></td>';
                                $("#location").append(td3);
                            }

                            if (obj.treatinfo[i].design != "") {
                                var td4 = '<td id="design_' + obj.treatinfo[i].design + '_' + obj.treatinfo[i].review + '_' + i + '"><i class="fa fa-fw fa-square-o"></i></td>';
                                $("#design").append(td4);
                                $("#design_" + obj.treatinfo[i].design + "_" + obj.treatinfo[i].review + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i").hasClass("fa-check-square-o")) {
                                        $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                            });
                                        });
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").removeClass("fa-square-o").addClass("fa-check-square-o");
                                                $("#designDetail").html("");
                                                var details = obj.treatinfo[e.data.i].designcomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#designDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td4 = '<td style="background-color:#E1E4E6"></td>';
                                $("#design").append(td4);
                            }

                            if (obj.treatinfo[i].replace != "") {
                                var td5 = '<td id="replace_' + obj.treatinfo[i].replace + '_' + i + '"><i class="fa fa-fw fa-square-o"></i></td>';
                                $("#replace").append(td5);
                                $("#replace_" + obj.treatinfo[i].replace + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i").hasClass("fa-check-square-o")) {
                                        $(this).find("i").removeClass("fa-check-square-o").addClass("fa-square-o");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i").hasClass("fa-check-square-o")) {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").removeClass("fa-square-o").addClass("fa-check-square-o");
                                                $("#replaceDetail").html("");
                                                var details = obj.treatinfo[e.data.i].replacecomplete.split("。");
                                                for (var i = 0; i < details.length; i++) {
                                                    var p = '<p>' + details[i] + '</p>';
                                                    $("#replaceDetail").append(p);
                                                }
                                            } else {
                                                alert("上一行还未选择复用模块！");
                                            }
                                        } else {
                                            alert("每一行只能选择一个模块复用！");
                                        }
                                    }
                                });
                            } else {
                                var td5 = '<td style="background-color:#E1E4E6"></td>';
                                $("#replace").append(td5);
                            }
                        }
                    },
                    error: function () {
                        alert("error");
                    }
                });
            });
            return true;
        }
    }
    return false;
}
//编辑按钮事件
function remove() {
    document.getElementById("userName").removeAttribute("disabled");
    document.getElementById("usernamepingyin").removeAttribute("disabled");
    document.getElementById("Nation").removeAttribute("disabled");
    document.getElementById("IDcardNumber").removeAttribute("disabled");
    document.getElementById("Birthday").removeAttribute("disabled");
    document.getElementById("Address").removeAttribute("disabled");
    document.getElementById("Number1").removeAttribute("disabled");
    document.getElementById("Number2").removeAttribute("disabled");
    document.getElementById("height").removeAttribute("disabled");
    document.getElementById("weight").removeAttribute("disabled");
    document.getElementById("hospitalnumber").removeAttribute("disabled");
    document.getElementById("doctor").removeAttribute("disabled");
    var add = document.getElementsByName("Gender");
    add[0].removeAttribute("disabled");
    add[1].removeAttribute("disabled");
    var ad = document.getElementsByName("RecordNumber");
    ad[0].removeAttribute("disabled");
    ad[1].removeAttribute("disabled");
    document.getElementById("group").removeAttribute("disabled");
    document.getElementById("Sub").removeAttribute("disabled");
    document.getElementById("Hospital").removeAttribute("disabled");
    document.getElementById("radionumber").removeAttribute("disabled");
}

//图片上交事件
function handleFiles(e) {
    var groupfiles = e.target.files;
    var reader = new FileReader();
    reader.onload = (function (file) {
        return function (e) {
            $("#self-photo").attr("src", this.result);
            $("#pic").attr("value", this.result);
        };
    })(groupfiles[0]);
    reader.readAsDataURL(groupfiles[0]);
}

//查看加速器预约情况
function chakan(treatID) {
    $("#appointcheckbody").empty();
    $("#appointcheckhead").show();
    $.ajax({
        type: "POST",
        url: "achievealldesign.ashx",
        async: false,
        data: {
            patientid: patientInfo.patientInfo[0].ID,
            chid: "",
            treatmentid:treatID
        },
        dateType: "json",
        success: function (data) {
            var group = eval("(" + data + ")");
            var info = group.info;
            if (info.length == 0) {
                $("#appointcheckhead").hide();
                $("#appointcheckbody").html("没有预约信息");
            }
            var content = '';
            for (var i = 0; i < info.length; i++) {
                var rowscount = 0;
                for (var j = 0; j < info[i].timeinfo.length; j++) {
                    rowscount = rowscount + info[i].timeinfo[j].childgesin.length;
                }
                for (var k = 0; k < info[i].timeinfo.length; k++) {
                    for (var m = 0; m < info[i].timeinfo[k].childgesin.length; m++) {
                        if (k == 0 && m == 0) {
                            if (info[i].timeinfo[k].childgesin[m].treatid == treatID) {
                                content = content + '<tr><td rowspan=' + rowscount + '>' + info[i].appdate.split(" ")[0] + '</td><td rowspan=' + info[i].timeinfo[k].childgesin.length + '>' + transfertime(toTime(info[i].timeinfo[k].begintime)) + "-" + transfertime(toTime(info[i].timeinfo[k].endtime)) + '</td><td  bgcolor="#ffff66">' + info[i].timeinfo[k].childgesin[m].Treatmentdescribe + "," + info[i].timeinfo[k].childgesin[m].designname + '</td><td  bgcolor="#ffff66">' + transferresult(info[i].timeinfo[k].childgesin[m].isfirst, info[i].timeinfo[k].childgesin[m].istreated) + '</td></tr>';
                            } else {
                                content = content + '<tr><td rowspan=' + rowscount + '>' + info[i].appdate.split(" ")[0] + '</td><td rowspan=' + info[i].timeinfo[k].childgesin.length + '>' + transfertime(toTime(info[i].timeinfo[k].begintime)) + "-" + transfertime(toTime(info[i].timeinfo[k].endtime)) + '</td><td>' + info[i].timeinfo[k].childgesin[m].Treatmentdescribe + "," + info[i].timeinfo[k].childgesin[m].designname + '</td><td >' + transferresult(info[i].timeinfo[k].childgesin[m].isfirst, info[i].timeinfo[k].childgesin[m].istreated) + '</td></tr>';
                            }
                        }
                        if (k > 0 && m == 0) {
                            if (info[i].timeinfo[k].childgesin[m].treatid == treatID) {
                                content = content + '<td rowspan=' + info[i].timeinfo[k].childgesin.length + '>' + transfertime(toTime(info[i].timeinfo[k].begintime)) + "-" + transfertime(toTime(info[i].timeinfo[k].endtime)) + '</td><td bgcolor="#ffff66">' + info[i].timeinfo[k].childgesin[m].Treatmentdescribe + "," + info[i].timeinfo[k].childgesin[m].designname + '</td><td bgcolor="#ffff66">' + transferresult(info[i].timeinfo[k].childgesin[m].isfirst, info[i].timeinfo[k].childgesin[m].istreated) + '</td></tr>';
                            } else {
                                content = content + '<td rowspan=' + info[i].timeinfo[k].childgesin.length + '>' + transfertime(toTime(info[i].timeinfo[k].begintime)) + "-" + transfertime(toTime(info[i].timeinfo[k].endtime)) + '</td><td>' + info[i].timeinfo[k].childgesin[m].Treatmentdescribe + "," + info[i].timeinfo[k].childgesin[m].designname + '</td><td>' + transferresult(info[i].timeinfo[k].childgesin[m].isfirst, info[i].timeinfo[k].childgesin[m].istreated) + '</td></tr>';
                            }
                        }
                        if (m > 0) {
                            if (info[i].timeinfo[k].childgesin[m].treatid == treatID) {
                                content = content + '<td bgcolor="#ffff66">' + info[i].timeinfo[k].childgesin[m].Treatmentdescribe + "," + info[i].timeinfo[k].childgesin[m].designname + '</td><td bgcolor="#ffff66">' + transferresult(info[i].timeinfo[k].childgesin[m].isfirst, info[i].timeinfo[k].childgesin[m].istreated) + '</td></tr>';
                            } else {
                                content = content + '<td>' + info[i].timeinfo[k].childgesin[m].Treatmentdescribe + "," + info[i].timeinfo[k].childgesin[m].designname + '</td><td>' + transferresult(info[i].timeinfo[k].childgesin[m].isfirst, info[i].timeinfo[k].childgesin[m].istreated) + '</td></tr>';
                            }
                        }

                    }
                }
            }
            $("#appointcheckbody").append(content);
        },
        error: function (data) {
            alert("error");
        }
    });


}
//转换函数
function transferresult(args1, args2) {
    if (args1 == "1") {
        if (args2 == "") {
            return "首次预约,未完成";
        } else {
            return "首次预约，已经完成";
        }
    } else {
        if (args2 == "") {
            return "非首次预约,未完成";
        } else {
            return "非首次预约，已经完成";
        }
    }
}
//转换预约时间防止超过24点
function transfertime(args) {
    var group = args.split(":");
    if (parseInt(group[0]) > 24) {
        return (parseInt(group[0])-24) + ":" + group[1] + "(次日)";
    } else {
        return args;
    }

}