window.addEventListener("load", Init, false);

var obj = [];
var Items = "";
var isAllGood = true;

function Init() {
    var ItemSelect = document.getElementById("TreatmentItem");
    var changeItem = document.getElementById("changeTreatmentItem");
    createItemSelect(ItemSelect);//创建设备隶属治疗项目下拉菜单
    createItemSelect(changeItem);
    createEquipmentType();//设备类型菜单
    document.getElementById("insert").addEventListener("click", setInsert, false);
    var allLink = document.getElementsByClassName("selectedUpdate");
    for (var i = 0; i < allLink.length; i++) {
        allLink[i].addEventListener("click", EditEquipment, false);
    }
    document.getElementById("changefrm").addEventListener("submit", checkAll, false);
    document.getElementById("equipmentName").addEventListener("blur", checkEmpty, false);
    var allInput = document.getElementById("changefrm").getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("Time") > -1) {
            allInput[i].addEventListener("blur", checkTimes, false);
        }
    }
    document.getElementById("onceTime").addEventListener("blur", checkOnceTreat, false);
}

function createEquipmentType() {
    var select = document.getElementById("equipmentType");
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/getEquipmentType.ashx";
    xmlHttp.open("get", url, true);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var json = xmlHttp.responseText;
            var jsonObj = eval("(" + json + ")");
            for (var i = 0; i < jsonObj.length; ++i) {
                select.options[i] = new Option(jsonObj[i].type, jsonObj[i].id);
            }
        }
    }
    xmlHttp.send();
}

function Refresh(evt) {
    evt.preventDefault();
    window.location = 'Root-equipment.aspx';
}

//创建设备隶属治疗项目下拉菜单
function createItemSelect(thisElement) {
    getCurrentItem();//获取当前所有隶属治疗项目

    thisElement.options.length = 0;
    thisElement.options[0] = new Option("隶属项目");
    thisElement.options[0].value = "allItem";
    if (Items == "") {
        return;
    }
    var allItems = Items.split(" ");
    for (var i = 0; i < allItems.length; i++) {
        if (allItems[i] != "") {
            thisElement.options[i + 1] = new Option(allItems[i]);
            thisElement.options[i + 1].value = allItems[i];
        }
    }
}

//获取当前所有隶属治疗项目
function getCurrentItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getTreamentItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    Items = xmlHttp.responseText;
}

function EditEquipment(evt) {
    evt.preventDefault();
    var equipID = document.getElementById("equipID");
    var thisType = document.getElementById("formType");
    thisType.value = "update";
    var middleArea = document.getElementById("middleArea");
    var topArea = document.getElementById("topArea");
    var hidden = this.parentNode.getElementsByTagName("INPUT");
    var id = hidden[0].value;
    equipID.value = id;
    document.getElementById("currentPage").value = hidden[1].value;
    getEquipmentInformation(id);

    var type = hidden[2].value;

    $("#equipmentType").val(type);

    FillForm();
}

function getEquipmentInformation(id) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getEquipmentInformation.ashx?id=" + id;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    obj = eval("(" + json + ")");
}

function FillForm() {
    var nameText = document.getElementById("equipmentName");
    nameText.value = obj[0].Name;
    var stateText = document.getElementById("equipmentState");
    selectedByValue(stateText, obj[0].State);
    var onceTime = document.getElementById("onceTime");
    onceTime.value = obj[0].Timelength;
    var AMbeg = document.getElementById("AMbeg");
    AMbeg.value = transTime(obj[0].BeginTimeAM);
    var AMEnd = document.getElementById("AMEnd");
    AMEnd.value = transTime(obj[0].EndTimeAM);
    var PMBeg = document.getElementById("PMBeg");
    PMBeg.value = transTime(obj[0].BegTimePM);
    var PMEnd = document.getElementById("PMEnd");
    PMEnd.value = transTime(obj[0].EndTimePM);
    var changeTreatmentItem = document.getElementById("changeTreatmentItem");
    selectedByValue(changeTreatmentItem, obj[0].TreatmentItem);
    var nextday = document.getElementById("allowNext");
    if (parseInt(PMEnd.value.split(":")[0]) >= 24) {
        nextday.getElementsByTagName("OPTION")[1].selected = true;
        var newhor = parseInt(PMEnd.value.split(":")[0]) - 24;
        var newmin = PMEnd.value.split(":")[1];
        PMEnd.value = newhor + ":" + newmin;
    } else {
        nextday.getElementsByTagName("OPTION")[0].selected = true;
    }

}

