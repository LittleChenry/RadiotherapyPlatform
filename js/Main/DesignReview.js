window.addEventListener("load", Init, false);

var userName;
var userID;
var signal = 0;
var signal1 = 0;
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
var treatID = window.location.search.split("=")[1];


var patient = getPatientInfo(treatID);
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

var progress = patient.Progress.split(",");
if (isInArray(progress, '11')) {
    var designInfo = getDesignInfo(treatID);
    var fieldInfo = getFieldInfo(treatID);
    var length = designInfo.length;
    for (var i = 0; i < length; i++) {
        if (designInfo[i].Treatmentname == patient.Treatmentname) {
            document.getElementById("positioninfomation1").innerHTML = designInfo[i].positioninfomation1;
            document.getElementById("dose1").innerHTML = cale(designInfo[i].DosagePriority);
            document.getElementById("Equipment1").innerHTML = designInfo[i].equipment;
            document.getElementById("plansystem1").innerHTML = designInfo[i].PlanSystem;
            document.getElementById("Coplanar1").innerHTML = charge1(designInfo[i].Coplanar1);
            document.getElementById("Irradiation1").innerHTML = designInfo[i].Irradiation1;
            document.getElementById("Raytype1").innerHTML = designInfo[i].Raytype;
            document.getElementById("energy1").innerHTML = designInfo[i].energy1;
            document.getElementById("IlluminatedNumber1").innerHTML = designInfo[i].IlluminatedNumber1;
            document.getElementById("Illuminatedangle1").innerHTML = designInfo[i].Illuminatedangle1;
            document.getElementById("MU1").innerHTML = designInfo[i].MU1;
            document.getElementById("ControlPoint1").innerHTML = designInfo[i].ControlPoint1;
            document.getElementById("positioninfomation2").innerHTML = fieldInfo[0].positioninfomation2;
            document.getElementById("dose2").innerHTML = fieldInfo[0].dose2;
            document.getElementById("Equipment2").innerHTML = fieldInfo[0].Equipment2;
            document.getElementById("plansystem2").innerHTML = fieldInfo[0].plansystem2;
            document.getElementById("remark").value = fieldInfo[0].remark;
            document.getElementById("Coplanar2").innerHTML = charge3(fieldInfo[0].Coplanar2);
            document.getElementById("Irradiation2").innerHTML = charge4(fieldInfo);
            document.getElementById("Raytype2").innerHTML = fieldInfo[0].Raytype2;
            document.getElementById("energy2").innerHTML = fieldInfo[0].energy2;
            document.getElementById("IlluminatedNumber2").innerHTML = fieldInfo[0].IlluminatedNumber2;
            document.getElementById("Illuminatedangle2").innerHTML = ruler(fieldInfo);
            document.getElementById("MU2").innerHTML = cale2(fieldInfo);
            document.getElementById("ControlPoint2").innerHTML = cale3(fieldInfo);
            document.getElementById("left").innerHTML = (designInfo[i].left == "")?"":(designInfo[i].left+"cm");
            document.getElementById("right").innerHTML = (designInfo[i].right == "")?"":(designInfo[i].right+"cm");
            document.getElementById("rise").innerHTML = (designInfo[i].rise == "")?"":(designInfo[i].rise+"cm");
            document.getElementById("drop").innerHTML = (designInfo[i].drop == "")?"":(designInfo[i].drop+"cm");
            document.getElementById("enter").innerHTML = (designInfo[i].enter == "")?"":(designInfo[i].enter+"cm");
            document.getElementById("out").innerHTML = (designInfo[i].out == "")?"":(designInfo[i].out+"cm");
        }
    }
    document.getElementById("userID").value = userID;
    document.getElementById("applyuser").innerHTML = userName;
    document.getElementById("time").innerHTML = getNowFormatDate();
    document.getElementById("hidetreatID").value = treatID;
    if (isInArray(progress, '12')) {
        var reviewInfo = getReviewInfo(treatID);       
                document.getElementById(plan(reviewInfo.PlanQA)).checked = true;
                document.getElementById("degree").value = reviewInfo.degree;
                document.getElementById("remark").value = reviewInfo.Remark;
                if(reviewInfo.sum=="1"){
                    document.getElementById("check1").innerHTML = "通过";
                    document.getElementById("check2").innerHTML = "通过";
                    document.getElementById("check3").innerHTML = "通过";
                    document.getElementById("check4").innerHTML = "通过";
                    document.getElementById("check5").innerHTML = "通过";
                    document.getElementById("check6").innerHTML = "通过";
                    document.getElementById("check7").innerHTML = "通过";
                    document.getElementById("check8").innerHTML = "通过";
                    document.getElementById("check9").innerHTML = "通过";
                    document.getElementById("check10").innerHTML = "通过";
                    document.getElementById("check11").innerHTML = "通过";
                    document.getElementById("check12").innerHTML = "通过";
                    document.getElementById("check13").innerHTML = "通过";
                    document.getElementById("check14").innerHTML = "通过";
                    document.getElementById("check15").innerHTML = "通过";
                    document.getElementById("applyuser").innerHTML = reviewInfo.name;
                    document.getElementById("time").innerHTML = reviewInfo.ReviewTime;
                    if (reviewInfo[i].userID == userID) {
                        window.parent.document.getElementById("edit").removeAttribute("disabled");
                    }
                
            }

        }
    }
}

