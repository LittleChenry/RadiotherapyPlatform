var isAllGood;//所有检查是否通过

var userName;
var userID;
var docandgroup;
window.addEventListener("load", Init, false);//添加页面加载处理函数

//初始化
function Init() {
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var session = getSession();
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
         $("#Menu-EquipmentView").attr("href", "javascript:;");
         $("#Menu-EquipmentView").bind("click", function(){
            alert("权限不够！");
         });
    }
    getUserName();
    document.getElementById("save").addEventListener("click", CheckEmpty, false);
    getdoctorandgroup();
    var select4 = document.getElementById("doctor");
    createdoctorItem(select4);
    select4.addEventListener("change", function () {
        createselect2(select4.selectedIndex);
    }, false);
    document.getElementById("userID").value = userID;
    document.getElementById("operate").innerHTML = userName;
    document.getElementById("date").innerHTML = getNowFormatDate();
    var $radio1 = $('input[name="RecordNumber"]:eq(0)');
    var $radio2 = $('input[name="RecordNumber"]:eq(1)');
    $radio2.bind('click', function () {
        $('#ishospital').css("display", "none");
    });
    $radio1.bind('click', function () {
        $('#ishospital').css("display", "block");
    });
    $("#IDcardNumber").bind("blur", function () {
        if (isCardNo()) {
            $(this).css("background", "yellow");
        } else {
            $(this).css("background", "white");
        }
        if ($(this).prop("value") == "") {
            $(this).css("background", "white");
        }
    });
    $("#radionumber").blur(function () {
        var isradio1 = isradio();
        if (isradio1==0) {
            $(this).css("background", "yellow");
        } else {
                  
            if (isradio1== 1) {
                $(this).css("background", "white");
            } else {
                $(this).css("background", "red");
            }
        }
        if ($(this).prop("value") == "") {
            $(this).css("background", "white");
        }
    });
    $("#sync").bind("click", Sync);
    $("#selectAddress").bind("click",SelectAddress);
    $("#IDcardNumber").bind("input propertychange", getBirthdate);
}

function SelectAddress() {
    var position = $("#Address").offset();
    var pickerTop = position.top + 29;
    var pickerLeft = position.left;
    var pickerWidth = $("#Address").width() + 9;
    var addressArea = "<div id='addressArea' class='addressPicker'>" +
        "<div class='nav-tabs-custom' style='margin-bottom:0px;'>" +
        "<ul id='address-title' class='nav nav-tabs' style='font-size:16px;'>" +
        "<li class='active'><a href='#tab_province' data-toggle='tab' aria-expanded='true'>省份</a></li>" +
        "<li class=''><a href='#tab_city' data-toggle='tab' aria-expanded='false'>城市</a></li>" +
        "<li class=''><a href='#tab_area' data-toggle='tab' aria-expanded='false'>县区</a></li>" +
        "<li class='pull-right'><a id='close-picker' href='javascript:;' class='text-muted'><i class='fa fa-fw fa-remove'></i></a></li>" +
        "</ul>" +
        "<div class='tab-content'>" +
        "<div class='tab-pane active' id='tab_province'></div>" +
        "<div class='tab-pane' id='tab_city'></div>" +
        "<div class='tab-pane' id='tab_area'></div>" +
        "</div></div></div>";
    $("#ChooseAddress").append(addressArea);
    $("#close-picker").bind("click", function(){
        $("#addressArea").remove();
        $("#Address").focus();
    });
    window.onresize=function(){
        var position = $("#Address").offset();
        var pickerTop = position.top + 29;
        var pickerLeft = position.left;
        var pickerWidth = $("#Address").width() + 9;
        $("#addressArea").offset({top:pickerTop, left:pickerLeft});
        $("#addressArea").width(pickerWidth);
    };
    $("#addressArea").offset({top:pickerTop, left:pickerLeft});
    $("#addressArea").width(pickerWidth);
    loadProvince('');
}

function Sync() {
    var CardID = $("#CardID").val();
    if (CardID == "") {
        alert("请输入就诊卡号!");
    }else{
        $.ajax({
            url: "GetBasicPatientFromWeb.ashx",
            type: "post",
            data: {
                info: CardID
            },
            dateType: "xml",
            async: false,
            success: function (data) {
                var patientInfo = $.parseJSON(data);
                $("#userName").val(patientInfo.Item.name);
                if (patientInfo.Item.sexid == 1) {
                    $("#sex").val("male");
                }else{
                    $("#sex").val("female");
                }
                $("#Birthday").val(patientInfo.Item.birthdate);
                $("#Nation").val(patientInfo.Item.nation);
                $("#Number1").val(patientInfo.Item.telenumber);
                $("#Number2").val(patientInfo.Item.telenumber2);
                $("#Address").val(patientInfo.Item.simpleaddress);
            },
            error: function (e) { 
                alert("error");
            }
        });
    }
}

function getBirthdate() {
    var IDcardNumber = $("#IDcardNumber").val();
    if (IDcardNumber.length > 13) { //320623 1993 10 24 4039
        var year = IDcardNumber.substring(6,10);
        var month = IDcardNumber.substring(10,12);
        var day = IDcardNumber.substring(12,14);
        var birthdate = year + "-" + month + "-" + day;
        $("#Birthday").val(birthdate);
    }
}

