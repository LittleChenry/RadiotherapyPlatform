window.addEventListener("load", Init, false);
var userName;
var userID;
var allpagenumber;
var obj = [];
var equipmentfrominfo = "";
var childdesigns;
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    getUserID();
    if ((typeof (userID) == "undefined")) 
    {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var session = getSession();
    var patient = getFAPatientInfo(treatmentID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = patient.Treatmentdescribe;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    var texthos = hosttext(patient.Hospital_ID);
    document.getElementById("hospitalid").innerHTML = texthos;
    document.getElementById("lightpart").innerHTML = patient.LightPart_ID;
    var groupprogress = patient.Progress.split(",");
    var i = 0;
    var iscommon = judgecommon(treatmentID);
    if (iscommon == "1") 
    {
            var designInfo = getDesignInfo(treatmentID);
            document.getElementById("Remarks").innerHTML = designInfo[i].RadiotherapyHistory;
            readDosagePriority(designInfo[i].DosagePriority);
            document.getElementById("technology").innerHTML = designInfo[i].technology;
            document.getElementById("equipment").innerHTML = designInfo[i].equipment;
            document.getElementById("PlanSystem").innerHTML = designInfo[i].PlanSystem;

    }
    if (iscommon == "0") 
    {
        $("#designinfo").hide();
    }
   
    var type = geteuqipmenttype(treatmentID);
    createfixEquipmachine(document.getElementById("equipmentName"), window.location.search.split("=")[2], type);
   
    var date = new Date();
    document.getElementById("AppiontDate").value = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
   
    $("#AppiontDate").unbind("change").change(function () {
        if ($("#AppiontDate").val() == "") {
            var date = new Date();
            $("#AppiontDate").val(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
        }
        CreateNewAppiontTable(event);
    });
    $("#previousday").click(function () {
        var date = $("#AppiontDate").val();
        var newdate = dateAdd2(date, -1);
        $("#AppiontDate").val(newdate);
        CreateNewAppiontTable(event);
    });
    $("#nextday").click(function () {
        var date = $("#AppiontDate").val();
        var newdate = dateAdd2(date, 1);
        $("#AppiontDate").val(newdate);
        CreateNewAppiontTable(event);
    });
    $("#timeselect").bind("change", function () {
        var dateString = document.getElementById("AppiontDate").value;
        CreateCurrentEquipmentTbale(dateString);
    });
   childdesigns = getAllChildDesign(patient.ID);
    for (var k = 0; k < childdesigns.length; k++) 
    {
        if (childdesigns[k].treatid == treatmentID) 
        {
            var j = k;
            while (true) 
            {
                if (j == k) 
                {
                    var tab = '<li class="active" onclick="handleli('+j+')"><a href="#tab' + j + '" data-toggle="tab" aria-expanded="false">' + childdesigns[j].Treatmentdescribe + childdesigns[j].DesignName + '</a></li>';
                    var content = '<div class="active tab-pane" id="tab' + j + '">' +
                                  '<input type="hidden" id="childdesinid' + j + '" value="' + childdesigns[j].chid+'">'+
                                  '<div class="single-row"><div class="item col-xs-12"> <span class="form-text col-xs-2" style="padding-left:0px;width:11%">首次预约：</span>' +
                                  '<button id="chooseappoint' + j + '" class="btn btn-default"  data-toggle="modal" data-target="#appoint">预约</button><button id="checkappoint' + j + '" style="margin-left:3%" class="btn btn-default"  data-toggle="modal" data-target="#checkappointmodal">查看预约情况</button><button style="margin-left: 17%" onclick="handlebutton(this,' + j + ')" class="btn btn-primary" id="pause' + j + '" type="button">暂停子计划</button></div></div>' +
                                  '<div class="single-row"><div class="item col-xs-12"><span style="margin-left:10%">(预约后将清除此子计划的已有预约)</span></div></div>'+
                                  '<div id="fieldinfo' + j + '" class="single-row"><div class="col-xs-6" style="padding-left:0px;"><span class="form-text col-xs-4">射野信息：</span></div></div>' +
                                  '<div id="fieldinfotable' + j + '"class="single-row"><div class="item area-group col-xs-12"><table id="Field' + j + '" class="table table-bordered"><thead><tr><th>射野ID</th><th>MU</th><th>放疗设备</th><th>照射技术</th><th>射野类型</th><th>能量</th><th>源皮距</th><th>机架角</th> <th>机头角</th><th>床转交</th><th>子野数</th></tr></thead>' +
                                  '</table></div></div><div class="single-row"><div class="item col-xs-4">射野数量：<span id="IlluminatedNumber' + j + '" class="underline"></span></div><div class="item col-xs-4">非共面照射：<span id="Coplanar' + j + '" class="underline"></span></div><div class="item col-xs-4">机器跳数：<span id="MachineNumbe' + j + '" class="underline"></span></div></div>' +
                                  '<div class="single-row"><div class="item col-xs-4">控制点数量：<span id="ControlPoint' + j + '" class="underline"></span></div><div class="item col-xs-4">射线类型：<span id="raytype' + j + '" class="underline"></span></div></div>' +
                                  '<div class="single-row"><div class="col-xs-4"><span class="form-text col-xs-5" style="padding-left:0px;">治疗总次数：</span><input id="totalnumber' + j + '"  onchange="checktotal(' + j + ')" name="totalnumber' + j + '" disabled="disabled" type="number" class="form-item" style="width:40%;"/></div>' +
                                  '<div class="col-xs-4"><span class="form-text" style="padding-left:0px;">已治疗次数：</span><span id="finishedtimes' + j + '" class="underline"></span></div></div>' +
                                  '<div class="single-row"><div class="item col-xs-12"><span style="margin-left:0">(修改次数后将清除此子计划的已有预约)</span></div></div>' +
                                 '<div class="single-row"><div class="col-xs-4"> <span class="form-text col-xs-5" style="padding-left:0px;">分割方式：</span><select  id="splitway' + j + '" disabled="disabled" class="col-xs-7 form-item" name="splitway' + j + '"></select></div></div>' +
                                  '<div class="single-row"> <div class="item area-group col-xs-9"><span class="col-xs-2" style="padding-left:0px;">特殊医嘱：</span><textarea id="remarks' + j + '" name="remarks' + j + '" class="form-area col-xs-10" disabled="disabled"></textarea></div></div>' +
                                  '<div id="logholder'+j+'" class="single-row"><div class="col-xs-8"><span class="form-text" style="padding-left:0px;">修改日志：</span><table  class="table table-bordered"><thead><tr><th>修改天数</th><th>修改时间</th><th>修改人</th></tr></thead><tbody id="log'+j+'"></tbody></table></div></div>';
                    $("#tabs").append(tab);
                    $("#tab-content").append(content);
                    allpagenumber = j;

                } else 
                {
                    var tab = '<li class="" onclick="handleli(' + j + ')"><a href="#tab' + j + '" data-toggle="tab" aria-expanded="false">' + childdesigns[j].Treatmentdescribe + childdesigns[j].DesignName + '</a></li>';
                    var content = '<div class="tab-pane" id="tab' + j + '">' +
                                  '<input type="hidden" id="childdesinid' + j + '" value="' + childdesigns[j].chid + '">' +
                                 '<div class="single-row"><div class="item col-xs-12"> <span class="form-text col-xs-2" style="padding-left:0px;width:11%">首次预约：</span>' +
                                  '<button id="chooseappoint' + j + '" class="btn btn-default"  data-toggle="modal" data-target="#appoint">预约</button><button id="checkappoint' + j + '" style="margin-left:3%" class="btn btn-default"  data-toggle="modal" data-target="#checkappointmodal">查看预约情况</button><button style="margin-left: 17%" onclick="handlebutton(this,' + j + ')" class="btn btn-primary" id="pause' + j + '" type="button">暂停子计划</button></div></div>' +
                                  '<div class="single-row"><div class="item col-xs-12"><span style="margin-left:10%">(预约后将清除此子计划的已有预约)</span></div></div>' +
                                 '<div id="fieldinfo' + j + '" class="single-row"><div class="col-xs-6" style="padding-left:0px;"><span class="form-text col-xs-4">射野信息：</span></div></div>' +
                                  '<div id="fieldinfotable' + j + '"class="single-row"><div class="item area-group col-xs-12"><table id="Field' + j + '" class="table table-bordered"><thead><tr><th>射野ID</th><th>MU</th><th>放疗设备</th><th>照射技术</th><th>射野类型</th><th>能量</th><th>源皮距</th><th>机架角</th> <th>机头角</th><th>床转交</th><th>子野数</th></tr></thead>' +
                                  '</table></div></div><div class="single-row"><div class="item col-xs-4">射野数量：<span id="IlluminatedNumber' + j + '" class="underline"></span></div><div class="item col-xs-4">非共面照射：<span id="Coplanar' + j + '" class="underline"></span></div><div class="item col-xs-4">机器跳数：<span id="MachineNumbe' + j + '" class="underline"></span></div></div>' +
                                  '<div class="single-row"><div class="item col-xs-4">控制点数量：<span id="ControlPoint' + j + '" class="underline"></span></div><div class="item col-xs-4">射线类型：<span id="raytype' + j + '" class="underline"></span></div></div>' +
                                  '<div class="single-row"><div class="col-xs-4"><span class="form-text col-xs-5" style="padding-left:0px;">治疗总次数：</span><input id="totalnumber' + j + '" onchange="checktotal('+j+')" name="totalnumber' + j + '" disabled="disabled" type="number" class="form-item" style="width:40%;"/></div>' +
                                  '<div class="col-xs-4"><span class="form-text" style="padding-left:0px;">已治疗次数：</span><span id="finishedtimes' + j + '" class="underline"></span></div></div>' +
                                   '<div class="single-row"><div class="item col-xs-12"><span style="margin-left:0">(修改次数后将清除此子计划的已有预约)</span></div></div>' +
                                  '<div class="single-row"><div class="col-xs-4"> <span class="form-text col-xs-5" style="padding-left:0px;">分割方式：</span><select  id="splitway' + j + '" disabled="disabled" class="col-xs-7 form-item" name="splitway' + j + '"></select></div></div>' +
                                  '<div class="single-row"> <div class="item area-group col-xs-9"><span class="col-xs-2" style="padding-left:0px;">特殊医嘱：</span><textarea id="remarks' + j + '" name="remarks' + j + '" class="form-area col-xs-10" disabled="disabled"></textarea></div></div>' +
                                  '<div id="logholder'+j+'" class="single-row"><div class="col-xs-8"><span class="form-text" style="padding-left:0px;">修改日志：</span><table  class="table table-bordered"><thead><tr><th>修改天数</th><th>修改时间</th><th>修改人</th></tr></thead><tbody id="log' + j + '"></tbody></table></div></div>';
                    $("#tabs").append(tab);
                    $("#tab-content").append(content);
                }
                j = j + 1;
                if ((j != childdesigns.length && childdesigns[j].treatid != treatmentID) || j == childdesigns.length)
                {
                    break;
                }
            }
            break;
        }
   }
    for(var j = 0; j < childdesigns.length; j++) 
    {
        if (childdesigns[j].treatid != treatmentID) 
        {
            var tab = '<li class="" onclick="handleli(' + j + ')"><a href="#tab' + j + '" data-toggle="tab" aria-expanded="false">' + childdesigns[j].Treatmentdescribe + childdesigns[j].DesignName + '</a></li>';
            var content = '<div class="tab-pane" id="tab' + j + '">' +
                          '<input type="hidden" id="childdesinid' + j + '" value="' + childdesigns[j].chid + '">' +
                          '<div class="single-row"><div class="item col-xs-12"> <span class="form-text col-xs-2" style="padding-left:0px;width:11%">首次预约：</span>' +
                          '<button id="chooseappoint' + j + '" class="btn btn-default"  data-toggle="modal" data-target="#appoint">预约</button><button id="checkappoint' + j + '" style="margin-left:3%" class="btn btn-default"  data-toggle="modal" data-target="#checkappointmodal">查看预约情况</button><button style="margin-left: 17%" onclick="handlebutton(this,' + j + ')" class="btn btn-primary" id="pause' + j + '" type="button">暂停子计划</button></div></div>' +
                          '<div class="single-row"><div class="item col-xs-12"><span style="margin-left:10%">(预约后将清除此子计划的已有预约)</span></div></div>' +
                          '<div id="fieldinfo' + j + '" class="single-row"><div class="col-xs-6" style="padding-left:0px;"><span class="form-text col-xs-4">射野信息：</span></div></div>' +
                          '<div id="fieldinfotable' + j + '"class="single-row"><div class="item area-group col-xs-12"><table id="Field' + j + '" class="table table-bordered"><thead><tr><th>射野ID</th><th>MU</th><th>放疗设备</th><th>照射技术</th><th>射野类型</th><th>能量</th><th>源皮距</th><th>机架角</th> <th>机头角</th><th>床转交</th><th>子野数</th></tr></thead>' +
                          '</table></div></div><div class="single-row"><div class="item col-xs-4">射野数量：<span id="IlluminatedNumber' + j + '" class="underline"></span></div><div class="item col-xs-4">非共面照射：<span id="Coplanar' + j + '" class="underline"></span></div><div class="item col-xs-4">机器跳数：<span id="MachineNumbe' + j + '" class="underline"></span></div></div>' +
                          '<div class="single-row"><div class="item col-xs-4">控制点数量：<span id="ControlPoint' + j + '" class="underline"></span></div><div class="item col-xs-4">射线类型：<span id="raytype' + j + '" class="underline"></span></div></div>' +
                          '<div class="single-row"><div class="col-xs-4"><span class="form-text col-xs-5" style="padding-left:0px;">治疗总次数：</span><input id="totalnumber' + j + '"  onchange="checktotal(' + j + ')"  name="totalnumber' + j + '" disabled="disabled" type="number" class="form-item" style="width:40%;"/></div>' +
                           '<div class="single-row"><div class="item col-xs-12"><span style="margin-left:0">(修改次数后将清除此子计划的已有预约)</span></div></div>' +
                         '<div class="col-xs-4"><span class="form-text" style="padding-left:0px;">已治疗次数：</span><span id="finishedtimes' + j + '" class="underline"></span></div></div>' +
                          '<div class="single-row"><div class="col-xs-4"> <span class="form-text col-xs-5" style="padding-left:0px;">分割方式：</span><select  id="splitway' + j + '" disabled="disabled" class="col-xs-7 form-item" name="splitway' + j + '"></select></div></div>' +
                          '<div class="single-row"> <div class="item area-group col-xs-9"><span class="col-xs-2" style="padding-left:0px;">特殊医嘱：</span><textarea id="remarks' + j + '" name="remarks' + j + '" class="form-area col-xs-10" disabled="disabled"></textarea></div></div>' +
                          '<div id="logholder'+j+'" class="single-row"><div class="col-xs-8"><span class="form-text" style="padding-left:0px;">修改日志：</span><table  class="table table-bordered"><thead><tr><th>修改天数</th><th>修改时间</th><th>修改人</th></tr></thead><tbody id="log' + j + '"></tbody></table></div></div>';
            $("#tabs").append(tab);
            $("#tab-content").append(content);
        }
  }
  for (var i = 0; i < childdesigns.length; i++) 
  {
      var fildinfo = childdesigns[i].fieldinfo;
      if (fildinfo.length == 0) {
            $("#fieldinfotable"+i).hide();
            $("#fieldinfo"+i).hide();
       } else {
          var table = $("#Field"+i);
          for (var k = 0; k < fildinfo.length; k++) {
              var content = '<tr><td>' + fildinfo[k].code + '</td><td>' + fildinfo[k].mu + '</td><td>' + fildinfo[k].equipment + '</td><td>' + fildinfo[k].radiotechnique;
              content = content + '</td><td>' + fildinfo[k].radiotype + '</td><td>' + fildinfo[k].energy + '</td><td>' + fildinfo[k].wavedistance + '</td><td>' + fildinfo[k].angleframe;
              content = content + '</td><td>' + fildinfo[k].noseangle + '</td><td>' + fildinfo[k].bedrotation + '</td><td>' + fildinfo[k].subfieldnumber + '</td></tr>';
              table.append(content);
          }
     }
  }
  for (var i = 0; i < childdesigns.length; i++) 
  {
      $("#IlluminatedNumber" + i).html(childdesigns[i].fieldinfo.length);
      var sum = 0;
      for (var j = 0; j < childdesigns[i].fieldinfo.length; j++) {
          sum = sum + parseInt(childdesigns[i].fieldinfo[j].subfieldnumber);
      }
      $("#ControlPoint" + i).html(sum);
      $("#totalnumber" + i).val(childdesigns[i].Totalnumber);
      sum = 0;
      for (var j = 0; j < childdesigns[i].fieldinfo.length; j++) {
          if (childdesigns[i].fieldinfo[j].mu != "") {
              sum = sum + parseFloat(childdesigns[i].fieldinfo[j].mu);
          }
      }
      $("#MachineNumbe" + i).html(sum);
      $("#finishedtimes" + i).html(childdesigns[i].treattimes);
  
      createSplitway(document.getElementById("splitway" + i));
      if (childdesigns[i].splitway != "") {
          $("#splitway" + i).val(childdesigns[i].splitway);
      }
      $("#remarks" + i).html(childdesigns[i].specialenjoin);
      $("#raytype" + i).html(childdesigns[i].fieldinfo[0].radiotype);
      $("#Coplanar" + i).html(childdesigns[i].fieldinfo[0].bedrotation == 0 ? "否" : "是");
      var log = childdesigns[i].changelog;
      if (log == "")
      {
         document.getElementById("logholder"+i).style.display = "none";
      }else 
      {
          var loggroup = log.split(";");
          var content = '';
          for (var k = 1; k < loggroup.length; k++) {
              var loggroupk = loggroup[k].split(",");
              content = content + '<tr style="text-align:center">';
              content = content + '<td>' + loggroupk[2] + '</td><td>' + loggroupk[1] + '</td><td>' + loggroupk[0] + '</td>';
              content = content + '</tr>';

          }
          $("#log"+i).append(content);
      }
      if (childdesigns[i].childstate == "0")
      {
          $("#pause" + i).removeClass("btn-primary");
          $("#pause" + i).addClass("btn-success");
          $("#pause" + i).html("恢复子计划");
          $("#chooseappoint" + i).attr("disabled", "disabled");
      }
      $("#chooseappoint" + i).unbind("click").click(function () {
          CreateNewAppiontTable(event);
      });
  }
  $("#sure").unbind("click").click(function () {
      checkAllTable(patient.ID,userID);
  });

  $("#operator").html(userName);
  var date = new Date();
  $("#date").html(date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate());
}
//总次数响应函数
function checktotal(number) {
    if (parseInt($("#totalnumber" + number).val()) < parseInt($("#finishedtimes" + number).html())) {
        $("#totalnumber" + number).css("background-color", "#ffff66");
    } else {
        $("#totalnumber" + number).css("background-color", "#ffffff");
    }
}
//获取病人对应的设备型号
function geteuqipmenttype(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "geteuqipmenttype.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;

}

////获取设备型号对应的所有设备，针对普放病人
//function createfixEquipmachine1(thiselement, item) {
//    var machineItem = JSON.parse(getmachineItem1(item)).Item;
//    thiselement.options.length = 0;
//    for (var i = 0; i < machineItem.length; i++) {
//        if (machineItem[i] != "") {
//            thiselement.options[i] = new Option(machineItem[i].Name);
//            thiselement.options[i].value = parseInt(machineItem[i].ID);
//        }
//    }
//}
////获取设备型号对应的所有设备，针对普放病人
//function getmachineItem1(item) {
//    var xmlHttp = new XMLHttpRequest();
//    var url = "getfixmachine.ashx?item=" + item;
//    xmlHttp.open("GET", url, false);
//    xmlHttp.send(null);
//    var Items = xmlHttp.responseText;
//    return Items;
//}

//设备下拉菜单
function createfixEquipmachine(thiselement, item, type) {
    var machineItem = JSON.parse(getmachineItem(item, type)).Item;
    thiselement.options.length = 0;
    for (var i = 0; i < machineItem.length; i++) {
        if (machineItem[i] != "") {
            thiselement.options[i] = new Option(machineItem[i].Name);
            thiselement.options[i].value = parseInt(machineItem[i].ID);
        }
    }
}

function getmachineItem(item, type) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getaccermachine.ashx?item=" + item + "&type=" + type;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}

//创建某设备某天的预约表
function CreateCurrentEquipmentTbale(dateString) {
    var table = document.getElementById("apptiontTable");
    var equiment;
    if (equipmentfrominfo != "") {
        equiment = [].concat(equipmentfrominfo.Equipment);
        } else {
        equiment = [];
    }
    if (equiment.length != 0) {
        var appointinfo = equipmentfrominfo.appointinfo;
        for (var temp = 0; temp < equiment.length; temp++) {
            for (var temp2 = 0; temp2 < appointinfo.length; temp2++) {
                if (parseInt(equiment[temp].Begin) == parseInt(appointinfo[temp2].Begin)) {
                    equiment[temp].state = "1";
                    }
                }
            }
            }
    RemoveAllChild(table);
    var selecttime = document.getElementById("timeselect");
    var currentIndex = selecttime.selectedIndex;
    var selecttimevalue = selecttime.options[currentIndex].value;
    var beginxianzhi = selecttimevalue.split("-")[0];
    var endxianzhi = selecttimevalue.split("-")[1];
    if (equiment.length == 0) {
        table.innerHTML = "今天已经不可以预约了,改天吧！";
        return;
    }
    var tempcount = 0;
    for (tempcount = 0; tempcount < equiment.length;) {
        if (!(parseInt(equiment[tempcount].Begin) >= parseInt(beginxianzhi) && parseInt(equiment[tempcount].End) <= parseInt(endxianzhi))) {
            equiment.splice(tempcount, 1);
            } else {
            tempcount++;
        }
        }
        var tbody = document.createElement("tbody");
        var i;
        for (i = 0; i < Math.ceil(equiment.length / 6) * 6 ; i++) {
            var count = i % 6;
            var tr;
            if (count == 0) {
                tr = document.createElement("tr");
                }
            var td = document.createElement("td");
            var sign = document.createElement("i");
            if (i <= equiment.length - 1) {
                if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    if (hour >= 24) {
                        var beginhour = parseInt(hour) - 24;
                        } else {
                        var beginhour = hour;
                        }
                    var begin = beginhour + ":" + minute;
                    var endhour = toTime(equiment[i].End).split(":")[0];
                    var endminute = toTime(equiment[i].End).split(":")[1];
                    var hourend = parseInt(endhour) - 24;
                    var end = hourend + ":" + endminute;
                    td.setAttribute("id", dateString + "_" + begin + "-" + end + "(次日)" + "_" + equiment[i].Begin + "_" + equiment[i].End);
                    } else {
                    td.setAttribute("id", dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Begin + "_" + equiment[i].End);
                    }
                if (equiment[i].state == "0") {
                    if (compareWithToday(dateString)) {
                        sign.className = "";
                        td.addEventListener("click", chooseItem, false);
                    } else {
                        td.style.backgroundColor = "#C1C1C1";
                        sign.className = "fa fa-fw fa-ban td-sign";
                        td.addEventListener("click", hasChosen, false);
                    }

                    } else {
                    td.style.backgroundColor = "#C1C1C1";
                    sign.className = "fa fa-fw fa-ban td-sign";
                    td.addEventListener("click", hasChosen, false);
                    }
                if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
                    var hour = toTime(equiment[i].Begin).split(":")[0];
                    var minute = toTime(equiment[i].Begin).split(":")[1];
                    if (hour >= 24) {
                        var beginhour = parseInt(hour) - 24;
                        } else {
                        var beginhour = hour;
                        }
                    var begin = beginhour + ":" + minute;
                    var endhour = toTime(equiment[i].End).split(":")[0];
                    var endminute = toTime(equiment[i].End).split(":")[1];
                    var hourend = parseInt(endhour) - 24;
                    var end = hourend + ":" + endminute;
                    var text = document.createTextNode(begin + " - " + end + "(次日)");
                    } else {
                    var text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
                    }
                td.appendChild(text);
                td.appendChild(sign);
                tr.appendChild(td);
            }
            if (i == equiment.length) {
                var k;
                for (k = equiment.length; k <= Math.ceil(equiment.length / 6) * 6 - 1; k++) {
                    var td = document.createElement("td");
                    tr.appendChild(td);
                }
                }
            if (count == 5) {
                tbody.appendChild(tr);
                }
                }
        table.appendChild(tbody);
        //} else {
    //    var tbody = document.createElement("tbody");
    //    var i;
    //    for (i = 0; i < Math.ceil(equiment.length / 6) * 6 ; i++) {
    //        var count = i % 6;
    //        var tr;
    //        if (count == 0) {
    //            tr = document.createElement("tr");
    //        }
    //        var td = document.createElement("td");
    //        var sign = document.createElement("i");
    //        if (i <= equiment.length - 1) {
    //            if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
    //                var hour = toTime(equiment[i].Begin).split(":")[0];
    //                var minute = toTime(equiment[i].Begin).split(":")[1];
    //                if (hour >= 24) {
    //                    var beginhour = parseInt(hour) - 24;
    //                } else {
    //                    var beginhour = hour;
    //                }
    //                var begin = beginhour + ":" + minute;
    //                var endhour = toTime(equiment[i].End).split(":")[0];
    //                var endminute = toTime(equiment[i].End).split(":")[1];
    //                var hourend = parseInt(endhour) - 24;
    //                var end = hourend + ":" + endminute;
    //                td.setAttribute("id", dateString + "_" + begin + "-" + end + "(次日)" + "_" + equiment[i].Begin + "_" + equiment[i].End);
    //            } else {
    //                td.setAttribute("id", dateString + "_" + toTime(equiment[i].Begin) + "-" + toTime(equiment[i].End) + "_" + equiment[i].Begin + "_" + equiment[i].End);
    //            }
    //            if (equiment[i].state == "0") {
    //                if (compareWithToday(dateString)) {
    //                    sign.className = "";
    //                    td.addEventListener("click", chooseItem, false);
    //                } else {
    //                    td.style.backgroundColor = "#C1C1C1";
    //                    sign.className = "fa fa-fw fa-ban td-sign";
    //                    td.addEventListener("click", hasChosen, false);
    //                }

    //            } else {
    //                td.style.backgroundColor = "#C1C1C1";
    //                sign.className = "fa fa-fw fa-ban td-sign";
    //                td.addEventListener("click", hasChosen, false);
    //            }
    //            if (parseInt(toTime(equiment[i].End).split(":")[0]) >= 24) {
    //                var hour = toTime(equiment[i].Begin).split(":")[0];
    //                var minute = toTime(equiment[i].Begin).split(":")[1];
    //                if (hour >= 24) {
    //                    var beginhour = parseInt(hour) - 24;
    //                } else {
    //                    var beginhour = hour;
    //                }
    //                var begin = beginhour + ":" + minute;
    //                var endhour = toTime(equiment[i].End).split(":")[0];
    //                var endminute = toTime(equiment[i].End).split(":")[1];
    //                var hourend = parseInt(endhour) - 24;
    //                var end = hourend + ":" + endminute;
    //                var text = document.createTextNode(begin + " - " + end + "(次日)");
    //            } else {
    //                var text = document.createTextNode(toTime(equiment[i].Begin) + " - " + toTime(equiment[i].End));
    //            }
    //            td.appendChild(text);
    //            td.appendChild(sign);
    //            tr.appendChild(td);
    //        }
    //        if (i == equiment.length) {
    //            var k;
    //            for (k = equiment.length; k <= Math.ceil(equiment.length / 6) * 6 - 1; k++) {
    //                var td = document.createElement("td");
    //                tr.appendChild(td);
    //            }
    //        }
    //        if (count == 5) {
    //            tbody.appendChild(tr);
    //        }
    //    }
    //    table.appendChild(tbody);
    //}
}

