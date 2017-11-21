window.addEventListener("load", Init, false);
var obj = [];
var tableNumber = 0;
var currentRows = 0;
var currentMainItem = "";
var radiosNum = 0;
var currentModel = "";

$(function () {
    $("#cycle").bind("change", function () {
        var cycle = $(this).find(":selected").val();
        $.ajax({
            type: "post",
            url: "../../pages/Root/getModel.ashx",
            data: { "cycle": cycle },
            success: function (data) {
                var jsonobj = $.parseJSON(data);
                var options = new Array();
                for (var i = 0; i < jsonobj.length; ++i) {
                    options.push("<option value=" + jsonobj[i].id + " >" + jsonobj[i].Name + "</option>");
                }
                $("#model").empty().append("<option value=''>--请选择模板--</option>").append(options.join(''));
            }
        });
    });
});

$(function () {
    $("#cycle").trigger("change");
});

function Init() {
    CreateEquipment();//创建设备选择下拉菜单
    //CreateTable("day");//创建日检表

    document.getElementById("sure").addEventListener("click", CreateCurrentTable, false);//根据条件生成表格按钮点击事件
    document.getElementById("fillTable").addEventListener("click", FillInTable, false);//修改表

    //翻页按钮点击事件
    var currentPage = document.getElementById("currentPage");//当前页数
    var sumPage = document.getElementById("sumPage");//总页数
    if (parseInt(currentPage.value) == (parseInt(sumPage.value) - 1)) {
        document.getElementById("nexrPage").className += " disabled";
        document.getElementById("lastPage").className += " disabled";
    } else {
        document.getElementById("nexrPage").addEventListener("click", transToNext, false);
        document.getElementById("lastPage").addEventListener("click", transToLast, false);
    }

    document.getElementById("cannel").addEventListener("click", cannelChange, false);//取消修改
    document.getElementById("sureFill").addEventListener("click", sureFill, false);//提交填写的表单
}

//根据条件创建表
function CreateCurrentTable(evt) {
    evt.preventDefault();

    document.getElementById("cannel").style.display = "none";
    document.getElementById("sureFill").style.display = "none";
    document.getElementById("fillTable").style.display = "block";

    var cycleSelect = document.getElementById("cycle");
    var index = cycleSelect.selectedIndex;

    var cycle = cycleSelect.options[index].value;//日、月、年
    var cycName = "";
    switch (cycle) {
        case "day":
            cycName = "日检表";
            break;
        case "month":
            cycName = "月检表";
            break;
        case "year":
            cycName = "年检表";
            break;
    }

    var models = $("#model :selected").val();
    if (models == "" || cycle == "") {
        return false;
    }

    document.getElementById("cycleTitle").innerHTML = cycName + "-" + $("#model :selected").text();

    currentModel = models;
    CreateTable(cycle, models);
    var currentPage = document.getElementById("currentPage");
    var sumPage = document.getElementById("sumPage");
    if (parseInt(currentPage.value) == (parseInt(sumPage.value) - 1)) {//只有一页时
        document.getElementById("nexrPage").className += " disabled";
        document.getElementById("lastPage").className += " disabled";
    } else {
        document.getElementById("nexrPage").addEventListener("click", transToNext, false);
        document.getElementById("lastPage").addEventListener("click", transToLast, false);
    }
}

//按检查周期选择创建表格
function CreateTable(cycle, model) {
    var tableArea = document.getElementById("tableArea");
    RemoveAllChild(tableArea);
    tableNumber = 0;
    var sumPage = document.getElementById("sumPage");
    sumPage.value = 0;
    //document.getElementById("currentPage").value = 0;
    currentRows = 0;
    currentMainItem = ""
    document.getElementById("firstPage").className += " disabled";
    document.getElementById("prePage").className += " disabled";
    document.getElementById("firstPage").removeEventListener("click", transToFirst, false);
    document.getElementById("prePage").removeEventListener("click", transToPre, false);

    GetCurrentInformation(cycle, model);
    for (var i = 0; i < obj.length; i++) {
        CreateByData(obj[i]);
    }
    if (parseInt(sumPage.value) > 1) {
        removeClass("disabled", document.getElementById("nexrPage"));
        removeClass("disabled", document.getElementById("lastPage"));
        document.getElementById("nexrPage").addEventListener("click", transToNext, false);
        document.getElementById("lastPage").addEventListener("click", transToLast, false);
    } else if (parseInt(sumPage.value) == 1 || parseInt(sumPage.value) == 0) {
        document.getElementById("nexrPage").removeEventListener("click", transToNext, false);
        document.getElementById("lastPage").removeEventListener("click", transToLast, false);
        if (document.getElementById("nexrPage").className.indexOf("disabled") == -1) {
            document.getElementById("nexrPage").className += " disabled";
        }
        if (document.getElementById("lastPage").className.indexOf("disabled") == -1) {
            document.getElementById("lastPage").className += " disabled";
        }
    }
}

