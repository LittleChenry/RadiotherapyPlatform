
window.addEventListener("load", Init, false);
var userName;
var userID;
var treatID;
var fileName = "";
var common;
var currentTab;
function Init(evt) {

    //获得当前执行人姓名与ID
    getUserName();
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
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
    // if (common == 0) {
    //     //plan不用生成
    // } else {
    //     //全部生成
    // }
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '11')) {
        var fildinfo = getfieldinfo();
        //填写信息
        fillData(fildinfo);
        if (fildinfo[0].userID == userID) {
            window.parent.document.getElementById("edit").removeAttribute("disabled");
        }
    } else {
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
    }

    // $("#IlluminatedNumber").blur(function(){
    //     var num = $("#IlluminatedNumber").val();
    //     if (num > 0) {
    //         var table = $("#Illuminatedangle");
    //         table.html("");
    //         var tbody = "<tbody>";
    //         var count = 1;
    //         while(count <= num){
    //             var rownum = 0;
    //             tbody += "<tr>";
    //             while(rownum < 4){
    //                 if (count <= num) {
    //                     td = '<td style="padding:0px;"><input type="text" id="angle' + count + '" name="angle' + count + '" class="td-input"></td>';
    //                 }else{
    //                     td = '<td style="text-align:center;">/</td>';
    //                 }
    //                 tbody += td;
    //                 rownum += 1;
    //                 count += 1;
    //             }
    //             tbody += "</tr>";
    //         }
    //         tbody += "/tbody";
    //         table.append(tbody);
    //     }
    // });

    // $(".file").on("change", "input[type='file']", function () {
    //     var filePath=$(this).val();
    //     var arr=filePath.split('\\');
    //     fileName=arr[arr.length-1];
    //     $("#filename").val(fileName);
    // })
}
// function table(num, str) {
//     var list = new Array();
//     list=str.split(",");
//     if (num > 0) {
//         var table = $("#Illuminatedangle");
//         table.html("");
//         var tbody = "<tbody>";
//         var count = 1;
//         while (count <= num) {
//             var rownum = 0;
//             tbody += "<tr>";
//             while (rownum < 4) {
//                 if (count <= num) {
//                     td = '<td style="padding:0px;"><input type="text" id="angle' + count + '" name="angle' + count + '" class="td-input" value="'+list[count-1]+'" disabled="disabled"></td>';
//                 } else {
//                     td = '<td style="text-align:center;">/</td>';
//                 }
//                 tbody += td;
//                 rownum += 1;
//                 count += 1;
//             }
//             tbody += "</tr>";
//         }
//         tbody += "/tbody";
//         table.append(tbody);
//     }
// }
//生成照射技术下拉框，这名字错的
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
//从数据库获取照射技术
function getPartItem3() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Irradiation.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//生成能量下拉框
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
//从数据库获取能量
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
// function addField() {
//     var table = document.getElementById("Field");
//     var rows = table.rows.length;
//     var row = table.insertRow(rows);
//     rows--;
//     var t1 = row.insertCell(0);
//     var t2 = row.insertCell(1);
//     var t3 = row.insertCell(2);
//     var t4 = row.insertCell(3);
//     var t5 = row.insertCell(4);
//     var t6 = row.insertCell(5);
//     var t7 = row.insertCell(6);
//     var t8 = row.insertCell(7);
//     var t9 = row.insertCell(8);
//     var t10 = row.insertCell(9);
//     var t11 = row.insertCell(10);
//     var t12 = row.insertCell(11);
//     t1.style.padding = "0px";
//     t2.style.padding = "0px";
//     t3.style.padding = "0px";
//     t4.style.padding = "0px";
//     t5.style.padding = "0px";
//     t6.style.padding = "0px";
//     t7.style.padding = "0px";
//     t8.style.padding = "0px";
//     t9.style.padding = "0px";
//     t10.style.padding = "0px";
//     t11.style.padding = "0px";   
//     t12.style.cssText = "text-align: center;padding:0px;vertical-align: middle";
//     t12.id="delete" + rows;
//     t1.innerHTML = '<input id="a1' + rows + '" name="a1' + rows + '" type="text" class="td-input" />';
//     t2.innerHTML = '<input id="mu' + rows + '" name="mu' + rows + '" type="text" class="td-input" />';
//     t3.innerHTML = '<input id="equipment' + rows + '" name="equipment' + rows + '" type="number" onmousewheel="return false;" class="td-input" />';
//     t4.innerHTML = '<input id="technology' + rows + '" name="technology' + rows + '" type="text" class="td-input" />';
//     t5.innerHTML = '<input id="type' + rows + '" name="type' + rows + '" type="text" class="td-input" />';
//     t6.innerHTML = '<input id="energyField' + rows + '" name="energyField' + rows + '" type="text" class="td-input" />';
//     t7.innerHTML = '<input id="ypj' + rows + '" name="ypj' + rows + '" type="text" class="td-input" />';
//     t8.innerHTML = '<input id="jjj' + rows + '" name="jjj' + rows + '" type="text" class="td-input" />';
//     t9.innerHTML = '<input id="jtj' + rows + '" name="jtj' + rows + '" type="text" class="td-input" />';
//     t10.innerHTML = '<input id="czj' + rows + '" name="czj' + rows + '" type="text" class="td-input" />';
//     t11.innerHTML = '<input id="childs' + rows + '" name="childs' + rows + '" type="text" class="td-input" />';
//     t12.innerHTML = '<a href="javascript:deleteField(' + rows + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
//     aa = aa + 1;
//     document.getElementById("aa").value = aa;
// }
// function deleteField(row) {
//     var table = document.getElementById("Field");
//     var maxrow = table.rows.length;
//     //var row = Number(currentbutton.id.replace(/[^0-9]/ig, ""));
//     for (var i = row + 1; i < maxrow - 1; i++) {
//         var j = i - 1;
//         var td1 = document.getElementById("a1" + i);
//         td1.id = "a1" + j;
//         td1.name = "a1" + j;
//         var td2 = document.getElementById("mu" + i);
//         td2.id = "mu" + j;
//         td2.name = "mu" + j;
//         var td3 = document.getElementById("equipment" + i);
//         td3.id = "equipment" + j
//         td3.name = "equipment" + j;
//         var td4 = document.getElementById("technology" + i);
//         td4.id = "technology" + j;
//         td4.name = "technology" + j;
//         var td5 = document.getElementById("type" + i);
//         td5.id = "type" + j;
//         td5.name = "type" + j;
//         var td6 = document.getElementById("energyField" + i);
//         td6.id = "energyField" + j;
//         td6.name = "energyField" + j;
//         var td7 = document.getElementById("ypj" + i);
//         td7.id = "ypj" + j;
//         td7.name = "ypj" + j;
//         var td8 = document.getElementById("jjj" + i);
//         td8.id = "jjj" + j;
//         td8.name = "jjj" + j;
//         var td9 = document.getElementById("jtj" + i);
//         td9.id = "jtj" + j;
//         td9.name = "jtj" + j;
//         var td10 = document.getElementById("czj" + i);
//         td10.id = "czj" + j;
//         td10.name = "czj" + j;
//         var td11 = document.getElementById("childs" + i);
//         td11.id = "childs" + j;
//         td11.name = "childs" + j;

