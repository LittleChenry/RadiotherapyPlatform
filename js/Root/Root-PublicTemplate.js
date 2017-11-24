var type = 1;
$(function () {
    createTable(type);
    $("#sureSelect").off("click").on("click", function () {
        type = $("#typeSelect").val();
        createTable(type);
    });

    $("#addModal").off("click").on("click", function () {
        if (type == "1") {
            $("#add_diagnose").modal({
                backdrop: false
            });
            clearAddDiagnose();
            createAddDiagnose();
            $("#sureDeleteDiagnose").hide();
        }
        if (type == "2") {
            $("#add_fix").modal({
                backdrop:false
            });
            clearAddFix();
            createAddFix();
            $("#sureDeleteFix").hide();
        }
        if (type == "3") {
            $("#add_locate").modal({
                backdrop:false
            });
             clearAddLocate();
             createAddLocate();
            $("#sureDeleteLocate").hide();
        }
        if (type == "7") {
        }
    });

});
function createTable(type) {
    $("#body").empty();
    if (type == "1") {
        $("#tabletitle").text("病情诊断模板");
        $.ajax({
            url: "Template-getTable.ashx",
            type: "post",
            data: {
                type: type
            },
            success: function (data) {
                var dataObj = $.parseJSON(data);

                for (var i = 0; i < dataObj.length; i++) {
                    var $row = $("<tr></tr>");
                    var $tds = $("<td>" + dataObj[i].Name + "</td>" + "<td hidden>" + dataObj[i].id + "</td>" + "<td hidden>" + dataObj[i].TemplateID + "</td>");
                    $row.append($tds);
                    $("#body").append($row);
                }
                $("#body").find("tr").each(function () {
                    $(this).off("click").on("click", function () {
                        createAddDiagnose();
                        $("#add_diagnose").modal({
                            backdrop: false
                        });
                        $("#sureDeleteDiagnose").show();
                        fillDiagnoseData($(this));
                        var $tr = $(this);
                        $("#sureDeleteDiagnose").off("click").on("click", function () {
                            deleteTemplate($tr);
                        });
                        $("#sureAddDiagnose").off("click").on("click", function () {
                            updateDiagnose($tr);
                        });
                    });
                });
            }
        });
    }
    if (type == "2") {
        $("#tabletitle").text("体位固定申请模板");
        $.ajax({
            url: "Template-getTable.ashx",
            type: "post",
            data: {
                type: type
            },
            success: function (data) {
                var dataObj = $.parseJSON(data);

                for (var i = 0; i < dataObj.length; i++) {
                    var $row = $("<tr></tr>");
                    var $tds = $("<td>" + dataObj[i].Name + "</td>" + "<td hidden>" + dataObj[i].id + "</td>" + "<td hidden>" + dataObj[i].TemplateID + "</td>");
                    $row.append($tds);
                    $("#body").append($row);
                }
                $("#body").find("tr").each(function () {
                    $(this).off("click").on("click", function () {
                        createAddFix();
                        $("#add_fix").modal({
                            backdrop: false
                        });
                        $("#sureDeleteFix").show();
                        fillFixData($(this));
                        var $tr = $(this);
                        $("#sureDeleteFix").off("click").on("click", function () {
                            deleteTemplate($tr);
                        });
                        $("#sureAddFix").off("click").on("click", function () {
                            updateFix($tr);
                        });
                    });
                });
            }
        });
    }
    if (type == "3") {
        $("#tabletitle").text("模拟定位申请模板");
        $.ajax({
            url: "Template-getTable.ashx",
            type: "post",
            data: {
                type: type
            },
            success: function (data) {
                var dataObj = $.parseJSON(data);

                for (var i = 0; i < dataObj.length; i++) {
                    var $row = $("<tr></tr>");
                    var $tds = $("<td>" + dataObj[i].Name + "</td>" + "<td hidden>" + dataObj[i].id + "</td>" + "<td hidden>" + dataObj[i].TemplateID + "</td>");
                    $row.append($tds);
                    $("#body").append($row);
                }
                $("#body").find("tr").each(function () {
                    $(this).off("click").on("click", function () {
                        createAddLocate();
                        $("#add_locate").modal({
                            backdrop: false
                        });
                        $("#sureDeleteLocate").show();
                        fillLocateData($(this));
                        var $tr = $(this);
                        $("#sureDeleteLocate").off("click").on("click", function () {
                            deleteTemplate($tr);
                        });
                        $("#sureAddLocate").off("click").on("click", function () {
                            updateLocate($tr);
                        });
                    });
                });
            }
        });
    }
    if (type == "7") {
        $("#tabletitle").text("计划申请模板");
    }
}
//---------------------------------------------------------------------------------------------------------------
function createAddLocate(){
    createscanpartItem(document.getElementById("scanpart"));
    createscanmethodItem(document.getElementById("scanmethod"));
    createspecialItem(document.getElementById("special_locate"));
    createaddmethodItem(document.getElementById("addmethod"));
    $("#sureAddLocate").off("click").on("click", function () {
        postLocate();
    });
}
function updateLocate($tr){
    var templateName = document.getElementById("templateName_locate").value;
    var scanpart = $("#scanpart").next("div").find("button").attr("title").replace(/ /g, "").replace(/,/g, "，");
    var scanmethod = document.getElementById("scanmethod").value;
    var up = document.getElementById("up").value;
    var down = document.getElementById("down").value;
    var add = $("input[name='add']:checked").val();
    var addmethod = document.getElementById("addmethod").value;
    var special_locate = document.getElementById("special_locate").value;
    var remark_locate = document.getElementById("remark_locate").value;
    var templateID = $tr.find("td").eq(2).text();
    if(templateName==""){
        alert("请填写模版名称");
        return false;
    }
    if(scanpart=="请选择"){
        scanpart="";
    }
    if(add=="0"){
        addmethod="";
    }
    var oStr = '';
    var postData = {"templateID":templateID,"scanpart":scanpart,"scanmethod":scanmethod,"add":add,"user":"0","addmethod":addmethod,"up":up,"down":down,"templatename":templateName,"requirement":special_locate,"remark":remark_locate};
    //这里需要将json数据转成post能够进行提交的字符串  name1=value1&name2=value2格式
    postData = (function(value){
    　　for(var key in value){
    　　　　oStr += key+"="+value[key]+"&";
    　　};
　    　return oStr;
    }(postData));
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/updateLocatetemplate.ashx";
    xmlHttp.open("POST", url, false);
    xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlHttp.send(postData);
    var result = xmlHttp.responseText;
    if (result == "success") {
        window.alert("模板保存成功"); 
        $("#add_locate").modal("hide");
        createTable(type);  
    }   
    if (result == "failure") {
        window.alert("模板保存失败");
    }
}
function clearAddLocate(){
    $("#templateName_locate").val("");
    $("#scanmethod").val("");
    $("#up").val("");
    $("#down").val("");
    $("input[name='add']:last").prop("checked",true);
    $("#addmethod").val("").prop("disabled",true);
    $("#special_locate").val("");
    $("#remark_locate").val("");
    $("#scanpart").multiselect('refresh');
}
function createscanpartItem(thiselement) {
    // var PartItem = JSON.parse(getscanpartItem()).Item;
    // var defaultItem = JSON.parse(getscanpartItem()).defaultItem;
    // if (defaultItem == "") {
    //     $(thiselement).attr("value", "");
    // } else {
    //     $(thiselement).attr("value", defaultItem.Name);
    // }
    // $(thiselement).bind("click", function () {
    //     event.stopPropagation();
    //     autoList(this, PartItem);
    // });
    $(thiselement).empty();
    $(thiselement).multiselect("destroy");
    $.ajax({
        url: "../../pages/Main/Records/getscanpart.ashx",
        type: "get",
        success: function (data) {
            var dataObj = $.parseJSON(data);

            for (var i = 0; i < dataObj.Item.length; i++) {
                var $option = $("<option value=" + dataObj.Item[i].Name + ">" + dataObj.Item[i].Name + "</option>");
                $(thiselement).append($option);
            }
            $(thiselement).multiselect({
                nonSelectedText: "请选择",
                buttonWidth: '500px',
                numberDisplayed: 10,
            });
        }
    });
}
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
    var url = "../../pages/Main/Records/getscanmethod.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
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
    var url = "../../pages/Main/Records/getscanspecial.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
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
function getaddmethodItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getaddmethod.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function forchange() {
    var add = document.getElementsByName("add");
    if (add[0].checked) {
        var select4 = document.getElementById("addmethod");
        select4.removeAttribute("disabled");
    }
    if (add[1].checked) {
        document.getElementById("addmethod").disabled = "true";

    }
}
function postLocate(){
    var templateName = document.getElementById("templateName_locate").value;
    var scanpart = $("#scanpart").next("div").find("button").attr("title").replace(/ /g, "").replace(/,/g, "，");
    var scanmethod = document.getElementById("scanmethod").value;
    var up = document.getElementById("up").value;
    var down = document.getElementById("down").value;
    var add = $("input[name='add']:checked").val();
    var addmethod = document.getElementById("addmethod").value;
    var special_locate = document.getElementById("special_locate").value;
    var remark_locate = document.getElementById("remark_locate").value;
    if(templateName==""){
        alert("请填写模版名称");
        return false;
    }
    if(scanpart=="请选择"){
        scanpart="";
    }
    if(add=="0"){
        addmethod="";
    }
    var oStr = '';
    var postData = {"scanpart":scanpart,"scanmethod":scanmethod,"add":add,"user":"0","addmethod":addmethod,"up":up,"down":down,"templatename":templateName,"requirement":special_locate,"remark":remark_locate};
    //这里需要将json数据转成post能够进行提交的字符串  name1=value1&name2=value2格式
    postData = (function(value){
    　　for(var key in value){
    　　　　oStr += key+"="+value[key]+"&";
    　　};
　    　return oStr;
    }(postData));
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/AddLocateTemplateByPost.ashx";
    xmlHttp.open("POST", url, false);
    xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlHttp.send(postData);
    var result = xmlHttp.responseText;
    if (result == "success") {
        window.alert("模板保存成功"); 
        $("#add_locate").modal("hide");
        createTable(type);  
    }   
    if (result == "failure") {
        window.alert("模板保存失败");
    }
}
function fillLocateData($tr){
    var id = $tr.find("td").eq(1).text();
    var templateID = $tr.find("td").eq(2).text();
    $.ajax({
        url: "../../pages/Main/Records/GetTemplateLocationApply.ashx?templateID=" + id,
        type: "get",
        success: function (data) {
            var json = data.replace(/\n/g, "\\n");
            var diagnosisInfo = eval("(" + json + ")");
            $("#templateName_locate").val($tr.find("td").eq(0).text());
            if(diagnosisInfo.templateInfo[0].scanpartID!=""){
                $("#scanpart").val(diagnosisInfo.templateInfo[0].scanpartID.split("，"));
                $("#scanpart").multiselect('refresh');
            }else{
                $("#scanpart").multiselect('refresh');
            }

            $("#scanmethod").val(diagnosisInfo.templateInfo[0].scanmethodID);
            $("#up").val(diagnosisInfo.templateInfo[0].UpperBound);
            $("#down").val(diagnosisInfo.templateInfo[0].LowerBound);
            if(diagnosisInfo.templateInfo[0].Enhance=="1"){
                $("input[name='add']:first").prop("checked",true);
                $("#addmethod").val("").prop("disabled",false);
                $("#addmethod").val(diagnosisInfo.templateInfo[0].enhancemethod);
            }else{
                $("input[name='add']:last").prop("checked",true);
                $("#addmethod").val("").prop("disabled",true);
            }
            $("#special_locate").val(diagnosisInfo.templateInfo[0].locationrequireID);
            $("#remark_locate").val(diagnosisInfo.templateInfo[0].Remarks);
        }
    });
}
//---------------------------------------------------------------------------------------------------------------
function createAddFix(){
    createmodelselectItem(document.getElementById("modelselect"));
    createspecialrequestItem(document.getElementById("specialrequest"));
    createbodyposItem(document.getElementById("bodyPost"));
    createfixEquipItem(document.getElementById("fixEquip"));
    $("#sureAddFix").off("click").on("click", function () {
        postFix();
    });
}
function createbodyposItem(thiselement){
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
    var url = "../../pages/Main/Records/getbodypost.ashx";
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
    var url = "../../pages/Main/Records/getmodel.ashx";
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
    var url = "../../pages/Main/Records/getspecial.ashx";
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
    var url = "../../pages/Main/Records/getfixequip.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
//清空体位固定
function clearAddFix(){
    $("#templateName_fix").val("");
    $("#modelselect").val("");
    $("#fixEquip").val("");
    $("#bodyPost").val("");
    $("#specialrequest").val("");
    $("#Remarks_fix").val("");
}
function postFix(){
    var model = document.getElementById("modelselect").value;
    var special = document.getElementById("specialrequest").value;  
    var bodypost = document.getElementById("bodyPost").value;
    var fixequip = document.getElementById("fixEquip").value;
    var Remarks = document.getElementById("Remarks_fix").value;
    var userID = "0";
    var TemplateName = $("#templateName_fix").val();
    if(TemplateName == ""){
        alert("请填写模板名称");
        return false;
    }
    var oStr = '';
    var postData = {"treatid":"","model":model,"fixreq":special,"user":"0","fixequip":fixequip,"bodypost":bodypost,"Remarks":Remarks,"templatename":TemplateName};
    //这里需要将json数据转成post能够进行提交的字符串  name1=value1&name2=value2格式
    postData = (function(value){
    　　for(var key in value){
    　　　　oStr += key+"="+value[key]+"&";
    　　};
　    　return oStr;
    }(postData));
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/AddFixTemplateByPost.ashx";
    xmlHttp.open("POST", url, false);
    xmlHttp.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    xmlHttp.send(postData);
    var result = xmlHttp.responseText;
    if (result == "success") {
        window.alert("模板保存成功"); 
        $("#add_fix").modal("hide");
        createTable(type);  
    }   
    if (result == "failure") {
        window.alert("模板保存失败");
    }   
}
function updateFix($tr){
    var model = document.getElementById("modelselect").value;
    var special = document.getElementById("specialrequest").value;  
    var bodypost = document.getElementById("bodyPost").value;
    var fixequip = document.getElementById("fixEquip").value;
    var Remarks = document.getElementById("Remarks_fix").value;
    var userID = "0";
    var TemplateName = $("#templateName_fix").val();
    var templateID = $tr.find("td").eq(2).text();
    var postData = {"treatid":"","model":model,"fixreq":special,"user":"0","fixequip":fixequip,"bodypost":bodypost,"Remarks":Remarks,"templatename":TemplateName,"templateID":templateID};
    $.ajax({
        type: "POST",
        url: "../../pages/Root/updateFixtemplate.ashx",
        async: false,
        data: postData,
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                $("#add_fix").modal("hide");
                createTable(type);
                alert("模版保存成功");

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
function fillFixData($tr){
    var id = $tr.find("td").eq(1).text();
    var templateID = $tr.find("td").eq(2).text();
    $.ajax({
        url: "../../pages/Main/Records/GetTemplateFixApply.ashx?templateID=" + id,
        type: "get",
        success: function (data) {
            var json = data.replace(/\n/g, "\\n");
            var diagnosisInfo = eval("(" + json + ")");
            $("#templateName_fix").val($tr.find("td").eq(0).text());
            $("#modelselect").val(diagnosisInfo.templateInfo[0].Model_ID);
            $("#fixEquip").val(diagnosisInfo.templateInfo[0].FixedEquipment_ID);
            $("#bodyPost").val(diagnosisInfo.templateInfo[0].BodyPosition);
            $("#specialrequest").val(diagnosisInfo.templateInfo[0].FixedRequirements_ID);
            $("#Remarks_fix").val(diagnosisInfo.templateInfo[0].RemarksApply);
        }
    });
}
// -------------------------------------------------------------------------------------------------------
//清空诊断
function clearAddDiagnose() {
    $("#bingqing1").val("");
    loadone();
    $("#bingqing2").val("");
    loadtwo();
    $("#bingqing3").val("");
    loadthree();
    $("#bingli1").val("");
    loadonenext();
    $("#bingli2").val("");
    loadtwonext();
    $("#remark").val("");
    $("#templateName").val("");
    $("#part").multiselect('refresh');
    $("#newpart").multiselect('refresh');
}

//更新诊断
function updateDiagnose($tr){
    var templateName = document.getElementById("templateName");
    var remark = document.getElementById("remark");
    var part = $("#part").next("div").find("button").attr("title").replace(/ /g, "").replace(/,/g, "，");
    var newpart = $("#newpart").next("div").find("button").attr("title").replace(/ /g, "").replace(/,/g, "，");
    var Aim = document.getElementById("Aim");
    var copybingli1 = document.getElementById("copybingli1");
    var copybingli2 = document.getElementById("copybingli2");
    var copybingqing1 = document.getElementById("copybingqing1");
    var copybingqing2 = document.getElementById("copybingqing2");
    var copybingqing3 = document.getElementById("copybingqing3");

    if (templateName.value == "") {
        window.alert("请填写模板名称");
        return false;

    }
    if (copybingqing1.value == "" || copybingqing2.value == "" || copybingqing3.value == "") {
        window.alert("病情诊断未填写完整");
        return false;

    }
    if (copybingli1.value == "" || copybingli2.value == "") {
        window.alert("病理诊断未填写完整");
        return false;

    }

    if (part == "请选择") {
        window.alert("请选择病变部位");
        return false;

    }
    if (newpart == "请选择") {
        window.alert("请选择照射部位");
        return false;

    }
    $.ajax({
        type: "POST",
        url: "../../pages/Root/updateDiagtemplate.ashx",
        async: false,
        data: {
            templateID:$tr.find("td").eq(1).text(),
            diagRecordID:$tr.find("td").eq(2).text(),
            remark: remark.value,
            part: part,
            newpart: newpart,
            TemplateName: templateName.value,
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
                $("#add_diagnose").modal("hide");
                createTable(type);
                alert("模版保存成功");

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
//删除模板
function deleteTemplate($tr) {
    var id = $tr.find("td").eq(1).text();
    $.ajax({
        url: "../../pages/Main/Records/deleteTemplate.ashx?templateID=" + id,
        type: "get",
        async: false,
        success: function (data) {
            if (data == "success") {
                $("#add_diagnose").modal("hide");
                $("#add_fix").modal("hide");
                $("#add_locate").modal("hide");
                window.alert("删除成功");
                createTable(type);
            } else {
                window.alert("网络忙");
                return false;
            }
        },
        error: function () {
            alert("网络忙");
        }
    });
}
function fillDiagnoseData($tr) {
    var id = $tr.find("td").eq(1).text();
    var templateID = $tr.find("td").eq(2).text();
    $.ajax({
        url: "../../pages/Main/Records/GetTemplateDiag.ashx?templateID=" + id,
        type: "get",
        success: function (data) {
            var json = data.replace(/\n/g, "\\n");
            var diagnosisInfo = eval("(" + json + ")");
            $("#bingqing1").val(diagnosisInfo.diagnosisInfo[0].diagnosisresultName1.split(",")[0]);
            loadone();
            $("#bingqing2").val(diagnosisInfo.diagnosisInfo[0].diagnosisresultName1.split(",")[1]);
            loadtwo();
            $("#bingqing3").val(diagnosisInfo.diagnosisInfo[0].diagnosisresultName1.split(",")[2]);
            loadthree();
            $("#bingli1").val(diagnosisInfo.diagnosisInfo[0].diagnosisresultName2.split(",")[0]);
            loadonenext();
            $("#bingli2").val(diagnosisInfo.diagnosisInfo[0].diagnosisresultName2.split(",")[1]);
            loadtwonext();
            $("#Aim").val(diagnosisInfo.diagnosisInfo[0].treatmentaimID);
            $("#remark").val(diagnosisInfo.diagnosisInfo[0].Remarks);
            $("#templateName").val($tr.find("td").eq(0).text());
            $("#part").val(diagnosisInfo.diagnosisInfo[0].partID.split("，"));
            $("#part").multiselect('refresh');
            $("#newpart").val(diagnosisInfo.diagnosisInfo[0].LightPart_ID.split("，"));
            $("#newpart").multiselect('refresh');
        }
    });
}
function createAddDiagnose() {
    createPartItem(document.getElementById("part"));
    createbingqingItem(document.getElementById("bingqing1"));
    createbingliItem(document.getElementById("bingli1"));
    createNewPartIem(document.getElementById("newpart"));
    createAimItem(document.getElementById("Aim"));
    $("#sureAddDiagnose").off("click").on("click", function () {
        postDiagnose();
    });
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
function getbingqingItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getResultFirstItem.ashx";
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
function getbingliItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getpathologyItem.ashx";
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
    createbingqing2(bingqing2, text1);
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
    var text3 = $("#bingqing3 option:selected").text();
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
function createbingqing2(thiselement, text) {
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
function getbingqing2Item(text) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getResultSecondItem.ashx?text=" + text;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createbingqing3(thiselement, text1, text2) {
    var bingqing3Item = JSON.parse(getbingqing3Item(text1, text2)).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("无");
    thiselement.options[0].value = "";
    for (var i = 0; i < bingqing3Item.length; i++) {
        if (bingqing3Item[i] != "") {
            thiselement.options[i + 1] = new Option(bingqing3Item[i].Name);
            thiselement.options[i + 1].value = bingqing3Item[i].ID;
        }
    }
}
function getbingqing3Item(text1, text2) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getResultThirdItem.ashx?text1=" + text1 + "&text2=" + text2;
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
    var url = "../../pages/Main/Records/getpathologySecondItem.ashx?text=" + text;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}
function createPartItem(thiselement) {
    $(thiselement).empty();
    $(thiselement).multiselect("destroy");
    $.ajax({
        url: "../../pages/Main/Records/getpart.ashx",
        type: "get",
        success: function (data) {
            var dataObj = $.parseJSON(data);

            for (var i = 0; i < dataObj.Item.length; i++) {
                var $option = $("<option value=" + dataObj.Item[i].Name + ">" + dataObj.Item[i].Name + "</option>");
                $(thiselement).append($option);
            }
            $(thiselement).multiselect({
                nonSelectedText: "请选择",
                buttonWidth: '500px',
                numberDisplayed: 10,
            });
        }
    });

}
function createNewPartIem(thiselement) {
    $(thiselement).empty();
    $(thiselement).multiselect("destroy");
    $.ajax({
        url: "../../pages/Main/Records/getnewpart.ashx",
        type: "get",
        success: function (data) {
            var dataObj = $.parseJSON(data);

            for (var i = 0; i < dataObj.Item.length; i++) {
                var $option = $("<option value=" + dataObj.Item[i].Name + ">" + dataObj.Item[i].Name + "</option>");
                $(thiselement).append($option);
            }
            $(thiselement).multiselect({
                nonSelectedText: "请选择",
                buttonWidth: '500px',
                numberDisplayed: 10,
            });
        }
    });
}
function createAimItem(thiselement) {
    $(thiselement).empty();
    $.ajax({
        url: "../../pages/Main/Records/getaims.ashx",
        type: "get",
        success: function (data) {
            var dataObj = $.parseJSON(data);

            for (var i = 0; i < dataObj.Item.length; i++) {
                var $option = $("<option value=" + dataObj.Item[i].ID + ">" + dataObj.Item[i].Aim + "</option>");
                $(thiselement).append($option);
            }

        }
    });
}
function postDiagnose() {
    //var reg = / /;
    var templateName = document.getElementById("templateName");
    var remark = document.getElementById("remark");
    var part = $("#part").next("div").find("button").attr("title").replace(/ /g, "").replace(/,/g, "，");
    var newpart = $("#newpart").next("div").find("button").attr("title").replace(/ /g, "").replace(/,/g, "，");
    var Aim = document.getElementById("Aim");
    var copybingli1 = document.getElementById("copybingli1");
    var copybingli2 = document.getElementById("copybingli2");
    var copybingqing1 = document.getElementById("copybingqing1");
    var copybingqing2 = document.getElementById("copybingqing2");
    var copybingqing3 = document.getElementById("copybingqing3");

    if (templateName.value == "") {
        window.alert("请填写模板名称");
        return false;

    }
    if (copybingqing1.value == "" || copybingqing2.value == "" || copybingqing3.value == "") {
        window.alert("病情诊断未填写完整");
        return false;

    }
    if (copybingli1.value == "" || copybingli2.value == "") {
        window.alert("病理诊断未填写完整");
        return false;

    }

    if (part == "请选择") {
        window.alert("请选择病变部位");
        return false;

    }
    if (newpart == "请选择") {
        window.alert("请选择照射部位");
        return false;

    }
    $.ajax({
        type: "POST",
        url: "../../pages/Main/Records/recordDiagtemplate.ashx",
        async: false,
        data: {
            treatid: "0",
            diaguserid: "0",
            treatname: "",
            remark: remark.value,
            part: part,
            newpart: newpart,
            TemplateName: templateName.value,
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
                $("#add_diagnose").modal("hide");
                createTable(type);
                alert("模版保存成功");

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