//根据value选择select当前选项
function selectedByValue(select, value) {
    var thisOption = select.getElementsByTagName("OPTION");
    for (var i = 0; i < thisOption.length; i++) {
        if (thisOption[i].value == value) {
            thisOption[i].selected = true;
            break;
        }
    }
}

//时间转换
function transTime(time) {
    var thisTime = parseInt(time);
    var hour = parseInt(thisTime / 60);
    var minute = parseInt(thisTime - hour * 60);
    return (hour.toString() + ":" + (minute < 10 ? "0" : "") + minute.toString());
}

function Cannel(evt) {
    evt.preventDefault();
    var middleArea = document.getElementById("middleArea");
    var topArea = document.getElementById("topArea");
    middleArea.style.display = "none";
    topArea.style.display = "none";
}

function checkAll(evt) {
    isAllGood = true;
    document.getElementById("error").innerHTML = "";
    var allTag = this.getElementsByTagName('*');
    for (var i = 0; i < allTag.length; i++) {
        if (!checkElement(allTag[i])) {
            isAllGood = false;
        }
    }
    if (isAllGood == false) {
        evt.preventDefault();
    } else {
        evt.preventDefault();
        var datas = $("#changefrm").serialize();
        var type = $("#formType").val();
        $.ajax({
            type: "post",
            url: "../../pages/Root/handlerEquipment.ashx",
            data: datas,
            success: function () {
                if (type == "insert") {
                    alert("插入成功");
                } else {
                    alert("更新成功");
                }
                window.location.href = "../../pages/Root/Root-equipment.aspx";
            }
        });
    }
}

function checkElement(thisElement) {
    var backClassName = "";
    var allClassName = thisElement.className.split(" ");
    for (var i = 0; i < allClassName.length; i++) {
        backClassName += checkClassName(allClassName[i], thisElement) + " ";
    }
    thisElement.className = backClassName;
    if (backClassName.indexOf("invalid") > -1) {
        var error = document.getElementById("error");
        if (thisElement.className.indexOf("IsEmpty") > -1) {
            error.innerHTML = "设备名不能为空";
        } else if (thisElement.className.indexOf("OnceTreatment") > -1) {
            error.innerHTML = "请输入0-199的时间间隔(单位分钟)";
        } else if ((error.innerHTML == "") && thisElement.className.indexOf("Time") > -1) {
            error.innerHTML = "请输入正确的时间(格式 xx:xx)";
        } else if (thisElement.className.indexOf("treatItem") > -1) {
            error.innerHTML = "请选择隶属项目";
        }
        return false;
    }
    return true;
}

