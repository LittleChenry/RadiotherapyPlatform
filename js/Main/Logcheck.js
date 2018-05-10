/* ***********************************************************
 * FileName: logcheck.js
 * Writer: xubixiao
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 病人日志记录
 * **********************************************************/
window.addEventListener("load", Init, false);
function Init() {
    $("#dates").val(new Date().getFullYear()+"-"+(new Date().getMonth()+1)+"-"+new Date().getDate());
    $("#datesend").val(new Date().getFullYear() + "-" + (new Date().getMonth()+1) + "-" + new Date().getDate());
    $.ajax({
        type: "GET",
        url: "getLogInfo.ashx",
        async: false,
        data: {
            startdate: $("#dates").val(),
            enddate: $("#datesend").val()
        },
        dateType: "json",
        success: function (data) {
            var datanew = eval("(" + data + ")");
            var tbody = $("#loginfo").find("tbody").eq(0);
            var content = "";
            for (var i = 0; i < datanew.length; i++) {
                content = content + '<tr>';
                content = content + '<td>' + datanew[i].userName + '</td><td>' + datanew[i].date.split(" ")[0] + '</td><td>' + datanew[i].logcontext + '</td>';
                if (datanew[i].ischecked == "0") {
                    content = content + '<td><button class="btn btn-info" onclick="check(this,' + datanew[i].id + ')">查看</button></td>';
                } else {
                    content = content + '<td>已经查看</td>';
                }
            }
            tbody.append(content);

        },
        error: function () {
            alert("error");
        }
    });
    $("#sureDate").click(function(){
        $.ajax({
            type: "GET",
            url: "getLogInfo.ashx",
            async: false,
            data: {
                startdate: $("#dates").val(),
                enddate: $("#datesend").val()
            },
            dateType: "json",
            success: function (data) {
                var datanew = eval("(" + data + ")");
                var tbody = $("#loginfo").find("tbody").eq(0);
                tbody.empty();
                var content = "";
                for (var i = 0; i < datanew.length; i++) {
                    content = content + '<tr>';
                    content = content + '<td>' + datanew[i].userName + '</td><td>' + datanew[i].date.split(" ")[0] + '</td><td>' + datanew[i].logcontext + '</td>';
                    if (datanew[i].ischecked == "0") {
                        content = content + '<td><button class="btn btn-info" onclick="check(this,' + datanew[i].id + ')">查看</button></td>';
                    } else {
                        content = content + '<td>已经查看</td>';
                    }
                }
                tbody.append(content);

            },
            error: function () {
                alert("error");
            }
        });
    });

}
function check(e,element) {
    $.ajax({
        type: "POST",
        url: "checkLog.ashx",
        async: false,
        data: {
            infoid:element
        },
        dateType: "json",
        success: function (data) {
            $(e).parent().html("已经查看");
        },
        error: function () {
            alert("error");
        }
    });

}