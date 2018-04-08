var patientbasic;
function print() {
    var $printArea = $("#printArea");
    $printArea.empty();
    var content = '<div style="text-align:right;"><i class="fa fa-square-o patientType"> 门诊</i><i class="fa fa-square-o patientType"> 病区1</i><i class="fa fa-square-o patientType"> 病区2</i></div>';
    content = content + '<div class="paper-title" style="margin-bottom: 0px;">'+
                        '<p style="font-size:18px;margin-bottom:0px;">江&nbsp苏&nbsp省&nbsp人&nbsp民&nbsp医&nbsp院</p>'+
                        '<p style="font-size:22px;margin-bottom:5px;">放射治疗单</p></div>';
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    $.ajax({
        type: "POST",
        url: "patientforprint.ashx",
        async: false,
        data: {
            chid: childdesigns[allpagenumber].chid

        },
        dateType: "json",
        success: function (data) {
            data = data.replace(/\r/g, "");
            data = data.replace(/\n/g, "\\n");
            data = data.replace(/\t/g, "");
            patientbasic =eval("(" + data + ")");
            patientbasic=patientbasic.patient[0];
        },
        error: function (data) {
            alert("error");
        }
    });
    content =content+'<div class="paper-content" style="margin-top:15px;"><div class="single-row" style="min-height:28px;">'+
                    '<div class="item col-xs-4">姓名：<span class="underline">' + patientbasic.Name + '</span></div>'+
                    '<div class="item col-xs-4">放疗号：<span class="underline">' + patientbasic.Radiotherapy_ID + '</span></div>'+
                    '<div class="item col-xs-4">主管医生：<span class="underline">' + patientbasic.RegisterDoctor + '</span></div></div>' +
                    '<div class="single-row" style="min-height:28px;">'+
                    '<div class="item col-xs-4">性别：<span class="underline">' + sex(patientbasic.Gender) + '</span></div>' +
                    '<div class="item col-xs-4">年龄：<span class="underline">' + patientbasic.Age + '</span></div>' +
                    '<div class="item col-xs-4">临床诊断：<span class="underline">' + patientbasic.diagnosisresult + '</span></div></div>'+
                    '<div class="single-row" style="min-height:28px;">'+
                    '<div class="item col-xs-6">联系电话1：<span class="underline">' + patientbasic.Contact1 + '</span></div>' +
                    '<div class="item col-xs-6">联系电话2：<span class="underline">' + patientbasic.Contact2 + '</span></div></div>' +
                    '<div class="single-row" style="min-height:20px;">'+
                    '<div class="item col-xs-12">地址：<span class="underline">' + patientbasic.Address + '</span></div></div></div>';

    content = content + '<div class="paper-content" style="margin-top:10px;border-bottom:0px;">'+
                        '<div id="pridiv" class="single-row"><div class="item area-group col-xs-12">' +
                        '<table id="pri" class="table table-bordered" style="margin-bottom:0px;"><thead><tr><th style="padding:5px 8px;">靶区</th><th style="padding:5px 8px;">外放/mm</th><th style="padding:5px 8px;">PTV</th><th style="padding:5px 8px;">单次量cGy</th><th style="padding:5px 8px;">次数</th>' +
                        '<th style="padding:5px 8px;">总剂量cGy</th><th style="padding:5px 8px;">体积/%</th><th style="padding:5px 8px;">优先级</th></tr></thead></table></div></div>';

    content = content + '<div id="fieldinfoprint" class="single-row"><div class="item area-group col-xs-12"><table id="Fieldprint" class="table table-bordered" style="margin-bottom:5px;"><thead><tr>' +
                        '<th style="padding:5px 8px;">射野ID</th><th style="padding:5px 8px;">MU</th><th style="padding:5px 8px;">放疗设备</th><th style="padding:5px 8px;">照射技术</th><th style="padding:5px 8px;">射野类型</th><th style="padding:5px 8px;">能量</th><th style="padding:5px 8px;">源皮距</th>'+
                        '<th style="padding:5px 8px;">机架角</th><th style="padding:5px 8px;">机头角</th><th style="padding:5px 8px;">床转交</th><th style="padding:5px 8px;">子野数</th></tr></thead></table></div></div>';
    var fixedeq = patientbasic.fixedeq == "" ? "":'，' + patientbasic.fixedeq;
    var model = patientbasic.model == "" ? "":'，' + patientbasic.model;
    var headrest = patientbasic.headrest == "" ? "":'，' + patientbasic.headrest;
    var specialrequire = patientbasic.specialrequire == "" ? "":'，' + patientbasic.specialrequire;
    var remarkinfo = patientbasic.remarkinfo == "" ? "" : '，' + patientbasic.remarkinfo;
    var refer = patientbasic.refer;
    content = content + '<div class="single-row" style="min-height:28px;">' +
                        '<div class="item col-xs-12">摆位信息：<span class="underline">' + patientbasic.pos + fixedeq + model + headrest + specialrequire + remarkinfo + '</span></div></div>';
    if (patientbasic.iscommon == "0") {
        content = content + '<div class="single-row" style="min-height:28px;">' +
                       '<div class="item col-xs-5">限光筒：<span class="underline">' + childdesigns[allpagenumber].fieldinfo[0].guangxianLeft + '</span>X<span class="underline">' + childdesigns[allpagenumber].fieldinfo[0].guangxianRight + '</span></div></div>';
    }
    if (patientbasic.parameterx != "") {
        content = content + '<div class="single-row" style="min-height:28px;"><div class="item col-xs-8">移床参数：X:<span  class="underline">' + zhengfu(patientbasic.parameterx) + '</span>(cm) , Y:<span  class="underline">' + zhengfuy(patientbasic.parameterz) + '</span>(cm) , Z:<span  class="underline">' + zhengfuz(patientbasic.parametery) + '</span>(cm)</div>';
    }
    if (refer != "") {
        if (!isNaN(refer)) {
            content = content + '<div class="item col-xs-4">体表参考刻度：<span class="underline">' + refer + '</span>(cm)</div></div>';
        } else {
            content = content + '<div class="item col-xs-4">体表参考刻度：<span class="underline">' + refer + '</span></div></div>';
        }
    } else {
        content = content + '</div>'
    }
    content = content + '<div class="single-row" style="min-height:28px;">'+
                        '<div class="item col-xs-4">治疗部位：<span class="underline">' + patientbasic.partID + '</span></div>'+
                        '<div class="item col-xs-4">治疗目标：<span  class="underline">' + patientbasic.treatmentaim + '</span></div>' +
                        '<div class="item col-xs-4">疗程计划：<span  class="underline">' + patientbasic.Treatmentdescribe + '</span></div></div>'+
                        '<div class="single-row" style="min-height:28px;">'+
                        '<div class="item col-xs-4">分割方式：<span  class="underline">' + patientbasic.splitway + '</span></div>' +
                        '<div class="item col-xs-4">机器总跳数：<span  class="underline">' + patientbasic.amount + '</span></div>' +
                        '<div class="item col-xs-4">首次执行时间：<span  class="underline">' + patientbasic.firsttime + '</span></div></div>'+
                        '<div class="single-row" style="min-height:60px;"><div class="item col-xs-12">特殊医嘱：</div></div></div>';
    content = content + '<div class="paper-footer" style="border-top:1px solid black;position:absolute;bottom:0px;"><div class="single-row" style="margin-top:20px;min-height:20px;"><div class="item col-xs-4"><span>医&nbsp&nbsp生：</span><span class="underline" style="padding-left:70%;">&nbsp</span></div><div class="item col-xs-4"><span>物理师：</span><span class="underline" style="padding-left:70%;">&nbsp</span></div><div class="item col-xs-4"><span>剂量师：</span><span class="underline" style="padding-left:70%;">&nbsp</span></div></div></div></div>';
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
            td.style.padding = "5px 8px";
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    tbody.style.textAlign = "center";
    table.appendChild(tbody);
    var number = allpagenumber;
    var fildinfo = childdesigns[number].fieldinfo;
    if (fildinfo.length == 0) {
        $("#fieldinfoprint").hide();
    } else {
        var table = $("#Fieldprint");
        for (var k = 0; k < fildinfo.length; k++) {
            var content = '<tr><td style="padding:5px 8px;">' + fildinfo[k].code + '</td><td style="padding:5px 8px;">' + fildinfo[k].mu + '</td><td style="padding:5px 8px;">' + fildinfo[k].equipment + '</td><td style="padding:5px 8px;">' + fildinfo[k].radiotechnique;
            content = content + '</td><td style="padding:5px 8px;">' + fildinfo[k].radiotype + '</td><td style="padding:5px 8px;">' + fildinfo[k].energy + '</td><td style="padding:5px 8px;">' + fildinfo[k].wavedistance + '</td><td style="padding:5px 8px;">' + fildinfo[k].angleframe;
            content = content + '</td><td style="padding:5px 8px;">' + fildinfo[k].noseangle + '</td><td style="padding:5px 8px;">' + fildinfo[k].bedrotation + '</td><td style="padding:5px 8px;">' + fildinfo[k].subfieldnumber + '</td></tr>';
            table.append(content);
        }
    }
    var $pagetitle = $(".paper-title");
    $printArea.show();
    $printArea.printArea({ "mode": "popup", "popClose": true });
    $pagetitle.prev().remove();
    $printArea.hide();
}
function zhengfu(str) {
    if (parseFloat(str) == 0) {
        return "0";
    }
    if (parseFloat(str) > 0) {
        return "左" + Math.abs(parseFloat(str));
    }
    if (parseFloat(str) < 0) {
        return "右" + Math.abs(parseFloat(str));
    }
}

function zhengfuz(str) {
    if (parseFloat(str) == 0) {
        return "0";
    }
    if (parseFloat(str) > 0) {
        return "升" + Math.abs(parseFloat(str));
    }
    if (parseFloat(str) < 0) {
        return "降" + Math.abs(parseFloat(str));
    }
}
function zhengfuy(str) {
    if (parseFloat(str) == 0) {
        return "0";
    }
    if (parseFloat(str) > 0) {
        return "进" + Math.abs(parseFloat(str));
    }
    if (parseFloat(str) < 0) {
        return "出" + Math.abs(parseFloat(str));
    }
}