function checkClassName(name, thisElement) {
    var backString = "";
    switch (name) {
        case "":
        case "invalid":
            break;
        case "IsEmpty":
            if (isAllGood && (thisElement.value == "")) {
                backString += "invalid ";
            }
            backString += name;
            break;
        case "OnceTreatment":
            if (isAllGood && !checkOnceTime(thisElement)) {
                backString += "invalid ";
            }
            backString += name;
            break;
        case "Time":
            if (isAllGood && !checkTime(thisElement)) {
                backString += "invalid ";
            }
            backString += name;
            break;
        case "treatItem":
            if (isAllGood && (thisElement.selectedIndex == 0)) {
                backString += "invalid ";
            }
            backString += name;
            break;
        case "AMEnd":
            if (isAllGood && !checkAfterTime(thisElement, "AMbeg")) {
                backString += "invalid ";
                if (thisElement.id = "AMEnd") {
                    error.innerHTML = "上午结束时间必须在开始时间之后";
                }
                if (thisElement.id == "PMEnd" && $("#allowNext :selected").val() == "afternoon") {
                    error.innerHTML = "下午结束时间必须在开始时间之后";
                }
            }
            backString += name;
            break;
        case "PMEnd":
            if (isAllGood && !checkAfterTime(thisElement, "PMBeg") && $("#allowNext :selected").val() == "afternoon") {
                backString += "invalid ";
                if (thisElement.id = "AMEnd") {
                    error.innerHTML = "上午结束时间必须在开始时间之后";
                }
                if (thisElement.id == "PMEnd" && $("#allowNext :selected").val() == "afternoon") {
                    error.innerHTML = "下午结束时间必须在开始时间之后";
                }
            }
            backString += name;
            break;
        default:
            backString += name;
    }
    return backString;
}

function checkAfterTime(thisElement,pre) {
    var preTime = document.getElementById(pre).value;
    var afterTime = thisElement.value;
    var preHour = preTime.split(":")[0];
    var preMin = preTime.split(":")[1];
    var afterHour = afterTime.split(":")[0];
    var afterMin = afterTime.split(":")[1];
    if (preHour == afterHour) {
        return (parseInt(preMin) < parseInt(afterMin));
    } else if (parseInt(preHour) < parseInt(afterHour)) {
        return true;
    } else {
        return false;
    }
}

function checkOnceTime(thisElement) {
    var rep = /^([1]?\d{1,2})$/;
    return rep.test(thisElement.value);
}

function checkTime(thisElement) {
    var rep1 = /^([0-1]?\d):[0-5]\d$/;
    var rep2 = /2[0-3]:[0-5]\d$/;
    return (rep1.test(thisElement.value) || rep2.test(thisElement.value));
}

function removeClassName(thisElement, name) {
    var backString = "";
    var allName = thisElement.className.split(" ");
    for (var i = 0; i < allName.length; i++) {
        if (allName[i] != name) {
            backString += allName[i] + " ";
        }
    }
    thisElement.className = backString;
}

function checkEmpty() {
    var error = document.getElementById("error");
    if (this.value == "") {
        error.innerHTML = "设备名不能为空";
        this.className += " invalid";
    } else {
        error.innerHTML = "";
        removeClassName(this, "invalid");
    }
}

function checkTimes() {
    var error = document.getElementById("error");
    if (!checkTime(this)) {
        error.innerHTML = "请输入正确的时间(格式 xx:xx)";
        this.className += " invalid";
    } else {
        error.innerHTML = "";
        removeClassName(this, "invalid");
        if (this.id == "PMBeg" || (this.id == "PMEnd" && $("#allowNext :selected").val() == "afternoon")) {
            var time = this.value.split(":");
            var hour = time[0];
            if (parseInt(hour) < 12) {
                hour = (parseInt(hour) + 12).toString();
                this.value = hour + ":" + time[1];
            }
        }
        if (this.id == "AMEnd" && !checkAfterTime(this, "AMbeg")) {
            error.innerHTML = "上午结束时间必须在开始时间之后";
            this.className += " invalid";
        } else if (this.id == "PMEnd" && !checkAfterTime(this, "PMBeg") && $("#allowNext :selected").val() == "afternoon") {
            error.innerHTML = "下午结束时间必须在开始时间之后";
            this.className += " invalid";
        }
    }
}

function checkOnceTreat() {
    var error = document.getElementById("error");
    if (!checkOnceTime(this)) {
        error.innerHTML = "请输入0-199的时间间隔(单位分钟)";
        this.className += " invalid";
    } else {
        error.innerHTML = "";
        removeClassName(this, "invalid");
    }
}

function setInsert() {
    var thisType = document.getElementById("formType");
    thisType.value = "insert";
}