function numSub(num1, num2) {
    var baseNum, baseNum1, baseNum2;
    try {
        baseNum1 = num1.toString().split(".")[1].length;
    } catch (e) {
        baseNum1 = 0;
    }
    try {
        baseNum2 = num2.toString().split(".")[1].length;
    } catch (e) {
        baseNum2 = 0;
    }
    baseNum = Math.pow(10, Math.max(baseNum1, baseNum2));
    var precision = (baseNum1 >= baseNum2) ? baseNum1 : baseNum2;
    return ((num1 * baseNum - num2 * baseNum) / baseNum).toFixed(precision);
}
function check() {
    var item = 1;
    signal = 1;
    if (document.getElementById("positioninfomation1").innerHTML == document.getElementById("positioninfomation2").innerHTML) {
        document.getElementById("check1").innerHTML = "通过";
    } else {
        item = 0;
        document.getElementById("check1").innerHTML = "不通过";
    }
    if (document.getElementById("dose1").innerHTML == document.getElementById("dose2").innerHTML) {
        document.getElementById("check2").innerHTML = "通过";
    }
    else {
        item = 0;
        document.getElementById("check2").innerHTML = "不通过";
    }
    if (document.getElementById("Equipment1").innerHTML == document.getElementById("Equipment2").innerHTML) {
        document.getElementById("check3").innerHTML = "通过";
    } else {
        item = 0;
        document.getElementById("check3").innerHTML = "不通过";
    }
    if (document.getElementById("plansystem1").innerHTML == document.getElementById("plansystem2").innerHTML) {
        document.getElementById("check4").innerHTML = "通过";
    } else {
        item = 0;
        document.getElementById("check4").innerHTML = "不通过";
    }
    if (document.getElementById("Coplanar1").innerHTML == document.getElementById("Coplanar2").innerHTML) {
        document.getElementById("check12").innerHTML = "通过";
    } else {
        item = 0;
        document.getElementById("check12").innerHTML = "不通过";
    }
    if (document.getElementById("Irradiation1").innerHTML == document.getElementById("Irradiation2").innerHTML) {
        document.getElementById("check5").innerHTML = "通过";
    } else {
        item = 0;
        document.getElementById("check5").innerHTML = "不通过";
    }
    if (document.getElementById("Raytype1").innerHTML == document.getElementById("Raytype2").innerHTML) {
        document.getElementById("check6").innerHTML = "通过";

    } else {
        item = 0;
        document.getElementById("check6").innerHTML = "不通过";
    }
    if (document.getElementById("energy1").innerHTML == document.getElementById("energy2").innerHTML) {
        document.getElementById("check7").innerHTML = "通过";

    } else {
        item = 0;
        document.getElementById("check7").innerHTML = "不通过";
    }
    if (document.getElementById("IlluminatedNumber1").innerHTML == document.getElementById("IlluminatedNumber2").innerHTML) {
        document.getElementById("check8").innerHTML = "通过";

    } else {
        item = 0;
        document.getElementById("check8").innerHTML = "不通过";
    }
    if (isequal()) {
        document.getElementById("check9").innerHTML = "通过";
    } else {
        item = 0;
        document.getElementById("check9").innerHTML = "不通过";
    }
    if (document.getElementById("MU1").innerHTML == document.getElementById("MU2").innerHTML) {
        document.getElementById("check10").innerHTML = "通过";
       
    } else {
        item = 0;
        document.getElementById("check10").innerHTML = "不通过";
    }
    if (document.getElementById("ControlPoint1").innerHTML == document.getElementById("ControlPoint2").innerHTML) {
        document.getElementById("check11").innerHTML = "通过";
        
    } else {
        item = 0;
        document.getElementById("check11").innerHTML = "不通过";

    }
    if (item == 0) {
        signal = 0;
    }
}
function isequal() {
    var str2 = document.getElementById("Illuminatedangle2").innerHTML;
    var str1 = document.getElementById("Illuminatedangle1").innerHTML;
    var array1 = new Array();
    array1 = str1.split(",");
    var array2 = new Array();
    array2 = str2.split(",");
    if (array1.length != array2.length) {
        return false;
    }
    var sign = new Array();
    for (var i = 0; i < array1.length; i++) {
        for (var j = 0; j < array2.length; j++) {
            if (array1[i]*1 == array2[j]*1) {
                sign[i] = 1;
                break;
            } else {
                sign[i] = 0;
            }
        }
    }
    for (var k = 0; k < sign.length; k++) {
        if (sign[k] == 0) {
            return false;
        }
    }
    return true;
}
function charge4(arr) {
    var count = 1;
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].Irradiation2;
    }
    var yuansu = new Array();
    var sum = new Array();
    for (var i = 0; i < array.length; i++) {
        for (var j = i + 1; j < array.length; j++) {
            if (array[i] == array[j]) {
                count++;
                array.splice(j, 1);
            }
        }
        yuansu[i] = array[i];
        sum[i] = count;
        count = 1;
    }
    var newsum = new Array();
    for (var item in sum) {
        newsum[item] = sum[item];
    }
    newsum.sort();
    for (var i = 0; i < sum.length; i++) {
        if (sum[i] == newsum[newsum.length - 1]) {
            return yuansu[i];
        }
    }
}
function confirm1(input, Button, cancelButton,confirm) {
    var content = input.innerHTML;
    if (content == "通过") {
        confirm.value = 1;
    }
    Button.style.display = "none";
    cancelButton.style.display = "block";
}