//与今天进行比较
function compareWithToday(time) {
    var year = time.split("-")[0];
    var month = time.split("-")[1];
    var day = time.split("-")[2];
    var date = new Date();
    if (parseInt(year) < parseInt(date.getFullYear())) {
        return false;
    } else {
        if (parseInt(year) == parseInt(date.getFullYear())) {
            if (parseInt(month) < parseInt(date.getMonth() + 1)) {
                return false;
            } else {
                if (parseInt(month) == parseInt(date.getMonth() + 1)) {
                    if (parseInt(day) < parseInt(date.getDate())) {
                        return false;
                    } else {
                        return true;
                    }
                } else {
                    return true;
                }
            }
        } else {
            return true;
        }
    }
}

function chooseItem() {
    if (ChoseID() == null) {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        } else {
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    } else {
        if (this.lastChild.className) {
            this.className = "";
            this.lastChild.className = "";
        } else {
            Clear();
            this.className = "chosen";
            this.lastChild.className = "fa fa-fw fa-check td-sign";
        }
    }

}
function ChoseID() {
    var td_id = null;
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                td_id = cell.id;
            }
        }
    }
    return td_id;
}
function Clear() {
    var table = document.getElementById("apptiontTable");
    for (var i = 0; i < table.rows.length; i++) {
        for (var j = 0; j < table.rows[i].cells.length; j++) {
            var cell = table.rows[i].cells[j];
            if (cell.className != "") {
                cell.className = "";
                cell.lastChild.className = "";
                return;
            }
        }
    }
}
function hasChosen() {
    alert("该时间段不能预约！");
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

//根据日期创建新表
function CreateNewAppiontTable(evt) {
    evt.preventDefault();
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipmentID = equipmentName.options[currentIndex].value;
    var AppiontDate = document.getElementById("AppiontDate");
    //if (!compareWithToday(AppiontDate.value)) {
    //    alert("不能选择小于当天的日期");
    //    var table = document.getElementById("apptiontTable");
    //    RemoveAllChild(table);
    //    equipmentfrominfo = [];
    //    return;
    //}
    var date = AppiontDate.value;
    var xmlHttp = new XMLHttpRequest();
    var url = "GetEquipmentWorktime.ashx?equipmentID=" + equipmentID + "&date=" + date;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    equipmentfrominfo = eval("(" + json + ")");
    CreateCurrentEquipmentTbale(date);
}

//删除某节点的所有子节点
function removeUlAllChild(evt) {
    while (evt.hasChildNodes()) {
        evt.removeChild(evt.firstChild);
    }
}

//提交首次预约
function checkAllTable(pid,userid) {
    var choseid = ChoseID();
    var appoint = choseid.split("_");
    var equipmentName = document.getElementById("equipmentName");
    var currentIndex = equipmentName.selectedIndex;
    var equipname = equipmentName.options[currentIndex].innerHTML;
    var equipid = equipmentName.options[currentIndex].value;
    var chid = $("#childdesinid" + allpagenumber).val();
    $.ajax({
        type: "POST",
        url: "../InsertAllappointment.ashx",
        async: true,
        data: {
            chid: chid,
            type: 1,
            date: appoint[0].split(" ")[0],
            begin: appoint[2],
            end: appoint[3],
            pid: pid,
            equip: equipid,
            userid: userid
        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                alert("预约成功");
            } else {
                alert("预约失败");
            }
        },
        error: function (data) {
            alert("error");
        }
    });
}

