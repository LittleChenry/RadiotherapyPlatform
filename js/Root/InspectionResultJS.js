var obj = [];

$(function () {
    //获取消息信息
    var information = window.location.search.split("?")[1];
    var infors = information.split("&");
    var ID = infors[0].split("=")[1];
    var people = infors[1].split("=")[1];
    var equipmentName = infors[2].split("=")[1];
    var date = infors[3].split("=")[1];
    $("h1.page-header").text(decodeURI(equipmentName) + "结果表");
    GetInformation(ID, date, people);//获取具体检查结果
});

function GetInformation(ID,date,people) {
    $("#loading").show();
    $.ajax({
        type: "GET",
        url: "../../pages/Root/GetConcreteInspectionResult.ashx?id=" + ID + "&people=" + people,
        async: true,
        dateType: "text",
        success: function (data) {
            obj = eval("(" + data + ")");
            CreateTable(date);
            $("#loading").hide();
        }
    });
}

function CreateTable(date) {
    $("div > span.panel-title").text("检查日期:" + date + "  检查人:" + obj[0].name);
    $("div > span.panel-title").after("<span style=float:right class=panel-title>功能状态:" + (obj[0].functionAll == 1 ? "正常" : "不正常") + "</h3>");
    var currentRows = 0;
    var currentPage = 0;
    var $currentTable = CreateNewTable(0);
    var currentMainItem = "";
    for (var i = 1; i < obj.length; ++i) {
        if (currentRows >= 16) {
            currentPage++;
            currentRows = 0;
            $currentTable = CreateNewTable(currentPage);
        }
        if (obj[i].MainItem != currentMainItem) {
            var $td = ("<tr style=text-align:left><td colspan=8>" + obj[i].MainItem + "</td></tr>");
            $currentTable.children("tbody").append($td);
            currentMainItem = obj[i].MainItem
            ++currentRows;
        }
        
        var $tr = ("<tr><td colspan=2>" + obj[i].ChildItem + "</td><td>" + obj[i].UIMRTRealValue + "</td><td>" + isOk(obj[i].UIMRTState) + "</td><td>" + obj[i].IMRTRealValue + "</td><td>" + isOk(obj[i].IMRTState) + "</td><td>" + obj[i].SRSRealValue + "</td><td>" + isOk(obj[i].SRSState) + "</td><td>" + functionIsOk(obj[i].FunctionalStatus) + "</td></tr>");
        $currentTable.children("tbody").append($tr);
        ++currentRows;    
    }
    $("#sumPage").val(currentPage + 1);
    if (currentPage > 0) {
        $("#pageButton :button:gt(1)").removeClass("disabled");
        //对下一页和末页按钮绑定事件
        pageButtonBind(2);
        pageButtonBind(3);
    } else {
        $("#pageButton :button").addClass("disabled");
    }
}

function functionIsOk(str) {
    if(str == ""){
        return "";
    }
    return str == "1" ? "正常" : "不正常";
}

function CreateNewTable(page) {
    var table = $("<table id=table" + page + "></table>");
    table.addClass("table table-bordered table-center table-hover");
    var thead = $("<thead><tr><th colspan=2>检查项目名</th><th>无调强检查值</th><th>无调强状态值</th><th>调强检查值</th><th>调强状态值</th><th>SRS/SBRT检查值</th><th>SRS/SBRT状态值</th><th>状态</th></tr></thead>");
    var tbody = $("<tbody id=body" + page + "></tbody>");
    table.append(thead).append(tbody);
    if (page > 0)
        table.hide();
    $("#tableArea").append(table);
    return table;
}

function pageButtonBind(which) {
    switch (which) {
        case 0:
            $("#pageButton :button:eq(0)").bind("click", function (evt) {
                firstPage();
                return false;
            });
            $("#pageButton :button:eq(0)").removeClass("disabled");
            break;
        case 1:
            $("#pageButton :button:eq(1)").bind("click", function (evt) {
                prePage();
                return false;
            });
            $("#pageButton :button:eq(1)").removeClass("disabled");
            break;
        case 2:
            $("#pageButton :button:eq(2)").bind("click", function (evt) {
                nextPage();
                return false;
            });
            $("#pageButton :button:eq(2)").removeClass("disabled");
            break;
        case 3:
            $("#pageButton :button:eq(3)").bind("click", function (evt) {
                lastPage();
                return false;
            });
            $("#pageButton :button:eq(3)").removeClass("disabled");
            break;
    }
}

function ButtonUnbind(which) {
    switch (which) {
        case 0:
            $("#pageButton :button:eq(0)").unbind("click");
            $("#pageButton :button:eq(0)").addClass("disabled");
            break;
        case 1:
            $("#pageButton :button:eq(1)").unbind("click");
            $("#pageButton :button:eq(1)").addClass("disabled");
            break;
        case 2:
            $("#pageButton :button:eq(2)").unbind("click");
            $("#pageButton :button:eq(2)").addClass("disabled");
            break;
        case 3:
            $("#pageButton :button:eq(3)").unbind("click");
            $("#pageButton :button:eq(3)").addClass("disabled");
            break;
    }
}

function firstPage() {
    pageChange("first");
    //解绑首页上一页
    ButtonUnbind(0);
    ButtonUnbind(1);
    if (parseInt($("#sumPage").val()) > 1) {
        pageButtonBind(2);
        pageButtonBind(3);
    }
}

function prePage() {
    pageChange("pre");
    if ($("#currentPage").val() == "1") {
        ButtonUnbind(0);
        ButtonUnbind(1);
    }
    pageButtonBind(2);
    pageButtonBind(3);
}

function nextPage() {
    pageChange("next");
    pageButtonBind(0);
    pageButtonBind(1);
    if (parseInt($("#sumPage").val()) == $("#currentPage").val()) {
        ButtonUnbind(2);
        ButtonUnbind(3);
    }
}

function lastPage() {
    pageChange("last");
    ButtonUnbind(2);
    ButtonUnbind(3);
    pageButtonBind(0);
    pageButtonBind(1);
}

function pageChange(type) {
    var currentPage = $("#currentPage").val();
    var toPage = 0;
    switch (type) {
        case "first":
            toPage = 1;
            break;
        case "pre":
            toPage = parseInt(currentPage) - 1;
            break;
        case "next":
            toPage = parseInt(currentPage) + 1;
            break;
        case "last":
            toPage = parseInt($("#sumPage").val());
            break;
    }
    --toPage;
    $("#tableArea > :visible").hide();
    $("#table" + toPage).show();
    $("#currentPage").val(toPage + 1);
}

function isOk(type) {
    switch (type) {
        case "1":
            return "正常";
        case "2":
            return "一般";
        case "3":
            return "不正常";
        default:
            return type;
    }
}