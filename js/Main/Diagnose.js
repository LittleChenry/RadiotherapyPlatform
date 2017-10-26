window.addEventListener("load", createPatient, false)

var userID;
var treatID;
var userName;
var radioID;
//JS入口主函数
function createPatient(evt) {
    //获取入口患者信息界面的div
    //获得当前执行人姓名与ID
    getUserID();
    if ((typeof(userID)=="undefined")) {
        if(confirm("用户身份已经失效,是否选择重新登录?"))
        {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var treatID = window.location.search.split("=")[1];
    var patient = getPatientInfo(treatID);
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    //调取后台所有等待就诊的疗程号及其对应的病人
    document.getElementById("test").addEventListener("click", remove, false);
    var part = document.getElementById("part");
    createPartItem(part);
    var newpart = document.getElementById("newpart");
    createNewpartItem(newpart);
    var aim = document.getElementById("Aim");
    createAimItem(aim);
    var bingqing1 = document.getElementById("bingqing1");
    createbingqingItem(bingqing1);
    var bingli1 = document.getElementById("bingli1");
    createbingliItem(bingli1);
    $("#treatname").attr("value", patient.Treatmentdescribe);
    var diagnosisInfo = getDignoseInfo(treatID);
    $("#current-tab").text(patient.Treatmentdescribe + "诊断");
    var groupprogress = patient.Progress.split(",");
    if (contains(groupprogress, "1")) {
        for (var i = 0; i < diagnosisInfo.diagnosisInfo.length; i++) {
            if (patient.Treatmentname == diagnosisInfo.diagnosisInfo[i].Treatmentname) {
                document.getElementById("operator").innerHTML = diagnosisInfo.diagnosisInfo[i].username;
                document.getElementById("date").innerHTML = diagnosisInfo.diagnosisInfo[i].Time;
                document.getElementById("bingqing1").value = diagnosisInfo.diagnosisInfo[i].diagnosisresultName1.split(",")[0];
                loadone();
                document.getElementById("bingqing2").value = diagnosisInfo.diagnosisInfo[i].diagnosisresultName1.split(",")[1];
                loadtwo();
                document.getElementById("bingqing3").value = diagnosisInfo.diagnosisInfo[i].diagnosisresultName1.split(",")[2];
                loadthree();
                document.getElementById("bingli1").value = diagnosisInfo.diagnosisInfo[i].diagnosisresultName2.split(",")[0];
                loadonenext();
                document.getElementById("bingli2").value = diagnosisInfo.diagnosisInfo[i].diagnosisresultName2.split(",")[1];
                loadtwonext();
                document.getElementById("part").value = diagnosisInfo.diagnosisInfo[i].partID;
                document.getElementById("newpart").value = diagnosisInfo.diagnosisInfo[i].LightPart_ID;
                document.getElementById("treatname").value = diagnosisInfo.diagnosisInfo[i].Treatmentdescribe;
                document.getElementById("Aim").value = diagnosisInfo.diagnosisInfo[i].treatmentaimID;
                document.getElementById("remark").value = diagnosisInfo.diagnosisInfo[i].Remarks;
                if (diagnosisInfo.diagnosisInfo[i].iscommonnumber == "1") {
                    $('input[name="patientjudge"]:eq(0)').prop('checked', true);
                } else {
                    $('input[name="patientjudge"]:eq(1)').prop('checked', true);
                }
                if (diagnosisInfo.diagnosisInfo[i].userID == userID) {
                    window.parent.document.getElementById("edit").removeAttribute("disabled");
                }
            } else {
                var tab = '<li class=""><a href="#tab'+ i +'" data-toggle="tab" aria-expanded="false">'+ diagnosisInfo.diagnosisInfo[i].Treatmentdescribe +'诊断</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                   + '<div class="item col-xs-12">病情诊断结果：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].diagnosisresultName1 + '</span></div></div>'
                   + '<div class="single-row"><div class="item col-xs-12">病理诊断结果：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].diagnosisresultName2 + '</span></div></div>'
                   + '<div class="single-row"><div class="item col-xs-6">病变部位：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].partname + '</span></div>'
                   + '<div class="item col-xs-6">照射部位：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].lightpartname + '</span></div></div>'
                   + '<div class="single-row"><div class="item col-xs-6">疗程名称：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].Treatmentdescribe + '</span></div>'
                    + '<div class="item col-xs-6">治疗目标：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].treatmentaim + '</span></div></div>'
                   + '<div class="single-row"><div class="item col-xs-6">备注：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].Remarks + '</span></div><div class="item col-xs-6"><button class="btn btn-success" disabled="disabled" id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
               
            }
        }
    } else {
        document.getElementById("date").innerHTML = getNowFormatDate();
        document.getElementById("operator").innerHTML = userName;
        document.getElementById("diaguserid").value = userID;

        for (var i = 0; i < diagnosisInfo.diagnosisInfo.length; i++) {
            var tab = '<li class=""><a href="#tab'+ i +'" data-toggle="tab" aria-expanded="false">'+ diagnosisInfo.diagnosisInfo[i].Treatmentdescribe +'诊断</a></li>';
            var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
               + '<div class="item col-xs-12">病情诊断结果：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].diagnosisresultName1 + '</span></div></div>'
               + '<div class="single-row"><div class="item col-xs-12">病理诊断结果：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].diagnosisresultName2 + '</span></div></div>'
               + '<div class="single-row"><div class="item col-xs-6">病变部位：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].partname + '</span></div>'
               + '<div class="item col-xs-6">照射部位：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].lightpartname + '</span></div></div>'
               + '<div class="single-row"><div class="item col-xs-6">疗程名称：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].Treatmentdescribe + '</span></div>'
                + '<div class="item col-xs-6">治疗目标：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].treatmentaim + '</span></div></div>'
               + '<div class="single-row"><div class="item col-xs-6">备注：<span class="underline">' + diagnosisInfo.diagnosisInfo[i].Remarks + '</span></div><div class="item col-xs-6"><button class="btn btn-success"  id="' + i + '">载入历史信息</button></div></div>';
            $("#tabs").append(tab);
            $("#tab-content").append(content);
            }
        }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var k = this.id;
            document.getElementById("bingqing1").value = diagnosisInfo.diagnosisInfo[k].diagnosisresultName1.split(",")[0];
            loadone();
            document.getElementById("bingqing2").value = diagnosisInfo.diagnosisInfo[k].diagnosisresultName1.split(",")[1];
            loadtwo();
            document.getElementById("bingqing3").value = diagnosisInfo.diagnosisInfo[k].diagnosisresultName1.split(",")[2];
            loadthree();
            document.getElementById("bingli1").value = diagnosisInfo.diagnosisInfo[k].diagnosisresultName2.split(",")[0];
            loadonenext();
            document.getElementById("bingli2").value = diagnosisInfo.diagnosisInfo[k].diagnosisresultName2.split(",")[1];
            loadtwonext();
            document.getElementById("part").value = diagnosisInfo.diagnosisInfo[k].partID;
            document.getElementById("newpart").value = diagnosisInfo.diagnosisInfo[k].LightPart_ID;
            document.getElementById("Aim").value = diagnosisInfo.diagnosisInfo[k].treatmentaimID;
            document.getElementById("remark").value = diagnosisInfo.diagnosisInfo[k].Remarks; 
        });
    });
}
function contains(group, s) {
    for (var k = 0; k <= group.length - 1; k++) {
        if (group[k] == s) {
            return true;
        }
    }
    return false;
    }
