window.addEventListener("load", Init, false);



var userName;
var userID;


function Init(evt) {

    //xubixiao
    //获取入口患者信息界面的div
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var treatID = window.location.search.split("=")[1];
    var patient = getPatientInfo(treatID);
    document.getElementById("hidetreatID").value = treatID;
    document.getElementById("userID").value = userID;
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    //document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    //document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    //document.getElementById("address").innerHTML = patient.Address;
    //document.getElementById("hospital").innerHTML = patient.Hospital;
    //document.getElementById("contact").innerHTML = patient.Contact1;
    //document.getElementById("contact2").innerHTML = patient.Contact2;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    //document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    //document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    createmodelselectItem(document.getElementById("modelselect"));
    createspecialrequestItem(document.getElementById("specialrequest"));
    createfixEquipItem(document.getElementById("fixEquip"));
    createbodyposItem(document.getElementById("bodyPost"));
    createheadrestItem(document.getElementById("Head"));
    $("#current-tab").text(patient.Treatmentdescribe + "体位固定记录");
    var fixedInfo = getFixedInfo(treatID);
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '4')) {
        for (var i = 0; i < fixedInfo.fixedInfo.length; i++) {
            if (patient.Treatmentname == fixedInfo.fixedInfo[i].Treatmentname) {
                if (fixedInfo.fixedInfo[i].userID == userID || fixedInfo.fixedInfo[i].userID =="") {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
                }
                
                document.getElementById("modelselect").value =  fixedInfo.fixedInfo[i].modelID;
                document.getElementById("specialrequest").value = fixedInfo.fixedInfo[i].requireID;
                document.getElementById("fixEquip").value = fixedInfo.fixedInfo[i].fixedEquipment;
                document.getElementById("bodyPost").value = fixedInfo.fixedInfo[i].body;
                document.getElementById("Head").value = fixedInfo.fixedInfo[i].headrest;
                document.getElementById("Remarks").value = fixedInfo.fixedInfo[i].Remarks;
                document.getElementById("operator").innerHTML = fixedInfo.fixedInfo[i].operate;
                document.getElementById("date").innerHTML = fixedInfo.fixedInfo[i].OperateTime;
                var boxesgroup = document.getElementsByClassName("boxes");
                boxesgroup[0].style.display = "none";
                var boxes = document.getElementById("multipic");
                var pictures = fixedInfo.fixedInfo[i].Pictures.split(",");
                if (fixedInfo.fixedInfo[i].Pictures == "") {
                    boxes.innerHTML = "无";
                } else {
                    for (var k = 1; k < pictures.length; k++) {
                        var div = document.createElement("DIV");
                        div.className = "boxes";
                        var div1 = document.createElement("DIV");
                        div1.className = "imgnum";
                        var img = document.createElement("IMG");
                        img.addEventListener("click",showPicture,false);
                        img.className = "img";
                        img.src = pictures[k];
                        img.style.display = "block";
                        div1.appendChild(img);
                        div.appendChild(div1);
                        boxes.appendChild(div);
                    }
                }
            } else {
                if (fixedInfo.fixedInfo[i].operate == "") {
                    continue;
                }
                var pictures = fixedInfo.fixedInfo[i].Pictures.split(",");
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + fixedInfo.fixedInfo[i].Treatmentdescribe + '体位固定记录</a></li>';
                var content = '<div class="tab-pane" id="tab'+ i +'">'
                    + '<div class="single-row"><div class="item col-xs-6">头枕:<span class="underline">' + fixedInfo.fixedInfo[i].headrestname + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12">备注：<span class="underline">'+ fixedInfo.fixedInfo[i].Remarks +'</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><span class="col-xs-2" style="padding-left:0px;">体位图片：</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><div id="multipic" class="imgbox multifile">';
                if (fixedInfo.fixedInfo[i].Pictures == "") {
                    content += '无</div></div></div>';
                } else {
                    for (var j = 1; j < pictures.length; j++) {
                        content = content + '<div class="boxes"><div class="imgnum">'
                                + '<span class="closecamera closearea"><i class="fa fa-times"></i></span>'
                                + '<img src="'+ pictures[j] +'" class="img" style="display:block;"/></div></div>';
                    }
                    content += '</div></div></div>';
                }
                content = content + '<div class="single-row"><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div></div>'
                $("#tabs").append(tab);
                $("#tab-content").append(content);
                $("#tab-content").find("img").each(function(){
                    $(this).bind("click",showPicture);
                });
            }
        }
    } else {
        document.getElementById("userID").value = userID;
        document.getElementById("operator").innerHTML = userName;
        document.getElementById("date").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
        for (var i = 0; i < fixedInfo.fixedInfo.length; i++) {
            if (patient.Treatmentname != fixedInfo.fixedInfo[i].Treatmentname) {
                if (fixedInfo.fixedInfo[i].operate == "") {
                    continue;
                }
                var pictures = fixedInfo.fixedInfo[i].Pictures.split(",");
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + fixedInfo.fixedInfo[i].Treatmentdescribe + '体位固定记录</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '">'
                    + '<div class="single-row"><div class="item col-xs-6">头枕:<span class="underline">' + fixedInfo.fixedInfo[i].headrestname + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12">备注：<span class="underline">' + fixedInfo.fixedInfo[i].Remarks + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><span class="col-xs-2" style="padding-left:0px;">体位图片：</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><div id="multipic" class="imgbox multifile">';
                if (fixedInfo.fixedInfo[i].Pictures == "") {
                    content += '无</div></div></div>';
                } else {
                    for (var j = 1; j < pictures.length; j++) {
                        content = content + '<div class="boxes"><div class="imgnum">'
                                + '<span class="closecamera closearea"><i class="fa fa-times"></i></span>'
                                + '<img src="' + pictures[j] + '" class="img" style="display:block;"/></div></div>';
                    }
                    content += '</div></div></div>';
                }
                content = content + '<div class="single-row"><div class="item col-xs-4"><button class="btn btn-success" type="button"  id="' + i + '">载入历史信息</button></div></div></div>'
                $("#tabs").append(tab);
                $("#tab-content").append(content);
                $("#tab-content").find("img").each(function () {
                    $(this).bind("click", showPicture);
                });
            } else {
                document.getElementById("modelselect").value = fixedInfo.fixedInfo[i].modelID;
                document.getElementById("specialrequest").value = fixedInfo.fixedInfo[i].requireID;
                document.getElementById("fixEquip").value = fixedInfo.fixedInfo[i].fixedEquipment;
                document.getElementById("bodyPost").value = fixedInfo.fixedInfo[i].body;              
            }
        }
    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            //document.getElementById("modelselect").value = fixedInfo.fixedInfo[k].modelID;
            //document.getElementById("specialrequest").value = fixedInfo.fixedInfo[k].requireID;
            //document.getElementById("fixEquip").value = fixedInfo.fixedInfo[k].fixedEquipment;
            //document.getElementById("bodyPost").value = fixedInfo.fixedInfo[k].body;
            document.getElementById("Head").value = fixedInfo.fixedInfo[k].headrest;
            document.getElementById("Remarks").value = fixedInfo.fixedInfo[k].Remarks;
        });
    });
}
function createbodyposItem(thiselement) {
    var PartItem = JSON.parse(getbodyposItem()).Item;
    var defaultItem = JSON.parse(getbodyposItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Name);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }
}
function getbodyposItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getbodypost.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createheadrestItem(thiselement) {
    var PartItem = JSON.parse(getrestItem()).Item;
    var defaultItem = JSON.parse(getrestItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Name);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }

}
function getrestItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getheadrest.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createmodelselectItem(thiselement) {
    var PartItem = JSON.parse(getmodelItem()).Item;
    var defaultItem = JSON.parse(getmodelItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Name);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }

}
function getmodelItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getmodel.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//第二页的特殊要求下拉菜单
function createspecialrequestItem(thiselement) {
    var PartItem = JSON.parse(getspecialItem()).Item;
    var defaultItem = JSON.parse(getspecialItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Requirements);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }

}
function getspecialItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getspecial.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//第二页获取固定装置下拉菜单
function createfixEquipItem(thiselement) {
    var PartItem = JSON.parse(getfixequipItem()).Item;
    var defaultItem = JSON.parse(getfixequipItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Name);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }

}
function getfixequipItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getfixequip.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
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
function showPicture(){
    $("#myModal").modal("show");
    $("#pic").attr("src",this.src);
}

function getFixedInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "fixInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1;
}

function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
}

//清楚所有子节点
function RemoveAllChild(area) {
    while (area.hasChildNodes()) {
        var first = area.firstChild;
        if (first != null && first != undefined)
            area.removeChild(first);
    }
}

//获取所有待等待体位固定申请疗程号以及所属患者ID与其他信息
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
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

//建立入口病患表

function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}



function dateformat(format) {
    var year = format.getFullYear();
    var month = format.getMonth() + 1;
    var day = format.getDate();
    var hour = format.getHours();
    var minute = format.getMinutes();
    if (minute < 10) {
        minute = "0" + minute;
    }
    var time = year + "年" + month + "月" + day + "日 " + hour + "：" + minute;
    return time;
}
function save() {
    if (document.getElementById("modelselect").value == "allItem") {
        window.alert("模具没有选择");
        return false;
    }
    if (document.getElementById("specialrequest").value == "allItem") {
        window.alert("特殊要求没有选择");
        return false;
    }
    if (document.getElementById("bodyPost").value == "allItem") {
        window.alert("体位没有选择");
        return false;
    }
    if (document.getElementById("fixEquip").value == "allItem") {
        window.alert("固定装置没有选择");
        return false;
    }
    if (document.getElementById("Head").value == "allItem") {
        window.alert("头枕没有选择");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveFixRecord"));
    $.ajax({
        url: "fixRecordRecord.ashx",
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
       
    });
}
function remove() {
    document.getElementById("modelselect").removeAttribute("disabled");
    document.getElementById("specialrequest").removeAttribute("disabled");
    document.getElementById("fixEquip").removeAttribute("disabled");
    document.getElementById("bodyPost").removeAttribute("disabled");
    document.getElementById("Remarks").removeAttribute("disabled");
    document.getElementById("Head").removeAttribute("disabled");
}
