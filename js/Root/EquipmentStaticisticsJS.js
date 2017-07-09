/**
 *
 **/

/**
 * 生成设备选择菜单下拉选项
 */
$(function () {
    getAllEquipment();
});

/**
 * 获取所有设备
 */
function getAllEquipment() {
    $.ajax({
        type: "post",
        url: "GetEquipment.ashx",
        dataType: "text",
        success: function (data) {
            fillSelect($.parseJSON(data));
        }
    })
}

/**
 * 填充下拉菜单
 */
function fillSelect(obj) {
    var $select = $("#equipmentSelect");
    for (var i = 0; i < obj.length; ++i) {
        $select.append("<option value=" + obj[i].ID + ">" + obj[i].Name + "</option>");
    }
}

/**
 * 搜索按钮事件
 */
$(function () {
    $("#search").bind("click", function () {
        var $equipment = $("#equipmentSelect").find(":selected");
        var dates = $("#dates").val();
        $.ajax({
            type: "post",
            url: "",
            dataType: "text",
            success: function (data) {
                createTable($.parseJSON(data));
            }
        })
    });
});

function createTable(obj) {
    createHead();
    createBody();
}

/*
 * 创建表头
 */
function createHead() {
    var $head = $("#thead");
    $head.empty();
    $.ajax({
        type: "post",
        url: "getEquipmentInspection.ashx",
        dataType: "text",
        success: function (data) {
            var jsonObj = $.parseJSON(data);
            var $tr = $("<tr></tr>");
            for (var i = 0; i < jsonObj.length; ++i) {

            }
        }
    });

}