//根据数据具体创建该表
function CreateByData(data) {
    var currentTable = document.getElementById("table" + tableNumber);
    if (currentTable == null || currentTable == undefined) {//没有这个table建立新表
        currentTable = CreateNewTable("table" + tableNumber);
    }
    if (currentRows >= 15) {
        currentTable = CreateNewTable("table" + (++tableNumber));
        currentMainItem = "";
        currentRows = 0;
    }
    ++currentRows;
    var ID = data.ID;
    var MainItem = data.MainItem;
    var ChildItem = data.ChildItem;
    var Explain = data.Explain;
    var Reference = data.Reference;
    var files = data.files;

    var ishas = false;

    var tbody = document.getElementById("body" + tableNumber);
    var tr = document.createElement("TR");
    tbody.appendChild(tr);
    if (MainItem != currentMainItem) {
        var MainItemTD = document.createElement("TD");
        MainItemTD.colSpan = 6;
        MainItemTD.style.textAlign = "left";
        MainItemTD.appendChild(document.createTextNode(MainItem));
        MainItemTD.className = "ItemName";
        tr.appendChild(MainItemTD);
        tr = document.createElement("TR");
        tbody.appendChild(tr);
        ++currentRows;
        currentMainItem = MainItem;
    }

    var Item = document.createElement("TD");
    Item.colSpan = "2";
    Item.className = "ItemName";
    Item.appendChild(document.createTextNode(ChildItem));
    var hidden = document.createElement("INPUT");
    hidden.type = "hidden";
    hidden.value = ID;
    Item.appendChild(hidden);
    tr.appendChild(Item);

    var exp = document.createElement("TD");
    exp.appendChild(document.createTextNode(Explain));
    if (files != null && files != "") {
        var alink = document.createElement("A");
        alink.appendChild(document.createTextNode("说明文件"));
        alink.href = files;
        alink.target = "_blank";
        exp.appendChild(document.createElement("BR"));
        exp.appendChild(alink);
    }
    tr.appendChild(exp);

    var tdUIMRTRef = document.createElement("TD");
    if (Reference == "NA") {
        tdUIMRTRef.appendChild(document.createTextNode("NA"));
    } else if (Reference == "IsOK") {
        tdUIMRTRef.appendChild(document.createTextNode("功能正常"));
    } else {
        tdUIMRTRef.appendChild(document.createTextNode(Reference));
    }
    tr.appendChild(tdUIMRTRef);

    var tdValue = document.createElement("TD");
    tdValue.className = "fillValue";
    tr.appendChild(tdValue);

    var functionState = document.createElement("TD");
    functionState.className = "functionState";
    tr.appendChild(functionState);
}

//创建一个带有表头的新表
function CreateNewTable(tid) {
    var tableArea = document.getElementById("tableArea");
    var table = document.createElement("TABLE");
    table.id = tid;
    table.className = "table table-bordered table-center table-hover";
    if (tid.substring(5) != "0") {
        table.style.display = "none";
    }
    var thead = document.createElement("THEAD");
    var tr = document.createElement("TR");
    var name = document.createElement("TH");
    name.colSpan = "2";
    name.appendChild(document.createTextNode("检查项目名"));
    tr.appendChild(name);

    var thUIMRTRef = document.createElement("TH");
    thUIMRTRef.appendChild(document.createTextNode("说明"));
    tr.appendChild(thUIMRTRef);
    var thUIMRTError = document.createElement("TH");
    thUIMRTError.appendChild(document.createTextNode("参考值"));
    tr.appendChild(thUIMRTError);

    var value = document.createElement("TH");
    value.appendChild(document.createTextNode("实际值"));
    tr.appendChild(value);

    var functionState = document.createElement("TH");
    functionState.appendChild(document.createTextNode("功能状态"));
    tr.appendChild(functionState);

    var tbody = document.createElement("TBODY");
    tbody.id = "body" + tableNumber;

    thead.appendChild(tr);
    table.appendChild(thead);
    table.appendChild(tbody);

    tableArea.appendChild(table);
    var sumPage = document.getElementById("sumPage");
    sumPage.value = parseInt(sumPage.value) + 1;
    return table;
}