//         var td12 = document.getElementById("delete" + i);
//         td12.id = "delete" + j;
//         td12.innerHTML = '<a  href="javascript:deleteField(' + j + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';;
//     }
//     table.deleteRow(row + 1);
//     aa = aa - 1;
//     document.getElementById("aa").value = aa;
// }
// $(function () {
//     $("#sure").bind("click", function () {
//         if (fileName == "") {
//             return false;
//         }
//         var formDate = new FormData();
//         if ($("#file")[0].files[0] == null) {
//             formDate.append("exist", "false");
//         } else {
//             formDate.append("file", $("#file")[0].files[0]);
//             formDate.append("exist", "true");
//         }
//         $.ajax({
//             type: "post",
//             url: "../../Root/test.ashx",
//             data: formDate,
//             processData: false,
//             contentType: false,
//             success: function (data) {
//                 var data = $.parseJSON(data);               
//                 //if (document.getElementById("radiotherapy").innerHTML != data.information[0].id) {
//                 //    alert("文件选择错误");
//                 //    return false;
//                 //}
//                 createInformation(data.information);
//                 creaetField(data.details);
//             }
//         });
//     });
// });

//读取DCM文件填入射野信息里的基本信息
function createInformation(data,panelId) {
    document.getElementById("id"+panelId).value = data[0].id;
    document.getElementById("pingyin"+panelId).value = data[0].lastName + data[0].firstName;
    document.getElementById("tps"+panelId).value = data[0].tps;       
    document.getElementById("Graded"+panelId).value = data[0].once;
    document.getElementById("fieldTimes"+panelId).value = data[0].fieldTimes;
    document.getElementById("pos"+panelId).value = data[0].pos;
    document.getElementById("total"+panelId).value = data[0].all;
}
//读取DCM文件填入射野信息里的表格信息
function creaetField(data,panelId) {   
    var table = document.getElementById("Field"+panelId);
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
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
        t1.innerHTML = '<input id="a1' + i+"_"+panelId + '" name="a1' + i+"_"+panelId + '" value="' + list[0]+ '" type="text" class="td-input" />';
        t2.innerHTML = '<input id="mu' + i+"_"+panelId + '" name="mu' + i +"_"+panelId+ '" type="text" value="' + list[1] + '" class="td-input" />';
        t3.innerHTML = '<input id="equipment' + i +"_"+panelId+ '" name="equipment' + i +"_"+panelId+ '" type="number" onmousewheel="return false;" value="' + list[2] + '" class="td-input" />';
        t4.innerHTML = '<input id="technology' + i+"_"+panelId + '" name="technology' + i+"_"+panelId + '" type="text" value="' + list[3] + '" class="td-input" />';
        t5.innerHTML = '<input id="type' + i +"_"+panelId+ '" name="type' + i+"_"+panelId + '" type="text" value="' + list[4] + '" class="td-input" />';
        t6.innerHTML = '<input id="energyField' + i+"_"+panelId + '" name="energyField' + i+"_"+panelId + '" type="text" value="' + list[5] + '" class="td-input" />';
        t7.innerHTML = '<input id="ypj' + i+"_"+panelId + '" name="ypj' + i +"_"+panelId+ '" type="text" value="' + list[6] + '" class="td-input" />';
        t8.innerHTML = '<input id="jjj' + i+"_"+panelId + '" name="jjj' + i +"_"+panelId+ '" type="text" value="' + list[7] + '" class="td-input" />';
        t9.innerHTML = '<input id="jtj' + i +"_"+panelId+ '" name="jtj' + i+"_"+panelId + '" type="text" value="' + list[8] + '" class="td-input" />';
        t10.innerHTML = '<input id="czj' + i +"_"+panelId+ '" name="czj' + i +"_"+panelId+ '" type="text" value="' + list[9] + '" class="td-input" />';
        t11.innerHTML = '<input id="childs' + i +"_"+panelId+ '" name="childs' + i+"_"+panelId + '" type="text" value="' + list[10] + '" class="td-input" />';

        //t1.innerHTML = '<input id="a1' + rows+"_"+panelId + '" name="a1' + rows+"_"+panelId + '" type="text" class="td-input" />';
        //t12.innerHTML = '<a href="javascript:deleteField(' + i + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    }
    document.getElementById("aa"+panelId).value = data.length;
}