function transfer(res) {
    if (res == "") {
        return "暂无分组";
    } else {
        return res;
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
function getDignoseInfo(treatid) {

    var xmlHttp = new XMLHttpRequest();

    var url = "diagnoseInfo.ashx?treatID=" + treatid;

    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
   
    var json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1;
}

//获取病人基本信息
function getPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientForDiagnose.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;

    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}
//第二步部位下拉项建立
function createPartItem(thiselement) {
    var PartItem = JSON.parse(getPartItem()).Item;
    var defaultItem = JSON.parse(getPartItem()).defaultItem;
    $(thiselement).bind("click",function(){
        event.stopPropagation();
        autoList(this, PartItem);
    });

}

function autoList(e, data){
    if ($(e).next().length == 0) {
        var position = $(e).offset();
        var parentelement = $(e).parent();
        var pickerTop = position.top + 30;
        var pickerLeft = position.left;
        var pickerWidth = $(e).width() + 12;
        $(document).click(function(){
            $(e).next().fadeOut();
        });
        var selectArea = "<div class='pickerarea'><ul class='auto_ul'>";
        for (var i = 0; i < data.length; i++) {
            li = "<li id='" + data[i].ID +"' class='auto_list'>" + data[i].Name + "</li>";
            selectArea += li;
        }
        selectArea += "</ul></div>";
        $(parentelement).append(selectArea);
        $(e).next().css({minWidth:pickerWidth});
        $(e).next().offset({top:pickerTop, left:pickerLeft});
        $(e).next().find("ul").find("li").each(function(){
            $(this).mouseover(function(){
                $(this).css("color","#FFFFFF");
                $(this).css("background","#3C8DBC");
            });
            $(this).mouseout(function(){
                $(this).css("color","#000000");
                $(this).css("background","#FFFFFF");
            });
            $(this).bind("click",function(){
                event.stopPropagation();
                if ($(this).find("i").length == 0) {
                    var ispan = "<i class='pull-right fa fa-fw fa-check'></i>"
                    $(this).append(ispan);
                }else{
                    $(this).find("i")[0].remove();
                }
                $(this).parent().parent().prev().val("");
                $(this).parent().find("li").each(function(index,element){
                    if ($(this).find("i").length != 0) {
                        var text = $(this).parent().parent().prev().val() + $(this).text().split("<")[0] + "，";
                        $(this).parent().parent().prev().val(text);
                    }
                });
                if ($(this).parent().parent().prev().val()) {
                    var temp = $(this).parent().parent().prev().val();
                    $(this).parent().parent().prev().val(temp.substring(0,temp.length-1));
                }
            });
        });
    }
    $(e).next().fadeIn();
}


//第二步部位项数据库调取
function getPartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createNewpartItem(thiselement) {
    var NewpartItem = JSON.parse(getNewpartItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-----照射部位选择-----");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < NewpartItem.length; i++) {
        if (NewpartItem[i] != "") {
            thiselement.options[i + 1] = new Option(NewpartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(NewpartItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getNewpartItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getnewpart.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createAimItem(thiselement) {
    var AimItem = JSON.parse(getAimItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("----治疗目标选择-----");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < AimItem.length; i++) {
        if (AimItem[i] != "") {
            thiselement.options[i + 1] = new Option(AimItem[i].Aim);
            thiselement.options[i + 1].value = parseInt(AimItem[i].ID);
        }
    }


}
//第二步部位项数据库调取
function getAimItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getaims.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createbingqingItem(thiselement) {
    var bingqingItem = JSON.parse(getbingqingItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("无");
    thiselement.options[0].value = "";
    for (var i = 0; i < bingqingItem.length; i++) {
        if (bingqingItem[i] != "") {
            thiselement.options[i + 1] = new Option(bingqingItem[i].Name);
            thiselement.options[i + 1].value = bingqingItem[i].ID;
        }
    }


}
//第二步部位项数据库调取
function getbingqingItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getResultFirstItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createbingliItem(thiselement) {
    var bingliItem = JSON.parse(getbingliItem()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("无");
    thiselement.options[0].value = "";
    for (var i = 0; i < bingliItem.length; i++) {
        if (bingliItem[i] != "") {
            thiselement.options[i + 1] = new Option(bingliItem[i].Name);
            thiselement.options[i + 1].value = bingliItem[i].ID;
        }
    }


}
//第二步部位项数据库调取
function getbingliItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getpathologyItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function loadone() {
    var text1 = $("#bingqing1 option:selected").text();
    var text2 = $("#bingqing2 option:selected").text();
    text1 = text1.replace(/&/g, "%26");
    text2 = text2.replace(/&/g, "%26");
    var bingqing2 = document.getElementById("bingqing2");
    createbingqing2(bingqing2,text1);
    var bingqing3 = document.getElementById("bingqing3");
    createbingqing3(bingqing3, text1, text2);
    $("#copybingqing1").attr("value", $("#bingqing1 option:selected").text());
}
function loadtwo() {
    var text1 = $("#bingqing1 option:selected").text();
    var text2 = $("#bingqing2 option:selected").text();
    text1 = text1.replace(/&/g, "%26");
    text2 = text2.replace(/&/g, "%26");
    var bingqing3 = document.getElementById("bingqing3");
    createbingqing3(bingqing3, text1, text2);
    $("#copybingqing2").attr("value", $("#bingqing2 option:selected").text());
}
function loadthree() {
    var text3= $("#bingqing3 option:selected").text();
    $("#copybingqing3").attr("value", text3);
}
function loadonenext() {
    var text1 = $("#bingli1 option:selected").text();
    var text1 = text1.replace(/&/g, "%26");
    var bingli2 = document.getElementById("bingli2");
    createbingli2(bingli2, text1);
    $("#copybingli1").attr("value", $("#bingli1 option:selected").text());
}
function loadtwonext() {
    var text2 = $("#bingli2 option:selected").text();
    $("#copybingli2").attr("value", $("#bingli2 option:selected").text());
}
function createbingqing2(thiselement, text)
{
    var bingqing2Item = JSON.parse(getbingqing2Item(text)).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("无");
    thiselement.options[0].value = "";
    for (var i = 0; i < bingqing2Item.length; i++) {
        if (bingqing2Item[i] != "") {
            thiselement.options[i + 1] = new Option(bingqing2Item[i].Name);
            thiselement.options[i + 1].value = bingqing2Item[i].ID;
        }
    }

}
//第二步部位项数据库调取
function getbingqing2Item(text) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getResultSecondItem.ashx?text="+text;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createbingqing3(thiselement, text1, text2)
{
    var bingqing3Item = JSON.parse(getbingqing3Item(text1, text2)).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("无");
    thiselement.options[0].value = "";
    for (var i = 0; i < bingqing3Item.length; i++) {
        if (bingqing3Item[i] != "") {
            thiselement.options[i + 1] = new Option(bingqing3Item[i].Name);
            thiselement.options[i + 1].value =bingqing3Item[i].ID;
        }
    }

}
//第二步部位项数据库调取
function getbingqing3Item(text1, text2) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getResultThirdItem.ashx?text1=" + text1+"&text2="+text2;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createbingli2(thiselement, text) {
    var bingli2Item = JSON.parse(getbingli2Item(text)).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("无");
    thiselement.options[0].value = "";
    for (var i = 0; i < bingli2Item.length; i++) {
        if (bingli2Item[i] != "") {
            thiselement.options[i + 1] = new Option(bingli2Item[i].Name);
            thiselement.options[i + 1].value = bingli2Item[i].ID;
        }
    }

}
function getbingli2Item(text) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getpathologySecondItem.ashx?text=" + text;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function save() {
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var treatID = window.location.search.split("=")[1];
    var time = document.getElementById("time");
    var remark = document.getElementById("remark");
    var part = document.getElementById("part");
    var newpart = document.getElementById("newpart");
    var Aim = document.getElementById("Aim");
    var treatname = document.getElementById("treatname");
    var copybingli1 = document.getElementById("copybingli1");
    var copybingli2 = document.getElementById("copybingli2");
    var copybingqing1 = document.getElementById("copybingqing1");
    var copybingqing2 = document.getElementById("copybingqing2");
    var copybingqing3 = document.getElementById("copybingqing3");
    var $radio1 = $('input[name="patientjudge"]:eq(0)');
    var $radio2 = $('input[name="patientjudge"]:eq(1)');
    var patientjudge;
    if ($radio1.prop("checked")) {
        patientjudge = 1;
    } else {
        patientjudge = 0;
    }
    if (part.value == "allItem") {
        window.alert("请选择病变部位");
        return false;
    
    }
    if (newpart.value == "allItem") {
        window.alert("请选择照射部位");
        return false;

    }
    if (Aim.value == "allItem") {
        window.alert("请选择照射部位");
        return false;
        
    }
    if (treatname.value == "") {
        window.alert("疗程不能为空");
        return false;
        
    }
    if (copybingli1.value == "" || copybingli2.value == "") {
        window.alert("病理诊断未填写完整");
        return false;
       
    }
    if (copybingqing1.value == "" || copybingqing2.value == "" || copybingqing3.value=="") {
        window.alert("病情诊断未填写完整");
        return false;
        
    }
    $.ajax({
        type: "POST",
        url: "recordDiag.ashx",
        async: false,
        data: {
            treatid: treatID,
            treatname:treatname.value,
            diaguserid: userID,
            remark: remark.value,
            part: part.value,
            newpart: newpart.value,
            Aim: Aim.value,
            patientjudge:patientjudge,
            copybingli1: copybingli1.value,
            copybingli2: copybingli2.value,
            copybingqing1: copybingqing1.value,
            copybingqing2: copybingqing2.value,
            copybingqing3:copybingqing3.value

        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                window.alert("诊断成功");
                askForBack();
            } else {
                window.alert("诊断失败");
                return false;
            }
        },
        error: function (e) {
            alert(e);
        }
    });

}
function chooseTempalte(templateID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetTemplateDiag.ashx?templateID=" + templateID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var json = json.replace(/\n/g, "\\n");
    var diagnosisInfo = eval("(" + json + ")");
    document.getElementById("bingqing1").value = diagnosisInfo.diagnosisInfo[0].diagnosisresultName1.split(",")[0];
    loadone();
    document.getElementById("bingqing2").value = diagnosisInfo.diagnosisInfo[0].diagnosisresultName1.split(",")[1];
    loadtwo();
    document.getElementById("bingqing3").value = diagnosisInfo.diagnosisInfo[0].diagnosisresultName1.split(",")[2];
    loadthree();
    document.getElementById("bingli1").value = diagnosisInfo.diagnosisInfo[0].diagnosisresultName2.split(",")[0];
    loadonenext();
    document.getElementById("bingli2").value = diagnosisInfo.diagnosisInfo[0].diagnosisresultName2.split(",")[1];
    loadtwonext();
    document.getElementById("part").value = diagnosisInfo.diagnosisInfo[0].partID;
    document.getElementById("newpart").value = diagnosisInfo.diagnosisInfo[0].LightPart_ID;
    document.getElementById("Aim").value = diagnosisInfo.diagnosisInfo[0].treatmentaimID;
    document.getElementById("remark").value = diagnosisInfo.diagnosisInfo[0].Remarks;
   
}
function saveTemplate(TemplateName) {
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var treatID = window.location.search.split("=")[1];
    var time = document.getElementById("time");
    var remark = document.getElementById("remark");
    var part = document.getElementById("part");
    var newpart = document.getElementById("newpart");
    var Aim = document.getElementById("Aim");
    var treatname = document.getElementById("treatname");
    var copybingli1 = document.getElementById("copybingli1");
    var copybingli2 = document.getElementById("copybingli2");
    var copybingqing1 = document.getElementById("copybingqing1");
    var copybingqing2 = document.getElementById("copybingqing2");
    var copybingqing3 = document.getElementById("copybingqing3");
    if (part.value == "allItem") {
        window.alert("请选择病变部位");
        return false;

    }
    if (newpart.value == "allItem") {
        window.alert("请选择照射部位");
        return false;

    }
    if (Aim.value == "allItem") {
        window.alert("请选择照射部位");
        return false;

    }
    if (treatname.value == "") {
        window.alert("疗程不能为空");
        return false;

    }
    if (copybingli1.value == "" || copybingli2.value == "") {
        window.alert("病理诊断未填写完整");
        return false;

    }
    if (copybingqing1.value == "" || copybingqing2.value == "" || copybingqing3.value == "") {
        window.alert("病情诊断未填写完整");
        return false;

    }
    $.ajax({
        type: "POST",
        url: "recordDiagtemplate.ashx",
        async: false,
        data: {
            treatid: treatID,
            treatname: treatname.value,
            diaguserid: userID,
            remark: remark.value,
            part: part.value,
            newpart: newpart.value,
            TemplateName:TemplateName,
            Aim: Aim.value,
            copybingli1: copybingli1.value,
            copybingli2: copybingli2.value,
            copybingqing1: copybingqing1.value,
            copybingqing2: copybingqing2.value,
            copybingqing3: copybingqing3.value

        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                window.alert("模板保存成功");
            } else {
                window.alert("模板保存失败");
                return false;
            }
        },
        error: function () {
            alert("error");
        }
    });

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
function askForBack() {
    document.location.reload();

}
function remove() {
    document.getElementById("remark").removeAttribute("disabled");
    document.getElementById("part").removeAttribute("disabled");
    document.getElementById("newpart").removeAttribute("disabled");
    document.getElementById("bingli1").removeAttribute("disabled");
    document.getElementById("bingli2").removeAttribute("disabled");
    document.getElementById("bingqing1").removeAttribute("disabled");
    document.getElementById("bingqing2").removeAttribute("disabled");
    document.getElementById("bingqing3").removeAttribute("disabled");
    document.getElementById("treatname").removeAttribute("disabled");
    document.getElementById("Aim").removeAttribute("disabled");
    $('input[name="patientjudge"]:eq(0)').prop('disabled', false);
    $('input[name="patientjudge"]:eq(1)').prop('disabled', false);
}