//移除所有子节点
function RemoveAllChild(area) {
    while (area.hasChildNodes()) {
        var child = tableArea.firstChild;
        if (child != null && child != undefined)
            area.removeChild(child);
    }
}

//获取数据库设备检查表数据
function GetCurrentInformation(cycle, model) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/GetInspection.ashx?cycle=" + cycle + "&model=" + model;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var json = xmlHttp.responseText;
    if (json == "]") {
        obj = [];
        return;
    }
    obj = eval("(" + json + ")");
}

function removeClass(rClass, thisElement) {
    var classNames = thisElement.className.split(" ");
    var rClassName = "";
    for (var i = 0; i < classNames.length; i++) {
        if (classNames[i] != rClass) {
            rClassName += classNames[i] + " ";
        }
    }
    thisElement.className = rClassName;
}

//到首页
function transToFirst(evt) {
    var currentPage = document.getElementById("currentPage");
    var sumPage = document.getElementById("sumPage");
    evt.preventDefault();
    var current = document.getElementById("table" + currentPage.value);
    current.style.display = "none";
    currentPage.value = "0";

    document.getElementById("table0").style.display = "table";
    document.getElementById("firstPage").className += " disabled";
    document.getElementById("firstPage").removeEventListener("click", transToFirst, false);
    document.getElementById("prePage").removeEventListener("click", transToPre, false);

    document.getElementById("prePage").className += " disabled";
    if (parseInt(currentPage.value) < (parseInt(sumPage.value) - 1)) {
        removeClass("disabled", document.getElementById("nexrPage"));
        removeClass("disabled", document.getElementById("lastPage"));
        document.getElementById("nexrPage").addEventListener("click", transToNext, false);
        document.getElementById("lastPage").addEventListener("click", transToLast, false);
    }
}

function transToPre(evt) {
    var currentPage = document.getElementById("currentPage");
    var sumPage = document.getElementById("sumPage");
    evt.preventDefault();
    var current = document.getElementById("table" + currentPage.value);
    current.style.display = "none";
    currentPage.value = parseInt(currentPage.value - 1);
    document.getElementById("table" + currentPage.value).style.display = "table";
    if (currentPage.value == "0") {
        document.getElementById("firstPage").className += " disabled";
        document.getElementById("prePage").className += " disabled";
        document.getElementById("firstPage").removeEventListener("click", transToFirst, false);
        document.getElementById("prePage").removeEventListener("click", transToPre, false);
    }
    if (parseInt(currentPage.value) < parseInt(sumPage.value - 1)) {
        removeClass("disabled", document.getElementById("nexrPage"));
        removeClass("disabled", document.getElementById("lastPage"));
        document.getElementById("nexrPage").addEventListener("click", transToNext, false);
        document.getElementById("lastPage").addEventListener("click", transToLast, false);
    }
}

function transToNext(evt) {
    var currentPage = document.getElementById("currentPage");
    var sumPage = document.getElementById("sumPage");
    evt.preventDefault();
    var current = document.getElementById("table" + currentPage.value);
    current.style.display = "none";
    currentPage.value = parseInt(currentPage.value + 1);
    document.getElementById("table" + currentPage.value).style.display = "table";
    if (parseInt(currentPage.value) == (parseInt(sumPage.value) - 1)) {
        document.getElementById("nexrPage").className += " disabled";
        document.getElementById("lastPage").className += " disabled";
        document.getElementById("nexrPage").removeEventListener("click", transToNext, false);
        document.getElementById("lastPage").removeEventListener("click", transToLast, false);
    }
    removeClass("disabled", document.getElementById("firstPage"));
    removeClass("disabled", document.getElementById("prePage"));
    document.getElementById("firstPage").addEventListener("click", transToFirst, false);
    document.getElementById("prePage").addEventListener("click", transToPre, false);
}

