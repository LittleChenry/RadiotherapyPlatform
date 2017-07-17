window.addEventListener("load", Init, false);
var userName;
var userID;
var number = 0;
var obj = [];
function Init(evt) {
    var treatmentgroup = window.location.search.split("&")[0];//?后第一个变量信息
    var treatmentID = treatmentgroup.split("=")[1];
    //调取后台所有等待就诊的疗程号及其对应的病人
    getUserID();
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    getUserName();
    var patient = getPatientInfo(treatmentID);
    document.getElementById("hidetreatID").value = treatmentID;
    document.getElementById("userID").value = userID;
    document.getElementById("username").innerHTML = patient.Name;
    document.getElementById("sex").innerHTML = sex(patient.Gender);
    document.getElementById("idnumber").innerHTML = patient.IdentificationNumber;
    document.getElementById("nation").innerHTML = patient.Nation;
    document.getElementById("age").innerHTML = patient.Age;
    document.getElementById("address").innerHTML = patient.Address;
    document.getElementById("hospital").innerHTML = patient.Hospital;
    document.getElementById("contact").innerHTML = patient.Contact1;
    document.getElementById("contact2").innerHTML = patient.Contact2;
    document.getElementById("treatID").innerHTML = patient.treatID;
    document.getElementById("progress").value = patient.Progress;
    document.getElementById("Reguser").innerHTML = patient.RegisterDoctor;
    document.getElementById("treatID").innerHTML = "疗程" + patient.Treatmentname;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    var replacerecordinfo = getreplacerecordInfo(treatmentID);
    document.getElementById("requireID").innerHTML = replacerecordinfo.replacerequire;
    document.getElementById("ApplicationUser").innerHTML = replacerecordinfo.ApplicationUser;
    document.getElementById("ApplicationTime").innerHTML = replacerecordinfo.ApplicationTime;
    document.getElementById("viewpdf").href = replacerecordinfo.pdf;
    document.getElementById("OriginCenter1").value = replacerecordinfo.data.split(",")[0];
    document.getElementById("OriginCenter2").value = replacerecordinfo.data.split(",")[1];
    document.getElementById("OriginCenter3").value = replacerecordinfo.data.split(",")[2];
    document.getElementById("PlanCenter1").value = replacerecordinfo.data.split(",")[3];
    document.getElementById("PlanCenter2").value = replacerecordinfo.data.split(",")[4];
    document.getElementById("PlanCenter3").value = replacerecordinfo.data.split(",")[5];
    document.getElementById("Movement1").value = replacerecordinfo.data.split(",")[6];
    document.getElementById("Movement2").value = replacerecordinfo.data.split(",")[7];
    document.getElementById("Movement3").value = replacerecordinfo.data.split(",")[8];
    $('#Movement1').bind('input propertychange', function () {
        if (document.getElementById("Result1").value == "") {
            document.getElementById("distance1").value = "";
        } else {
            document.getElementById("distance1").value = parseInt(document.getElementById("Result1").value) - parseInt(document.getElementById("Movement1").value);
        }
    });
    $('#Result1').bind('input propertychange', function () {
        if (document.getElementById("Movement1").value == "") {
            document.getElementById("distance1").value = "";
        } else {
            document.getElementById("distance1").value = parseInt(document.getElementById("Result1").value) - parseInt(document.getElementById("Movement1").value);
        }
    });
    $('#Movement2').bind('input propertychange', function () {
        if (document.getElementById("Result2").value == "") {
            document.getElementById("distance2").value = "";
        } else {
            document.getElementById("distance2").value = parseInt(document.getElementById("Result2").value) - parseInt(document.getElementById("Movement2").value);
        }
    });
    $('#Movement3').bind('input propertychange', function () {
        if (document.getElementById("Result3").value == "") {
            document.getElementById("distance3").value = "";
        } else {
            document.getElementById("distance3").value = parseInt(document.getElementById("Result3").value) - parseInt(document.getElementById("Movement3").value);
        }
    });
    $('#Result2').bind('input propertychange', function () {
        if (document.getElementById("Movement2").value == "") {
            document.getElementById("distance2").value = "";
        } else {
            document.getElementById("distance2").value = parseInt(document.getElementById("Result2").value) - parseInt(document.getElementById("Movement2").value);
        }
    });
    $('#Result3').bind('input propertychange', function () {
        if (document.getElementById("Movement3").value == "") {
            document.getElementById("distance3").value = "";
        } else {
            document.getElementById("distance3").value = parseInt(document.getElementById("Result3").value) - parseInt(document.getElementById("Movement3").value);
        }
    });
    var info = getreplacerecordInfomation(treatmentID);
    $("#current-tab").text("疗程" + patient.Treatmentname + "复位记录");
    var groupprogress = patient.Progress.split(","); 
    if (contains(groupprogress, "13")) {
       for (var i = 0; i < info.length; i++) {
           if (info[i].treatmentname == patient.Treatmentname) {
               var ReplacementRecord = document.getElementById("ReplacementRecord")
               for (var k = 0; k < 3; k++) {
                   ReplacementRecord.rows[k + 1].cells[1].innerHTML = info[i].OriginCenter.split(",")[k];
                   ReplacementRecord.rows[k + 1].cells[2].innerHTML = info[i].PlanCenter.split(",")[k];
                   ReplacementRecord.rows[k + 1].cells[3].innerHTML = info[i].Movement.split(",")[k];
                   ReplacementRecord.rows[k + 1].cells[4].innerHTML = info[i].Result.split(",")[k];
                   ReplacementRecord.rows[k + 1].cells[5].innerHTML = info[i].Distance.split(",")[k];
               }
               var boxes = document.getElementById("multipic_DRR");
               var firstdrr = document.getElementById("firstdrr");
               firstdrr.style.display = "none";
               var pictures = info[i].ReferenceDRRPicture.split(",");
               if (info[i].ReferenceDRRPicture == "") {
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
               var boxes1 = document.getElementById("multipic_yanzheng");
               var firstyanzheng = document.getElementById("firstyanzheng");
               firstyanzheng.style.display = "none";
               var pictures = info[i].VerificationPicture.split(",");
               if (info[i].VerificationPicture == "") {
                   boxes1.innerHTML = "无";
               } else {
                   for (var k = 1; k < pictures.length; k++) {
                       var div = document.createElement("DIV");
                       div.className = "boxes";
                       var div1 = document.createElement("DIV");
                       div1.className = "imgnum";
                       var img = document.createElement("IMG");
                       img.className = "img";
                       img.src = pictures[k];
                       img.style.display = "block";
                       div1.appendChild(img);
                       div.appendChild(div1);
                       boxes1.appendChild(div);
                   }
               }
               document.getElementById("Remarks").value = info[i].Remarks;
               document.getElementById("operator").innerHTML = info[i].username;
               document.getElementById("date").innerHTML = info[i].OperateTime;
           } else {
               var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">疗程' + info[i].treatmentname + '复位记录</a></li>';
               var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                   + '<div class="col-xs-12" style="padding-left:0px;"><span class="form-text col-xs-12">参数变化(按照PDF填写)：</span></div></div>'
                   + '<div class="single-row"><div class="item area-group col-xs-12"><table id="ReplacementRecord" class="table table-bordered" style="table-layout:fixed;word-wrap:break-word;">'
                   + '<thead><tr><th>方向</th><th>原始中心(cm)</th><th>计划中心(cm)</th><th>移床参数(cm)</th><th>复位结果(cm)</th><th>差值(cm)</th></tr></thead>'
                   + '<tbody style="text-align:center;"><tr><td>x</td><td>' + info[i].OriginCenter.split(",")[0] + '</td><td>' + info[i].PlanCenter.split(",")[0] + '</td><td>' + info[i].Movement.split(",")[0] + '</td><td>' + info[i].Result.split(",")[0] + '</td><td>' + info[i].Distance.split(",")[0] + '</td></tr>'
                   + '<tr><td>y</td><td>' + info[i].OriginCenter.split(",")[1] + '</td><td>' + info[i].PlanCenter.split(",")[1] + '</td><td>' + info[i].Movement.split(",")[1] + '</td><td>' + info[i].Result.split(",")[1] + '</td><td>' + info[i].Distance.split(",")[1] + '</td></tr>'
                   + '<tr><td>z</td><td>' + info[i].OriginCenter.split(",")[2] + '</td><td>' + info[i].PlanCenter.split(",")[2] + '</td><td>' + info[i].Movement.split(",")[2] + '</td><td>' + info[i].Result.split(",")[2] + '</td><td>' + info[i].Distance.split(",")[2] + '</td></tr></tbody></table></div></div>'
                   + '<div class="single-row"><div class="item col-xs-8"><span class="col-xs-2" style="padding-left:0px;">参考DRR：</span></div></div>';
               var pictures = info[i].ReferenceDRRPicture.split(",");
               if (info[i].ReferenceDRRPicture == "") {
                   content = content + '<div class="single-row"><div class="item col-xs-12"><div class="imgbox multifile"><div class="boxes">无</div></div></div></div>';
               } else {
                   content = content + '<div class="single-row"><div class="item col-xs-12">';
                   for (var k = 1; k < pictures.length; k++) {
                       content = content + '<div class="imgbox multifile"><div class="boxes"><div class="imgnum"> <img  class="img"  src="' + pictures[k] + '" style="display:block" /></div></div>';
                   }
                   content = content + "</div></div>";
               }
               content = content + '<div class="single-row"><div class="item col-xs-12"><span class="col-xs-2" style="padding-left:0px;">验证图像：</span></div></div>';
               var pictures1 = info[i].VerificationPicture.split(",");
               if (info[i].VerificationPicture == "") {
                   content = content + '<div class="single-row"><div class="item col-xs-12"><div class="imgbox multifile"><div class="boxes">无</div></div></div></div>';
               } else {
                   content = content + '<div class="single-row"><div class="item col-xs-12">';
                   for (var k = 1; k < pictures1.length; k++) {
                       content = content + '<div class="imgbox multifile"><div class="boxes"><div class="imgnum"> <img class="img"  src="' + pictures1[k] + '" style="display:block" /></div></div>';
                   }
                   content = content + "</div></div>";

               }
               content = content + '<div class="single-row"><div class="item area-group col-xs-8"><span class="col-xs-2" style="padding-left:0px;">备注：</span><span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button" disabled="disabled" id="' + i + '">载入历史信息</button></div></div>';
               $("#tabs").append(tab);
               $("#tab-content").append(content);
               $("#tab-content").find("img").each(function () {
                   $(this).bind("click", showPicture);
               });
           }
       }
    } else {
        var date = new Date();
        document.getElementById("date").innerHTML = date.getFullYear() + "-" + (date.getMonth() + 1) + "-" + date.getDate();
        document.getElementById("operator").innerHTML = userName;
        for (var i = 0; i < info.length; i++) {
            if (info[i].treatmentname != patient.Treatmentname) {
                var tab = '<li class=""><a href="#tab' + i + '" data-toggle="tab" aria-expanded="false">疗程' + info[i].treatmentname + '复位记录</a></li>';
                var content = '<div class="tab-pane" id="tab' + i + '"><div class="single-row">'
                    + '<div class="col-xs-12" style="padding-left:0px;"><span class="form-text col-xs-12">参数变化(按照PDF填写)：</span></div></div>'
                    + '<div class="single-row"><div class="item area-group col-xs-12"><table id="ReplacementRecord" class="table table-bordered" style="table-layout:fixed;word-wrap:break-word;">'
                    + '<thead><tr><th>方向</th><th>原始中心(cm)</th><th>计划中心(cm)</th><th>移床参数(cm)</th><th>复位结果(cm)</th><th>差值(cm)</th></tr></thead>'
                    + '<tbody style="text-align:center;"><tr><td>x</td><td>' + info[i].OriginCenter.split(",")[0] + '</td><td>' + info[i].PlanCenter.split(",")[0] + '</td><td>' + info[i].Movement.split(",")[0] + '</td><td>' + info[i].Result.split(",")[0] + '</td><td>' + info[i].Distance.split(",")[0] + '</td></tr>'
                    + '<tr><td>y</td><td>' + info[i].OriginCenter.split(",")[1] + '</td><td>' + info[i].PlanCenter.split(",")[1] + '</td><td>' + info[i].Movement.split(",")[1] + '</td><td>' + info[i].Result.split(",")[1] + '</td><td>' + info[i].Distance.split(",")[1] + '</td></tr>'
                    + '<tr><td>z</td><td>' + info[i].OriginCenter.split(",")[2] + '</td><td>' + info[i].PlanCenter.split(",")[2] + '</td><td>' + info[i].Movement.split(",")[2] + '</td><td>' + info[i].Result.split(",")[2] + '</td><td>' + info[i].Distance.split(",")[2] + '</td></tr></tbody></table></div></div>'
                    + '<div class="single-row"><div class="item col-xs-8"><span class="col-xs-2" style="padding-left:0px;">参考DRR：</span></div></div>';
                var pictures = info[i].ReferenceDRRPicture.split(",");
                if (info[i].ReferenceDRRPicture == "") {
                    content = content + '<div class="single-row"><div class="item col-xs-12"><div class="imgbox multifile"><div class="boxes">无</div></div></div></div>';
                } else {
                    content = content + '<div class="single-row"><div class="item col-xs-12">';
                    for (var k = 1; k < pictures.length; k++) {
                        content = content + '<div class="imgbox multifile"><div class="boxes"><div class="imgnum"> <img  class="img"  src="' + pictures[k] + '" style="display:block" /></div></div></div>';
                    }
                    content = content + "</div></div>";
                }
                content = content + '<div class="single-row"><div class="item col-xs-12"><span class="col-xs-2" style="padding-left:0px;">验证图像：</span></div></div>';
                var pictures1 = info[i].VerificationPicture.split(",");
                if (info[i].VerificationPicture == "") {
                    content = content + '<div class="single-row"><div class="item col-xs-12"><div class="imgbox multifile"><div class="boxes">无</div></div></div></div>';
                } else {
                    content = content + '<div class="single-row"><div class="item col-xs-12">';
                    for (var k = 1; k < pictures1.length; k++) {
                        content = content + '<div class="imgbox multifile"><div class="boxes"><div class="imgnum"> <img class="img"  src="' + pictures1[k] + '" style="display:block" /></div></div></div>';
                    }
                    content = content + "</div></div>";

                }
                content = content + '<div class="single-row"><div class="item area-group col-xs-8"><span class="col-xs-2" style="padding-left:0px;">备注：</span><span class="underline">' + info[i].Remarks + '</span></div><div class="item col-xs-4"><button class="btn btn-success" type="button"  id="' + i + '">载入历史信息</button></div></div>';
                $("#tabs").append(tab);
                $("#tab-content").append(content);
                $("#tab-content").find("img").each(function () {
                    $(this).bind("click", showPicture);
                });
            }
        }
    }
    $("#tab-content").find("button").each(function () {
        $(this).bind("click", function () {
            var m = this.id;
            var ReplacementRecord = document.getElementById("ReplacementRecord")
            for (var k = 1; k < 4; k++) {
                alert(m);
                document.getElementById("OriginCenter"+k).value = info[m].OriginCenter.split(",")[k-1];
                document.getElementById("PlanCenter" + k).value = info[m].PlanCenter.split(",")[k - 1];
                document.getElementById("Movement" + k).value = info[m].Movement.split(",")[k - 1];
                document.getElementById("Result" + k).value = info[m].Result.split(",")[k - 1];
                document.getElementById("distance" + k).value = info[m].Distance.split(",")[k - 1];
            }
            document.getElementById("Remarks").value = info[m].Remarks;

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
function showPicture() {
    $("#myModal").modal("show");
    $("#pic").attr("src", this.src);
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

function getreplacerecordInfomation(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getfinishedreplacerecord.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.info;
}
function getreplacerecordInfo(treatmentID) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getreplaceApply.ashx?treatmentID=" + treatmentID;
    xmlHttp.open("GET", url, false);
    xmlHttp.send(null);
    var json = xmlHttp.responseText;
    var obj1 = eval("(" + json + ")");
    return obj1.replace[0];
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
    var boxgroup = document.getElementById("multipic_DRR");
    var boxgroup1 = document.getElementById("multipic_yanzheng");
    document.getElementById("cankaodrr").value = boxgroup.children.length - 1;
    document.getElementById("yanzheng").value = boxgroup1.children.length - 1;
    if (document.getElementById("OriginCenter1").value == "" || document.getElementById("OriginCenter2").value == "" || document.getElementById("OriginCenter3").value == "") {
        window.alert("原始中心没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("PlanCenter1").value == "" || document.getElementById("PlanCenter2").value == "" || document.getElementById("PlanCenter3").value == "") {
        window.alert("计划中心没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("Movement1").value == "" || document.getElementById("Movement2").value == "" || document.getElementById("Movement3").value == "") {
        window.alert("移床参数没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("Result1").value == "" || document.getElementById("Result2").value == "" || document.getElementById("Result3").value == "") {
        window.alert("复位结果没有完善");
        evt.preventDefault();
        return;
    }
    if (document.getElementById("cankaodrr").value == "0" || document.getElementById("yanzheng").value == "0") {
        window.alert("参考DRR和验证图像未完善");
        evt.preventDefault();
        return;
    }
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    var form = new FormData(document.getElementById("saveReplaceRecord"));
    $.ajax({
        url: "ReplaceRecordRecord.ashx",
        type: "post",
        data: form,
        processData: false,
        contentType: false,
        success: function (data) {
            alert("更新成功");
            window.location.reload();
        },
        error: function (e) {
            window.location.href = "Error.aspx";
        },
    });
}
function getchildNumber(boxgroup) {
    var r = [];
    var n = boxgroup.firstChild;
    for (; n; n = n.nextSibling) {
        if (n.nodeType === 1 && n !== elem) {
            r.push(n);
        }
    }
    return r.length ;
}
function remove() {
    var groups = document.getElementsByTagName("input");
    for (var k = 0; k <= groups.length - 1; k++) {
            groups[k].removeAttribute("disabled");
    }
    document.getElementById("Remarks").removeAttribute("disabled");
    document.getElementById("viewpdf").removeAttribute("disabled");
}