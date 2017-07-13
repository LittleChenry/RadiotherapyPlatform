window.addEventListener("load", Init, false);



var userName;
var userID;


function Init(evt) {

    //xubixiao
    //获取入口患者信息界面的div
    getUserID();
    getUserName();

    var treatID = window.location.search.split("=")[1];
    
   
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
    document.getElementById("treatID").innerHTML = "疗程" + patient.Treatmentname;
    document.getElementById("diagnosisresult").innerHTML = patient.diagnosisresult;
    document.getElementById("radiotherapy").innerHTML = patient.Radiotherapy_ID;
    document.getElementById("RecordNumber").innerHTML = patient.RecordNumber;
    document.getElementById("hospitalid").innerHTML = patient.Hospital_ID;
    //document.getElementById("part").innerHTML = patient.partname;

    $("#current-tab").text(patient.Treatmentname);
    if (patient.Progress >= 3) {
        var fixedInfo = getFixedInfo(treatID);
        for (var i = 0; i < fixedInfo.fixedInfo.length; i++) {
            if (patient.Treatmentname == fixedInfo.fixedInfo[i].Treatmentname) {
                for (var k = i + 1; k < fixedInfo.fixedInfo.length; k++) {
                    if (fixedInfo.fixedInfo[k].fixedid == fixedInfo.fixedInfo[i].fixedid) {
                        $("#current-tab").innerHTML = $("#current-tab").innerHTML + "," + fixedInfo.fixedInfo[k].Treatmentname;
                    }
                }
                document.getElementById("body").innerHTML = fixedInfo.fixedInfo[i].body;
                document.getElementById("requireID").innerHTML = fixedInfo.fixedInfo[i].requireID;
                document.getElementById("modelID").innerHTML = fixedInfo.fixedInfo[i].modelID;
                document.getElementById("fixedEquipment").innerHTML = fixedInfo.fixedInfo[i].fixedEquipment;
                document.getElementById("ApplicationUser").innerHTML = fixedInfo.fixedInfo[i].ApplicationUser;
                document.getElementById("ApplicationTime").innerHTML = fixedInfo.fixedInfo[i].ApplicationTime;
                var BodyPositionDetail = "固定装置：" + fixedInfo.fixedInfo[i].fixedEquipment + "；固定模具：" + fixedInfo.fixedInfo[i].modelID + "；体位：" + fixedInfo.fixedInfo[i].body + "；特殊要求：" + fixedInfo.fixedInfo[i].requireID;
                document.getElementById("BodyPositionDetail").value = BodyPositionDetail;
                if (patient.Progress >= 5) {
                    document.getElementById("BodyPositionDetail").value = fixedInfo.fixedInfo[i].BodyPositionDetail;          
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
                        for (var i = 1; i < pictures.length; i++) {
                            var div = document.createElement("DIV");
                            div.className = "boxes";
                            var div1 = document.createElement("DIV");
                            div1.className = "imgnum";
                            var img = document.createElement("IMG");
                            img.addEventListener("click",showPicture,false);
                            img.className = "img";
                            img.src = pictures[i];
                            img.style.display = "block";
                            div1.appendChild(img);
                            div.appendChild(div1);
                            boxes.appendChild(div);
                        }
                    }
                }
            }else{
                var Treatmentnames = fixedInfo.fixedInfo[i].fixedid;
                for (var k = i + 1; k < fixedInfo.fixedInfo.length; k++) {
                    alert(fixedInfo.fixedInfo[k].fixedid + "," + fixedInfo.fixedInfo[i].fixedid)
                    if (fixedInfo.fixedInfo[k].fixedid == fixedInfo.fixedInfo[i].fixedid) {
                        for (var j = 0; j < i; j++) {
                            if (fixedInfo.fixedInfo[j].fixedid != fixedInfo.fixedInfo[i].fixedid) {
                                Treatmentnames = Treatmentnames + "," + fixedInfo.fixedInfo[k].fixedid;
                            }
                        }
                    }
                }
                var pictures = fixedInfo.fixedInfo[i].Pictures.split(",");
                var tab = '<li class=""><a href="#tab'+ i +'" data-toggle="tab" aria-expanded="false">疗程'+ Treatmentnames +'体位固定记录</a></li>';
                var content = '<div class="tab-pane" id="tab'+ i +'"><div class="single-row">'
                    + '<div class="item col-xs-12">体位详细描述：<span class="underline">'+ fixedInfo.fixedInfo[i].BodyPositionDetail +'</span></div></div>'
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
        var fixedInfo = getFixedInfo(treatID);
        for (var i = 0; i < fixedInfo.fixedInfo.length; i++) {
            if (patient.Treatmentname != fixedInfo.fixedInfo[i].Treatmentname) {
                var Treatmentnames = fixedInfo.fixedInfo[i].fixedid;
                for (var k = i + 1; k < fixedInfo.fixedInfo.length; k++) {
                    alert(fixedInfo.fixedInfo[k].fixedid + "," + fixedInfo.fixedInfo[i].fixedid)
                    if (fixedInfo.fixedInfo[k].fixedid == fixedInfo.fixedInfo[i].fixedid) {
                        for (var j = 0; j < i; j++) {
                            if (fixedInfo.fixedInfo[j].fixedid != fixedInfo.fixedInfo[i].fixedid) {
                                Treatmentnames = Treatmentnames + "," + fixedInfo.fixedInfo[k].fixedid;
                            }
                        }
                    }
                }
                var pictures = fixedInfo.fixedInfo[i].Pictures.split(",");
                var tab = '<li class=""><a href="#tab'+ i +'" data-toggle="tab" aria-expanded="false">疗程'+ Treatmentnames +'体位固定记录</a></li>';
                var content = '<div class="tab-pane" id="tab'+ i +'"><div class="single-row">'
                    + '<div class="item col-xs-12">体位详细描述：<span class="underline">'+ fixedInfo.fixedInfo[i].BodyPositionDetail +'</span></div></div>'
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
                $("#tabs").append(tab);
                $("#tab-content").append(content);
                $("#tab-content").find("img").each(function(){
                    $(this).bind("click",showPicture);
                });
            }
        }
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
function postimportFIX() {
    
    if (document.getElementById("BodyPositionDetail").value == "") {
        alert("请填写体位详细描述");
        return;
    }    
    if (document.getElementById("Remarks").value == "") {
        alert("请填写备注");
        return;
    }
    if (document.getElementById("Remarks").value == "") {
        alert("请填写备注");
        return;
    }
    var form = new FormData(document.getElementById("saveFixRecord"));
    $.ajax({
        url: "fixRecordRecord.ashx",
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
        failure: function (e) {
            alert("更新失败！！");
        }
    });
}
function remove() {
    document.getElementById("BodyPositionDetail").removeAttribute("disabled");
    document.getElementById("Remarks").removeAttribute("disabled");
}
