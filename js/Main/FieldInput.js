
window.addEventListener("load", Init, false);
var userName;
var userID;
var treatID;
var fileName = "";
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
    document.getElementById("lightpart").innerHTML = patient.lightpartname;
}
$(".file").on("change", "input[type='file']", function () {
    var filePath=$(this).val();
    var arr=filePath.split('\\');
    fileName=arr[arr.length-1];
    $("#filename").val(fileName);
})
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
                createInformation(data.information);
                creaetField(data.details);
            }
        });
    });
});
function createInformation(data) {
    
    document.getElementById("tps").innerHTML = data[0].tps;   
    
    document.getElementById("Graded").innerHTML = data[0].once;
    document.getElementById("fieldTimes").innerHTML = data[0].fieldTimes;
    document.getElementById("pos").innerHTML = data[0].pos;
    document.getElementById("total").innerHTML = data[0].all;
}
function creaetField(data) {   
    var table = document.getElementById("Field");
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
        var tr = document.createElement("tr");
        for (var j = 0; j < 11; j++) {
            var td = document.createElement("td");            
            var textNode = document.createTextNode(list[j]);          
            td.appendChild(textNode);
            tr.appendChild(td);
        }
        var td = document.createElement("td");
        var textNode = document.createTextNode("");
        td.appendChild(textNode);
        tr.appendChild(td);
        tbody.appendChild(tr);
    }
    tbody.style.textAlign = "center";
    table.appendChild(tbody);
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