// function readField(data) {   
//     var table = document.getElementById("Field");
//     var tbody = document.createElement("tbody");
//     for (var i = table.rows.length - 1; i > 0; i--) {
//         table.deleteRow(i);
//     }
//     aa = data.length;
//     document.getElementById("fieldTimes").value = data.length;
//     for (var i = 0; i < data.length; i++) {
//         var list = new Array();
//         list[0] = data[i].code;
//         list[1] = data[i].mu;
//         list[2] = data[i].equipment;
//         list[3] = data[i].radiotechnique;
//         list[4] = data[i].radiotype;
//         list[5] = data[i].energy;
//         list[6] = data[i].wavedistance;
//         list[7] = data[i].angleframe;
//         list[8] = data[i].noseangle;
//         list[9] = data[i].bedrotation;
//         list[10] = data[i].subfieldnumber;
//         var row = table.insertRow(i + 1);
//         var t1 = row.insertCell(0);
//         var t2 = row.insertCell(1);
//         var t3 = row.insertCell(2);
//         var t4 = row.insertCell(3);
//         var t5 = row.insertCell(4);
//         var t6 = row.insertCell(5);
//         var t7 = row.insertCell(6);
//         var t8 = row.insertCell(7);
//         var t9 = row.insertCell(8);
//         var t10 = row.insertCell(9);
//         var t11 = row.insertCell(10);
//         var t12 = row.insertCell(11);
//         t1.style.padding = "0px";
//         t2.style.padding = "0px";
//         t3.style.padding = "0px";
//         t4.style.padding = "0px";
//         t5.style.padding = "0px";
//         t6.style.padding = "0px";
//         t7.style.padding = "0px";
//         t8.style.padding = "0px";
//         t9.style.padding = "0px";
//         t10.style.padding = "0px";
//         t11.style.padding = "0px";
//         t12.style.padding = "0px";
//         t1.innerHTML = '<input id="a1' + i + '" name="a1' + i + '" value="' + list[0] + '" type="text" disabled="disabled" class="td-input" />';
//         t2.innerHTML = '<input id="mu' + i + '" name="mu' + i + '" type="text" value="' + list[1] + '" class="td-input" disabled="disabled"/>';
//         t3.innerHTML = '<input id="equipment' + i + '" name="equipment' + i + '" type="number" onmousewheel="return false;" value="' + list[2] + '" class="td-input" disabled="disabled"/>';
//         t4.innerHTML = '<input id="technology' + i + '" name="technology' + i + '" type="text" value="' + list[3] + '" class="td-input" disabled="disabled"/>';
//         t5.innerHTML = '<input id="type' + i + '" name="type' + i + '" type="text" value="' + list[4] + '" class="td-input" disabled="disabled"/>';
//         t6.innerHTML = '<input id="energyField' + i + '" name="energyField' + i + '" type="text" value="' + list[5] + '" class="td-input" disabled="disabled"/>';
//         t7.innerHTML = '<input id="ypj' + i + '" name="ypj' + i + '" type="text" value="' + list[6] + '" class="td-input" disabled="disabled"/>';
//         t8.innerHTML = '<input id="jjj' + i + '" name="jjj' + i + '" type="text" value="' + list[7] + '" class="td-input" disabled="disabled"/>';
//         t9.innerHTML = '<input id="jtj' + i + '" name="jtj' + i + '" type="text" value="' + list[8] + '" class="td-input" disabled="disabled"/>';
//         t10.innerHTML = '<input id="czj' + i + '" name="czj' + i + '" type="text" value="' + list[9] + '" class="td-input" disabled="disabled"/>';
//         t11.innerHTML = '<input id="childs' + i + '" name="childs' + i + '" type="text" value="' + list[10] + '" class="td-input" disabled="disabled"/>';
//         //t12.innerHTML = '<a href="javascript:deleteField(' + i + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
//     }
//     document.getElementById("aa").value = aa;
// }
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

// function save() {   
//     var form = new FormData(document.getElementById("saveField"));
//     if (common == 1) {
//         if (document.getElementById("Irradiation").value == "allItem") {
//             window.alert("照射技术没有选择");
//             return false;
//         }
//         if (document.getElementById("ener").value == "allItem") {
//             window.alert("能量没有选择");
//             return false;
//         }
//         if (document.getElementById("IlluminatedNumber").value == "") {
//             window.alert("射野数量没有输入");
//             return false;
//         }
//         if (document.getElementById("MachineNumbe").value == "") {
//             window.alert("机器跳数没有输入");
//             return false;
//         }
//         if (document.getElementById("ControlPoint").value == "") {
//             window.alert("控制点数量没有输入");
//             return false;
//         }
//     }
//     $.ajax({
//         url: "saveField.ashx",
//         type: "post",
//         data: form,
//         processData: false,
//         async: false,
//         contentType: false,
//         success: function (data) {
//             if (data == "success") {
//                 alert("保存成功");
//                 window.location.reload();
//             } else {
//                 alert("保存失败");
//                 return false;
//             }
            
//         },
//         error: function (e) {
//             window.location.href = "Error.aspx";
//         },
//         failure: function (e) {
//             window.location.href = "Error.aspx";
//         }
//     });
// }
//消除disabled
function remove() {
    $("input").attr("disabled",false);
    $("input[name*='filename']").attr("disabled",true);
}
//--------------------------------------------------------------------------------------------
//子计划
//--------------------------------------------------------------------------------------------


//新增
$(function(){
    $("#addSubDesign").off("click").on("click",function () {
        if($("#subdesignname").val() == ""){
            alert("请输入子计划名称");
            return false;
        }
        // var howmanyLi = $("#designTab li").length;
        // $("#designTab li").removeClass("active");
        
        // var $tab = $('<li class="active"><a href="#tab' + howmanyLi + '" data-toggle="tab" aria-expanded="false">' + $("#subdesignname").val() +'</a></li>');
        // $("#designTab").append($tab);
        // createTabPanel(howmanyLi);
        var lastLi = $("#designTab li").last().children("a").attr("href");
        if(lastLi == undefined){
            var panelId = 0;
        }else{
            var panelId = parseInt(lastLi.substring(4))+1;
        }
        
        createLi(panelId);
        $("#subdesignname").val("子计划" + (panelId + 2));
    });
});
function createLi(panelId) {
    $("#designTab li").removeClass("active");
    $("#designTab li").removeClass("active");
        
    var $tab = $('<li class="active"><a href="#tab' + panelId + '" data-toggle="tab" aria-expanded="false">' + $("#subdesignname").val() +'</a></li>');
    $("#designTab").append($tab);
    createTabPanel(panelId);
    $("#subdesignname").val("子计划"+(panelId+2));
}