function transToLast(evt) {
    var currentPage = document.getElementById("currentPage");
    var sumPage = document.getElementById("sumPage");
    evt.preventDefault();
    var current = document.getElementById("table" + currentPage.value);
    current.style.display = "none";
    var last = parseInt(sumPage.value) - 1;
    currentPage.value = last;
    document.getElementById("table" + last).style.display = "table";
    document.getElementById("nexrPage").className += " disabled";
    document.getElementById("lastPage").className += " disabled";
    document.getElementById("nexrPage").removeEventListener("click", transToNext, false);
    document.getElementById("lastPage").removeEventListener("click", transToLast, false);
    removeClass("disabled", document.getElementById("firstPage"));
    removeClass("disabled", document.getElementById("prePage"));
    document.getElementById("firstPage").addEventListener("click", transToFirst, false);
    document.getElementById("prePage").addEventListener("click", transToPre, false);
}

function FillInTable(evt) {
    evt.preventDefault();
    var selected = document.getElementById("equipment");

    this.style.display = "none";
    document.getElementById("cannel").style.display = "block";
    document.getElementById("sureFill").style.display = "block";
    document.getElementById("chooseFunctionState").style.display = "block";
    selected.className += " disableInput";
    selected.disabled = true;

    var allTD = document.getElementById("tableArea").getElementsByTagName("TD");
    for (var i = 0; i < allTD.length; ++i) {
        switch (allTD[i].className) {
            case "fillValue":
                if (allTD[i - 1].innerText == "NA" || allTD[i - 1].innerText == "功能正常")
                    break;
                var inputText = document.createElement("INPUT");
                inputText.type = "text";
                inputText.className = "fillText checkEmpty form-control";
                //inputText.addEventListener("blur", checkContent, false);
                allTD[i].appendChild(inputText);
                break;
            case "functionState":
                var radio0 = document.createElement("INPUT");
                var radio1 = document.createElement("INPUT");
                radio0.name = "radioList" + radiosNum;
                radio0.type = "radio";
                radio1.name = "radioList" + radiosNum;
                radio1.type = "radio";
                ++radiosNum;
                var label1 = document.createElement("LABEL");
                label1.appendChild(radio0);
                label1.appendChild(document.createTextNode("正常"));
                var label2 = document.createElement("LABEL");
                label2.appendChild(radio1);
                label2.appendChild(document.createTextNode("不正常"));
                allTD[i].appendChild(label1);
                allTD[i].appendChild(label2);
                break;
        }
    }
}

function cannelChange(evt) {
    evt.preventDefault();
    reupdate();
}

//重构界面
function reupdate() {
    document.getElementById("cannel").style.display = "none";
    document.getElementById("sureFill").style.display = "none";
    document.getElementById("chooseFunctionState").style.display = "none";
    document.getElementById("fillTable").style.display = "block";
    removeClass("disableInput", document.getElementById("equipment"));
    document.getElementById("equipment").disabled = false;

    var radio = document.getElementsByName("functionStateRadio");
    for (var i = 0; i < radio.length; i++) {
        radio[i].checked = false;
    }

    var title = document.getElementById("cycleTitle").innerHTML;
    var cycName;

    switch (title.substring(0, 3)) {
        case "日检表":
            cycName = "day";
            break;
        case "月检表":
            cycName = "month";
            break;
        case "年检表":
            cycName = "year";
            break;
    }
    CreateTable(cycName, currentModel);
}

