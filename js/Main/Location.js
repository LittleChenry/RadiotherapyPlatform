window.addEventListener("load", Init, false);
var userName;
var userID;

function Init(evt) {

    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var treatID = window.location.search.split("=")[1];
    //document.getElementById("treatID").innerHTML = treatID;
    document.getElementById("userID").value = userID;
    document.getElementById("hidetreatID").value = treatID;
    var patient = getPatientInfo(treatID);
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
    var select1 = document.getElementById("scanpart");
    createscanpartItem(select1);
    var select2 = document.getElementById("scanmethod");
    createscanmethodItem(select2);
    var select3 = document.getElementById("special");
    createspecialItem(select3);
    var add = document.getElementsByName("add");
    if (add[0].checked) {
        var select4 = document.getElementById("addmethod");
        createaddmethodItem(select4);
    } else {
        document.getElementById("addmethod").disabled = "true";

    }
    $("#current-tab").text(patient.Treatmentdescribe + "模拟定位记录");
    var locationInfo = getDignoseInfo(treatID);
    var progress = patient.Progress.split(",");
    if (isInArray(progress, '5')) {
        for (var i = 0; i < locationInfo.length; i++) {
            if (patient.Treatmentname == locationInfo[i].Treatmentname) {
                if (locationInfo[i].userID == userID || locationInfo[i].userID == "") {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
                }
                document.getElementById("remark").value = locationInfo[i].Remarks;
                document.getElementById("Remarks").value = locationInfo[i].Remarksrecord;
                var add = document.getElementsByName("add");
              
                document.getElementById("scanpart").value = locationInfo[i].ScanPart;
                document.getElementById("scanmethod").value = locationInfo[i].ScanMethod;
                document.getElementById("special").value = locationInfo[i].requireID;
                document.getElementById("up").value = locationInfo[i].UpperBound;
                document.getElementById("down").value = locationInfo[i].LowerBound;

                if (locationInfo[i].Enhance == 1) {
                    add[0].checked = "true";
                    document.getElementById("addmethod").value = locationInfo[i].EnhanceMethod;
                } else {
                    add[1].checked = "true";
                    document.getElementById("enhancemethod").style.display = "none";
                }              
                document.getElementById("Thickness").value = locationInfo[i].Thickness;
                document.getElementById("Number").value = locationInfo[i].Number;
                document.getElementById("ReferenceNumber").value = locationInfo[i].ReferenceNumber;
                document.getElementById("ReferenceScale").value = locationInfo[i].ReferenceScale;
                document.getElementById("operator").innerHTML = locationInfo[i].operate;
                document.getElementById("date").innerHTML = locationInfo[i].OperateTime;
                var boxesgroup = document.getElementsByClassName("boxes");
                boxesgroup[0].style.display = "none";
                var boxes = document.getElementById("multipic");
                var pictures = locationInfo[i].CTPictures.split(",");
                if (locationInfo[i].CTPictures == "") {
                    boxes.innerHTML = "无";
                } else {
                    for (var k = 1; k < pictures.length; k++) {
                        var div = document.createElement("DIV");
                        div.className = "boxes";
                        var div1 = document.createElement("DIV");
                        div1.className = "imgnum";
                        var img = document.createElement("IMG");
                        img.addEventListener("click", showPicture, false);
                        img.className = "img";
                        img.src = pictures[k];
                        img.style.display = "block";
                        div1.appendChild(img);
                        div.appendChild(div1);
                        boxes.appendChild(div);
                    }
                }
            }
            else {
                if (locationInfo[i].Thickness == "") {
                    continue;
                }
                var pictures = locationInfo[i].CTPictures.split(",");
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + locationInfo[i].Treatmentdescribe + '模拟定位记录</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">层厚：<span class="underline">' + locationInfo[i].Thickness + '</span></div>'
                    + '<div class="item col-xs-6">层数：<span class="underline">' + locationInfo[i].Number + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">参考中心层面：<span class="underline">' + locationInfo[i].ReferenceNumber + '</span></div>'
                    + '<div class="item col-xs-6">体表参考刻度：<span class="underline">' + locationInfo[i].ReferenceScale + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12">记录备注：<span class="underline">' + locationInfo[i].Remarksrecord + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><span class="col-xs-2" style="padding-left:0px;">定位图片：</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><div id="multipic" class="imgbox multifile">';
                if (locationInfo[i].CTPictures == "") {
                    content += '无</div></div></div>';
                } else {
                    for (var j = 1; j < pictures.length; j++) {
                        content = content + '<div class="boxes"><div class="imgnum">'
                                + '<span class="closecamera closearea"><i class="fa fa-times"></i></span>'
                                + '<img src="' + pictures[j] + '" class="img" style="display:block;"/></div></div>';
                    }
                    content += '</div></div></div>';
                }
                content = content + '<div class="single-row"><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
                $("#tab-content").find("img").each(function () {
                    $(this).bind("click", showPicture);
                });
            }
        }
    }
    else {
        document.getElementById("userID").value = userID;
        document.getElementById("operator").innerHTML = userName;
        document.getElementById("date").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
        for (var i = 0; i < locationInfo.length; i++) {
            if (patient.Treatmentname != locationInfo[i].Treatmentname) {
                if (locationInfo[i].Thickness == "") {
                    continue;
                }
                var pictures = locationInfo[i].CTPictures.split(",");
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">' + locationInfo[i].Treatmentdescribe + '模拟定位记录</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="item col-xs-6">层厚：<span class="underline">' + locationInfo[i].Thickness + '</span></div>'
                    + '<div class="item col-xs-6">层数：<span class="underline">' + locationInfo[i].Number + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-6">参考中心层面：<span class="underline">' + locationInfo[i].ReferenceNumber + '</span></div>'
                    + '<div class="item col-xs-6">体表参考刻度：<span class="underline">' + locationInfo[i].ReferenceScale + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12">记录备注：<span class="underline">' + locationInfo[i].Remarksrecord + '</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><span class="col-xs-2" style="padding-left:0px;">定位图片：</span></div></div>'
                    + '<div class="single-row"><div class="item col-xs-12"><div id="multipic" class="imgbox multifile">';
                if (locationInfo[i].CTPictures == "") {
                    content += '无</div></div></div>';
                } else {
                    for (var j = 1; j < pictures.length; j++) {
                        content = content + '<div class="boxes"><div class="imgnum">'
                                + '<span class="closecamera closearea"><i class="fa fa-times"></i></span>'
                                + '<img src="' + pictures[j] + '" class="img" style="display:block;"/></div></div>';
                    }
                    content += '</div></div></div>';
                }
                content = content + '<div class="single-row"><div class="item col-xs-4"><button class="btn btn-success" type="button"  id="' + i + '">载入历史信息</button></div></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
                $("#tab-content").find("img").each(function () {
                    $(this).bind("click", showPicture);
                });
            } else {
                document.getElementById("remark").value = locationInfo[i].Remarks;
                var add = document.getElementsByName("add");

                document.getElementById("scanpart").value = locationInfo[i].ScanPart;
                document.getElementById("scanmethod").value = locationInfo[i].ScanMethod;
                document.getElementById("special").value = locationInfo[i].requireID;
                document.getElementById("up").value = locationInfo[i].UpperBound;
                document.getElementById("down").value = locationInfo[i].LowerBound;

                if (locationInfo[i].Enhance == 1) {
                    add[0].checked = "true";
                    document.getElementById("addmethod").value = locationInfo[i].EnhanceMethod;
                } else {
                    add[1].checked = "true";
                    document.getElementById("enhancemethod").style.display = "none";
                }
                var $radio1 = $('input[name="add"]:eq(0)');
                var $radio2 = $('input[name="add"]:eq(1)');
                $radio2.bind('click', function () {
                    document.getElementById("enhancemethod").style.display = "none";
                });
                $radio1.bind('click', function () {
                    document.getElementById("enhancemethod").style.display = "block";
                });
               
            }
        }
    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            document.getElementById("Thickness").value = locationInfo[k].Thickness;
            document.getElementById("Number").value = locationInfo[k].Number;
            document.getElementById("ReferenceNumber").value = locationInfo[k].ReferenceNumber;
            document.getElementById("ReferenceScale").value = locationInfo[k].ReferenceScale;
            document.getElementById("Remarks").value = locationInfo[k].Remarksrecord;
        });
    });
}
function isInArray(arr, value) {
    for (var i = 0; i < arr.length; i++) {
        if (value === arr[i]) {
            return true;
        }
    }
    return false;
}
function createscanpartItem(thiselement) {
    var PartItem = JSON.parse(getscanpartItem()).Item;
    var defaultItem = JSON.parse(getscanpartItem()).defaultItem;
    if (defaultItem == "") {
        $(thiselement).attr("value", "");
    } else {
        $(thiselement).attr("value", defaultItem.Name);
    }
    $(thiselement).bind("click", function () {
        event.stopPropagation();
        autoList(this, PartItem);
    });
}
function autoList(e, data) {
    if ($(e).next().length == 0) {
        var position = $(e).offset();
        var parentelement = $(e).parent();
        var pickerTop = position.top + 30;
        var pickerLeft = position.left;
        var pickerWidth = $(e).width() + 12;
        $(document).click(function () {
            $(e).next().fadeOut(200);
        });
        var selectArea = "<div class='pickerarea'><ul class='auto_ul'>";
        for (var i = 0; i < data.length; i++) {
            li = "<li id='" + data[i].ID + "' class='auto_list'>" + data[i].Name + "</li>";
            selectArea += li;
        }
        selectArea += "</ul></div>";
        $(parentelement).append(selectArea);
        $(e).next().css({ minWidth: pickerWidth });
        $(e).next().offset({ top: pickerTop, left: pickerLeft });
        $(e).next().find("ul").find("li").each(function () {
            $(this).mouseover(function () {
                $(this).css("color", "#FFFFFF");
                $(this).css("background", "#3C8DBC");
            });
            $(this).mouseout(function () {
                $(this).css("color", "#333333");
                $(this).css("background", "#FFFFFF");
            });
            $(this).bind("click", function () {
                event.stopPropagation();
                if ($(this).find("i").length == 0) {
                    var ispan = "<i class='pull-right fa fa-fw fa-check'></i>"
                    $(this).append(ispan);
                } else {
                    $(this).find("i")[0].remove();
                }
                $(this).parent().parent().prev().val("");
                $(this).parent().find("li").each(function (index, element) {
                    if ($(this).find("i").length != 0) {
                        var text = $(this).parent().parent().prev().val() + $(this).text().split("<")[0] + "，";
                        $(this).parent().parent().prev().val(text);
                    }
                });
                if ($(this).parent().parent().prev().val()) {
                    var temp = $(this).parent().parent().prev().val();
                    $(this).parent().parent().prev().val(temp.substring(0, temp.length - 1));
                }
            });
        });
    }
    $(e).next().fadeIn(200);
}
function getscanpartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getscanpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//扫描部位
function createscanmethodItem(thiselement) {
    var PartItem = JSON.parse(getscanmethodItem()).Item;
    var defaultItem = JSON.parse(getscanmethodItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Method);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }
}
function getscanmethodItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getscanmethod.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//扫描特殊要求
function createspecialItem(thiselement) {
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
    var url = "getscanspecial.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//增强方式
function createaddmethodItem(thiselement) {
    var PartItem = JSON.parse(getaddmethodItem()).Item;
    var defaultItem = JSON.parse(getaddmethodItem()).defaultItem;
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i] = new Option(PartItem[i].Method);
            thiselement.options[i].value = parseInt(PartItem[i].ID);
        }
    }
    if (defaultItem != "") {
        thiselement.value = defaultItem.ID;
    }
}
function forchange() {
    var add = document.getElementsByName("add");
    if (add[0].checked) {
        var select4 = document.getElementById("addmethod");
        select4.removeAttribute("disabled");
        createaddmethodItem(select4);
    }
    if (add[1].checked) {
        document.getElementById("addmethod").disabled = "true";

    }
}
function getaddmethodItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getaddmethod.ashx";
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
function showPicture(){
    $("#showPic").click();
    $("#pic").attr("src",this.src);
}

function getDignoseInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "LocationInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.locationInfo;
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
                //alert(userID);                
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
    var special = document.getElementById("special").value;
    var addgroup = document.getElementsByName("add");
    var add;
    if (addgroup[0].checked == true) {
        add = addgroup[0].value;
    } else {
        add = addgroup[1].value;
    }
    if (document.getElementById("scanpart").value == "allItem") {
        window.alert("请选择扫描部位");
        return false;
    }
    if (document.getElementById("scanmethod").value == "allItem") {
        window.alert("请选择扫描方式");
        return false;
    }
    if (document.getElementById("up").value == "") {
        window.alert("请填写上界");
        return false;
    }
    if (document.getElementById("down").value == "") {
        window.alert("请填写下界");
        return false;
    }
    if (add == "1") {
        if (document.getElementById("addmethod").value == "allItem") {
            window.alert("请选择增强方式");
            return false;
        }
    }
    if (special == "allItem") {
        window.alert("请选择特殊要求");
        return false;
    }
    if (document.getElementById("Thickness").value == "") {
        alert("请填写层厚");
        return false;
    }
    if (document.getElementById("Number").value == "") {
        alert("请填写层数");
        return false;
    }
    if (document.getElementById("ReferenceNumber").value == "") {
        alert("请填写参考中心层面");
        return false;
    }
    if (document.getElementById("ReferenceScale").value == "") {
        alert("请填写体表参考刻度");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("frmlocation"));
    $.ajax({
        url: "locationRecordRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        async: false,      
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
    });
}

function remove() {
    document.getElementById("scanmethod").removeAttribute("disabled");
    document.getElementById("scanpart").removeAttribute("disabled");
    document.getElementById("up").removeAttribute("disabled");
    document.getElementById("down").removeAttribute("disabled");
    document.getElementById("special").removeAttribute("disabled");
    document.getElementById("remark").removeAttribute("disabled");
    document.getElementById("Remarks").removeAttribute("disabled");
    document.getElementById("yes").removeAttribute("disabled");
    document.getElementById("No").removeAttribute("disabled");
    document.getElementById("addmethod").removeAttribute("disabled");
    document.getElementById("Thickness").removeAttribute("disabled");
    document.getElementById("Number").removeAttribute("disabled");
    document.getElementById("ReferenceNumber").removeAttribute("disabled");
    document.getElementById("ReferenceScale").removeAttribute("disabled");   
}
