var currentFirst = "";

$(function () {
    getFirst();

    $("#sureit").bind("click", function () {
        currentFirst = $("#first :selected").text();
        getSecond();
        $("#newCode").show(200);
        $("#changeCode").show(200);
    });


    $("#cannelButton").bind("click", function () {
        $("#addCode").find("input").val("");
    });

    $("#sureAdd").bind("click", function () {
        var name = $("#nameNew").val();
        var error = $("#error");
        error.hide();
        if (name == "") {
            error.show();
            error.text("名称不能为空");
            return false;
        }
        addCode(name);
    });

    $("#changeCode").bind("click", function () {
        $("#newCode").hide();
        $(this).hide();
        $("#closeEdit").show(200);
        $("#tableArea").bind("click", function (evt) {
            var which = evt.target;
            var tr = $(which).closest("tr");
            $("#nameEdit").val(tr.find("td")[0].innerText);
            $("#idEdit").val(tr.find("td input[type=hidden]").val());
            $("#EditGroup").trigger("click");
        });
    });

    $("#sureEdit").bind("click", function () {
        updateCode($("#nameEdit").prev().val(), $("#nameEdit").val());
    });

    $("#closeEdit").bind("click", function () {
        $(this).hide();
        $("#tableArea").unbind("click");
        $("#newCode").show();
        $("#changeCode").show();
    });
});

function getFirst() {
    $.ajax({
        type: "post",
        url: "../../pages/Root/getMorphoFirst.ashx",
        success: function (data) {
            var firstObj = $.parseJSON(data);
            createSelect("first", firstObj, "group");
        }
    });
}

function createSelect(id, data, name) {
    var select = $("#" + id);
    select.empty().append("<option value=''>无</option>");
    var options = new Array();
    for (var i = 0; i < data.length; i++) {
        options.push("<option>" + data[i][name] + "</option>");
    }
    select.append(options.join(''));
}

function getSecond() {
    $.ajax({
        type: "post",
        url: "../../pages/Root/getmorphoSecond.ashx",
        data: { "first": $("#first :selected").text() },
        success: function (data) {
            if (data == "[")
                return;
            obj = $.parseJSON(data);
            createTable(obj);
        }
    });
}

function createTable(data) {
    $("#tableArea").createTable(data, {
        headName: new Array("名称"),
        needKey: true,
        key:"id"
    });
}

function addCode(name) {
    var currentPage = $("#currentPage").val();
    $.ajax({
        type: "post",
        url: "../../pages/Root/addmorpholCode.ashx",
        data: { "first": currentFirst, "name": name },
        success: function (id) {
            objAdd(id, name);
            $("#tableArea").createTable(obj, {
                headName: new Array("名称"),
                needKey: true,
                key:"id",
                pages: parseInt(currentPage)
            });
            alert("新增成功");
            $("#cannelButton").trigger("click");
        }
    });
}

function objAdd(id, name) {
    obj.push({ "id": id, "name": name });
}

function updateCode(id, name) {
    var currentPage = $("#currentPage").val();
    $.ajax({
        type: "post",
        url: "../../pages/Root/updatemorpholCode.ashx",
        data: { "id": id, "name": name },
        success: function () {
            updateObj(id, name);
            $("#tableArea").createTable(obj, {
                headName: new Array("名称"),
                needKey: true,
                key:"id",
                pages: parseInt(currentPage)
            });
            alert("修改成功");
            $("#cannelEdit").trigger("click");
        }
    });
}

function updateObj(id, name) {
    for (var i = 0; i < obj.length; i++) {
        if (obj[i].id == id) {
            obj[i].name = name;
            break;
        }
    }
}