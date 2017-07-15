window.addEventListener("load", Init, false);
var userName;
var userID;
var require;
var rowcount=1;
function Init(evt) {
    //获得当前执行人姓名与ID
    getUserName();
    getUserID();
    //此处为分页代码
    var treatID = window.location.search.split("=")[1];
    document.getElementById("treatID").innerHTML = treatID;
    var patient = getPatientInfo(treatID);
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("address").innerHTML = patient.Address;
    document.getElementById("hospital").innerHTML = patient.Hospital;
    document.getElementById("contact").innerHTML = patient.Contact1;
    document.getElementById("contact2").innerHTML = patient.Contact2;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("part").innerHTML = patient.partname;
    if (patient.Progress >= 16) {
      
    }
    if (patient.Progress == 15) {
        document.getElementById("userID").value = userID;
        document.getElementById("applyuser").innerHTML = userName;
        document.getElementById("time").innerHTML = getNowFormatDate();
        document.getElementById("hidetreatID").value = treatID;
        document.getElementById("finish").addEventListener("click", finishigrt, false);
        document.getElementById("edit").addEventListener("click", edit, false);
        document.getElementById("finishtreat").addEventListener("click", function () {
            if (this.innerHTML == "结束疗程") {
                this.innerHTML = "恢复治疗状态"; 
                document.getElementById("complete").value = "1";
            }else
            {
                this.innerHTML = "结束疗程";
                document.getElementById("complete").value = "0";
            }
            
        }, false);
        createtreatrecordtable(treatID);
    }
}
function gettreatmentrecordInfo(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "designApplyInfo.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.designInfo[0];
}
function createtreatrecordtable(treatID) {
    var infomation = gettreatrecord(treatID);
    var info = getdesign(treatID);
    var date = new Date();
    var shuzu = [];
    document.getElementById("treatdatetime").innerHTML =  (date.getMonth() + 1) + "-" + date.getDate();
    var datestring = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
    document.getElementById("Number3").value = info.IlluminatedNumber;
    document.getElementById("Number4").value = info.MachineNumbe;
    var session = getsession();
    document.getElementById("assistoperator").innerHTML = session.assistant;
    document.getElementById("assistoperator1").value = session.assistant;
    document.getElementById("firstoperator").innerHTML = userName;
    if (infomation == "") {
        document.getElementById("Number5").addEventListener("change", function () {
              document.getElementById("sum").innerHTML = document.getElementById("Number5").value;
          }, false);
        document.getElementById("treateddays").innerHTML = "1";
        document.getElementById("treateddays1").value ="1";
        document.getElementById("treatedtimes").innerHTML = "1";
        document.getElementById("treatdatetime1").value = "1";
          
      } else {
          var length = infomation.length;
          document.getElementById("treateddays").innerHTML = GetDateDiff(infomation[length - 1].TreatTime, datestring)+1;
          document.getElementById("treateddays1").value = GetDateDiff(infomation[length - 1].TreatTime, datestring)+1;
          document.getElementById("treatedtimes").innerHTML = parseInt(infomation[0].TreatedTimes) + 1;
          document.getElementById("treatdatetime1").value = parseInt(infomation[0].TreatedTimes) + 1;
          $(function () {
              $('#Number5').bind('input propertychange', function () {
                  var sum = 0;
                  for (var j = 0; j <= length - 1; j++) {
                      sum = sum + parseInt(infomation[j].Singlenumber);
                  }
                  if (this.value == "") {
                      document.getElementById("sum").innerHTML = "";
                  } else {
                      document.getElementById("sum").innerHTML = parseInt(document.getElementById("Number5").value) + sum;
                  }
  
              });
          })
          for (var k = 0; k < infomation.length-2; k++) {
              if (isSameWeek(infomation[k].TreatTime, infomation[k + 1].TreatTime)==0) {
                  shuzu.push(k);
                  shuzu.push(k + 1);

              }
          }
          shuzu.push(length - 1);
          if(shuzu.length>1)
          {
              shuzu.splice(0, 1);
          }
          var first=shuzu[0];

          var treat = document.getElementById("treatmentrecord");
          for (var i = 0; i <= length - 1; i++) {
              var igrtnumber=getigrtnumber(infomation[i].ID);
              var tr = document.createElement("TR");
              var td1 = document.createElement("TD");
              td1.innerHTML = replace(infomation[i].TreatTime);
              var td2 = document.createElement("TD");
              td2.innerHTML = infomation[i].TreatedDays;
              var td3 = document.createElement("TD");
              td3.innerHTML = infomation[i].TreatedTimes;
              var td4 = document.createElement("TD");
              td4.innerHTML = infomation[i].IlluminatedNumber;
              var td5 = document.createElement("TD");
              td5.innerHTML = infomation[i].MachineNumbe;
              var td6 = document.createElement("TD");
              td6.innerHTML = infomation[i].Singlenumber;
              var sum = 0;
              for (var j = i; j <= length - 1; j++) {
                  sum = sum + parseInt(infomation[j].Singlenumber);
              }
              var td7= document.createElement("TD");
              td7.innerHTML = sum;
              var td8 = document.createElement("TD");
              td8.innerHTML = igrtnumber;
              var td9 = document.createElement("TD");
              td9.innerHTML = infomation[i].X_System;
              var td10 = document.createElement("TD");
              td10.innerHTML = infomation[i].Y_System;
              var td11 = document.createElement("TD");
              td11.innerHTML = infomation[i].Z_System;
              var td12 = document.createElement("TD");
              td12.innerHTML = infomation[i].Treat_User_ID;
              var td13 = document.createElement("TD");
              td13.innerHTML = infomation[i].Assist_User_ID;
              if (i < first || first == length - 1) {
                  var td14 = document.createElement("TD");
                  tr.appendChild(td1);
                  tr.appendChild(td2);
                  tr.appendChild(td3);
                  tr.appendChild(td4);
                  tr.appendChild(td5);
                  tr.appendChild(td6);
                  tr.appendChild(td7);
                  tr.appendChild(td8);
                  tr.appendChild(td9);
                  tr.appendChild(td10);
                  tr.appendChild(td11);
                  tr.appendChild(td12);
                  tr.appendChild(td13);
                  tr.appendChild(td14);

              } else {
                  if (i == shuzu[0]) {
                      var temp = shuzu[1];
                      var rows = (temp - i) + 1;
                      var td14 = document.createElement("TD");
                      td14.rowSpan = rows;
                      td14.style.padding = "0px";
                      td14.style.verticalAlign = "middle";
                      var button = document.createElement("Button");
                      button.className = "btn btn-success btn-sm";
                      var text = document.createTextNode("确定");
                      button.appendChild(text);
                      td14.appendChild(button);
                      shuzu.splice(0, 2);
                      tr.appendChild(td1);
                      tr.appendChild(td2);
                      tr.appendChild(td3);
                      tr.appendChild(td4);
                      tr.appendChild(td5);
                      tr.appendChild(td6);
                      tr.appendChild(td7);
                      tr.appendChild(td8);
                      tr.appendChild(td9);
                      tr.appendChild(td10);
                      tr.appendChild(td11);
                      tr.appendChild(td12);
                      tr.appendChild(td13);
                      tr.appendChild(td14);

                  } else {
                      tr.appendChild(td1);
                      tr.appendChild(td2);
                      tr.appendChild(td3);
                      tr.appendChild(td4);
                      tr.appendChild(td5);
                      tr.appendChild(td6);
                      tr.appendChild(td7);
                      tr.appendChild(td8);
                      tr.appendChild(td9);
                      tr.appendChild(td10);
                      tr.appendChild(td11);
                      tr.appendChild(td12);
                      tr.appendChild(td13);
                  }
              }
              treat.appendChild(tr);
          }

      }

}
function replace(date) {
    var s = date.split("-")[1];
    var k = date.split("-")[2];
    if (s.substring(0, 1)=="0") {
        s=s.substring(1, 2);
    }
    if (k.substring(0, 1)== "0") {
        k = k.substring(1, 2);
    }
    return s + "-" + k;

}