//增加天数
function dateAdd2(dd, n) {
    var strs = new Array();
    strs = dd.split("-");
    var y = strs[0];
    var m = strs[1];
    var d = strs[2];
    var t = new Date(y, m - 1, d);
    var str = t.getTime() + n * (1000 * 60 * 60 * 24);
    var newdate = new Date();
    newdate.setTime(str);
    var strYear = newdate.getFullYear();
    var strDay = newdate.getDate();
    if (strDay < 10) {
        strDay = "0" + strDay;
    }
    var strMonth = newdate.getMonth() + 1;
    if (strMonth < 10) {
        strMonth = "0" + strMonth;
    }
    var strdate = strYear + "-" + strMonth + "-" + strDay;
    return strdate;
}
function judgecommon(treatid) {
    var xmlHttp = new XMLHttpRequest();
    var url = "judgecommon.ashx?treatmentID=" + treatid;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var Items = xmlHttp.responseText;
    return Items;
}

function createSplitway(thiselement) {
    var getsplitwayItem = JSON.parse(getsplitway()).Item;
    thiselement.options.length = 0;
    thiselement.options[0] = new Option("-- 分割方式--");
    thiselement.options[0].value = "allItem";
    for (var i = 0; i < getsplitwayItem.length; i++) {
        if (getsplitwayItem[i] != "") {
            thiselement.options[i+1] = new Option(getsplitwayItem[i].Ways);
            thiselement.options[i+1].value = parseInt(getsplitwayItem[i].ID);
        }
    }
    if (getsplitwayItem[0].defaultItem != "") {
        thiselement.value = getsplitwayItem[0].defaultItem;
    }
}
function getsplitway() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getsplitwayItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var Items = xmlHttp.responseText;
    return Items;
}

