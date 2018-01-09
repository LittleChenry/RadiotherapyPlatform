var patientbasic;
function print() {
    var $printArea = $("#printArea");
    $printArea.empty();
    var content = '<div style="margin-right:10px">门诊&nbsp&nbsp病区1&nbsp&nbsp病区2</div>';
    content = content + '<div class="paper-title">江&nbsp&nbsp苏&nbsp&nbsp省&nbsp&nbsp人&nbsp&nbsp民&nbsp&nbsp医&nbsp&nbsp院<br/><font size="5.5">放&nbsp射&nbsp治&nbsp疗&nbsp单</font></div>';
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    $.ajax({
        type: "POST",
        url: "patientforprint.ashx",
        async: false,
        data: {
            treat: treatmentID

        },
        dateType: "json",
        success: function (data) {
            patientbasic =eval("(" + data + ")");
            patientbasic=patientbasic.patient[0];
        },
        error: function (data) {
            alert("error");
        }
    });
    content =content+'<div class="paper-content"><div class="single-row"><div class="item col-xs-4">姓名：<span  class="underline">' + patientbasic.Name + '</span></div><div class="item col-xs-4">放疗号：<span  class="underline">' + patientbasic.Radiotherapy_ID + '</span></div><div class="item col-xs-4">性别：<span  class="underline">' + sex(patientbasic.Gender) + '</span></div></div>' +
                  '<div class="single-row"><div class="item col-xs-4">年龄：<span class="underline">' + patientbasic.Age + '</span></div>' +
                  '<div class="item col-xs-4">联系电话：<span  class="underline">' + patientbasic.Contact1 + '</span></div>' +
                  '<div class="item col-xs-4">主管医生：<span  class="underline">' + patientbasic.RegisterDoctor + '</span></div></div>' +
                  '<div class="single-row"><div class="item col-xs-4">治疗目标：<span  class="underline">' + patientbasic.treatmentaim + '</span></div>' +
                  '<div class="item col-xs-4">诊断结果：<span  class="underline">' + patientbasic.diagnosisresult + '</span></div>'+
                  '<div class="item col-xs-4">疗程：<span  class="underline">' + patientbasic.Treatmentdescribe + '</span></div></div>'+
                  '<div class="single-row"><div class="item col-xs-12">地址：<span  class="underline">' + patientbasic.Address + '</span></div></div></div>';
    content = content + '<div class="paper-content"><div class="single-row"><div class="item area-group col-xs-12"> <table id="pri" class="table table-bordered"><thead><tr><th>靶区</th><th>外放/mm</th><th>PTV</th><th>单次量cGy</th><th>次数</th>' +
                        '<th>总剂量cGy</th><th>体积/%</th><th>优先级</th></tr></thead></table></div></div>';
    content = content + '<div id="fieldinfoprint" class="single-row"><div class="item area-group col-xs-12"><table id="Fieldprint" class="table table-bordered"><thead><tr>' +
                    '<th>射野ID</th><th>MU</th><th>放疗设备</th><th>照射技术</th><th>射野类型</th><th>能量</th><th>源皮距</th><th>机架角</th><th>机头角</th><th>床转交</th><th>子野数</th></tr></thead></table></div></div></div>';
    content = content + '<div class="paper-content"><div class="single-row"><div class="item col-xs-4">治疗部位：<span  class="underline">' + patientbasic.partID + '</span></div><div class="item col-xs-4">照射部位：<span  class="underline">' + patientbasic.LightPart_ID + '</span></div><div class="item col-xs-4">摆位信息：<span  class="underline">' + patientbasic.pos + '</span></div></div>' +
                      '<div class="single-row"><div class="item col-xs-4">次数：<span  class="underline">' + patientbasic.total + '</span></div><div class="item col-xs-4">模式：<span  class="underline">' + patientbasic.splitway + '</span></div><div class="item col-xs-4">首次治疗日期：<span  class="underline">' + patientbasic.firsttime + '</span></div></div>';
    if (patientbasic.parameterx == "") {
        content = content + '</div>';
    } else {
        content = content + '<div class="single-row"><div class="item col-xs-12">移床参数：X:<span  class="underline">' + patientbasic.parameterx + '</span>(cm)Y:<span  class="underline">' + patientbasic.parametery + '</span>(cm)Z:<span  class="underline">' + patientbasic.parameterz + '</span>(cm)</div></div></div>';
    }
    content = content + '<div class="paper-footer"><div class="single-row"><div class="item col-xs-4">医生：<span  class="underline">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></div><div class="item col-xs-4">物理师：<span  class="underline">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></div><div class="item col-xs-4">网络确认：<span  class="underline">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span></div></div></div></div>';
    $printArea.append(content);
    DosagePriority = patientbasic.Priority;
    var table = document.getElementById("pri");
    var tbody = document.createElement("tbody");
    for (var i = table.rows.length - 1; i > 0; i--) {
        table.deleteRow(i);
    }
    DosagePriority = DosagePriority.substring(0, DosagePriority.length - 1);
    var lists = new Array();
    lists = DosagePriority.split(";");
    for (var i = 0; i < lists.length; i++) {
        var list = new Array();
        list = lists[i].split(",");
        var tr = document.createElement("tr");
        for (var j = 0; j < list.length; j++) {
            var td = document.createElement("td");
            var textNode = document.createTextNode(list[j]);
            td.appendChild(textNode);
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    tbody.style.textAlign = "center";
    table.appendChild(tbody);
    var fildinfo = getfieldinfo(treatmentID);
    if (fildinfo.length == 0) {
        $("#fieldinfoprint").hide();
    } else {
        var table = $("#Fieldprint");
        for (var k = 0; k < fildinfo.length; k++) {
            var content = '<tr><td>' + fildinfo[k].code + '</td><td>' + fildinfo[k].mu + '</td><td>' + fildinfo[k].equipment + '</td><td>' + fildinfo[k].radiotechnique;
            content = content + '</td><td>' + fildinfo[k].radiotype + '</td><td>' + fildinfo[k].energy + '</td><td>' + fildinfo[k].wavedistance + '</td><td>' + fildinfo[k].angleframe;
            content = content + '</td><td>' + fildinfo[k].noseangle + '</td><td>' + fildinfo[k].bedrotation + '</td><td>' + fildinfo[k].subfieldnumber + '</td></tr>';
            table.append(content);
        }
    }
    var $pagetitle = $(".paper-title");
    $printArea.show();
    $printArea.printArea({ "mode": "popup", "popClose": true });
    $pagetitle.prev().remove();
    $printArea.hide();
}
