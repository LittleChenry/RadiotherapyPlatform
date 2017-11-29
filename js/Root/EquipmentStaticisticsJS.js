/**
 *
 **/
var currentData;
var currentDate;
var currentMainItem;
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
    var isClick = false;
    $("#search").bind("click", function () {
        if (isClick == true)
            return;
        isClick = true;
        var $equipment = $("#equipmentSelect").find(":selected");
        $(".panel-title").text($equipment.text());
        var dates = $("#dates").val();
        currentDate = dates;
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
                currentData = jsonObj;
                createTablebody("#tableArea", jsonObj, 12, dates);
                $.ajax({
                    type: "post",
                    url: "/RadiotherapyPlatform/pages/Main/getMainItemLength.ashx",
                    data: { "equipmentID": $equipment.val() },
                    async: false,
                    success: function (MainItem) {
                        var jsonObj = $.parseJSON(MainItem);
                        currentMainItem = jsonObj;
                        createMainItem(jsonObj, "#tableArea thead", "style = 'border-right:1px solid #ccc;border-left:1px solid #ccc;padding:2px'");
                        isClick = false;
                    }
                });
            }
        })
    });
});

function createTablebody(area,jsonObj, r, dates) {
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
    $(area).createTable(jsonObj, {
        rows: r,
        needDate: true,
        createDate: dates,
        lessLength: max,
        headName: head
    });
}

function createMainItem(jsonObj, area,style) {
    var MainTr = new Array();
    MainTr.push("<tr><th> </th>");
    for (var i = 0; i < jsonObj.length; i++) {
        MainTr.push("<th " + style +" colspan=" + jsonObj[i].len + ">" + jsonObj[i].name + "</th>");
    }
    var trMain = MainTr.join('');
    $(area).prepend(trMain);
}

function countLength(obj) {
    var arr = Object.keys(obj);
    var len = arr.length;
    return len;
}

/**
* 打印
*/
$(function(){
    $("#print").bind("click", function () {
        createTablebody("#printArea", currentData, currentData.length + 1, currentDate);
        createMainItem(currentMainItem, "#printArea thead", "");
        $("#printArea").prepend("<h2 style=text-align:center>" + $(".panel-title").text() + "</h2>");
        $("#printArea").find("input[type=button]").remove();
        $("#printArea").show().printArea({ "mode": "popup", "popClose": true });
        $("#printArea").empty().append("<table class='table table-hover'></table>").hide();
    });
});