function hosttext(str) {
    if (str == "") {
        return "未住院";
    } else {
        return ("住院,住院号:" + str);
    }
}


function contains(group, s) {
    for (var k = 0; k <= group.length - 1; k++) {
        if (group[k] == s) {
            return true;
        }
    }
    return false;
}
function charge1(evt) {
    if (evt == "0")
        return "不是";
    else
        return "是";
}
function charge(evt) {
    if (evt == "0")
        return "不可行";
    else
        return "可行";
}
function getDesignInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designConfirmInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo;
}
function readDosagePriority(DosagePriority) {
    var table = document.getElementById("Priority");
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
}
function readDosage(DosagePriority) {
    var table = document.getElementById("Dosage");
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
            if (j == 2) {
                var textNode = document.createTextNode("<");
                td.appendChild(textNode);
                tr.appendChild(td);
            } else {
                var textNode = document.createTextNode(list[j]);
            }
            td.appendChild(textNode);
            tr.appendChild(td);
        }
        tbody.appendChild(tr);
    }
    tbody.style.textAlign = "center";
    table.appendChild(tbody);
}

//获取病人姓名
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

//获取病人ID
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

//调取数据库申请信息
function getfirstaccelerateInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "Getfinishedfirstaccelerate.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[obj1.info.length-1];
}

