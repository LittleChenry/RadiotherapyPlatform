var day;
var month;
var year;

/**
 * 创建表头
 */
$(function () {
    var date = new Date();
    day = date.getDate();
    month = date.getMonth() + 1;
    year = date.getFullYear();
    

    var $thead = $("#thead");
    var str = "<tr><th style=width:12.5%>时间\\日期</th>";
    for (var i = 0; i < 7; ++i) {
        str += "<th style=width:12.5%>" + (date.getMonth() + 1) + "月" + date.getDate() + "日</th>";
        date.setDate(date.getDate() + 1);
    }
    str += "</tr>";

    $thead.append(str);
});

/**
 **创建函数
 */
function appointView(){
    var id = $("#equipment").val();
    createBody(id);
}

/**
 * 创建表格
 * @param id 设备id
 */
function createBody(id) {
    $("#tbody").empty();
    var jsonObj = [];
    var lastDate = new Date();
    lastDate.setDate(lastDate.getDate() + 7);
    $.ajax({
        type: "post",
        url: "../../pages/Root/getAppointmentByTime.ashx",
        async: false,
        data: { "id": id, "year": year, "month": month, "day": day, "lyear":lastDate.getFullYear(), "lmonth": lastDate.getMonth() + 1, "lday":lastDate.getDate() },
        dataType: "text",
        success: function (data) {
            if (data == "]")
                return;
            jsonObj = $.parseJSON(data);
            
            createTime(jsonObj);
            createdate(jsonObj, (jsonObj[0].Task == "模拟定位"));
        }
    });
}

function createTime(obj) {
    var date = obj[0].Date;
    var $tbody = $("#tbody");
    for (var i = 0; i < obj.length; ++i) {
        if (date == obj[i].Date) {
            var $tr = $("<tr><td>" + convertTime(obj[i].Begin) + "-" + convertTime(obj[i].End) + "</td><td></td><td></td><td></td><td></td><td></td><td></td><td></td></tr>");
            $tbody.append($tr);
        } else {
            break;
        }
    }
}

function convertTime(time) {
    var t = parseInt(time);
    var h = parseInt(t / 60);
    var m = t - h * 60;
    var str = "";
    str += h + ":" + (m >= 10 ? "" : "0") + m;
    return str;
}

function createdate(jsonObj, isDouble) {
    $tr = $("#tbody").find("tr");
    var size = $tr.length;

    var currentDate = jsonObj[0].Date;
    var arr = new Array();
    for (var i = 0; i < size; i++) {
        arr.push(1);
    }

    for (var i = 0; i < jsonObj.length; ++i) {
        if (jsonObj[i].State == 1) {
            var row = i % size;//第几行
            var col = computeDays(currentDate, jsonObj[i].Date);
            //if (isDouble && i != (jsonObj.length - 1) && jsonObj[i].Date == jsonObj[i + 1].Date && jsonObj[i].PatientID == jsonObj[i + 1].PatientID) {
            //    $($($tr[row]).find("td")[col + arr[row]]).attr("rowspan", "2").text("复位验证 : " + jsonObj[i].PatientName);
            //    $($($tr[row + 1]).find("td")[col + arr[row + 1]]).remove();
            //    arr[row + 1] = arr[row + 1] - 1;
            //    i++;
            //} else {
            var span = document.createElement("span");
            if (jsonObj[i].Completed == "1") {
                if (jsonObj[i].ischecked == "1") {
                    var text = document.createTextNode(jsonObj[i].PatientName + ' : CT复查(已完成)');
                } else {
                    var text = document.createTextNode(jsonObj[i].PatientName + ' : ' + jsonObj[i].Task + '(已完成)');
                }
            } else {
                if (jsonObj[i].ischecked == "1") {
                    var text = document.createTextNode(jsonObj[i].PatientName + ' : CT复查(未完成)');
                } else {
                    var text = document.createTextNode(jsonObj[i].PatientName + ' : ' + jsonObj[i].Task + '(未完成)');
                }
            }
                span.setAttribute("id", jsonObj[i].Treatment_ID + '_' + jsonObj[i].ID);
                span.appendChild(text);
                $($tr[row]).find("td")[col + arr[row]].appendChild(span);
            
            //}
        }
    }
}

//天数差
function computeDays(startTime, endTime) {
    var st = new Date(startTime.replace(/-/g, "\/"));
    var et = new Date(endTime.replace(/-/g, "\/"));
    return (et - st) / (24 * 60 * 60 * 1000);
}