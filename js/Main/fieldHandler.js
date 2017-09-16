var objURL = "";
$(function () {
    $("#sure").bind("click", function () {
        if (objURL == "") {
            return false;
        }
        var formDate = new FormData();
        if ($("#file")[0].files[0] == null) {
            formDate.append("exist", "false");
        } else {
            formDate.append("file", $("#file")[0].files[0]);
            formDate.append("exist", "true");
        }
        $.ajax({
            type: "post",
            url: "getFieldInformation.ashx",
            data: formDate,
            // 告诉jQuery不要去处理发送的数据
            processData: false,
            // 告诉jQuery不要去设置Content-Type请求头
            contentType: false,
            success: function (data) {
                var data = $.parseJSON(data);
                createInformation(data.information);
                creaetField(data.details);
            }
        });
    });
});

$(document).on('change', '#file', function () { //PictureUrl为input file 的id
    //console.log(this.files[0]);
    function getObjectURL(file) {
        var url = null;
        if (window.createObjcectURL != undefined) {
            url = window.createOjcectURL(file);
        } else if (window.URL != undefined) {
            url = window.URL.createObjectURL(file);
        } else if (window.webkitURL != undefined) {
            url = window.webkitURL.createObjectURL(file);
        }
        return url;
    }
    objURL = getObjectURL(this.files[0]);//这里的objURL就是input file的真实路径
    if ($("#show")[0]) {
        $("#show").remove();
    }
    $("#file").after("<a id=show target=_blank href=" + objURL + " >file</a>");
});

function createInformation(data) {
    var elements = new Array();
    elements.push("<div class='col-md-12'>");
        elements.push("<div class='col-sm-4'>");
        elements.push("放疗号:");
        elements.push(data[0].id);
        elements.push("</div><div class='col-sm-4'>tps:");
        elements.push(data[0].tps);
        elements.push("</div><div class='col-sm-4'>总剂量:");
        elements.push(data[0].all);
        elements.push("</div></div><div class='col-md-12'>");
        elements.push("</div><div class='col-sm-4'>分次剂量:");
        elements.push(data[0].once);
        elements.push("</div><div class='col-sm-4'>射野总数:");
        elements.push(data[0].fieldTimes);
        elements.push("</div><div class='col-sm-4'>摆位信息:");
        elements.push(data[0].pos);
        elements.push("</div>");
    elements.push("</div>");
    $("#information").empty().append(elements.join(''));
}

function creaetField(data){
    $("#field").createTable(data, {
        headName: new Array("射野id","MU","放疗设备","照射技术","射野类型","能量","源皮距","机架角","机头角",
                    "床转交", "子野数"),

    });
}