function save() {
    var number = allpagenumber;
    var totalnumber = document.getElementById("totalnumber"+number).value;
    if (document.getElementById("splitway" + number).value == "allItem") {
        window.alert("请选择分割方式");
        return false;
    }
    if ($("#pause"+number).html() == "恢复子计划") {
        window.alert("请先恢复此子计划的治疗");
        return false;
    }
    if (document.getElementById("totalnumber" + number).value == "") {
        window.alert("总次数没有填写");
        return false;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    $.ajax({
        type: "POST",
        url: "saveChildDesign.ashx",
        async: true,
        data: {
            chid: childdesigns[number].chid,
            totalnumber: totalnumber,
            user: userID,
            username:userName,
            splitway: document.getElementById("splitway"+number).value,
            remarks: document.getElementById("remarks"+number).value

        },
        dateType: "json",
        success: function (data) {
            if (data == "success") {
                window.alert("修改成功");
                window.parent.document.getElementById("save").removeAttribute("disabled");
                var content = content + '<tr style="text-align:center">';
                content = content + '<td>' + totalnumber + '</td><td>' + getNowFormatDate() + '</td><td>' + userName + '</td>';
                content = content + '</tr>';
                $("#log" + number).append(content);
            } else {
                window.alert("修改失败");
            }

        },
        error: function (data) {
            alert("error");
        }
    });
   
}
//获取session
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}
//获取当前时间
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
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
            + " " + date.getHours() + seperator2 + date.getMinutes()
            + seperator2 + date.getSeconds();
    return currentdate;
}

