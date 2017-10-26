﻿
window.addEventListener("load", Init, false);
var userName;
var userID;
var treatID;
var fileName = "";
var aa = 0;
var ss = 0;
var common;
function Init(evt) {

    //获得当前执行人姓名与ID
    getUserName();
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    //此处为分页代码
    //alert("jy");
    //document.getElementById("username").value = userID; 
    treatID = window.location.search.split("=")[1];

    var patient = getPatientInfo(treatID);
    document.getElementById("userID").value = userID;
    document.getElementById("hidetreatID").value = treatID;
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
    document.getElementById("lightpart").innerHTML = patient.LightPart_ID;
    common = patient.iscommon;
    if (common == 0) {
        document.getElementById("plan").innerHTML = "";
    } else {
        var select1 = document.getElementById("Irradiation");
        createPlanSystemItem(select1);
        var select2 = document.getElementById("ener");
        createenergyItem(select2);
    }
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '11')) {
        var fildinfo = getfieldinfo();
        if (common == 1) {
            document.getElementById("Irradiation").value = fildinfo[0].Irradiation;
            document.getElementById("ener").value = fildinfo[0].energy2;
            document.getElementById("IlluminatedNumber").value = fildinfo[0].IlluminatedNumber;
            ss = fildinfo[0].IlluminatedNumber;
            table(ss, fildinfo[0].Illuminatedangle);
            document.getElementById("MachineNumbe").value = fildinfo[0].MachineNumbe;
            document.getElementById("ControlPoint").value = fildinfo[0].ControlPoint;
            document.getElementById("Coplanar").value = fildinfo[0].Coplanar;
        }
        document.getElementById("pingyin").value = fildinfo[0].pinyin;
        document.getElementById("id").value = fildinfo[0].radioID;
        document.getElementById("tps").value = fildinfo[0].tps;
        document.getElementById("pos").value = fildinfo[0].pos;
        document.getElementById("Graded").value = fildinfo[0].Singledose;
        document.getElementById("total").value = fildinfo[0].Totaldose;
        document.getElementById("applyuser").innerHTML = fildinfo[0].Name;
        document.getElementById("time").innerHTML = fildinfo[0].time;
        readField(fildinfo);
        if (fildinfo[0].userID == userID) {
            window.parent.document.getElementById("edit").removeAttribute("disabled");
        }
    } else {
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
    }

    $("#IlluminatedNumber").blur(function(){
        var num = $("#IlluminatedNumber").val();
        if (num > 0) {
            var table = $("#Illuminatedangle");
            table.html("");
            var tbody = "<tbody>";
            var count = 1;
            while(count <= num){
                var rownum = 0;
                tbody += "<tr>";
                while(rownum < 4){
                    if (count <= num) {
                        td = '<td style="padding:0px;"><input type="number" id="angle' + count + '" name="angle' + count + '" class="td-input"></td>';
                    }else{
                        td = '<td style="text-align:center;">/</td>';
                    }
                    tbody += td;
                    rownum += 1;
                    count += 1;
                }
                tbody += "</tr>";
            }
            tbody += "/tbody";
            table.append(tbody);
        }
    });

    $(".file").on("change", "input[type='file']", function () {
        var filePath=$(this).val();
        var arr=filePath.split('\\');
        fileName=arr[arr.length-1];
        $("#filename").val(fileName);
    })
}
function table(num, str) {
    var list = new Array();
    list=str.split(",");
    if (num > 0) {
        var table = $("#Illuminatedangle");
        table.html("");
        var tbody = "<tbody>";
        var count = 1;
        while (count <= num) {
            var rownum = 0;
            tbody += "<tr>";
            while (rownum < 4) {
                if (count <= num) {
                    td = '<td style="padding:0px;"><input type="number" id="angle' + count + '" name="angle' + count + '" class="td-input" value="'+list[count-1]+'" disabled="disabled"></td>';
                } else {
                    td = '<td style="text-align:center;">/</td>';
                }
                tbody += td;
                rownum += 1;
                count += 1;
            }
            tbody += "</tr>";
        }
        tbody += "/tbody";
        table.append(tbody);
    }
}
function createPlanSystemItem(thiselement) {
    var PartItem = JSON.parse(getPartItem3()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--照射技术选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }
    if (PartItem[0].defaultItem != "") {
        thiselement.value = PartItem[0].defaultItem;
    }
}
//第二步部位项数据库调取
function getPartItem3() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Irradiation.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createenergyItem(thiselement) {
    var PartItem = JSON.parse(getPartItem4()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--能量选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }
    if (PartItem[0].defaultItem != "") {
        thiselement.value = PartItem[0].defaultItem;
    }
}
//第二步部位项数据库调取
function getPartItem4() {
    var xmlHttp = new XMLHttpRequest();
    var url = "energy.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
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
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
}
function addField() {
    var table = document.getElementById("Field");
    var rows = table.rows.length;
    var row = table.insertRow(rows);
    rows--;
    var t1 = row.insertCell(0);
    var t2 = row.insertCell(1);
    var t3 = row.insertCell(2);
    var t4 = row.insertCell(3);
    var t5 = row.insertCell(4);
    var t6 = row.insertCell(5);
    var t7 = row.insertCell(6);
    var t8 = row.insertCell(7);
    var t9 = row.insertCell(8);
    var t10 = row.insertCell(9);
    var t11 = row.insertCell(10);
    var t12 = row.insertCell(11);
    t1.style.padding = "0px";
    t2.style.padding = "0px";
    t3.style.padding = "0px";
    t4.style.padding = "0px";
    t5.style.padding = "0px";
    t6.style.padding = "0px";
    t7.style.padding = "0px";
    t8.style.padding = "0px";
    t9.style.padding = "0px";
    t10.style.padding = "0px";
    t11.style.padding = "0px";   
    t12.style.cssText = "text-align: center;padding:0px;vertical-align: middle";
    t12.id="delete" + rows;
    t1.innerHTML = '<input id="a1' + rows + '" name="a1' + rows + '" type="text" class="td-input" />';
    t2.innerHTML = '<input id="mu' + rows + '" name="mu' + rows + '" type="text" class="td-input" />';
    t3.innerHTML = '<input id="equipment' + rows + '" name="equipment' + rows + '" type="number" class="td-input" />';
    t4.innerHTML = '<input id="technology' + rows + '" name="technology' + rows + '" type="text" class="td-input" />';
    t5.innerHTML = '<input id="type' + rows + '" name="type' + rows + '" type="text" class="td-input" />';
    t6.innerHTML = '<input id="energyField' + rows + '" name="energyField' + rows + '" type="text" class="td-input" />';
    t7.innerHTML = '<input id="ypj' + rows + '" name="ypj' + rows + '" type="text" class="td-input" />';
    t8.innerHTML = '<input id="jjj' + rows + '" name="jjj' + rows + '" type="text" class="td-input" />';
    t9.innerHTML = '<input id="jtj' + rows + '" name="jtj' + rows + '" type="text" class="td-input" />';
    t10.innerHTML = '<input id="czj' + rows + '" name="czj' + rows + '" type="text" class="td-input" />';
    t11.innerHTML = '<input id="childs' + rows + '" name="childs' + rows + '" type="text" class="td-input" />';
    t12.innerHTML = '<a href="javascript:deleteField(' + rows + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    aa = aa + 1;
    document.getElementById("aa").value = aa;
}
function deleteField(row) {
    var table = document.getElementById("Field");
    var maxrow = table.rows.length;
    //var row = Number(currentbutton.id.replace(/[^0-9]/ig, ""));
    for (var i = row + 1; i < maxrow - 1; i++) {
        var j = i - 1;
        var td1 = document.getElementById("a1" + i);
        td1.id = "a1" + j;
        td1.name = "a1" + j;
        var td2 = document.getElementById("mu" + i);
        td2.id = "mu" + j;
        td2.name = "mu" + j;
        var td3 = document.getElementById("equipment" + i);
        td3.id = "equipment" + j
        td3.name = "equipment" + j;
        var td4 = document.getElementById("technology" + i);
        td4.id = "technology" + j;
        td4.name = "technology" + j;
        var td5 = document.getElementById("type" + i);
        td5.id = "type" + j;
        td5.name = "type" + j;
        var td6 = document.getElementById("energyField" + i);
        td6.id = "energyField" + j;
        td6.name = "energyField" + j;
        var td7 = document.getElementById("ypj" + i);
        td7.id = "ypj" + j;
        td7.name = "ypj" + j;
        var td8 = document.getElementById("jjj" + i);
        td8.id = "jjj" + j;
        td8.name = "jjj" + j;
        var td9 = document.getElementById("jtj" + i);
        td9.id = "jtj" + j;
        td9.name = "jtj" + j;
        var td10 = document.getElementById("czj" + i);
        td10.id = "czj" + j;
        td10.name = "czj" + j;
        var td11 = document.getElementById("childs" + i);
        td11.id = "childs" + j;
        td11.name = "childs" + j;

        var td12 = document.getElementById("delete" + i);
        td12.id = "delete" + j;
        td12.innerHTML = '<a  href="javascript:deleteField(' + j + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';;
    }
    table.deleteRow(row + 1);
    aa = aa - 1;
    document.getElementById("aa").value = aa;
}
$(function () {
    $("#sure").bind("click", function () {
        if (fileName == "") {
            return false;
        }
        var formDate = new FormData();
        if ($("#file")[0].files[0] == null) {
            formDate.append("exist", "false");
        } else {
            formDate.append("file", $("#file")[0].files[0]);
            formDate.append("exist", "true");
        }
        $.ajax({
            type: "post",
            url: "getFieldInformation.ashx",
            data: formDate,
            processData: false,
            contentType: false,
            success: function (data) {
                var data = $.parseJSON(data);
                //if (document.getElementById("radiotherapy").innerHTML != data.information[0].id) {
                //    alert("文件选择错误");
                //    return false;
                //}
                createInformation(data.information);
                creaetField(data.details);
            }
        });
    });
});
function createInformation(data) {
    document.getElementById("id").value = data[0].id;
    document.getElementById("pingyin").value = data[0].lastName + data[0].firstName;
    document.getElementById("tps").value = data[0].tps;       
    document.getElementById("Graded").value = data[0].once;
    document.getElementById("fieldTimes").value = data[0].fieldTimes;
    document.getElementById("pos").value = data[0].pos;
    document.getElementById("total").value = data[0].all;
}
function creaetField(data) {   
    var table = document.getElementById("Field");
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
    aa = data.length;
    for (var i = 0; i < data.length; i++) {
        var list = new Array();
        list[0] = data[i].a1;
        list[1] = data[i].mu;
        list[2] = data[i].equipment;
        list[3] = data[i].technology;
        list[4] = data[i].type;
        list[5] = data[i].energyField;
        list[6] = data[i].ypj;
        list[7] = data[i].jjj;
        list[8] = data[i].jtj;
        list[9] = data[i].czj;
        list[10] = data[i].childs;
        var row = table.insertRow(i + 1);
        var t1 = row.insertCell(0);
        var t2 = row.insertCell(1);
        var t3 = row.insertCell(2);
        var t4 = row.insertCell(3);
        var t5 = row.insertCell(4);
        var t6 = row.insertCell(5);
        var t7 = row.insertCell(6);
        var t8 = row.insertCell(7);
        var t9 = row.insertCell(8);
        var t10 = row.insertCell(9);
        var t11 = row.insertCell(10);
        var t12 = row.insertCell(11);
        t1.style.padding = "0px";
        t2.style.padding = "0px";
        t3.style.padding = "0px";
        t4.style.padding = "0px";
        t5.style.padding = "0px";
        t6.style.padding = "0px";
        t7.style.padding = "0px";
        t8.style.padding = "0px";
        t9.style.padding = "0px";
        t10.style.padding = "0px";
        t11.style.padding = "0px";
        t12.style.padding = "0px";
        t1.innerHTML = '<input id="a1' + i + '" name="a1' + i + '" value="' + list[0]+ '" type="text" class="td-input" />';
        t2.innerHTML = '<input id="mu' + i + '" name="mu' + i + '" type="text" value="' + list[1] + '" class="td-input" />';
        t3.innerHTML = '<input id="equipment' + i + '" name="equipment' + i + '" type="number" value="' + list[2] + '" class="td-input" />';
        t4.innerHTML = '<input id="technology' + i + '" name="technology' + i + '" type="text" value="' + list[3] + '" class="td-input" />';
        t5.innerHTML = '<input id="type' + i + '" name="type' + i + '" type="text" value="' + list[4] + '" class="td-input" />';
        t6.innerHTML = '<input id="energyField' + i + '" name="energyField' + i + '" type="text" value="' + list[5] + '" class="td-input" />';
        t7.innerHTML = '<input id="ypj' + i + '" name="ypj' + i + '" type="text" value="' + list[6] + '" class="td-input" />';
        t8.innerHTML = '<input id="jjj' + i + '" name="jjj' + i + '" type="text" value="' + list[7] + '" class="td-input" />';
        t9.innerHTML = '<input id="jtj' + i + '" name="jtj' + i + '" type="text" value="' + list[8] + '" class="td-input" />';
        t10.innerHTML = '<input id="czj' + i + '" name="czj' + i + '" type="text" value="' + list[9] + '" class="td-input" />';
        t11.innerHTML = '<input id="childs' + i + '" name="childs' + i + '" type="text" value="' + list[10] + '" class="td-input" />';
        //t12.innerHTML = '<a href="javascript:deleteField(' + i + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    }
    document.getElementById("aa").value = aa;
}

function readField(data) {   
    var table = document.getElementById("Field");
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
    aa = data.length;
    document.getElementById("fieldTimes").value = data.length;
    for (var i = 0; i < data.length; i++) {
        var list = new Array();
        list[0] = data[i].code;
        list[1] = data[i].mu;
        list[2] = data[i].equipment;
        list[3] = data[i].radiotechnique;
        list[4] = data[i].radiotype;
        list[5] = data[i].energy;
        list[6] = data[i].wavedistance;
        list[7] = data[i].angleframe;
        list[8] = data[i].noseangle;
        list[9] = data[i].bedrotation;
        list[10] = data[i].subfieldnumber;
        var row = table.insertRow(i + 1);
        var t1 = row.insertCell(0);
        var t2 = row.insertCell(1);
        var t3 = row.insertCell(2);
        var t4 = row.insertCell(3);
        var t5 = row.insertCell(4);
        var t6 = row.insertCell(5);
        var t7 = row.insertCell(6);
        var t8 = row.insertCell(7);
        var t9 = row.insertCell(8);
        var t10 = row.insertCell(9);
        var t11 = row.insertCell(10);
        var t12 = row.insertCell(11);
        t1.style.padding = "0px";
        t2.style.padding = "0px";
        t3.style.padding = "0px";
        t4.style.padding = "0px";
        t5.style.padding = "0px";
        t6.style.padding = "0px";
        t7.style.padding = "0px";
        t8.style.padding = "0px";
        t9.style.padding = "0px";
        t10.style.padding = "0px";
        t11.style.padding = "0px";
        t12.style.padding = "0px";
        t1.innerHTML = '<input id="a1' + i + '" name="a1' + i + '" value="' + list[0] + '" type="text" disabled="disabled" class="td-input" />';
        t2.innerHTML = '<input id="mu' + i + '" name="mu' + i + '" type="text" value="' + list[1] + '" class="td-input" disabled="disabled"/>';
        t3.innerHTML = '<input id="equipment' + i + '" name="equipment' + i + '" type="number" value="' + list[2] + '" class="td-input" disabled="disabled"/>';
        t4.innerHTML = '<input id="technology' + i + '" name="technology' + i + '" type="text" value="' + list[3] + '" class="td-input" disabled="disabled"/>';
        t5.innerHTML = '<input id="type' + i + '" name="type' + i + '" type="text" value="' + list[4] + '" class="td-input" disabled="disabled"/>';
        t6.innerHTML = '<input id="energyField' + i + '" name="energyField' + i + '" type="text" value="' + list[5] + '" class="td-input" disabled="disabled"/>';
        t7.innerHTML = '<input id="ypj' + i + '" name="ypj' + i + '" type="text" value="' + list[6] + '" class="td-input" disabled="disabled"/>';
        t8.innerHTML = '<input id="jjj' + i + '" name="jjj' + i + '" type="text" value="' + list[7] + '" class="td-input" disabled="disabled"/>';
        t9.innerHTML = '<input id="jtj' + i + '" name="jtj' + i + '" type="text" value="' + list[8] + '" class="td-input" disabled="disabled"/>';
        t10.innerHTML = '<input id="czj' + i + '" name="czj' + i + '" type="text" value="' + list[9] + '" class="td-input" disabled="disabled"/>';
        t11.innerHTML = '<input id="childs' + i + '" name="childs' + i + '" type="text" value="' + list[10] + '" class="td-input" disabled="disabled"/>';
        //t12.innerHTML = '<a href="javascript:deleteField(' + i + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    }
    document.getElementById("aa").value = aa;
}
function getfieldinfo() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getallfieldinfo.ashx?treatmentID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.Item;
}
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
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
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}
function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}

