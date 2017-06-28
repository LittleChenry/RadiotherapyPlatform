var obj = [];

$(function () {
    var length = CreateTitleList();//创建检查结果标题列表,返回检查表数量
    var $pagebutton = $("#pageButton");
    if (length <= 9) {
        $pagebutton.children().addClass("disabled");
    } else {
        $("#pageButton :button:gt(1)").removeClass("disabled");
        //对下一页和末页按钮绑定事件
        pageButtonBind(2);
        pageButtonBind(3);
    }
});

function CreateTitleList() {
    var $ul = $("#resultTitle");
    GetResultDate();//获取检查结果数据
    var count = 0;
    $.each(obj, function () {
        if (count < 6) {
            var $li = CreateLi(this.ID, this.Date, this.EquipmentName, this.Cycle, this.People, false);
            $ul.append($li);
        } else if (count < 9) {
            var $li = CreateLi(this.ID, this.Date, this.EquipmentName, this.Cycle, this.People, true);
            $ul.append($li);
        } else {
            return false;
        }
        ++count;
    });
    if (obj.length > 6) {
        $link = $("<a href=#>more</a>");
        $link.css({ float: "right", fontSize: "14px" });
        $link.bind("click", function(evt) {
            evt.preventDefault();
            $pagebutton = $("#pageButton");
            if ($pagebutton.is(":hidden")) {
                $("#resultTitle > li:gt(5)").slideDown("fast");
                $("#pageButton").show("fast");
                $(this).text("concise");
            } else {
                $("#resultTitle > li:gt(5)").slideUp("fast");
                $("#pageButton").hide("fast");
                $(this).text("more");
            }
        });
        $("div > span.panel-title").parent().append($link);
    }
    $("#currentPage").val("1");
    $("#loading").hide(50);
    return obj.length;
}

function GetResultDate() {
    $.ajax({
        type: "GET",
        url: "GetInspectionResult.ashx",
        async: false,
        dateType: "text",
        success: function (date) {
            var json = date;
            obj = eval("(" + date + ")");
        }
    });
}

//创建li
function CreateLi(ID, date, EquipmentName, Cycle, People, ishide) {
    var cycName = "";
    switch (Cycle) {
        case "day":
            cycName = "日检";
            break;
        case "month":
            cycName = "月检";
            break;
        case "year":
            cycName = "年检";
            break;
    }
    var $span = $("<span style=float:right>" + date + "</span>");
    var $a = $("<a href=InspectionResult.aspx?id=" + ID + "&People=" + People + "&Equipment=" + EquipmentName + cycName + "&date=" + date.split(" ")[0] + " target=_blank>" + cycName + "-" + EquipmentName + "</a>");
    var $br = $("<hr style=margin-top: 5px; margin-bottom: 5px;>");
    var $hideInput = $("<input type=hidden value=" + ID + " />");
    var $li = $("<li></li>");
    if (ishide) {
        $li.addClass("tohidden");
    }
    $li.append($span).append($a).append($br).append($hideInput);
    return $li;
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
    if (obj.length > 9) {
        pageButtonBind(2);
        pageButtonBind(3);
    }
}

function prePage(){
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
    if (parseInt($("#currentPage").val()) * 9 >= obj.length) {
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

//根据条件变换页数
function pageChange(type) {
    var currentPage = $("#currentPage").val();
    var $ul = $("#resultTitle");
    $ul.empty();
    var count = 0;
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
            toPage = (obj.length % 9 == 0) ? parseInt(obj.length / 9) : parseInt(obj.length / 9 + 1);
            if (toPage == 0) {
                toPage = 1;
            }
            break;
    }
    $("#currentPage").val(toPage);
    for (var i = (toPage - 1) * 9; i < (toPage) * 9; i++) {
        if (i < obj.length) {
            if (count < 6) {
                var $li = CreateLi(obj[i].ID, obj[i].Date, obj[i].EquipmentName, obj[i].Cycle, obj[i].People, false);
                $ul.append($li);
            } else {
                var $li = CreateLi(obj[i].ID, obj[i].Date, obj[i].EquipmentName, obj[i].Cycle, obj[i].People, true);
                $ul.append($li);
            }
        }
    }
    $("li.tohidden").show();
}