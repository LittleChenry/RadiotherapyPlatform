var currentCode = "";
var maxCode = 0;
var currentFirst = "";
var currentSecond = "";
var obj = [];

$(function () {
    getFirst();
    
    $("#first").bind("change", function () {
        getSecond();
    });

    $("#sureit").bind("click", function () {
        currentCode = $("#second :selected").text().substring(0, 3);
        currentFirst = $("#first :selected").text();
        currentSecond = $("#second :selected").text();
        getThird();
        $("#newCode").show(200);
        $("#changeCode").show(200);
    });

    $("#newCode").bind("click", function () {
        createCode();
    });

    $("#cannelButton").bind("click", function () {
        $("#addCode").find("input").val("");
    });

    $("#sureAdd").bind("click", function () {
        var code = $("#codeNew").val();
        var name = $("#nameNew").val();
        var error = $("#error");
        error.hide();
        if (code == "") {
            error.show();
            error.text("编码不能为空");
            return false;
        }
        if (name == "") {
            error.show();
            error.text("名称不能为空");
            return false;
        }
        addCode(code,name);
    });

    $("#changeCode").bind("click", function () {
        $("#newCode").hide();
        $(this).hide();
        $("#closeEdit").show(200);
        $("#tableArea").bind("click", function (evt) {
            var which = evt.target;
            var tr = $(which).closest("tr");
            $("#codeEdit").val(tr.find("td")[0].innerText);
            $("#nameEdit").val(tr.find("td")[1].innerText);
            $("#idEdit").val(tr.find("td input[type=hidden]").val());
            $("#EditGroup").trigger("click");
        });
    });

    $("#sureEdit").bind("click", function () {
        updateCode($("#codeEdit").prev().val(), $("#codeEdit").val(), $("#nameEdit").val());
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
        url: "getFirst.ashx",
        success: function (data) {
            var firstObj = $.parseJSON(data);
            createSelect("first", firstObj, "group");
        }
    });
}

function getSecond() {
    $.ajax({
        type: "post",
        url: "getSecond.ashx",
        data: {"first" : $("#first").find(":selected").text()},
        success: function (data) {
            var secondObj = $.parseJSON(data);
            createSelect("second", secondObj, "group");
        }
    });
}

function getThird() {
    $.ajax({
        type: "post",
        url: "getThird.ashx",
        data: { "second": $("#second :selected").text() },
        success: function (data) {
            if (data == "[")
                return;
            obj = $.parseJSON(data);
            findMax(obj);
            createTable(obj);
        }
    });
}

function findMax(data) {
    var max = -1;
    for (var i = 0; i < data.length; i++) {
        if(parseInt(data[i].code.split(".")[1]) > max){
            max = parseInt(data[i].code.split(".")[1]);
        }
    }
    maxCode = max;
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

function createTable(data) {
    $("#tableArea").createTable(data, {
        headName: new Array("编码", "名称"),
        needKey: true
    });
}

function createCode() {
    if (maxCode == 0 || currentCode == "")
        return;
    var code = $("#codeNew");
    code.val(currentCode + "." + (maxCode + 1));
}

function addCode(code, name) {
    var currentPage = $("#currentPage").val();
    $.ajax({
        type: "post",
        url: "addCode.ashx",
        data: { "first": currentFirst, "second": currentSecond, "code": code, "name": name },
        success: function (id) {
            objAdd(id,code, name);
            $("#tableArea").createTable(obj, {
                headName: new Array("编码", "名称"),
                needKey: true,
                pages:parseInt(currentPage)
            });
            alert("新增成功");
            $("#cannelButton").trigger("click");
        }
    });
}

function objAdd(id, code, name) {
    obj.push({"id":id, "code": code, "name": name });
}

function updateCode(id, code, name) {
    var currentPage = $("#currentPage").val();
    $.ajax({
        type: "post",
        url: "updateCode.ashx",
        data: { "id": id, "code": code, "name": name },
        success: function () {
            updateObj(id, code, name);
            $("#tableArea").createTable(obj, {
                headName: new Array("编码", "名称"),
                needKey: true,
                pages: parseInt(currentPage)
            });
            alert("修改成功");
            $("#cannelEdit").trigger("click");
        }
    });
}

function updateObj(id, code, name) {
    for (var i = 0; i < obj.length; i++) {
        if (obj[i].id == id) {
            obj[i].name = name;
            obj[i].code = code;
            break;
        }
    }
}