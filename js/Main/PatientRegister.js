var isAllGood;//所有检查是否通过
var docandgroup;
window.addEventListener("load", Init, false);
//初始化 
var userID;
var Radiotherapy_ID;
var equipmentfrominfo = "";

function Init(evt) {
    var treatID = window.location.search.split("&")[0].split("=")[1];
    Radiotherapy_ID = window.location.search.split("&")[1].split("=")[1];
    getdoctorandgroup();
    var select4 = document.getElementById("doctor");
    createdoctorItem(select4);
    select4.addEventListener("change", function () {
        createselect2(select4.selectedIndex);
    }, false);
    document.getElementById("chooseProject").addEventListener("click", function () {
        CreateNewAppiontTable(event);
    }, false);//根据条件创建预约表
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
function changeAppoint(e) {
     var treatID = window.location.search.split("&")[0].split("=")[1];
    var $e = $(e);
    var item = $e.parent().parent().children().first().text();
    var oldappoint = $e.parent().parent().attr("ID").split("_")[1];
    if (item == "体位固定") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Fixed")
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAppiontTable(e);
        });
    }
    if (item == "模拟定位") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Location")
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAppiontTable(e);
        });
    }
    if (item == "加速器") {
        createaccerEquipmachine(document.getElementById("equipmentName"), treatID)
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAccerAppiontTable(e);
        });
    }
    if (item == "复位模拟") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Replacement")
        $("#chooseProject").unbind("click").bind("click", function () {
            CreateNewAppiontTable(e);
        });
    }
    var date = new Date();
    var date = date.Format('yyyy-MM-dd');
    document.getElementById("AppiontDate").value = date;
    if (item != "加速器") {
        CreateNewAppiontTable(e);
    } else {
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
        document.getElementById("background-photo").style.display = "none";
        document.getElementById("photo").style.display = "inline";
        document.getElementById("photo").src = PatientInfo.patientInfo[0].Picture;
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
        thiselement.options.length = 0;
        thiselement.options[0] = new Option("----分组选择-----");
        thiselement.options[0].value = "allItem";
        for (var i = 1; i <= groupitem.length - 1; i++) {
            thiselement.options[i] = new Option(groupitem[i].groupname);
            thiselement.options[i].value = parseInt(groupitem[i].groupid);
        }
    }

}
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
//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(equiment, dateString) {
    $("#timechoose").hide();
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
                if (parseInt(toTime(equiment[i].Begin).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    var beginhour = parseInt(hour) - 24;
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
                if (parseInt(toTime(equiment[i].Begin).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    var beginhour = parseInt(hour) - 24;
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
function CreateCurrentAccerEquipmentTbale(dateString) {
    $("#timechoose").show();
    var table = document.getElementById("apptiontTable");
    var equiment;
    if (equipmentfrominfo != "") {
        equiment = [].concat(equipmentfrominfo.Equipment);
    } else {
        equiment = [];
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
function Clear() {
    var table = document.getElementById("apptiontTable");
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
}
function hasChosen() {
    alert("该时间段已被预约！");
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
function CreateNewAccerAppiontTable(evt) {
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipmentID = equipmentName.options[currentIndex].value;
    var AppiontDate = document.getElementById("AppiontDate");
    if (!compareWithToday(AppiontDate.value)) {
        alert("不能选择小于当天的日期");
        var table = document.getElementById("apptiontTable");
        RemoveAllChild(table);
        equipmentfrominfo = [];
        return;
    }
    var date = AppiontDate.value;
    var xmlHttp = new XMLHttpRequest();
    var url = "GetEquipmentWorktime.ashx?equipmentID=" + equipmentID + "&date=" + date;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    equipmentfrominfo = eval("(" + json + ")");
    CreateCurrentAccerEquipmentTbale(date);

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
            var restartTreatmentButton = '<button id="restartTreatment" class="btn btn-success" type="button" onclick="changeState(this)" style="margin-left:4px;">恢复疗程</button>';
            addTreatmentButton.after(restartTreatmentButton);
    }
}

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
        case "恢复疗程":
            state = 0;
            break;
    }
    $.ajax({
        type: "GET",
        url: "changeTreatmentState.ashx?state=" + state +"&treatID=" + document.getElementById("treatID").value,
        async: false,
        dateType: "text",
        success: function (data) {
            alert("修改成功！");
            window.parent.RolesToPatients();
            window.parent.adjustTable();
            window.parent.Recover();
        },
        error: function () {
            alert("error");
        }
    });
}

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
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            diagnose = temp[1];
            group = temp[2];
        }
    });
    $("#fixed").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            fixed = temp[1];
        }
    });
    $("#location").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            location = temp[1];
        }
    });
    $("#design").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
            var temp = $(this).attr("id").split("_");
            design = temp[1];
            review = temp[2];
        }
    });
    $("#replace").find("td").each(function () {
        if ($(this).find("i")[0].className != "") {
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
        async: true,
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
            $("#addTreatmentRecord").html("");
            var patient = getpatient();
            paging(patient);
        },
        error: function () {
            alert("error");
        }
    });
}

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
                        var tbody = '<tbody><tr id="register"><td>患者登记<i></i></td></tr>' +
                            '<tr id="diagnose"><td>病情诊断<i></i></td></tr>' +
                            '<tr id="fixed"><td>体位固定<i></i></td></tr><tr id="location"><td>CT模拟<i></i></td></tr>' +
                            '<tr id="design"><td>计划设计<i></i></td></tr><tr id="replace"><td>复位验证<i></i></td></tr></tbody>';
                        table.append(thead);
                        table.append(tbody);
                        data = data.replace(/\r/g, "");
                        data = data.replace(/\n/g, "\\n");
                        obj = $.parseJSON(data);
                        var newTreatname = obj.treatinfo.length + 1;
                        $("#newname").val("疗程" + newTreatname);
                        for (var i = 0; i < obj.treatinfo.length; i++) {
                            var th = '<th>' + obj.treatinfo[i].Treatmentdescribe + '</th>';
                            table.find("thead").find("tr").append(th);
                            var td0 = '<td id="register_' + i + '"><i></i></td>';
                            $("#register").append(td0);
                            $("#register_" + i).click({ i: i }, function (e) {
                                if ($(this).find("i")[0].className != "") {
                                    $(this).find("i").removeClass();
                                    $(this).parent().nextAll().each(function () {
                                        $(this).find("td").each(function () {
                                            $(this).find("i").removeClass();
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
                                        if ($(this).find("i")[0].className != "") {
                                            currentrowselected = 1;
                                        }
                                    });
                                    if (currentrowselected == 0) {
                                        $(this).find("i").addClass("fa fa-fw fa-check");
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
                                var td1 = '<td id="diagnose_' + obj.treatinfo[i].diagnose + '_' + obj.treatinfo[i].group + '_' + i + '"><i></i></td>';
                                $("#diagnose").append(td1);
                                $("#diagnose_" + obj.treatinfo[i].diagnose + "_" + obj.treatinfo[i].group + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
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
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
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
                                var td1 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#diagnose").append(td1);
                            }

                            if (obj.treatinfo[i].fixed != "") {
                                var td2 = '<td id="fixed_' + obj.treatinfo[i].fixed + '_' + i + '"><i></i></td>';
                                $("#fixed").append(td2);
                                $("#fixed_" + obj.treatinfo[i].fixed + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
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
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
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
                                var td2 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#fixed").append(td2);
                            }

                            if (obj.treatinfo[i].location != "") {
                                var td3 = '<td id="location_' + obj.treatinfo[i].location + '_' + i + '"><i></i></td>';
                                $("#location").append(td3);
                                $("#location_" + obj.treatinfo[i].location + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                        $("#locationDetail").html("未选择");
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
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
                                var td3 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#location").append(td3);
                            }

                            if (obj.treatinfo[i].design != "") {
                                var td4 = '<td id="design_' + obj.treatinfo[i].design + '_' + obj.treatinfo[i].review + '_' + i + '"><i></i></td>';
                                $("#design").append(td4);
                                $("#design_" + obj.treatinfo[i].design + "_" + obj.treatinfo[i].review + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $(this).parent().nextAll().each(function () {
                                            $(this).find("td").each(function () {
                                                $(this).find("i").removeClass();
                                            });
                                        });
                                        $("#designDetail").html("未选择");
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
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
                                var td4 = '<td style="background-color:#E1E4E6"><i></i></td>';
                                $("#design").append(td4);
                            }

                            if (obj.treatinfo[i].replace != "") {
                                var td5 = '<td id="replace_' + obj.treatinfo[i].replace + '_' + i + '"><i></i></td>';
                                $("#replace").append(td5);
                                $("#replace_" + obj.treatinfo[i].replace + "_" + i).click({ i: i }, function (e) {
                                    if ($(this).find("i")[0].className != "") {
                                        $(this).find("i").removeClass();
                                        $("#replaceDetail").html("未选择");
                                    } else {
                                        var currentrowselected = 0;
                                        var prerowselected = 0;
                                        $(this).parent().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                currentrowselected = 1;
                                            }
                                        });
                                        $(this).parent().prev().find("td").each(function () {
                                            if ($(this).find("i")[0].className != "") {
                                                prerowselected = 1;
                                            }
                                        });
                                        if (currentrowselected == 0) {
                                            if (prerowselected == 1) {
                                                $(this).find("i").addClass("fa fa-fw fa-check");
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
                                var td5 = '<td style="background-color:#E1E4E6"><i></i></td>';
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