function save() {   
    var form = new FormData(document.getElementById("saveField"));
    if (common == 1) {
        if (document.getElementById("Irradiation").value == "allItem") {
            window.alert("照射技术没有选择");
            return false;
        }
    }
    $.ajax({
        url: "saveField.ashx",
        type: "post",
        data: form,
        processData: false,
        async: false,
        contentType: false,
        success: function (data) {
            if (data == "success") {
                alert("保存成功");
                window.location.reload();
            } else {
                alert("保存失败");
                return false;
            }
            
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        },
        failure: function (e) {
            window.location.href = "Error.aspx";
        }
    });
}
function remove() {
    document.getElementById("id").removeAttribute("disabled");
    document.getElementById("pingyin").removeAttribute("disabled");
    document.getElementById("sure").removeAttribute("disabled");
    document.getElementById("tps").removeAttribute("disabled");
    document.getElementById("total").removeAttribute("disabled");
    document.getElementById("Graded").removeAttribute("disabled");
    document.getElementById("fieldTimes").removeAttribute("disabled");
    document.getElementById("pos").removeAttribute("disabled");
    if (common == 1) {
        document.getElementById("Irradiation").removeAttribute("disabled");
        document.getElementById("ener").removeAttribute("disabled");
        document.getElementById("IlluminatedNumber").removeAttribute("disabled");
        //document.getElementById("Illuminatedangle").readonly="false";
        document.getElementById("MachineNumbe").removeAttribute("disabled");
        document.getElementById("ControlPoint").removeAttribute("disabled");
        document.getElementById("Coplanar").removeAttribute("disabled");
        if (ss > 0) {
            for (var j = 1; j <= ss; j++) {
                document.getElementById("angle" + j).removeAttribute("disabled");
            }
        }
    }
    $("#add").attr("href", "javascript:addField()");
    if (aa > 0) {
        for (var i = 0; i < aa; i++) {
            document.getElementById("a1"+i).removeAttribute("disabled");
            document.getElementById("mu"+i).removeAttribute("disabled");
            document.getElementById("equipment"+i).removeAttribute("disabled");
            document.getElementById("technology"+i).removeAttribute("disabled");
            document.getElementById("type"+i).removeAttribute("disabled");
            document.getElementById("energyField"+i).removeAttribute("disabled");
            document.getElementById("ypj"+i).removeAttribute("disabled");
            document.getElementById("jjj"+i).removeAttribute("disabled");
            document.getElementById("jtj"+i).removeAttribute("disabled");
            document.getElementById("czj"+i).removeAttribute("disabled");
            document.getElementById("childs"+i).removeAttribute("disabled");
        }
    }
}
