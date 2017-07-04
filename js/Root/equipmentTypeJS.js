/**
 *
 */

var jsonObj = [];

/**
 *
 */
$(function () {
    createTable(1);
});

function getType() {
    $.ajax({
        type: "post",
        url: "getEquipmentType.ashx",
        dataType: "text",
        async: false,
        success: function (data) {
            jsonObj = $.parseJSON(data);
        }
    });
}

function createTable(page) {
    getType();
    var sumPage = countSumPage(jsonObj.length);
    $("#sumPage").val(sumPage);
    initBindPage();
    createPage(page);
}

/**
 * 创建指定页
 * @param page 第几页
 */
function createPage(page) {
    var $tbody = $("#tbody");

    $tbody.empty();

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        var $tr = $("<tr><td>"
                    + jsonObj[i].id
                    + "</td><td>"
                    + jsonObj[i].type
                    + "</td></tr>");
        $tbody.append($tr);
    }
}

/**
 * 翻页事件
 */
function initBindPage() {
    var sumPages = $("#sumPage").val();
    if (parseInt(sumPages) > 1) {
        nextPage();
        lastPage();
    }
}

/**
 * 首页事件
 * 1.绑定首页按钮事件
 * 2.创建当前表格首页
 * 3.设定当前页为首页
 * 4.解绑并取消首页上一页
 * 5.如果是从最后一页操作的末页下一页绑定
 */
function firstPage() {
    $("#firstPage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        createPage(1);
        $("#currentPage").val(1);
        $(this).unbind("click").addClass("disabled");
        $("#prePage").unbind("click").addClass("disabled");

        if (currentPage == $("#sumPage").val()) {
            nextPage();
            lastPage();
        }
    });
}

/**
 * 上一页绑定
 * 1.读取当前页数
 * 2.绑定按钮
 * 3.算出上一页
 * 4.生成视图
 * 5.更新当前页码
 * 6.如果当前为首页解绑首页上一页
 * 7.如果原来是末页解绑下一页末页
 */
function prePage() {
    $("#prePage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        var prePage = currentPage - 1;
        createPage(prePage);
        $("#currentPage").val(prePage);

        if (prePage == 1) {
            $(this).addClass("disabled").unbind("click");
            $("#firstPage").addClass("disabled").unbind("click");
        }

        if (currentPage == parseInt($("#sumPage").val())) {
            nextPage();
            lastPage();
        }
    });
}

/**
 * 下一页
 * 1.读取当前页数
 * 2.绑定按钮
 * 3.算出下一页
 * 4.生成视图
 * 5.更新当前页
 * 6.如果当前是末页解绑下一页末页
 * 7.如果原来是首页绑定首页上一页
 */
function nextPage() {
    $("#nextPage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        if (currentPage == $("#sumPage").val()) {
            return;
        }
        var nextPage = parseInt(currentPage) + 1;
        createPage(nextPage);
        $("#currentPage").val(nextPage);

        if (nextPage == parseInt($("#sumPage").val())) {
            $(this).unbind("click").addClass("disabled");
            $("#lastPage").unbind("click").addClass("disabled");
        }

        if (currentPage == "1") {
            firstPage();
            prePage();
        }
    });
}

/**
 * 末页
 * 1.获取当前页
 * 2.绑定按钮
 * 3.生成末页视图
 * 4.更新当前页
 * 5.解绑末页下一页
 * 6.如果当前页为1绑定首页上一页
 */
function lastPage() {
    $("#lastPage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        createPage(parseInt($("#sumPage").val()));
        $("#currentPage").val($("#sumPage").val());

        $(this).unbind("click").addClass("disabled");
        $("#nextPage").unbind("click").addClass("disabled");

        if (currentPage == "1") {
            firstPage();
            prePage();
        }
    });
}

/**
 * 计算表格最大页数（12行1页)
 * @param size 数据行数
 * @return 最大页数
 */
function countSumPage(size) {
    var temp = parseInt(size / 12);
    var sumPages = size / 12 - temp == 0 ? temp : temp + 1;
    return sumPages;
}

/**
 * 新增设备类型
 */
$(function () {
    $("#sureAdd").bind("click", function () {
        var type = $("#addEquipmentType").val();
        if (type == "") {
            $("#addEquipmentType").addClass("invalid");
            return false;
        } else {
            $.ajax({
                type: "post",
                url: "addEquipmentType.ashx",
                data: { "type": type },
                success: function () {
                    alert("新增成功");
                    createTable(parseInt($("#currentPage").val()));
                    $("#cannelButton").trigger("click");
                }
            });
        }
    });
});

/**
 * 取消新增按钮
 */
$(function () {
    $("#cannelButton").bind("click", function () {
        $("#addEquipmentType").removeClass("invalid").val("");
    });
});


/**
 * 编辑处理
 */
$(function () {
    $("#changeGroup").bind("click", function () {
        $(this).hide();
        $("#newGroup").hide();
        $("#closeEdite").fadeIn(360);
        $("#parameterTable").bind("click", function (evt) {
            var which = evt.target;
            var $tr = $(which).closest("tr");
            editType($tr);
            $("#EditGroup").trigger("click");
        });
    });
    $("#closeEdite").bind("click", function () {
        $("#parameterTable").unbind("click");
        $(this).hide();
        $("#changeGroup").fadeIn(360);
        $("#newGroup").fadeIn(360);
    })
});

function editType($tr) {
    var $td = $tr.find("td");
    $("#editType").val($td[1].innerText);
    $("#equipmentID").val($td[0].innerText);
}

$(function () {
    $("#sureEdit").bind("click", function () {
        var type = $("#editType").val();
        var id = $("#equipmentID").val();
        $.ajax({
            type: "post",
            url: "editEquipmentType.ashx",
            data: { "id": id, "type": type },
            success: function () {
                alert("修改成功");
                createTable(parseInt($("#currentPage").val()));
                $("#cannelEdit").trigger("click");
            }
        });
    });
});

$(function () {
    $("#deleteType").bind("click", function () {
        var id = $("#equipmentID").val();
        $.ajax({
            type: "post",
            url: "deleteEquipmentType.ashx",
            data: { "id": id},
            success: function () {
                alert("删除成功");
                createTable(parseInt($("#currentPage").val()));
                $("#cannelEdit").trigger("click");
            }
        })
    });
});

$(function () {
    $("#search").bind("click", function () {
        var text = $("#GroupSearchID").val();
        if (text == "") {
            window.location.href = "../../pages/Root/EquipmentTypeManage.aspx";
        } else {
            $("#pageButton").hide();
            $("#searchRecover").show(360);
            var search = [];
            for (var i = 0; i < jsonObj.length; ++i) {
                if (jsonObj[i].type.toUpperCase().indexOf(text.toUpperCase()) > -1) {
                    search.push(jsonObj[i]);
                }
            }

            var $tbody = $("#tbody");

            $tbody.empty();

            for (var i = 0; i < search.length; ++i) {
                var $tr = $("<tr><td>"
                            + search[i].id
                            + "</td><td>"
                            + search[i].type
                            + "</td></tr>");
                $tbody.append($tr);
            }

        }

    });

    $("#refresh").bind("click", function () {
        window.location.href = "../../pages/Root/EquipmentTypeManage.aspx";
    });
});