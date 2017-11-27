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
            url: "getCheckRecord.ashx",
            data: {"equipmentID" : $equipment.val(), "date" : dates},
            dataType: "text",
            success: function (data) {
                if (data == "null") {
                    return;
                }
                var jsonObj = $.parseJSON(data);
                var max = 0, index = 0;
                for (var i = 0; i < jsonObj.length; ++i) {
                    var len = countLength(jsonObj[i]);
                    if (max < len) {
                        max = len;
                        index = i;
                    }
                }
                var head = new Array();
                for (i in jsonObj[index]) {
                    head.push(i);
                }
                $("#tableArea").createTable(jsonObj, {
                    rows: 12,
                    needDate: true,
                    createDate: dates,
                    lessLength: max,
                    headName: head
                });
                $.ajax({
                    type: "post",
                    url: "/RadiotherapyPlatform/pages/Main/getMainItemLength.ashx",
                    data: { "equipmentID": $equipment.val() },
                    success: function (MainItem) {
                        var jsonObj = $.parseJSON(MainItem);
                        var MainTr = new Array();
                        MainTr.push("<tr><th> </th>");
                        for (var i = 0; i < jsonObj.length; i++) {
                            MainTr.push("<th style='border-right:1px solid #ccc;border-left:1px solid #ccc;padding:2px' colspan=" + jsonObj[i].len + ">" + jsonObj[i].name + "</th>");
                        }
                        var trMain = MainTr.join('');
                        $("#tableArea thead").prepend(trMain);
                    }
                });
            }
        })
    });
});

function countLength(obj) {
    var arr = Object.keys(obj);
    var len = arr.length;
    return len;
}