function getigrtnumber(id)
{
    var xmlHttp = new XMLHttpRequest();
    var url = "getigrtnumber.ashx?ID=" + id;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var count = xmlHttp.responseText;
    return count;
}
function GetDateDiff(startDate, endDate) {
    var startTime = new Date(Date.parse(startDate.replace(/-/g, "/"))).getTime();
    var endTime = new Date(Date.parse(endDate.replace(/-/g, "/"))).getTime();
    var dates = Math.abs((startTime - endTime)) / (1000 * 60 * 60 * 24);
    return dates;
}
function isSameWeek(old, now) {
    var oneDayTime = 1000 * 60 * 60 * 24;
    var old1 = new Date(Date.parse(old.replace(/-/g, "/"))).getTime();
    var now1 = new Date(Date.parse(now.replace(/-/g, "/"))).getTime();
    var old_count = parseInt(old1/ oneDayTime);
    var now_other = parseInt(now1/ oneDayTime);
    return parseInt((old_count + 4) / 7) == parseInt((now_other + 4) / 7);
}

function getsum() {
    var k = 1;
    var x=0;
    var y=0;
    var z=0;
    for (k = 1; k <= 3 * rowcount; k++) {
        if (document.getElementById("require" + k + "1") != undefined) {
            x+=parseInt(document.getElementById("auto" + k + "1").innerHTML);
        }
        if (document.getElementById("require" + k + "2") != undefined) {
            y += parseInt(document.getElementById("auto" + k + "2").innerHTML);
        }
        if (document.getElementById("require" + k + "3") != undefined) {
            z += parseInt(document.getElementById("auto" + k + "3").innerHTML);
        }

    }
    return x + "," + y + ","+z;

}
function getsession() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getSession.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1;
}
function getdesign(treatID)
{
    var xmlHttp = new XMLHttpRequest();
    var url = "TreatmentRecordInfo.ashx?treatmentID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info[0];
}
//function bangding() {
//    $(function () {
//        var k = 1;
//        for (k = 1; k <= 3 * rowcount; k++) {
//            if (document.getElementById("require" + k + "1") != undefined) {
//                $('#require' + k + '1').bind('input propertychange', function () {
//                    if ($('#require' + k + '1').val != "" || $('#Number' + k + '1').val != "") {
//                        document.getElementById("auto" + k + "1").innerHTML = $('#require' + k + '1').val - $('#Number' + k + '1').val;
//                    } else {
//                        document.getElementById("auto" + k + "1").innerHTML = "";
//                    }