function cancelconfirm(input, Button, cancelButton,confirm) {
    var content = input.innerHTML;
    if (content == "取消通过") {
        confirm.value = 0;
    }
    Button.style.display = "block";
    cancelButton.style.display = "none";
}
function ruler(arr) {
    var array = new Array();
    var str = "";
    for (var item in arr) {
        array[item] = arr[item].Illuminatedangle2;
    }
    
    for (var i = 0; i < array.length-1; i++) {
        str = str+array[i]+","
    }
    str = str + array[array.length - 1];
    return str;
}
function cale2(arr) {
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].MU2 * 1;
    }
    var len = array.length;
    var sum = 0;
    for (var i = 0; i < len; i++) {
        sum += array[i];
    }
    sum = parseInt(sum * Math.pow(10, 6) + 0.5, 10) / Math.pow(10, 6);
    return sum;
}
function cale3(arr) {
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].ControlPoint2 * 1;
    }
    var len = array.length;
    var sum = 0;
    for (var i = 0; i < len; i++) {
        sum += array[i];
    }

    return sum;
}
//function createdegreeItem(thiselement) {
//    var PartItem = JSON.parse(getdegreeItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--优化程度选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getdegreeItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getdegree.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
//function createplaceinfoItem(thiselement) {
//    var PartItem = JSON.parse(getplaceinfoItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--信息选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getplaceinfoItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getplaceinfo.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
//function createdrrItem(thiselement) {
//    var PartItem = JSON.parse(getdrrItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--drr选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getdrrItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getdrr.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
//function createimportItem(thiselement) {
//    var PartItem = JSON.parse(getimportItem()).Item;
//    thiselement.options.length = 0;
//    thiselement.options[0] = new Option("--导出选择--");
//    thiselement.options[0].value = "allItem";
//    for (var i = 0; i < PartItem.length; i++) {
//        if (PartItem[i] != "") {
//            thiselement.options[i + 1] = new Option(PartItem[i].Name);
//            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
//        }
//    }