function isradio() {
    var radio = document.getElementById("radionumber").value;
    var reg = /^(\d{8})$/;
    if (!reg.test(radio)) {
        return 0;
    } else {
        var returndata;
        $.ajax({
            url: "recheck.ashx",
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
function createdoctorItem(thiselement) {
    var doctorItem = docandgroup;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----医生选择-----");
    thiselement.options[0].value = "allItem";
    var i = 0;
    for(var jsondata in doctorItem)
    {
        thiselement.options[i + 1] = new Option(doctorItem[jsondata][0].username);
        thiselement.options[i + 1].value = parseInt(doctorItem[jsondata][0].userid);
            i++;
    }
}

function createselect2(index) {
    var thiselement = document.getElementById("group");
    var groups = docandgroup;
    var groupitem="";
    var k = 0;
    for (var jsondata in groups) {
        if (k == index-1) {
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
        for (var i = 1; i <= groupitem.length - 1; i++)
            {
            thiselement.options[i] = new Option(groupitem[i].groupname);
            thiselement.options[i].value = parseInt(groupitem[i].groupid);
        }
    }
}

function getdoctorandgroup() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/getdoctorandgroup.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    docandgroup =JSON.parse(Items).Item;
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
function CheckEmpty() {
    if (document.getElementById("radionumber").value == "") {
        window.alert("放疗号不能为空");
        return;
    }
    if (isradio() != 1) {
        window.alert("放疗号设置不合格");
        return;
    }
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

    if (document.getElementById("Birthday").value == "") {
        window.alert("出生日期不能为空");
        return;
    }

    if (document.getElementById("Address").value == "") {
        window.alert("家庭地址不能为空");
        return;
    }
    if (document.getElementById("Number1").value == "") {
        window.alert("电话1不能为空");
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
    if (isCardNo()) {
        window.alert("身份证格式不正确");
        return;
    }
    var $radio1 = $('input[name="RecordNumber"]:eq(0)');
    if ($radio1.prop("checked") && document.getElementById("hospitalnumber").value=="") {
        window.alert("住院号不能为空");
        return;
    }
    
    if (document.getElementById("doctor").value == "allItem") {
        window.alert("请选择医生");
        return;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("frmaddpatient"));
    $.ajax({
        url: "Addpatient.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        async: false,
        success: function (data) {
            if (data == "success") {
                alert("注册成功");
                window.location.reload();
            } else {
                alert("注册失败");
                return false;
            }
           
        },
        error: function (e) {
            window.location.href = "../Records/Error.aspx";
        }
    });
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

function loadProvince(regionId) {
    $("#tab_province").html("");
    $("#tab_city").html("");
    $("#tab_area").html("");
    var jsonStr = getAddress(regionId, 0);
    var provinces = "<div>";
    for (var k in jsonStr) {
        var singleProvince = "<a class='single-choice' href='javascript:;' onclick='loadCity(" + k + ",\"" + jsonStr[k] + "\")'>" + jsonStr[k] +"</a>";
        provinces += singleProvince;
    }
    provinces += "</div>";
    $("#tab_province").append(provinces);
}

function loadCity(regionId, province) {
    $("#Address_province").val(province);
    $("#address-title").find("li").each(function(index, element){
        if (index == 1) {
            $(this).find("a").click();
        }
    });
    $("#Address").val($("#Address_province").val());
    $("#tab_city").html("");
    $("#tab_area").html("");
    regionId = regionId + "";
    var jsonStr = getAddress(regionId, 1);
    var cities = "<div>";
    for (var k in jsonStr) {
        var singleCity = "<a class='single-choice' href='javascript:;' onclick='loadArea(" + k + ",\"" + jsonStr[k] + "\")'>" + jsonStr[k] +"</a>";
        cities += singleCity;
    }
    cities += "</div>";
    $("#tab_city").append(cities);
}

function loadArea(regionId, city) {
    $("#Address_city").val(city);
    if ($("#Address_province").val() == $("#Address_city").val() || $("#Address_city").val() == "市辖区" || $("#Address_city").val() == "县"  || $("#Address_city").val()== "省直辖行政单位"   || $("#Address_city").val()=="省直辖县级行政单位") {
        $("#Address_city").val("");
    }
    $("#address-title").find("li").each(function(index, element){
        if (index == 2) {
            $(this).find("a").click();
        }
    });
    $("#Address").val($("#Address_province").val() + $("#Address_city").val());
    $("#tab_area").html("");
    regionId = regionId + "";
    var jsonStr = getAddress(regionId, 2);
    var areas = "<div>";
    for (var k in jsonStr) {
        var singleArea = "<a class='single-choice' href='javascript:;' onclick='loadAddress(\"" + jsonStr[k] + "\")'>" + jsonStr[k] +"</a>";
        areas += singleArea;
    }
    areas += "</div>";
    $("#tab_area").append(areas);
}

function loadAddress(area) {
    $("#Address_area").val(area);
    if ($("#Address_city").val() == $("#Address_area").val() || $("#Address_province").val() == $("#Address_area").val()) {
        $("#Address_area").val("");
    }
    $("#Address").val($("#Address_province").val() + $("#Address_city").val() + $("#Address_area").val());
    $("#addressArea").remove();
    $("#Address").focus();
}

function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
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