//                });
//            }
//            if (document.getElementById("require" + k + "2") != undefined) {
//                $('#require' + k + '2').bind('input propertychange', function () {
//                    if (this.value != "") {
//                        document.getElementById("auto" + k + "2").innerHTML = document.getElementById("require" + k + "2").value - document.getElementById("Number" + k + "2").value;
//                    } else {
//                        document.getElementById("auto" + k + "2").innerHTML = "";
//                    }

//                });
//            }
//            if (document.getElementById("require" + k + "3") != undefined) {
//                $('#require' + k + '3').bind('input propertychange', function () {
//                    if (this.value != "") {
//                        document.getElementById("auto" + k + "3").innerHTML = document.getElementById("require" + k + "3").value - document.getElementById("Number" + k + "3").value;
//                    } else {
//                        document.getElementById("auto" + k + "3").innerHTML = "";
//                    }

//                });
//            }

//        }
//    });
// }
function finishigrt() {
    var k = 1;
    document.getElementById("live").value ="";
    for (k = 1; k <= 3 * rowcount; k++) {
        if (document.getElementById("require" + k + "1") != undefined) {
            document.getElementById("live").value = document.getElementById("live").value + "," + k;
            if (document.getElementById("require" + k + "1").value != "" && document.getElementById("Number" + k + "1").value != "") {
                document.getElementById("auto" + k + "1").innerHTML = document.getElementById("require" + k + "1").value - document.getElementById("Number" + k + "1").value;
                document.getElementById("require" + k + "1").disabled = "true";
                document.getElementById("Number" + k + "1").disabled = "true";
               
            } else {
                alert("摆位误差表未填写完整");
                return;
            }
        }
        if (document.getElementById("require" + k + "2") != undefined) {
            if (document.getElementById("require" + k + "2").value != "" && document.getElementById("Number" + k + "2").value != "") {
                document.getElementById("auto" + k + "2").innerHTML = document.getElementById("require" + k + "2").value - document.getElementById("Number" + k + "2").value;
                document.getElementById("require" + k + "2").disabled = "true";
                document.getElementById("Number" + k + "2").disabled = "true";
            } else {
                alert("摆位误差表未填写完整");
                return;
            }
        }
        if (document.getElementById("require" + k + "3") != undefined) {
            if (document.getElementById("require" + k + "3").value != "" && document.getElementById("Number" + k + "3").value != "") {
                document.getElementById("auto" + k + "3").innerHTML = document.getElementById("require" + k + "3").value - document.getElementById("Number" + k + "3").value;
                document.getElementById("require" + k + "3").disabled = "true";
                document.getElementById("Number" + k + "3").disabled = "true";
            } else {
                alert("摆位误差表未填写完整");
                return;
            }
        }
 
    }
    var agroup = document.getElementsByTagName("a");
    for (var m = 0; m < agroup.length; m++) {
        agroup[m].addEventListener("click",handle,false);
    }
    var len = agroup.length - 1;
    var sum = getsum();
    var group = sum.split(",");
    document.getElementById("igrttimes").innerHTML = len;
    document.getElementById("RLcount").innerHTML = group[0]/len;
    document.getElementById("APcount").innerHTML = group[1]/len;
    document.getElementById("SIcount").innerHTML = group[2] / len;
    document.getElementById("RLcount1").value = group[0] / len;
    document.getElementById("APcount1").value = group[1] / len;
    document.getElementById("SIcount1").value = group[2] / len;


}
function gettreatrecord(treatID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "TreatmentRecord.ashx?treatID=" + treatID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.treatmentRecordInfo;
}
function handle(evt) {
    evt.preventDefault();
}
function edit() {
    var k = 1;
    for (k = 1; k <= 3 * rowcount; k++) {
        if (document.getElementById("require" + k + "1") != undefined) {
            document.getElementById("require" + k + "1").removeAttribute("disabled");
            document.getElementById("Number" + k + "1").removeAttribute("disabled");
        }
        if (document.getElementById("require" + k + "2") != undefined) {
            document.getElementById("require" + k + "2").removeAttribute("disabled");
            document.getElementById("Number" + k + "2").removeAttribute("disabled");
        }
        if (document.getElementById("require" + k + "3") != undefined) {
            document.getElementById("require" + k + "3").removeAttribute("disabled");
            document.getElementById("Number" + k + "3").removeAttribute("disabled");
        }
    }
    var agroup = document.getElementsByTagName("a");
    for (var m = 0; m < agroup.length; m++) {
        agroup[m].removeEventListener("click",handle,false);
    }
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

function addigrt() {
    var table = document.getElementById("igrttable");
    rowcount++;
    var igrttbody = document.getElementById("igrttbody");
    var tr1 = document.createElement("TR");
    tr1.setAttribute("id", "tr" + rowcount + "1");
    var tr2 = document.createElement("TR");
    tr2.setAttribute("id", "tr" + rowcount + "2");
    var tr3 = document.createElement("TR");
    tr3.setAttribute("id", "tr" + rowcount + "3");
    tr1.innerHTML = '<td class="rowclass" rowspan="3">' + rowcount + '</td><td>x</td><td style="padding:0px;"><input id="require' + rowcount + '1" name="require' + rowcount + '1" type="number" class="td-input" /></td><td style="padding:0px;"><input id="Number' + rowcount + '1" name="Number' + rowcount + '1" type="number" class="td-input"/></td><td id="auto' + rowcount + '1"></td><td rowspan="3">' +
                   '<a  href="javascript:deleteigrt(' + rowcount + ');"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a></td>';
    tr2.innerHTML = "<td>y</td><td style='padding:0px;'><input id='require"+rowcount+"2' name='require"+rowcount+"2' type='number' class='td-input' /></td><td style='padding:0px;'><input id='Number" + rowcount + "2' name='Number" + rowcount + "2' type='number' class='td-input'/></td><td id='auto" + rowcount + "2'></td>";
    tr3.innerHTML = "<td>z</td><td style='padding:0px;'><input id='require" + rowcount + "3' name='require" + rowcount + "3' type='number' class='td-input' /></td><td style='padding:0px;'><input id='Number" + rowcount + "3' name='Number" + rowcount + "3' type='number' class='td-input'/></td><td id='auto" + rowcount + "3'></td>";
    igrttbody.appendChild(tr1);
    igrttbody.appendChild(tr2);
    igrttbody.appendChild(tr3);
    var rowclass = document.getElementsByClassName("rowclass");
    for (var k = 0; k < rowclass.length; k++) {
        rowclass[k].innerHTML = k + 1;
    }

}
function deleteigrt(row) {
    var igrttbody = document.getElementById("igrttbody");
    var tr = document.getElementById("tr" +row+ "1");
    RemoveAllChild(tr);
    tr = document.getElementById("tr" + row + "2");
    RemoveAllChild(tr);
    tr = document.getElementById("tr" + row + "3");
    RemoveAllChild(tr);
    var rowclass = document.getElementsByClassName("rowclass");
    for (var k = 0; k < rowclass.length; k++) {
        rowclass[k].innerHTML = k+1;
    }

}
function toTime(minute) {
    var hour = parseInt(parseInt(minute) / 60);
    var min = parseInt(minute) - hour * 60;
    return hour.toString() + ":" + (min < 10 ? "0" : "") + min.toString();
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
    area.parentNode.removeChild(area);
}

//获取所有待等待模拟定位申请疗程号以及所属患者ID与其他信息
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

//回退按钮



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
    var k = 1;
    for (k = 1; k <= 3 * rowcount; k++) {
        if (document.getElementById("require" + k + "1") != undefined) {
            if (document.getElementById("require" + k + "1").value == "" || document.getElementById("Number" + k + "1").value == "") {
                alert("摆位误差表未填写完整");
                return;
            }
        }
        if (document.getElementById("require" + k + "2") != undefined) {
            if (document.getElementById("require" + k + "2").value == "" || document.getElementById("Number" + k + "2").value == "") {
                alert("摆位误差表未填写完整");
                return;
            }
        }
        if (document.getElementById("require" + k + "3") != undefined) {
            if (document.getElementById("require" + k + "3").value == "" || document.getElementById("Number" + k + "3").value == "") {
                alert("摆位误差表未填写完整");
                return;
            }
     
        }
    }
    if (document.getElementById("Number3").value == "") {
        alert("填写射野数目");
        return;
    }
    if (document.getElementById("Number4").value == "") {
        alert("填写机器跳数");
        return;
    } if (document.getElementById("Number5").value == "") {
        alert("填写单次剂量");
        return;
    }
    if (document.getElementById("RLcount1").value == "") {
        alert("未完成IGRT摆位记录");
        return;
    }
    document.getElementById("savetreatrecord").submit();
}