var isAllGood;//所有检查是否通过

var userName;
var userID;

window.addEventListener("load", Init, false);//添加页面加载处理函数

//初始化
function Init() {
    getUserID();
    getUserName();
    document.getElementById("save").addEventListener("click", CheckEmpty, false);
    document.getElementById("Number1").addEventListener("change", phoneFormat, false);//电话号码格式化
    document.getElementById("Number2").addEventListener("change", phoneFormat, false);//电话号码格式化
    var select3 = document.getElementById("SickPart");
    createPartItem(select3);
    var select4 = document.getElementById("doctor");
    createdoctorItem(select4);
    var select5 = document.getElementById("Sub");
    createSubcenterItem(select5);
    document.getElementById("userID").value = userID;
    document.getElementById("operate").innerHTML = userName;
    document.getElementById("date").innerHTML = getNowFormatDate();
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
//第二步诊断单中的分中心负责人选择项建立
function createSubcenterItem(thiselement) {
    var subcenterItem = JSON.parse(getsubcenterItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--分中心负责人--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < subcenterItem.length; i++) {
        if (subcenterItem[i] != "") {
            thiselement.options[i + 1] = new Option(subcenterItem[i].Name);
            thiselement.options[i + 1].value = parseInt(subcenterItem[i].ID);
        }
    }


}
//第二步分中心负责人数据库信息调取
function getsubcenterItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getsubcenter.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createdoctorItem(thiselement) {
    var doctorItem = JSON.parse(getdoctorItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----医生选择-----");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < doctorItem.length; i++) {
        if (doctorItem[i] != "") {
            thiselement.options[i + 1] = new Option(doctorItem[i].Name);
            thiselement.options[i + 1].value = parseInt(doctorItem[i].ID);
        }
    }
}
function getdoctorItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getdoctor.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
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
function createPartItem(thiselement) {
    var PartItem = JSON.parse(getPartItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--部位选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }
}
//第二步部位项数据库调取
function getPartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//检查各个输入项内容
function CheckEmpty() {

    if (document.getElementById("userName").value == "") {
        window.alert("姓名不能为空");
        return;
    }
    if (document.getElementsByName("Gender")[0].checked == false  && document.getElementsByName("Gender")[1].checked == false) {
        window.alert("性别不能为空");
        return;
    }
    if (document.getElementById("Nation").value == "") {
        window.alert("民族不能为空");
        return;
    }
    if (document.getElementById("IDcardNumber").value == "") {
        window.alert("身份证不能为空");
        return;
    }
    if (isCardNo()) {
        window.alert("身份证格式不正确");
        return;
    }
    if (document.getElementById("Birthday").value == "") {
        window.alert("出生日期不能为空");
        return;

    }   
    if (document.getElementById("Address").value == "") {
        window.alert("地址不能为空");
        return;
    }
    if (document.getElementById("Number1").value == "") {
        window.alert("电话1不能为空");
        return;
    }
    if (checkPhone()) {
        window.alert("电话1格式不正确");
        return;
    }
    if (document.getElementById("Number2").value == "") {
        window.alert("电话2不能为空");
        return;
    }
    if (checkPhone2()) {
        window.alert("电话2格式不正确");
        return;
    }
    if (document.getElementById("height").value == "") {
        window.alert("身高不能为空");
        return;
    }
    if (document.getElementById("weight").value == "") {
        window.alert("体重不能为空");
        return;
    }
    if (document.getElementById("RecordNumber").value == "") {
        window.alert("病案号不能为空");
        return;
    }
    if (document.getElementById("SickPart").value == "allItem") {
        window.alert("请选择患病部位");
        return;
    }
    if (document.getElementById("doctor").value == "allItem") {
        window.alert("请选择医生");
        return;
    }
    if (document.getElementById("Hospital").value == "") {
        window.alert("就诊医院不能为空");
        return;
    }  
    if (document.getElementById("Sub").value == "allItem") {
        window.alert("请选择分中心负责人");
        return;
    }  
    document.getElementById("frmaddpatient").submit();
}

//根据classname做对应的各项检查
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
function getUserID() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetUserID.ashx";
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
function getUserName() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetUserName.ashx";
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
function isCardNo() {
    // 身份证号码为15位或者18位，15位时全为数字，18位前17位为数字，最后一位是校验位，可能为数字或字符X  
    var card = document.getElementById("IDcardNumber").value;
    var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;
    if (!reg.test(card)) {
        return true;
    }
    return false;
}