//}
////第二步部位项数据库调取
//function getimportItem() {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getimport.ashx";
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send();
//    var Items = xmlHttp.responseText;
//    return Items;
//}
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
}
function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}
function cale(str) {
    var lists = new Array();
    var dose = new Array();
    lists = str.split(";");
    var a = 0;
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        dose[a] = list[5];
        a++;
    }
    var max = 0;
    var len = dose.length;
    if (len = 1) {
        return lists[0].split(",")[3] + "/" + lists[0].split(",")[5];
    } else {
        for (var i = 1; i < len; i++) {
            if (dose[i] > max) {
                max = i;
            }
        }
        return lists[max].split(",")[3] + "/" + lists[max].split(",")[5];
    }
}
function getReviewInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "ReviewInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.reviewInfo[0];
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
}
function getFieldInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "FieldConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
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
function charge(evt) {
    if (evt == "0")
        return "不可执行";
    else
        return "可执行";
}
function charge1(evt) {
    if (evt == "0")
        return "不是";
    else
        return "是";
}
function charge3(evt) {
    if (evt == "0.0")
        return "不是";
    else
        return "是";
}
function charge2(evt) {
    if (evt == "0")
        return "不通过";
    else
        return "通过";
}
function getreference(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("ReferenceCenterX").value = Reference[0];
    document.getElementById("ReferenceCenterY").value = Reference[1];
    document.getElementById("ReferenceCenterZ").value = Reference[2];
}
function gettreatment(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("TreatmentCenterX").value = Reference[0];
    document.getElementById("TreatmentCenterY").value = Reference[1];
    document.getElementById("TreatmentCenterZ").value = Reference[2];
}
function getmovement(ReferenceCenter) {
    var Reference = ReferenceCenter.split(",");
    document.getElementById("MovementX").value = Reference[0];
    document.getElementById("MovementY").value = Reference[1];
    document.getElementById("MovementZ").value = Reference[2];
}
function save() {
    if (signal == 0) {
        window.alert("请核对正确");
        return false;
    }
    if (document.getElementById("TechnologyConfirm1").value == 0) {
        window.alert("请核对正确");
        return false;
    }
    if (document.getElementById("confirmPlanSystem1").value == 0) {
        window.alert("请核对正确");
        return false;
    }
    if (document.getElementById("EquipmentConfirm1").value == 0) {
        window.alert("请核对正确");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveReview"));
    $.ajax({
        url: "designReviewRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        async: false,
        contentType: false,
        success: function (data) {
            if (data == "success") {
                alert("保存成功");
            } else {
                alert("保存失败");
                return false;
            }
            window.location.reload();
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
    document.getElementById("confirm").removeAttribute("disabled");
    document.getElementById("confirmCoplanar").removeAttribute("disabled");
    document.getElementById("Button1").removeAttribute("disabled");
    document.getElementById("Button3").removeAttribute("disabled");
    document.getElementById("degree").removeAttribute("disabled");
    document.getElementById("fp_upload").removeAttribute("disabled");
    document.getElementById("fp_upload1").removeAttribute("disabled");
}
function plan(evt) {
    if (evt == "1")
        return "yes";
    else
        return "no";
}