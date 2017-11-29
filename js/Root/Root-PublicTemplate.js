var type = 1;
$(function () {
    document.getElementById('aa').value = 0;
    document.getElementById('bb').value = 0;
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
            $("#add_design").modal({
                backdrop:false
            });
              clearAddDesign();
              createAddDesign();
             $("#sureDeleteDesign").hide();
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
                        createAddDesign();
                        $("#add_design").modal({
                            backdrop: false
                        });
                        $("#sureDeleteDesign").show();
                        fillDesignData($(this));
                        var $tr = $(this);
                        $("#sureDeleteDesign").off("click").on("click", function () {
                            deleteTemplate($tr);
                        });
                        $("#sureAddDesign").off("click").on("click", function () {
                            updateDesign($tr);
                        });
                    });
                });
            }
        });
    }
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
                $("#add_design").modal("hide");
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
//---------------------------------------------------------------------------------------------------------------
//生成modal下拉框等数据
function createAddDesign(){
    //

    createTechnologyItem(document.getElementById("technology_design"));
    createEquipmentItem(document.getElementById("equipment_design"));
    $("#sureAddDesign").off("click").on("click", function () {
        postDesign();
    });
}
//清空modal数据
function clearAddDesign(){
    $("#templateName_design").val("");
    $("#Remarks_design").val("");
    for (var i = parseInt($("#aa").val()); i >= 0; i--) {
        deleteDosagePriority(i);
    }
    for (var i = parseInt($("#bb").val()); i >= 0; i--) {
        deleteDosage(i);
    }
    $("#technology_design").val("allItem");
    $("#equipment_design").val("allItem");
}
//根据选中$tr的id值，查询此条模版的相关数据,填入modal
function fillDesignData($tr){
    $("#templateName_design").val($tr.find("td").eq(0).text());
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/GetTemplateDesignApply.ashx?templateID=" + $tr.find("td").eq(1).text();
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    document.getElementById("Remarks_design").value = obj1.templateInfo[0].RadiotherapyHistory;
    if(obj1.templateInfo[0].DosagePriority!=""){
        addDosagePriority1(obj1.templateInfo[0].DosagePriority);
    }
    if(obj1.templateInfo[0].Dosage!=""){
        addDosage1(obj1.templateInfo[0].Dosage);
    }
    document.getElementById("technology_design").value = obj1.templateInfo[0].technology;
    document.getElementById("equipment_design").value = obj1.templateInfo[0].equipment;
}
//更新
function updateDesign($tr){
    var templateName_design = document.getElementById("templateName_design").value
    if(templateName_design==""){
        window.alert("请填写模版名称");
        return false;
    }
    if (document.getElementById("technology_design").value == "allItem") {
        window.alert("治疗技术没有选择");
        return false;
    }
    $("#updateID").val($tr.find("td").eq(2).text());
    var form = new FormData(document.getElementById("design_form"));
    $.ajax({
        url: "updateDesigntemplate.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        async: false,
        success: function (data) {
            alert("模板保存成功");
            $("#add_design").modal("hide");
            createTable(type);         
        },
        error: function (e) {
            alert("error");
        },
        failure: function (e) {
             alert("模板保存失败");
        }
    });
}
//添加
function postDesign(){
    var templateName_design = document.getElementById("templateName_design").value
    if(templateName_design==""){
        window.alert("请填写模版名称");
        return false;
    }
    
    if (document.getElementById("technology_design").value == "allItem") {
        window.alert("治疗技术没有选择");
        return false;
    }
    $("#templateName_design").val(templateName_design + "(公共模版)");
    var form = new FormData(document.getElementById("design_form"));
    $.ajax({
        url: "AddDesignTemplateByPost.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        async: false,
        success: function (data) {
            alert("模板保存成功");
            $("#add_design").modal("hide");
            createTable(type);         
        },
        error: function (e) {
            alert("error");
        },
        failure: function (e) {
             alert("模板保存失败");
        }
    });
}
function addDosagePriority() {
    var table = document.getElementById("Priority");
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
    t1.style.padding = "0px";
    t2.style.padding = "0px";
    t3.style.padding = "0px";
    t4.style.padding = "0px";
    t5.style.padding = "0px";
    t6.style.padding = "0px";
    t7.style.padding = "0px";
    t8.style.padding = "0px";  
    t9.style.cssText = "text-align: center;padding:0px;vertical-align: middle";
    t9.id = "delete"+rows;
    t1.innerHTML = '<input id="Prioritytype' + rows + '" name="Prioritytype' + rows + '" type="text" class="td-input" />';
    t2.innerHTML = '<input id="Priorityout' + rows + '" name="Priorityout' + rows + '" type="text" class="td-input" />';
    t3.innerHTML = '<input id="Prioritptv' + rows + '" name="Prioritptv' + rows + '" type="text" class="td-input" />';
    t4.innerHTML = '<input id="Prioritcgy' + rows + '" name="Prioritcgy' + rows + '" type="number" class="td-input" />';
    t5.innerHTML = '<input id="Priorittime' + rows + '" name="Priorittime' + rows + '" type="number" class="td-input" />';
    t6.innerHTML = '<input id="Prioritsum' + rows + '" name="Prioritsum' + rows + '" type="number" class="td-input" />';
    t7.innerHTML = '<input id="Prioritremark' + rows + '" name="Prioritremark' + rows + '" type="text" class="td-input" />';
    t8.innerHTML = '<input id="Priorit' + rows + '" name="Priorit' + rows + '" type="number" class="td-input" />';
    t9.innerHTML = '<a href="javascript:deleteDosagePriority(' + rows + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>'; 
    var i = rows;
    $('#Prioritcgy' + i).bind('input propertychange', { i: i }, function (e) {
        if (document.getElementById("Prioritcgy" + e.data.i).value == "") {
            document.getElementById("Prioritsum" + e.data.i).value = "";
        } else {
            document.getElementById("Prioritsum" + e.data.i).value = parseInt(document.getElementById("Prioritcgy" + e.data.i).value) * parseInt(document.getElementById("Priorittime" + e.data.i).value);
        }
    });
    $('#Priorittime' + i).bind('input propertychange', { i: i }, function (e) {
        if (document.getElementById("Priorittime" + e.data.i).value == "") {
            document.getElementById("Prioritsum" + e.data.i).value = "";
        } else {
            document.getElementById("Prioritsum" + e.data.i).value = parseInt(document.getElementById("Prioritcgy" + e.data.i).value) * parseInt(document.getElementById("Priorittime" + e.data.i).value);
        }
    });
    aa = rows;
    document.getElementById("aa").value = aa;
}
function deleteDosagePriority(row) {
    var table = document.getElementById("Priority");
    var maxrow = table.rows.length;
    //var row = Number(currentbutton.id.replace(/[^0-9]/ig, ""));
    for (var i = row + 1; i < maxrow - 1; i++) {
        var j = i - 1;
        var td1 = document.getElementById("Prioritytype" + i);
        td1.id = "Prioritytype" + j;
        td1.name = "Prioritytype" + j;
        var td2 = document.getElementById("Priorityout" + i);
        td2.id = "Priorityout" + j;
        td2.name = "Priorityout" + j;
        var td3 = document.getElementById("Prioritptv" + i);
        td3.id = "Prioritptv" + j
        td3.name = "Prioritptv" + j;
        var td4 = document.getElementById("Prioritcgy" + i);
        td4.id = "Prioritcgy" + j;
        td4.name = "Prioritcgy" + j;
        var td5 = document.getElementById("Priorittime" + i);
        td5.id = "Priorittime" + j;
        td5.name = "Priorittime" + j;
        var td6 = document.getElementById("Prioritsum" + i);
        td6.id = "Prioritsum" + j;
        td6.name = "Prioritsum" + j;
        var td7 = document.getElementById("Prioritremark" + i);
        td7.id = "Prioritremark" + j;
        td7.name = "Prioritremark" + j;
        var td8 = document.getElementById("Priorit" + i);
        td8.id = "Priorit" + j;
        td8.name = "Priorit" + j;        
        var td9 = document.getElementById("delete" + i);
        td9.id = "delete" + j;
        td9.innerHTML = '<a  href="javascript:deleteDosagePriority(' + j + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';;
    }
    table.deleteRow(row + 1);
    aa--;
    document.getElementById("aa").value=aa;
}
function addDosage() {
    var table = document.getElementById("Dosage");
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
    t11.style.cssText = "text-align: center;padding:0px;vertical-align: middle";
    t11.id = "deletes" + rows;
    t1.innerHTML = '<input id="type' + rows + '" name="type' + rows + '" type="text" class="td-input" />';
    t2.innerHTML = '<input id="dv' + rows + '" name="dv' + rows + '" type="text" class="td-input" />';
    t3.innerHTML = '<input type="text" class="td-input" value="<" readonly="true" />';
    t4.innerHTML = '<input id="number' + rows + '" name="number' + rows + '" type="number" class="td-input" />';
    t5.innerHTML = '<input id="out' + rows + '" name="out' + rows + '" type="text" class="td-input" />';
    t6.innerHTML = '<input id="prv' + rows + '" name="prv' + rows + '" type="text" class="td-input" />';
    t7.innerHTML = '<input id="num' + rows + '" name="num' + rows + '" type="number" class="td-input" />';
    t8.innerHTML = '<input type="text" class="td-input" value="<" readonly="true" />';
    t9.innerHTML = '<input id="numbers' + rows + '" name="numbers' + rows + '" type="text" class="td-input" />';
    t10.innerHTML = '<input id="pp' + rows + '" name="pp' + rows + '" type="number" class="td-input" />';
    t11.innerHTML = '<a href="javascript:deleteDosage(' + rows + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
    bb = rows;
    document.getElementById("bb").value =bb;
}
function addDosagePriority1(DosagePriority) {
    var table = document.getElementById("Priority");
    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    var rows = table.rows.length;
    for (var j = rows-1; j > 0; j--) {
        table.deleteRow(j);
    }   
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var row = table.insertRow(i+1);        
        var t1 = row.insertCell(0);
        var t2 = row.insertCell(1);
        var t3 = row.insertCell(2);
        var t4 = row.insertCell(3);
        var t5 = row.insertCell(4);
        var t6 = row.insertCell(5);
        var t7 = row.insertCell(6);
        var t8 = row.insertCell(7);
        var t9 = row.insertCell(8);
        t1.style.padding = "0px";
        t2.style.padding = "0px";
        t3.style.padding = "0px";
        t4.style.padding = "0px";
        t5.style.padding = "0px";
        t6.style.padding = "0px";
        t7.style.padding = "0px";
        t8.style.padding = "0px";
        t9.style.cssText = "text-align: center;padding:0px;vertical-align: middle";
        t9.id = "delete" + i;
        t1.innerHTML = '<input id="Prioritytype' + i + '" name="Prioritytype' + i + '" value="'+list[0]+'" type="text" class="td-input" />';
        t2.innerHTML = '<input id="Priorityout' + i + '" name="Priorityout' + i + '" value="' + list[1] + '" type="text" class="td-input" />';
        t3.innerHTML = '<input id="Prioritptv' + i + '" name="Prioritptv' + i + '" value="' + list[2] + '" type="text" class="td-input" />';
        t4.innerHTML = '<input id="Prioritcgy' + i + '" name="Prioritcgy' + i + '" value="' + list[3] + '" type="number" class="td-input" />';
        t5.innerHTML = '<input id="Priorittime' + i + '" name="Priorittime' + i + '" value="' + list[4] + '" type="number" class="td-input" />';
        t6.innerHTML = '<input id="Prioritsum' + i + '" name="Prioritsum' + i + '" value="' + list[5] + '" type="number" class="td-input" />';
        t7.innerHTML = '<input id="Prioritremark' + i + '" name="Prioritremark' + i + '" value="' + list[6] + '" type="text" class="td-input" />';
        t8.innerHTML = '<input id="Priorit' + i + '" name="Priorit' + i + '" type="number" value="' + list[7] + '" class="td-input" />';
        t9.innerHTML = '<a href="javascript:deleteDosagePriority(' + i + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';
        $('#Prioritcgy' + i).bind('input propertychange', { i: i }, function (e) {
            if (document.getElementById("Prioritcgy" + e.data.i).value == "") {
                document.getElementById("Prioritsum" + e.data.i).value = "";
            } else {
                document.getElementById("Prioritsum" + e.data.i).value = parseInt(document.getElementById("Prioritcgy" + e.data.i).value) * parseInt(document.getElementById("Priorittime" + e.data.i).value);
            }
        });
        $('#Priorittime' + i).bind('input propertychange', { i: i }, function (e) {
            if (document.getElementById("Priorittime" + e.data.i).value == "") {
                document.getElementById("Prioritsum" + e.data.i).value = "";
            } else {
                document.getElementById("Prioritsum" + e.data.i).value = parseInt(document.getElementById("Prioritcgy" + e.data.i).value) * parseInt(document.getElementById("Priorittime" + e.data.i).value);
            }
        });
    }
    aa = lists.length - 1;
    document.getElementById("aa").value = aa;
}
function addDosage1(DosagePriority) {
    var table = document.getElementById("Dosage");
    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    var rows = table.rows.length;
    for (var j = rows - 1; j > 0; j--) {
        table.deleteRow(j);
    }
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var row = table.insertRow(i + 1);
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
        t11.style.cssText = "text-align: center;padding:0px;vertical-align: middle";
        t11.id = "deletes" + i;
        t1.innerHTML = '<input id="type' + i + '" name="type' + i + '" value="' + list[0] + '"type="text" class="td-input" />';
        t2.innerHTML = '<input id="dv' + i + '" name="dv' + i + '" type="text" value="' + list[1] + '" class="td-input" />';
        t3.innerHTML = '<input type="text" class="td-input" value="<" readonly="true" />';
        t4.innerHTML = '<input id="number' + i + '" name="number' + i + '" type="number" value="' + list[3] + '" class="td-input" />';
        t5.innerHTML = '<input id="out' + i + '" name="out' + i + '" type="text" value="' + list[4] + '" class="td-input" />';
        t6.innerHTML = '<input id="prv' + i + '" name="prv' + i + '" type="text" value="' + list[5] + '" class="td-input" />';
        t7.innerHTML = '<input id="num' + i + '" name="num' + i + '" type="number" value="' + list[6] + '" class="td-input" />';
        t8.innerHTML = '<input type="text" class="td-input" value="<" readonly="true" />';
        t9.innerHTML = '<input id="numbers' + i + '" name="numbers' + i + '" type="text" value="' + list[8] + '" class="td-input" />';
        t10.innerHTML = '<input id="pp' + i + '" name="pp' + i + '" type="number" value="' + list[9] + '" class="td-input" />';
        t11.innerHTML = '<a href="javascript:deleteDosage(' + i + ');"><i class="fa fa-fw fa-minus-circle" value="' + list[10] + '" style="font-size:18px;"></i></a>';
    }
    bb = lists.length-1;
    document.getElementById("bb").value = bb;
}
function deleteDosage(row) {
    var table = document.getElementById("Dosage");
    var maxrow = table.rows.length;
    //var row = Number(currentbutton.id.replace(/[^0-9]/ig, ""));
    for (var i = row + 1; i < maxrow - 1; i++) {
        var j = i - 1;
        var td1 = document.getElementById("type" + i);
        td1.id = "type" + j;
        td1.name = "type" + j;
        var td2 = document.getElementById("dv" + i);
        td2.id = "dv" + j;
        td2.name = "dv" + j;

        var td4 = document.getElementById("number" + i);
        td4.id = "number" + j;
        td4.name = "number" + j;
        var td5 = document.getElementById("out" + i);
        td5.id = "out" + j;
        td5.name = "out" + j;
        var td6 = document.getElementById("prv" + i);
        td6.id = "prv" + j;
        td6.name = "prv" + j;
        var td7 = document.getElementById("num" + i);
        td7.id = "num" + j;
        td7.name = "num" + j;
        var td9 = document.getElementById("numbers" + i);
        td9.id = "numbers" + j;
        td9.name = "numbers" + j;
        var td10 = document.getElementById("pp" + i);
        td10.id = "pp" + j;
        td10.name = "pp" + j;        
        var td11 = document.getElementById("deletes" + i);
        td11.id = "deletes" + j;
        td11.innerHTML = '<a  href="javascript:deleteDosage(' + j + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>';;
    }
    table.deleteRow(row + 1);
    bb--;
    document.getElementById("bb").value = bb;
}
function createTechnologyItem(thiselement) {
    var PartItem = JSON.parse(getTechnology()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--治疗技术选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }
    if (PartItem[0].defaultItem != "") {
        thiselement.value = PartItem[0].defaultItem;
    }
}
function getTechnology() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getTechnology.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function createEquipmentItem(thiselement) {
    var PartItem = JSON.parse(getEquipment()).item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("--放疗设备选择--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < PartItem.length; i++) {
        if (PartItem[i] != "") {
            thiselement.options[i + 1] = new Option(PartItem[i].Name);
            thiselement.options[i + 1].value = parseInt(PartItem[i].ID);
        }
    }
    if (PartItem[0].defaultItem != "") {
        thiselement.value = PartItem[0].defaultItem;
    }
}
function getEquipment() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/Records/getEqForDesign.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
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
                buttonWidth: "100%",
                numberDisplayed: 10,
                buttonContainer: "<div class='multiselect-wrapper' />"
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
    var templateName = document.getElementById("templateName_locate").value+"(公用模板)";
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
    var TemplateName = $("#templateName_fix").val();
    var userID = "0";
    if(TemplateName == ""){
        alert("请填写模板名称");
        return false;
    }
    TemplateName = $("#templateName_fix").val() + "(公用模板)";
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
                buttonWidth: "100%",
                numberDisplayed: 10,
                buttonContainer: "<div class='multiselect-wrapper' />"
            });
            $(thiselement).css('width', '500px');
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
                buttonWidth: "100%",
                numberDisplayed: 10,
                buttonContainer: "<div class='multiselect-wrapper' />"

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
            TemplateName: templateName.value+"(公用模板)",
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