function createTabPanel(panelId) {
    $("#tabpanels").children().removeClass("active");
    if (common == 1) {
        var $div_tab = $("<div class='tab-pane active' id='tab" + panelId + "'></div>");
        var $aa = $("<input type='hidden' id='aa" + panelId + "' name='aa" + panelId + "'  value=0></input>");
        var $ss = $("<input type='hidden' id='ss" + panelId + "' name='ss" + panelId + "' value=0></input>");
        $aa.appendTo($div_tab);
        $ss.appendTo($div_tab);
        var $div_plan = $("<div id='plan" + panelId + "'></div>");
        var $div_papercontent = $("<div class='paper-content'></div>");

        var $div_0 = $("<div class='content-title'><span>计划信息：</span></div>");
        var $div_1 = $("<div class='single-row'>"
                    + "<div class='item col-xs-6'>"
                    + "照射技术：<select id='Irradiation" + panelId + "' name='Irradiation" + panelId + "' class='form-item'></select>"
                    + "</div>"
                    + "<div class='item col-xs-6'>"
                    + "能量：<select id='ener" + panelId + "' name='ener" + panelId + "' class='form-item'></select>"
                    + "</div>"
                    + "</div>");
        var $div_2 = $("<div class='single-row'>"
                    + "<div class='item col-xs-6'>"
                    + "射野数量：<input id='IlluminatedNumber" + panelId + "' name='IlluminatedNumber" + panelId + "' class='form-item' type='number' onmousewheel='return false;' name='IlluminatedNumber'/>"
                    + "</div>"
                    + "<div class='item col-xs-6'>"
                    + "非共面照射：<select id='Coplanar" + panelId + "' name='Coplanar" + panelId + "' class='form-item'><option value='0'>否</option><option value='1'>是</option></select>"
                    + "</div>"
                    + "</div>");

        var $div_3 = $("<div class='single-row'>"
                    + "<div class='item col-xs-6'>"
                    + "机器跳数：<input id='MachineNumbe" + panelId + "' class='form-item' type='number' onmousewheel='return false;' name='MachineNumbe" + panelId + "'/>"
                    + "</div>"
                    + "<div class='item col-xs-6'>"
                    + "控制点数量：<input id='ControlPoint" + panelId + "' class='form-item' type='number' onmousewheel='return false;' name='ControlPoint" + panelId + "'/>"
                    + "</div>"
                    + "</div>");
        var $div_4 = $("<div class='single-row'>"
                    + "<div class='item col-xs-6'>"
                    + "射野角度："
                    + "</div>"
                    + "</div>");

        var $div_5 = $("<div class='single-row'>"
                    + "<div class='col-xs-12'>"
                    + "<table id='Illuminatedangle" + panelId + "' class='table table-bordered' name='Illuminatedangle" + panelId + "'></table>"
                    + "</div>"
                    + "</div>");
        var $div_yc = $("<div class='single-row'>"
                    + "<div class='col-xs-6'>"
                    + "<span class='form-text col-xs-4' style='padding-left:0px;'>移床参数：</span>"
                    + "</div>"
                    + "</div>");
        var $div_yc_content1 = $("<div class='single-row'>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>左：</span>"
	                + "<div class='group-item'>"
	                + "<input id='left" + panelId + "' name='left" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>右：</span>"
	                + "<div class='group-item'>"
	                + "<input id='right" + panelId + "' name='right" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "</div>");
        var $div_yc_content2 = $("<div class='single-row'>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>升：</span>"
	                + "<div class='group-item'>"
	                + "<input id='rise" + panelId + "' name='rise" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>降：</span>"
	                + "<div class='group-item'>"
	                + "<input id='drop" + panelId + "' name='drop" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "</div>");
        var $div_yc_content3 = $("<div class='single-row'>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>进：</span>"
	                + "<div class='group-item'>"
	                + "<input id='enter" + panelId + "' name='enter" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>出：</span>"
	                + "<div class='group-item'>"
	                + "<input id='out" + panelId + "' name='out" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "</div>");

        $div_0.appendTo($div_papercontent);
        $div_1.appendTo($div_papercontent);
        $div_2.appendTo($div_papercontent);
        $div_3.appendTo($div_papercontent);
        $div_4.appendTo($div_papercontent);
        $div_5.appendTo($div_papercontent);
        $div_yc.appendTo($div_papercontent);
        $div_yc_content1.appendTo($div_papercontent);
        $div_yc_content2.appendTo($div_papercontent);
        $div_yc_content3.appendTo($div_papercontent);
        $div_papercontent.appendTo($div_plan);
        $div_plan.appendTo($div_tab);
        $div_tab.appendTo($("#tabpanels"));

        createPlanSystemItem(document.getElementById("Irradiation" + panelId));
        createenergyItem(document.getElementById("ener" + panelId));
        $("#IlluminatedNumber" + panelId).blur(function () {
            var num = $(this).val();
            if (num > 0) {
                var table = $("#Illuminatedangle" + panelId);
                table.html("");
                var tbody = "<tbody>";
                var count = 1;
                while (count <= num) {
                    var rownum = 0;
                    tbody += "<tr>";
                    while (rownum < 4) {
                        if (count <= num) {
                            td = '<td style="padding:0px;"><input type="text" id="angle' + count + "_" + panelId + '" name="angle' + count + "_" + panelId + '" class="td-input"></td>';
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
        });
        $('#left' + panelId).bind('input propertychange', function () {
            if (document.getElementById("left" + panelId).value == "") {
                document.getElementById("right" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("right" + panelId).disabled = "disabled";
            }
        });
        $('#right' + panelId).bind('input propertychange', function () {
            if (document.getElementById("right" + panelId).value == "") {
                document.getElementById("left" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("left" + panelId).disabled = "disabled";
            }
        });
        $('#drop' + panelId).bind('input propertychange', function () {
            if (document.getElementById("drop" + panelId).value == "") {
                document.getElementById("rise" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("rise" + panelId).disabled = "disabled";
            }
        });
        $('#rise' + panelId).bind('input propertychange', function () {
            if (document.getElementById("rise" + panelId).value == "") {
                document.getElementById("drop" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("drop" + panelId).disabled = "disabled";
            }
        });
        $('#enter' + panelId).bind('input propertychange', function () {
            if (document.getElementById("enter" + panelId).value == "") {
                document.getElementById("out" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("out" + panelId).disabled = "disabled";
            }
        });
        $('#out' + panelId).bind('input propertychange', function () {
            if (document.getElementById("out" + panelId).value == "") {
                document.getElementById("enter" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("enter" + panelId).disabled = "disabled";
            }
        });


        var $div_papercontent1 = $("<div class=paper-content></div>");
        var $div_6 = $("<div class='content-title'><span>射野信息：</span></div>");
        var $div_7 = $("<div class='single-row'>"
	                    + "<div class='col-xs-6'>"
	                    + "<div class='group-item' style='width: 80%;'>"
	                    + "<input id='filename" + panelId + "' class='form-control' type='text' name='filename" + panelId + "' style='border-radius: 4px 0px 0px 4px;' disabled='disabled'/>"
	                    + "<span class='input-group-btn'><a href='javascript:;' class='btn btn-info file'>选择文件<input type='file' id='file" + panelId + "'/></a></span>"
	                    + "</div>"
	                    + "</div>"
	                    + "<div class=col-xs-6>"
	                    + "<button class='btn btn-success' id='sure" + panelId + "' type='button'><i class='fa fa-fw fa-reply-all'></i>导入</button>"
	                    + "</div>"
	                    + "</div>");

        var $div_8 = $("<div class='single-row'>"
	                + "<div class='item col-xs-4'>"
	                + "放疗号：<input id='id" + panelId + "' class='form-item' name='id" + panelId + "'/>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "姓名拼音：<input id='pingyin" + panelId + "' class='form-item' name='pingyin" + panelId + "'/>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "TPS：<input id='tps" + panelId + "' class='form-item' name='tps" + panelId + "'/>"
	                + "</div>"
	                + "</div>");

        var $div_9 = $("<div class='single-row'>"
	                + "<div class='item col-xs-4'>"
	                + "总剂量：<div class='group-item'>"
	                + "<input id='total" + panelId + "' class='form-group-input' name='total" + panelId + "'/>"
	                + "<span class='input-group-addon'>cGy</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "分次剂量：<div class='group-item'>"
	                + "<input id='Graded" + panelId + "' class='form-group-input' name='Graded" + panelId + "'/>"
	                + "<span class='input-group-addon'>cGy</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "射野总数：<input id='fieldTimes" + panelId + "' class='form-item' name='fieldTimes" + panelId + "'/>"
	                + "</div>"
	                + "</div>");

        var $div_10 = $("<div class='single-row'>"
	                + "<div class='item col-xs-4'>"
	                + "摆位信息：<input id='pos" + panelId + "' class='form-item' name='pos" + panelId + "'/>"
	                + "</div>"
                    + "<div class='item col-xs-8'>"
	                + "限光筒：<input id='xianLeft" + panelId + "' style='width:12%' class='form-item' name='xianLeft" + panelId + "'/>"
                    + "&nbsp&nbspx&nbsp&nbsp <input id='xianRight" + panelId + "' style='width:12%' class='form-item' name='xianRight" + panelId + "'/>"
	                + "</div>"
	                + "</div>");

        var $div_11 = $("<div class='single-row'>"
	                + "<div class='col-xs-6' style='padding-left: 0px;'>"
	                + "<span class='form-text col-xs-5'>射野信息：</span>"
	                + "</div>"
	                + "</div>");

        var $div_12 = $("<div class='single-row'>"
	                + "<div class='item area-group col-xs-12'>"
	                + "<table id='Field" + panelId + "' class='table table-bordered'>"
	                + "<thead><tr>"
	                + "<th>射野ID</th><th>MU</th><th>放疗设备</th><th>照射技术</th><th>射野类型</th><th>能量</th><th>源皮距</th><th>机架角</th><th>机头角</th><th>床转交</th><th>子野数</th>"
	                + "<th style='text-align: center;'><a id='add" + panelId + "' href='javascript:;'><i class='fa fa-fw fa-plus-circle' style='font-size: 18px;'></i></a></th>"
	                + "</tr></thead>"
	                + "</table>"
	                + "</div>"
	                + "</div>");

        $div_6.appendTo($div_papercontent1);
        $div_7.appendTo($div_papercontent1);
        $div_8.appendTo($div_papercontent1);
        $div_9.appendTo($div_papercontent1);
        $div_10.appendTo($div_papercontent1);
        $div_11.appendTo($div_papercontent1);
        $div_12.appendTo($div_papercontent1);

        $div_papercontent1.appendTo($div_tab);
        $div_tab.appendTo($("#tabpanels"));

        $("#add" + panelId).off("click").on("click", function () {
            addFieldanother(panelId);
        });
        $(".file").on("change", "input[type='file']", function () {
            var filePath = $(this).val();
            var arr = filePath.split('\\');
            fileName = arr[arr.length - 1];
            $("#filename" + panelId).val(fileName);
        })
        $("#sure" + panelId).off("click").on("click", function () {
            if (fileName == "") {
                return false;
            }
            var formDate = new FormData();
            if ($("#file" + panelId)[0].files[0] == null) {
                formDate.append("exist", "false");
            } else {
                formDate.append("file", $("#file" + panelId)[0].files[0]);
                formDate.append("exist", "true");
            }
            $.ajax({
                type: "post",
                url: "../../Root/test.ashx",
                data: formDate,
                processData: false,
                contentType: false,
                success: function (data) {
                    var data = $.parseJSON(data);
                    //if (document.getElementById("radiotherapy").innerHTML != data.information[0].id) {
                    //    alert("文件选择错误");
                    //    return false;
                    //}
                    createInformation(data.information, panelId);
                    creaetField(data.details, panelId);
                }
            });
        });
    } else {
        var $div_tab = $("<div class='tab-pane active' id='tab" + panelId + "'></div>");
        var $aa = $("<input type='hidden' id='aa" + panelId + "' name='aa" + panelId + "'  value=0></input>");
        var $ss = $("<input type='hidden' id='ss" + panelId + "' name='ss" + panelId + "' value=0></input>");
        $aa.appendTo($div_tab);
        $ss.appendTo($div_tab);
        var $div_plan = $("<div id='plan" + panelId + "'></div>");
        var $div_papercontent = $("<div class='paper-content'></div>");

        var $div_0 = $("<div class='content-title'><span>计划信息：</span></div>");
        var $div_yc = $("<div class='single-row'>"
                    + "<div class='col-xs-6'>"
                    + "<span class='form-text col-xs-4' style='padding-left:0px;'>移床参数：</span>"
                    + "</div>"
                    + "</div>");
        var $div_yc_content1 = $("<div class='single-row'>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>左：</span>"
	                + "<div class='group-item'>"
	                + "<input id='left" + panelId + "' name='left" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' value='0'/>"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>右：</span>"
	                + "<div class='group-item'>"
	                + "<input id='right" + panelId + "' name='right" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "</div>");
        var $div_yc_content2 = $("<div class='single-row'>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>升：</span>"
	                + "<div class='group-item'>"
	                + "<input id='rise" + panelId + "' name='rise" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' value='0'/>"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='col-xs-6'>"
	                + "<span class='form-text col-xs-4'>降：</span>"
	                + "<div class='group-item'>"
	                + "<input id='drop" + panelId + "' name='drop" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
	                + "<span class='input-group-addon'>cm</span>"
	                + "</div>"
	                + "</div>"
	                + "</div>");
        var $div_yc_content3 = $("<div class='single-row'>"
                + "<div class='col-xs-6'>"
                + "<span class='form-text col-xs-4'>进：</span>"
                + "<div class='group-item'>"
                + "<input id='enter" + panelId + "' name='enter" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' value='0'/>"
                + "<span class='input-group-addon'>cm</span>"
                + "</div>"
                + "</div>"
                + "<div class='col-xs-6'>"
                + "<span class='form-text col-xs-4'>出：</span>"
                + "<div class='group-item'>"
                + "<input id='out" + panelId + "' name='out" + panelId + "' type='number' onmousewheel='return false;' class='form-group-input' />"
                + "<span class='input-group-addon'>cm</span>"
                + "</div>"
                + "</div>"
                + "</div>");

        $div_0.appendTo($div_papercontent);
        $div_yc.appendTo($div_papercontent);
        $div_yc_content1.appendTo($div_papercontent);
        $div_yc_content2.appendTo($div_papercontent);
        $div_yc_content3.appendTo($div_papercontent);
        $div_papercontent.appendTo($div_plan);
        $div_plan.appendTo($div_tab);
        $div_tab.appendTo($("#tabpanels"));
        $('#left' + panelId).bind('input propertychange', function () {
            if (document.getElementById("left" + panelId).value == "") {
                document.getElementById("right" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("right" + panelId).disabled = "disabled";
            }
        });
        $('#right' + panelId).bind('input propertychange', function () {
            if (document.getElementById("right" + panelId).value == "") {
                document.getElementById("left" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("left" + panelId).disabled = "disabled";
            }
        });
        $('#drop' + panelId).bind('input propertychange', function () {
            if (document.getElementById("drop" + panelId).value == "") {
                document.getElementById("rise" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("rise" + panelId).disabled = "disabled";
            }
        });
        $('#rise' + panelId).bind('input propertychange', function () {
            if (document.getElementById("rise" + panelId).value == "") {
                document.getElementById("drop" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("drop" + panelId).disabled = "disabled";
            }
        });
        $('#enter' + panelId).bind('input propertychange', function () {
            if (document.getElementById("enter" + panelId).value == "") {
                document.getElementById("out" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("out" + panelId).disabled = "disabled";
            }
        });
        $('#out' + panelId).bind('input propertychange', function () {
            if (document.getElementById("out" + panelId).value == "") {
                document.getElementById("enter" + panelId).removeAttribute("disabled");
            } else {
                document.getElementById("enter" + panelId).disabled = "disabled";
            }
        });


        var $div_papercontent1 = $("<div class=paper-content></div>");
        var $div_6 = $("<div class='content-title'><span>射野信息：</span></div>");
        var $div_7 = $("<div class='single-row'>"
	                + "<div class='item col-xs-4'>"
	                + "射野总数：<input id='fieldTimes" + panelId + "' class='form-item' name='fieldTimes" + panelId + "'/>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "TPS：<input id='tps" + panelId + "' class='form-item' name='tps" + panelId + "' value='Monaco'/>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "摆位信息：<input id='pos" + panelId + "' class='form-item' name='pos" + panelId + "'/>"
	                + "</div>"
	                + "</div>");

        var $div_10 = $("<div class='single-row'>"
	                + "<div class='item col-xs-4'>"
	                + "总剂量：<div class='group-item'>"
	                + "<input id='total" + panelId + "' class='form-group-input' name='total" + panelId + "'/>"
	                + "<span class='input-group-addon'>cGy</span>"
	                + "</div>"
	                + "</div>"
	                + "<div class='item col-xs-4'>"
	                + "分次剂量：<div class='group-item'>"
	                + "<input id='Graded" + panelId + "' class='form-group-input' name='Graded" + panelId + "'/>"
	                + "<span class='input-group-addon'>cGy</span>"
	                + "</div>"
	                + "</div>"
                    + "<div class='item col-xs-4'>"
	                + "限光筒：<input id='xianLeft" + panelId + "' style='width:20%' class='form-item' name='xianLeft" + panelId + "'/>"
                    + "&nbsp&nbspx&nbsp&nbsp <input id='xianRight" + panelId + "' style='width:20%' class='form-item' name='xianRight" + panelId + "'/>"
	                + "</div>"
	                + "</div>");

        var $div_8 = $("<div class='single-row'>"
	                + "<div class='col-xs-6' style='padding-left: 0px;'>"
	                + "<span class='form-text col-xs-5'>射野信息：</span>"
	                + "</div>"
	                + "</div>");

        var $div_9 = $("<div class='single-row'>"
	                + "<div class='item area-group col-xs-12'>"
	                + "<table id='Field" + panelId + "' class='table table-bordered'>"
	                + "<thead><tr>"
	                + "<th>射野ID</th><th>MU</th><th>放疗设备</th><th>照射技术</th><th>射野类型</th><th>能量</th><th>源皮距</th><th>机架角</th><th>机头角</th><th>床转交</th><th>子野数</th>"
	                + "<th style='text-align: center;'><a id='add" + panelId + "' href='javascript:;'><i class='fa fa-fw fa-plus-circle' style='font-size: 18px;'></i></a></th>"
	                + "</tr></thead>"
	                + "</table>"
	                + "</div>"
	                + "</div>");

        $div_6.appendTo($div_papercontent1);
        $div_7.appendTo($div_papercontent1);
        $div_10.appendTo($div_papercontent1);
        $div_8.appendTo($div_papercontent1);
        $div_9.appendTo($div_papercontent1);

        $div_papercontent1.appendTo($div_tab);
        $div_tab.appendTo($("#tabpanels"));

        $("#add" + panelId).off("click").on("click", function () {
            addFieldanother(panelId);
        });
        dosageData(panelId);
        //createTPS(document.getElementById("tps"+panelId));
        //createPOS(document.getElementById("pos"+panelId));
    }
}
function dosageData(panelId) {
    var id = window.location.search.split("=")[1];
    $.ajax({
        url: "getDosage.ashx",
        type: "post",
        async:false,
        data: {
            treatID: id
        },
        success: function (data) {
            var lists = new Array();
            var dose = new Array();
            lists = data.split(";");
            var a = 0;
            for (var i = 0; i < lists.length-1; i++) {
                var list = new Array();
                list = lists[i].split(",");
                dose[a] = list[5];
                a++;
            }
            var max = 0;
            var len = dose.length;
            if (len = 1) {
                $("#total"+panelId).val(lists[0].split(",")[3]);
                $("#Graded" + panelId).val(lists[0].split(",")[5]);
            } else {
                for (var i = 1; i < len; i++) {
                    if (dose[i] > max) {
                        max = i;
                    }
                }
                $("#total" + panelId).val(lists[0].split(",")[3]);
                $("#Graded" + panelId).val(lists[0].split(",")[5]);
            }
        }
    });

}

function createTPS(thiselement) {
    var PartItem = JSON.parse(getTPS()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--TPS选择--");
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

function getTPS() {
    var xmlHttp = new XMLHttpRequest();
    var url = "PlanSystem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function createPOS(thiselement) {
    var data = JSON.parse(getPOS());
    var PartItem = data.Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--摆位信息--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }
    if (data.defaultItem != "") {
        thiselement.value = data.defaultItem.ID;
    }
}

function getPOS() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getbodypost.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function addFieldanother(panelId) {
    var table = document.getElementById("Field"+panelId);
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
    t12.id="delete" + rows+"_"+panelId;
    t1.innerHTML = '<input id="a1' + rows+"_"+panelId + '" name="a1' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t2.innerHTML = '<input id="mu' + rows+"_"+panelId + '" name="mu' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t3.innerHTML = '<input id="equipment' + rows+"_"+panelId + '" name="equipment' + rows+"_"+panelId + '" type="number" onmousewheel="return false;" class="td-input" />';
    t4.innerHTML = '<input id="technology' + rows+"_"+panelId + '" name="technology' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t5.innerHTML = '<input id="type' + rows+"_"+panelId + '" name="type' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t6.innerHTML = '<input id="energyField' + rows+"_"+panelId + '" name="energyField' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t7.innerHTML = '<input id="ypj' + rows+"_"+panelId + '" name="ypj' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t8.innerHTML = '<input id="jjj' + rows+"_"+panelId + '" name="jjj' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t9.innerHTML = '<input id="jtj' + rows+"_"+panelId + '" name="jtj' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t10.innerHTML = '<input id="czj' + rows+"_"+panelId + '" name="czj' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t11.innerHTML = '<input id="childs' + rows+"_"+panelId + '" name="childs' + rows+"_"+panelId + '" type="text" class="td-input" />';
    t12.innerHTML = '<a href="javascript:deleteFieldanother(' + rows + ',' + panelId +');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    $("#aa"+panelId).val(parseInt($("#aa"+panelId).val())+1);
}
function deleteFieldanother(row,panelId) {
    var table = document.getElementById("Field"+panelId);
    var maxrow = table.rows.length;
    for (var i = row + 1; i < maxrow - 1; i++) {
        var j = i - 1;
        var td1 = document.getElementById("a1" + i+"_"+panelId);
        td1.id = "a1" + j+"_"+panelId;
        td1.name = "a1" + j+"_"+panelId;
        var td2 = document.getElementById("mu" + i+"_"+panelId);
        td2.id = "mu" + j+"_"+panelId;
        td2.name = "mu" + j+"_"+panelId;
        var td3 = document.getElementById("equipment" + i+"_"+panelId);
        td3.id = "equipment" + j+"_"+panelId;
        td3.name = "equipment" + j+"_"+panelId;
        var td4 = document.getElementById("technology" + i+"_"+panelId);
        td4.id = "technology" + j+"_"+panelId;
        td4.name = "technology" + j+"_"+panelId;
        var td5 = document.getElementById("type" + i+"_"+panelId);
        td5.id = "type" + j+"_"+panelId;
        td5.name = "type" + j+"_"+panelId;
        var td6 = document.getElementById("energyField" + i+"_"+panelId);
        td6.id = "energyField" + j+"_"+panelId;
        td6.name = "energyField" + j+"_"+panelId;
        var td7 = document.getElementById("ypj" + i+"_"+panelId);
        td7.id = "ypj" + j+"_"+panelId;
        td7.name = "ypj" + j+"_"+panelId;
        var td8 = document.getElementById("jjj" + i+"_"+panelId);
        td8.id = "jjj" + j+"_"+panelId;
        td8.name = "jjj" + j+"_"+panelId;
        var td9 = document.getElementById("jtj" + i+"_"+panelId);
        td9.id = "jtj" + j+"_"+panelId;
        td9.name = "jtj" + j+"_"+panelId;
        var td10 = document.getElementById("czj" + i+"_"+panelId);
        td10.id = "czj" + j+"_"+panelId;
        td10.name = "czj" + j+"_"+panelId;
        var td11 = document.getElementById("childs" + i+"_"+panelId);
        td11.id = "childs" + j+"_"+panelId;
        td11.name = "childs" + j+"_"+panelId;

        var td12 = document.getElementById("delete" + i+"_"+panelId);
        td12.id = "delete" + j+"_"+panelId;
        td12.innerHTML = '<a href="javascript:deleteFieldanother(' + row + ',' + panelId +');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    }
    table.deleteRow(row + 1);
    $("#aa"+panelId).val(parseInt($("#aa"+panelId).val())-1);
}

function save() {
    var flag = saveSub();
    if (flag == false) {
        return false;
    }
}

function saveSub() {
    
    var whichTabStr = $("#tabpanels").children(".active").attr("id");
    var whichTab = whichTabStr.substring(3);
    if ($("#left" + whichTab).val() == "" && $("#right" + whichTab).val() == "") {
        alert("移床参数未填写完整");
        return false;
    }
    if ($("#rise" + whichTab).val() == "" && $("#drop" + whichTab).val() == "") {
        alert("移床参数未填写完整");
        return false;
    }
    if ($("#enter" + whichTab).val() == "" && $("#out" + whichTab).val() == "") {
        alert("移床参数未填写完整");
        return false;
    }
    var form = new FormData(document.getElementById("saveField"));
    form.append("item", whichTab);
    form.append("DesignName"+whichTab,$("#designTab").children("ul .active").find("a").text());
    if (common == 1) {
        if (document.getElementById("Irradiation"+whichTab).value == "allItem") {
            window.alert("照射技术没有选择");
            return false;
        }
        if (document.getElementById("ener"+whichTab).value == "allItem") {
            window.alert("能量没有选择");
            return false;
        }
        if (document.getElementById("IlluminatedNumber"+whichTab).value == "") {
            window.alert("射野数量没有输入");
            return false;
        }
        if (document.getElementById("MachineNumbe"+whichTab).value == "") {
            window.alert("机器跳数没有输入");
            return false;
        }
        if (document.getElementById("ControlPoint"+whichTab).value == "") {
            window.alert("控制点数量没有输入");
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
                alert("子计划："+$("#designTab").children("ul .active").find("a").text()+" 保存成功");
                //
                $("#edit",window.parent.document).attr("disabled",false);
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
function fillData(data) {
    var tabNum = 0;
    var dataFinal = new Array();
    for(var i = 0; i < data.length; i++){
        if(parseInt(data[i].item) > tabNum){
            tabNum = parseInt(data[i].item);
        }
    }
    for(var i = 0; i <= tabNum; i++){
        var temp = new Array();
        dataFinal.push(temp);
    }

    for(var i = 0; i < data.length; i++){
        dataFinal[parseInt(data[i].item)].push(data[i]);
    }

    //模拟点击事件，生成tab
    for(var i = 0; i < dataFinal.length; i++){
        if(dataFinal[i].length == 0){
            continue;
        }
        $("#subdesignname").val(dataFinal[i][0].DesignName);
        createLi(i);
        //填写内容
        if(common == 1){
            $("#Irradiation"+i).val(dataFinal[i][0].Irradiation);
            $("#ener"+i).val(dataFinal[i][0].energy2);
            $("#IlluminatedNumber"+i).val(dataFinal[i][0].IlluminatedNumber);
            $("#Coplanar"+i).val(dataFinal[i][0].Coplanar);
            $("#MachineNumbe"+i).val(dataFinal[i][0].MachineNumbe);
            $("#ControlPoint"+i).val(dataFinal[i][0].ControlPoint);
            
            table(dataFinal[i][0].IlluminatedNumber,dataFinal[i][0].Illuminatedangle,dataFinal[i][0].item);
        }
        $("#left"+i).val(dataFinal[i][0].left);
        $("#right"+i).val(dataFinal[i][0].right);
        $("#rise"+i).val(dataFinal[i][0].rise);
        $("#out"+i).val(dataFinal[i][0].out);
        $("#enter"+i).val(dataFinal[i][0].enter);
        $("#drop"+i).val(dataFinal[i][0].drop);
        $("#pingyin"+i).val(dataFinal[i][0].pinyin);
        $("#id"+i).val(dataFinal[i][0].radioID);
        $("#tps"+i).val(dataFinal[i][0].tps);
        $("#pos"+i).val(dataFinal[i][0].pos);
        $("#Graded" + i).val(dataFinal[i][0].Singledose);
        $("#xianLeft" + i).val(dataFinal[i][0].xianleft);
        $("#xianRight" + i).val(dataFinal[i][0].xianright);
        $("#total"+i).val(dataFinal[i][0].Totaldose);
        $("#applyuser").html(dataFinal[i][0].Name);
        $("#time").html(dataFinal[i][0].time);
        readField(dataFinal[i],dataFinal[i][0].item);

        $("input").attr("disabled",true);
    }
}
//射野角度表格生成
function table(num, str,panelId) {
    var list = new Array();
    list=str.split(",");
    if (num > 0) {
        var table = $("#Illuminatedangle"+panelId);
        table.html("");
        var tbody = "<tbody>";
        var count = 1;
        while (count <= num) {
            var rownum = 0;
            tbody += "<tr>";
            while (rownum < 4) {
                if (count <= num) {
                    td = '<td style="padding:0px;"><input type="text" id="angle' + count+"_"+panelId + '" name="angle' + count+"_"+panelId+ '" class="td-input" value="'+list[count-1]+'" disabled="disabled"></td>';
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

function readField(data,panelId) {   
    var table = document.getElementById("Field"+panelId);
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
    aa = data.length;
    document.getElementById("fieldTimes"+panelId).value = data.length;
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
        t1.innerHTML = '<input id="a1' + i+"_"+panelId + '" name="a1' + i +"_"+panelId+ '" value="' + list[0] + '" type="text" disabled="disabled" class="td-input" />';
        t2.innerHTML = '<input id="mu' + i+"_"+panelId + '" name="mu' + i +"_"+panelId+ '" type="text" value="' + list[1] + '" class="td-input" disabled="disabled"/>';
        t3.innerHTML = '<input id="equipment' + i +"_"+panelId+ '" name="equipment' + i +"_"+panelId+ '" type="number" onmousewheel="return false;" value="' + list[2] + '" class="td-input" disabled="disabled"/>';
        t4.innerHTML = '<input id="technology' + i +"_"+panelId+ '" name="technology' + i +"_"+panelId+ '" type="text" value="' + list[3] + '" class="td-input" disabled="disabled"/>';
        t5.innerHTML = '<input id="type' + i +"_"+panelId+ '" name="type' + i +"_"+panelId+ '" type="text" value="' + list[4] + '" class="td-input" disabled="disabled"/>';
        t6.innerHTML = '<input id="energyField' + i +"_"+panelId+ '" name="energyField' + i +"_"+panelId+ '" type="text" value="' + list[5] + '" class="td-input" disabled="disabled"/>';
        t7.innerHTML = '<input id="ypj' + i +"_"+panelId+ '" name="ypj' + i +"_"+panelId+ '" type="text" value="' + list[6] + '" class="td-input" disabled="disabled"/>';
        t8.innerHTML = '<input id="jjj' + i +"_"+panelId+ '" name="jjj' + i +"_"+panelId+ '" type="text" value="' + list[7] + '" class="td-input" disabled="disabled"/>';
        t9.innerHTML = '<input id="jtj' + i +"_"+panelId+ '" name="jtj' + i +"_"+panelId+ '" type="text" value="' + list[8] + '" class="td-input" disabled="disabled"/>';
        t10.innerHTML = '<input id="czj' + i +"_"+panelId+ '" name="czj' + i +"_"+panelId+ '" type="text" value="' + list[9] + '" class="td-input" disabled="disabled"/>';
        t11.innerHTML = '<input id="childs' + i +"_"+panelId+ '" name="childs' + i +"_"+panelId+ '" type="text" value="' + list[10] + '" class="td-input" disabled="disabled"/>';
        //t12.innerHTML = '<a href="javascript:deleteField(' + i + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    }
    document.getElementById("aa"+panelId).value = data.length;
}

$(function(){
    $("#saveSubDesign").off("click").on("click",function(){
        saveSub();
    });
});