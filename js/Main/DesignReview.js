window.addEventListener("load", Init, false);

var userName;
var userID;
var signal = 0;
var signal1 = 0;
var role;
var item11 = 0;
function Init(evt) {

//获得当前执行人姓名与ID,
getUserName();
getUserID();
var session = getSession();
role = session.role;
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
document.getElementById("lightpart").innerHTML = patient.LightPart_ID;

var progress = patient.Progress.split(",");
if (isInArray(progress, '11')) {
    var designInfo = getDesignInfo(treatID);
    var fieldInfo = getFieldInfo(treatID);
    var length = designInfo.length;
    for (var i = 0; i < length; i++) {
        if (designInfo[i].Treatmentname == patient.Treatmentname) {
            document.getElementById("yes").checked = true;
            var $radio1 = $('input[name="planQA"]:eq(0)');
            var $radio2 = $('input[name="planQA"]:eq(1)');
            $radio2.bind('click', function () {
                document.getElementById("degree").disabled = "disabled";
                document.getElementById("remark").disabled = "disabled";
            });
            $radio1.bind('click', function () {
                if (document.getElementById("yes").disabled != "disabled") {
                    document.getElementById("degree").removeAttribute("disabled");
                    document.getElementById("remark").removeAttribute("disabled");
                }              
            });
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
            document.getElementById("pinyin1").innerHTML = designInfo[i].pinyin1;
            document.getElementById("radioID1").innerHTML = designInfo[i].radioID1;
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
            document.getElementById("IlluminatedNumber2").innerHTML = fieldInfo.length;
            document.getElementById("Illuminatedangle2").innerHTML = ruler(fieldInfo);
            document.getElementById("MU2").innerHTML = cale2(fieldInfo);
            document.getElementById("pinyin2").innerHTML = fieldInfo[0].pinyin2;
            document.getElementById("radioID2").innerHTML = fieldInfo[0].radioID2;
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
        item11 = 1;
        var reviewInfo = getReviewInfo(treatID);       
                document.getElementById(plan(reviewInfo.PlanQA)).checked = true;
                document.getElementById("degree").value = reviewInfo.degree;
                document.getElementById("remark").value = reviewInfo.Remark;
                if (reviewInfo.sum == "1") {
                    signal = 1;
                    document.getElementById("TechnologyConfirm1").value = 1;
                    document.getElementById("confirmPlanSystem1").value = 1;
                    document.getElementById("EquipmentConfirm1").value = 1;
                    document.getElementById("check1").innerHTML = "通过";
                    document.getElementById("check1").style.color = "#0000ff";
                    document.getElementById("check2").innerHTML = "通过";
                    document.getElementById("check2").style.color = "#0000ff";
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
                    document.getElementById("check97").innerHTML = "通过";
                    document.getElementById("check97").style.color = "#0000ff";
                    document.getElementById("check98").innerHTML = "通过";
                    document.getElementById("check98").style.color = "#0000ff";
                    document.getElementById("check99").innerHTML = "通过";
                    document.getElementById("check99").style.color = "#0000ff";
                    document.getElementById("check3").style.color = "#0000ff";
                    document.getElementById("check4").style.color = "#0000ff";
                    document.getElementById("check5").style.color = "#0000ff";
                    document.getElementById("check6").style.color = "#0000ff";
                    document.getElementById("check7").style.color = "#0000ff";
                    document.getElementById("check8").style.color = "#0000ff";
                    document.getElementById("check9").style.color = "#0000ff";
                    document.getElementById("check10").style.color = "#0000ff";
                    document.getElementById("check11").style.color = "#0000ff";
                    document.getElementById("check12").style.color = "#0000ff";
                    document.getElementById("check13").style.color = "#0000ff";
                    document.getElementById("check14").style.color = "#0000ff";
                    document.getElementById("applyuser").innerHTML = reviewInfo.name;
                    document.getElementById("time").innerHTML = reviewInfo.ReviewTime;
                    if (reviewInfo.PDF1 != "") {
                        var content = '<div class="group-item col-xs-3"><a href="' + reviewInfo.PDF1 + '"target="_blank"   class="btn btn-default">查看已传计划PDF文档</a></div>';
                        $("#firstplan").append(content);

                    }
                    if (reviewInfo.PDF2 != "") {
                        var content = '<div class="group-item col-xs-3"><a href="' + reviewInfo.PDF2 + '"target="_blank"   class="btn btn-default">查看已传复核PDF文档</a></div>';
                        $("#secondplan").append(content);

                    }
                }
                if (reviewInfo.userID == userID) {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
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
        document.getElementById("check1").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check1").innerHTML = "不通过";
        document.getElementById("check1").style.color = "#ff0000";
    }
    if (document.getElementById("dose1").innerHTML == document.getElementById("dose2").innerHTML) {
        document.getElementById("check2").innerHTML = "通过";
        document.getElementById("check2").style.color = "#0000ff";
    }
    else {
        item = 0;
        document.getElementById("check2").innerHTML = "不通过";
        document.getElementById("check2").style.color = "#ff0000";
    }
    var equipment = document.getElementById("Equipment1").innerHTML;
    var dreg = /(\d*)([a-z]*[A-Z]*)(\d*)/;
    dreg.exec(equipment);
    var deleteEChar = RegExp.$1 + RegExp.$3;
    if (deleteEChar == document.getElementById("Equipment2").innerHTML) {
        document.getElementById("check3").innerHTML = "通过";
        document.getElementById("check3").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check3").innerHTML = "不通过";
        document.getElementById("check3").style.color = "#ff0000";
    }
    if (document.getElementById("plansystem1").innerHTML == document.getElementById("plansystem2").innerHTML) {
        document.getElementById("check4").innerHTML = "通过";
        document.getElementById("check4").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check4").innerHTML = "不通过";
        document.getElementById("check4").style.color = "#ff0000";
    }
    if (document.getElementById("Coplanar1").innerHTML == document.getElementById("Coplanar2").innerHTML) {
        document.getElementById("check12").innerHTML = "通过";
        document.getElementById("check12").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check12").innerHTML = "不通过";
        document.getElementById("check12").style.color = "#ff0000";
    }
    if (document.getElementById("Irradiation1").innerHTML.toLowerCase() == document.getElementById("Irradiation2").innerHTML.toLowerCase()) {
        document.getElementById("check5").innerHTML = "通过";
        document.getElementById("check5").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check5").innerHTML = "不通过";
        document.getElementById("check5").style.color = "#ff0000";
    }
    if (document.getElementById("Raytype1").innerHTML == document.getElementById("Raytype2").innerHTML) {
        document.getElementById("check6").innerHTML = "通过";
        document.getElementById("check6").style.color = "#0000ff";

    } else {
        item = 0;
        document.getElementById("check6").innerHTML = "不通过";
        document.getElementById("check6").style.color = "#ff0000";
    }
    var enery = document.getElementById("energy1").innerHTML;
    var reg = /(\d*)([a-z]*[A-Z]*)(\d*)/;
    reg.exec(enery);
    var deleteChar = RegExp.$1 + RegExp.$3;
    if (deleteChar == parseInt(document.getElementById("energy2").innerHTML)) {
        document.getElementById("check7").innerHTML = "通过";
        document.getElementById("check7").style.color = "#0000ff";

    } else {
        item = 0;
        document.getElementById("check7").innerHTML = "不通过";
        document.getElementById("check7").style.color = "#ff0000";
    }
    if (document.getElementById("IlluminatedNumber1").innerHTML == document.getElementById("IlluminatedNumber2").innerHTML) {
        document.getElementById("check8").innerHTML = "通过";
        document.getElementById("check8").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check8").innerHTML = "不通过";
        document.getElementById("check8").style.color = "#ff0000";
    }
    if (isequal()) {
        document.getElementById("check9").innerHTML = "通过";
        document.getElementById("check9").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check9").innerHTML = "不通过";
        document.getElementById("check9").style.color = "#ff0000";
    }
    if (isequal1()) {
        document.getElementById("check10").innerHTML = "通过";
        document.getElementById("check10").style.color = "#0000ff";
       
    } else {
        item = 0;
        document.getElementById("check10").innerHTML = "不通过";
        document.getElementById("check10").style.color = "#ff0000";
    }
    if (document.getElementById("ControlPoint1").innerHTML == document.getElementById("ControlPoint2").innerHTML) {
        document.getElementById("check11").innerHTML = "通过";
        document.getElementById("check11").style.color = "#0000ff";
        
    } else {
        item = 0;
        document.getElementById("check11").innerHTML = "不通过";
        document.getElementById("check11").style.color = "#ff0000";

    }
    if (pinyinequal()) {
        document.getElementById("check13").innerHTML = "通过";
        document.getElementById("check13").style.color = "#0000ff";
    } else {
        item = 0;
        document.getElementById("check13").innerHTML = "不通过";
        document.getElementById("check13").style.color = "#ff0000";

    }
    if (document.getElementById("radioID1").innerHTML == document.getElementById("radioID2").innerHTML) {
        document.getElementById("check14").innerHTML = "通过";
        document.getElementById("check14").style.color = "#0000ff";

    } else {
        item = 0;
        document.getElementById("check14").innerHTML = "不通过";
        document.getElementById("check14").style.color = "#ff0000";

    }
    if (item == 0) {
        signal = 0;
    }
}
function pinyinequal() {
    var text = document.getElementById("pinyin1").innerHTML;
    var value = text.replace(/[^a-zA-Z]/ig, "");
    return value.toLowerCase() == document.getElementById("pinyin2").innerHTML.toLowerCase()
}
function isequal1() {
    var str1 = document.getElementById("MU1").innerHTML;
    var str2 = document.getElementById("MU2").innerHTML;
    var num1 = Math.round(str1 * 1);
    var num2 = Math.round(str2 * 1);
    if (num1 == num2) {
        return true;
    } else {
        return false;
    }
}
function force() {
    signal = 1;
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
    document.getElementById("check1").style.color = "#0000ff";
    document.getElementById("check2").style.color = "#0000ff";
    document.getElementById("check3").style.color = "#0000ff";
    document.getElementById("check4").style.color = "#0000ff";
    document.getElementById("check5").style.color = "#0000ff";
    document.getElementById("check6").style.color = "#0000ff";
    document.getElementById("check7").style.color = "#0000ff";
    document.getElementById("check8").style.color = "#0000ff";
    document.getElementById("check9").style.color = "#0000ff";
    document.getElementById("check10").style.color = "#0000ff";
    document.getElementById("check11").style.color = "#0000ff";
    document.getElementById("check12").style.color = "#0000ff";
    document.getElementById("check13").style.color = "#0000ff";
    document.getElementById("check14").style.color = "#0000ff";
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
            if (qq(array1[i],array2[j])) {
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
function qq(a1, a2) {
    if (isInArray(a1, "/")) {
        if (!isInArray(a2, "/")) {
            return false;
        } else {
            if (a1.split("/")[0]*1 == a2.split("/")[0]*1 && a1.split("/")[1]*1 == a2.split("/")[1]*1) {
                return true;
            } else {
                return false;
            }
        }
    } else {
        if (a1 * 1 == a2 * 1) {
            return true;
        } else {
            return false;
        }
    }
   
}
function charge4(arr) {
    var count = 1;
    var array = new Array();
    for (var item in arr) {
        array[item] = arr[item].Irradiation2;
    }
    var yuansu = new Array();
 
    for (var i = 0; i < array.length; i++) {
        if (array[i].toLowerCase() == "3DCRT".toLowerCase() || array[i].toLowerCase() == "Step and shot".toLowerCase() || array[i].toLowerCase() == "Static".toLowerCase()) {
            yuansu[i]= "Static";
        }
        if (array[i].toLowerCase() == "dMLC".toLowerCase() || array[i].toLowerCase() == "VMAT".toLowerCase() || array[i].toLowerCase() == "Dynamic".toLowerCase()) {
            yuansu[i] = "Dynamic";
        }
    }
    for (var j = 0; j < yuansu.length; j++) {
        if (yuansu[j] != yuansu[0]) {
            return "Dynamic,Static"
        }
    }
    return yuansu[0];
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
    if (role == "科主任") {
        document.getElementById("Forced").removeAttribute("disabled");
    }
    if (item11 == 0) {
        document.getElementById("confirmCoplanar").removeAttribute("disabled");
        document.getElementById("Button1").removeAttribute("disabled");
        document.getElementById("Button3").removeAttribute("disabled");
    }
    document.getElementById("degree").removeAttribute("disabled");
    document.getElementById("degree").removeAttribute("disabled");
    document.getElementById("remark").removeAttribute("disabled");
    var add = document.getElementsByName("planQA");
    add[0].removeAttribute("disabled");
    add[1].removeAttribute("disabled");
    document.getElementById("fp_upload1").removeAttribute("disabled");
    document.getElementById("fp_upload").removeAttribute("disabled");
}
function plan(evt) {
    if (evt == "1")
        return "yes";
    else
        return "no";
}