var isAllGood;//所有检查是否通过
var docandgroup;
window.addEventListener("load", Init, false);
//初始化 

function Init(evt) {
    var treatID = window.location.search.split("=")[1];
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
    for (var i = 0; i < appoints.appoint.length; i++) {
        var appointDate = new Date(appoints.appoint[i].Date);
        var completed = (appoints.appoint[i].Completed == "1") ? "已完成" : "未完成";
        var tr = '<tr id="apoint_' + appoints.appoint[i].appointid + '"><td>' + appoints.appoint[i].Task + '</td>'
            + '<td>' + appointDate.Format("yyyy-MM-dd") + ' , ' + toTime(appoints.appoint[i].Begin) + ' - ' + toTime(appoints.appoint[i].End) + '</td>'
            + '<td>' + completed + '</td>';
        if (appoints.appoint[i].Completed == "1") {
            tr = tr + '<td><button disabled="disabled" class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
        } else {
            tr = tr + '<td><button  class="btn btn-success" type="button" onclick="changeAppoint(this)">更改</button></td></tr>';
        }
        viewAppointsBody.append(tr);
    }
 
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
    var $e = $(e);
    var item = $e.parent().parent().children().first().text();
    var oldappoint = $e.parent().parent().attr("ID").split("_")[1];
    if (item == "体位固定") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Fixed")
    }
    if (item == "模拟定位") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Location")
    }
    if (item == "加速器") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Accelerator")
    }
    if (item == "复位模拟") {
        createfixEquipmachine(document.getElementById("equipmentName"), "Replacement")
    }
    var date = new Date();
    var date = date.Format('yyyy-MM-dd');
    document.getElementById("AppiontDate").value = date;
    CreateNewAppiontTable(e);
    $("#sure").bind("click", function () {
        $(this).unbind("click");
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
                $.ajax({
                    type: "POST",
                    url: "changeAccerateAppoint.ashx",
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
    var select4 = document.getElementById("doctor");
    createselect2(select4.selectedIndex);
    if (PatientInfo.patientInfo[0].group == "") {
        document.getElementById("group").value = "allItem";
    } else {
        document.getElementById("group").value =PatientInfo.patientInfo[0].group;
    }
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
    if (document.getElementById("userName").value=="") {
        window.alert("姓名不能为空");
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
    if (document.getElementById("Hospital").value=="") {
        window.alert("就诊医院不能为空");
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
    if (document.getElementById("height").value=="") {
        window.alert("身高不能为空");
        return false;                  
    }
    if (document.getElementById("weight").value=="") {
        window.alert("体重不能为空");
        return false;                 
    }
    if (document.getElementById("Sub").value == "") {
        window.alert("请输入分中心负责人"); 
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
function checkAllTable() {
    var choseid = ChoseID();
    var appoint = choseid.split("_");
    document.getElementById("idforappoint").value = appoint[0];
    document.getElementById("appointtime").value = appoint[3] + " " + appoint[1] + " " + appoint[2];
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