//获取所有待等待体位固定申请疗程号以及所属患者ID与其他信息
function getFAPatientInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "patientInfoForFix.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.patient[0];
}
//删除某节点的所有子节点
function removeUlAllChild(evt) {
    while (evt.hasChildNodes()) {
        evt.removeChild(evt.firstChild);
    }
}

//性别换算
function sex(evt) {
    if (evt == "F")
        return "女";
    else
        return "男";
}
//打开编辑
function remove() {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentid = treatmentgroup.split("=")[1];
    for (var i = 0; i < childdesigns.length; i++) {
        if (childdesigns[i].childstate != "0") {
            $("#totalnumber" + i).removeAttr("disabled");
            $("#splitway" + i).removeAttr("disabled");
            $("#remarks" + i).removeAttr("disabled");
        }
    }
}

//获取病人的所有子计划信息
function getAllChildDesign(patientID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getAllChildDesignInfo.ashx?patientid=" + patientID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    json = json.replace(/\r/g, "");
    json = json.replace(/\n/g, "\\n");
    json = json.replace(/\t/g, "");
    var data = eval("(" + json + ")");
    return data.patientinfo;
}

//点击标签触发子页面标识函数
function handleli(number) {
    allpagenumber=number;
}

//点击计划控制按钮触发子计划状态调整
function handlebutton(e, number) {
    if($(e).html()=="暂停子计划")
    {
        $.ajax({
            type: "POST",
            url: "changeChdesignState.ashx",
            async: false,
            data: {
                state: $("#totalnumber" + number).val() != "",
                type: "0",
                childdesignid: childdesigns[number].chid
            },
            dateType: "json",
            success: function (data) {
                $(e).html("恢复子计划");
                $(e).removeClass("btn-primary");
                $(e).addClass("btn-success");
                $("#totalnumber" + number).attr("disabled","disabled");
                $("#splitway" + number).attr("disabled", "disabled");
                $("#remarks" + number).attr("disabled", "disabled");
                $("#chooseappoint" + number).attr("disabled", "disabled");
            },
            error: function (data) {
                alert("error");
            }
        });
        return;
    }
    if ($(e).html() == "恢复子计划") {
        $.ajax({
            type: "POST",
            url: "changeChdesignState.ashx",
            async: false,
            data: {
                state: $("#totalnumber" + number).val() != "",
                type: "1",
                childdesignid: childdesigns[number].chid
            },
            dateType: "json",
            success: function (data) {
                $(e).html("暂停子计划");
                $(e).addClass("btn-primary");
                $(e).removeClass("btn-success");
                $("#totalnumber" + number).removeAttr("disabled");
                $("#splitway" + number).removeAttr("disabled");
                $("#remarks" + number).removeAttr("disabled");
                $("#chooseappoint" + number).removeAttr("disabled");
            },
            error: function (data) {
                alert("error");
            }
        });
        return;
    }

}