function sureFill(evt) {
    evt.preventDefault();
    var choosed = false;
    var radio = document.getElementsByName("functionStateRadio");
    for (var i = 0; i < radio.length; i++) {
        choosed |= radio[i].checked;
    }
    if (!choosed) {
        alert("请选择功能状态");
        return;
    }
    if (!checkTable()) {
        var con = confirm("有未填项，是否继续提交");
        if (con == false)
            return;
    }
    var obj = [];
    var content = { "ID": "", "RealValue": "", "FunctionalStatus": "" };
    var allTr = document.getElementById("tableArea").getElementsByTagName("TR");
    for (var i = 0; i < allTr.length; ++i) {
        if (allTr[i].firstChild.getElementsByTagName("INPUT")[0] != undefined) {
            var tds = allTr[i].getElementsByTagName("TD");
            content.ID = tds[0].getElementsByTagName("INPUT")[0].value;
            var radios = tds[4].getElementsByTagName("INPUT");
            if (radios[0].checked == true) {
                content.FunctionalStatus = 1;
            } else if (radios[1].checked == true) {
                content.FunctionalStatus = 0;
            } else {
                content.FunctionalStatus = -1;
            }
            if (tds[2].innerHTML != "NA" && tds[2].innerHTML != "功能正常") {
                content.RealValue = tds[3].firstChild.value;
            } else if (tds[2].innerHTML == "NA") {
                content.RealValue = "NA";
            } else if (tds[2].innerHTML == "功能正常") {
                content.RealValue = (content.FunctionalStatus == -1 ? "" : statusToChinese(content.FunctionalStatus));
            }

            obj.push(content);
            content = { "ID": "", "RealValue": "", "FunctionalStatus": "" };
        }
    }

    var jsonStr = toJsonString(obj);
    postDate(jsonStr);
    alert("提交成功");
    reupdate();
}

function statusToChinese(status) {
    if (status == "0") {
        return "不正常";
    } else if (status == "1") {
        return "正常";
    }
}

function checkTable() {
    var isallGood = true;
    var allInput = document.getElementById("tableArea").getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].type == "text" && allInput[i].className.indexOf("checkEmpty") > -1) {
            if (allInput[i].value == "") {
                allInput[i].className += " invalid";
                isallGood = false;
            } else {
                removeClass("invalid", allInput[i]);
            }
        }
    }

    return isallGood;
}

function checkContent(evt) {
    removeClass("invalid", this);
    var value = this.value;
    if (value == "NA" || value == "功能正常")
        return;
    var rep = /(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1})) ?(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1}))? ?(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1}))? *$/g;
    if (!rep.test(value)) {
        this.className += " invalid";
        return false;
    }
    rep.exec(value);
    var newValue = "";
    newValue += RegExp.$1 + " ";
    if (RegExp.$4 != "") {
        newValue += RegExp.$4 + " ";
    }
    if (RegExp.$7 != "") {
        newValue += RegExp.$7;
    }
    this.value = newValue;
}

//将json对象转为json字符串
function toJsonString(jsonObject) {
    var str = '[';
    for (var i = 0; i < jsonObject.length; i++) {
        str += "{"
        for (obj in jsonObject[i]) {
            str += "\"" + obj + "\":\"" + jsonObject[i][obj] + "\",";
        }
        str = str.substring(0, str.length - 1);
        str += "}";
        if (i < (jsonObject.length - 1)) {
            str += ",";
        }
    }
    str += "]";
    return str;
}

function postDate(jsonStr) {
    var title = document.getElementById("cycleTitle").innerHTML;
    var cycName;

    switch (title.substring(0, 3)) {
        case "日检表":
            cycName = "day";
            break;
        case "月检表":
            cycName = "month";
            break;
        case "年检表":
            cycName = "year";
            break;
    }

    var select = document.getElementById("equipment");
    var index = select.selectedIndex;
    var equipmentID = select.options[index].value;

    var radio = document.getElementsByName("functionStateRadio");
    var choosed;
    for (var i = 0; i < radio.length; i++) {
        if (radio[i].checked) {
            choosed = radio[i].value;
        }
    }

    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/RecordEquipmentCheck.ashx";
    xmlHttp.open("POST", url, true);
    xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var content = "date=" + jsonStr + "&cycle=" + cycName + "&equipment=" + equipmentID + "&functionState=" + choosed + "&model=" + currentModel;
    xmlHttp.send(content);
}

function CreateEquipment() {
    var select = document.getElementById("equipment");
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Main/GetSessionEquipment.ashx";
    xmlHttp.open("GET", url, true);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var json = xmlHttp.responseText;
            var obj = eval("(" + json + ")");
            if (obj.ID == "null") {
                return;
            }
            
            select.options[0] = new Option(obj.Name);
            select.options[0].value = obj.ID;
            
        }
    };
    xmlHttp.send();
}