window.addEventListener("load", Init, false);
var obj = [];
var tableNumber = 0;
var currentRows = 0;
var currentMainItem = "";
var deleteID = "";
var isAllGood = true;

function Init() {
    CreateTable("day");//创建日检表

    document.getElementById("sure").addEventListener("click", CreateCurrentTable, false);//根据条件生成表格按钮点击事件
    document.getElementById("changeTable").addEventListener("click", toChangeTable, false);//修改表

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
    document.getElementById("sureChange").addEventListener("click", sureChange, false);//确定修改
    document.getElementById("addItem").addEventListener("click", addItem, false);//新增检查项
    //document.getElementById("addCannel").addEventListener("click", addCannel, false);
    //根据新增中的下拉菜单选项改变对应输入框状态
    document.getElementById("UIMRTUnit").addEventListener("change", changeInput, false);
    document.getElementById("IMRTUnit").addEventListener("change", changeInput, false);
    document.getElementById("SRSUnit").addEventListener("change", changeInput, false);

    document.getElementById("addItemFrm").addEventListener("reset", addCannel, false);
    document.getElementById("submitAdd").addEventListener("click", addNewItem, false);

    document.getElementById("UIMRTReference").addEventListener("blur", changeValue, false);
    document.getElementById("UIMRTError").addEventListener("blur", changeValue, false);
    document.getElementById("IMRTReference").addEventListener("blur", changeValue, false);
    document.getElementById("IMRTError").addEventListener("blur", changeValue, false);
    document.getElementById("SRSReference").addEventListener("blur", changeValue, false);
    document.getElementById("SRSError").addEventListener("blur", changeValue, false);

    document.getElementById("MainItemSelect").addEventListener("change", showNewInput, false);//新建中主项目名选择
}

//根据条件创建表
function CreateCurrentTable(evt) {
    evt.preventDefault();

    document.getElementById("cannel").style.display = "none";
    document.getElementById("sureChange").style.display = "none";
    document.getElementById("changeTable").style.display = "block";

    var cycleSelect = document.getElementById("cycle");
    var index = cycleSelect.selectedIndex;
    if (index == 0) {
        return;
    }
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
    document.getElementById("cycleTitle").innerHTML = cycName;
    CreateTable(cycle);
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
function CreateTable(cycle) {
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

    GetCurrentInformation(cycle);
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
    var UIMRTReference = data.UIMRTReference;
    var UIMRTError = data.UIMRTError;
    var UIMRTUnit = data.UIMRTUnit;
    var IMRTReference = data.IMRTReference;
    var IMRTError = data.IMRTError;
    var IMRTUnit = data.IMRTUnit;
    var SRSReference = data.SRSReference;
    var SRSError = data.SRSError;
    var SRSUnit = data.SRSUnit;
    var ishas = false;

    var tbody = document.getElementById("body" + tableNumber);
    var tr = document.createElement("TR");
    tbody.appendChild(tr);
    if (MainItem != currentMainItem) {
        var MainItemTD = document.createElement("TD");
        MainItemTD.colSpan = 8;
        MainItemTD.style.textAlign = "left";
        MainItemTD.appendChild(document.createTextNode(MainItem));
        MainItemTD.className = "ItemName";
        tr.appendChild(MainItemTD);
        tr = document.createElement("TR");
        tbody.appendChild(tr);;
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
    var tdUIMRTRef = document.createElement("TD");
    if (UIMRTUnit == "NA") {
        tdUIMRTRef.appendChild(document.createTextNode("NA"));
    } else if (UIMRTUnit == "IsOK") {
        tdUIMRTRef.appendChild(document.createTextNode("功能是否正常"));
    } else {
        tdUIMRTRef.appendChild(document.createTextNode(UIMRTReference));
    }
    tr.appendChild(tdUIMRTRef);

    var tdUIMRTError = document.createElement("TD");
    if (UIMRTUnit == "NA") {
        tdUIMRTError.appendChild(document.createTextNode("NA"));
    } else if (UIMRTUnit == "IsOK") {
        tdUIMRTError.appendChild(document.createTextNode("功能是否正常"));
    } else {
        tdUIMRTError.appendChild(document.createTextNode(UIMRTError));
    }
    tr.appendChild(tdUIMRTError);

    var tdIMRTRef = document.createElement("TD");
    if (IMRTUnit == "NA") {
        tdIMRTRef.appendChild(document.createTextNode("NA"));
    } else if (IMRTUnit == "IsOK") {
        tdIMRTRef.appendChild(document.createTextNode("功能是否正常"));
    } else {
        tdIMRTRef.appendChild(document.createTextNode(IMRTReference));
    }
    tr.appendChild(tdIMRTRef);

    var tdIMRTError = document.createElement("TD");
    if (IMRTUnit == "NA") {
        tdIMRTError.appendChild(document.createTextNode("NA"));
    } else if (IMRTUnit == "IsOK") {
        tdIMRTError.appendChild(document.createTextNode("功能是否正常"));
    } else {
        tdIMRTError.appendChild(document.createTextNode(IMRTError));
    }
    tr.appendChild(tdIMRTError);

    var tdSRSRef = document.createElement("TD");
    if (SRSUnit == "NA") {
        tdSRSRef.appendChild(document.createTextNode("NA"));
    } else if (SRSUnit == "IsOK") {
        tdSRSRef.appendChild(document.createTextNode("功能是否正常"));
    } else {
        tdSRSRef.appendChild(document.createTextNode(SRSReference));
    }
    tr.appendChild(tdSRSRef);

    var tdSRSError = document.createElement("TD");
    if (SRSUnit == "NA") {
        tdSRSError.appendChild(document.createTextNode("NA"));
    } else if (SRSUnit == "IsOK") {
        tdSRSError.appendChild(document.createTextNode("功能是否正常"));
    } else {
        tdSRSError.appendChild(document.createTextNode(SRSError));
    }
    tr.appendChild(tdSRSError);
}

function findMainItem(now) {
    var allTD = document.getElementById("tableArea").getElementsByTagName("TD");
    for (var i = 0; i < allTD.length; i++) {
        if (allTD[i].className == "ItemName") {
            if (now == allTD[i].firstChild.nodeValue) {
                return allTD[i].parentNode;
            }
        }
    }
    return null;
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
    thUIMRTRef.appendChild(document.createTextNode("无调强参考值"));
    tr.appendChild(thUIMRTRef);
    var thUIMRTError = document.createElement("TH");
    thUIMRTError.appendChild(document.createTextNode("无调强误差值"));
    tr.appendChild(thUIMRTError);
    var thIMRTRef = document.createElement("TH");
    thIMRTRef.appendChild(document.createTextNode("调强参考值"));
    tr.appendChild(thIMRTRef);
    var thIMRTError = document.createElement("TH");
    thIMRTError.appendChild(document.createTextNode("调强误差值"));
    tr.appendChild(thIMRTError);
    var thSRSRef = document.createElement("TH");
    thSRSRef.appendChild(document.createTextNode("SRS/SBRT参考值"));
    tr.appendChild(thSRSRef);
    var thSRSError = document.createElement("TH");
    thSRSError.appendChild(document.createTextNode("SRS/SBRT误差值"));
    tr.appendChild(thSRSError);
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
function GetCurrentInformation(cycle) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/GetInspection.ashx?cycle=" + cycle;
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var json = xmlHttp.responseText;
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

//修改表按钮事件
function toChangeTable(evt) {
    evt.preventDefault();
    document.getElementById("cannel").style.display = "block";
    document.getElementById("sureChange").style.display = "block";
    this.style.display = "none";
    document.getElementById("addItem").style.display = "none";
    deleteID = "";
    var allTd = document.getElementsByTagName("TD");
    for (var i = 0; i < allTd.length; i++) {
        if (allTd[i].className != "ItemName" && (allTd[i].parentNode.parentNode.parentNode.parentNode.id != undefined && allTd[i].parentNode.parentNode.parentNode.parentNode.id != "addItemFrm")) {
            var inner = allTd[i].innerHTML;
            allTd[i].removeChild(allTd[i].firstChild);
            allTd[i].appendChild(CreateChangeDiv(inner));
        }
    }
    var allTr = document.getElementsByTagName("TR");
    for (var i = 0; i < allTr.length; i++) {
        if (allTr[i].getElementsByTagName("TD").length > 1) {
            CreateDeleteButton(allTr[i]);//创建删除按钮
        }
    }
}

function CreateDeleteButton(Tr) {
    var td = document.createElement("TD");
    var button = document.createElement("INPUT");
    button.type = "button";
    button.value = "删除";
    button.className = "btn btn-danger btn-xs";
    button.addEventListener("click", DeleteItem, false);
    td.appendChild(button);
    Tr.appendChild(td);
}

//删除检查项
function DeleteItem(evt) {
    evt.preventDefault();
    var id = this.parentNode.parentNode.getElementsByTagName("INPUT")[0].value;
    var tr = this.parentNode.parentNode;
    var tbody = tr.parentNode;
    tbody.removeChild(tr);
    deleteID += id + " ";
}

function CreateChangeDiv(text) {
    var div = document.createElement("DIV");
    div.className = "input-group col-sm-12";
    div.style.width = "160px";

    var textInput = document.createElement("INPUT");
    textInput.type = text;
    textInput.className = "inputText";
    textInput.value = text;
    textInput.addEventListener("blur", checkContent, false);//检查填写对象
    textInput.style.width = "100px";
    if (text == "NA" || text == "功能是否正常") {
        textInput.readOnly = true;
        textInput.className += " disableInput";
    }
    div.appendChild(textInput);

    var span = document.createElement("SPAN");
    span.className = "input-group-addon addSpan";
    span.style.paddingBottom = "2px";
    span.style.paddingTop = "2px";

    var select = document.createElement("SELECT");
    select.style.width = "60px";
    select.options[0] = new Option("NA");
    select.options[0].value = "NA";
    select.options[1] = new Option("功能正常");
    select.options[1].value = "IsOK";
    select.options[2] = new Option("填写数值");
    select.options[2].value = "write";
    select.addEventListener("change", checkSelected, false);
    switch (text) {
        case "NA":
            select.selectedIndex = 0;
            break;
        case "功能是否正常":
            select.selectedIndex = 1;
            break;
        default:
            select.selectedIndex = 2;
    }
    span.appendChild(select);

    div.appendChild(span);

    return div;
}

function checkSelected(evt) {
    var selectedIndex = this.selectedIndex;
    var parent = this.parentNode.parentNode;
    var input = parent.getElementsByTagName("INPUT")[0];
    switch (selectedIndex) {
        case 0:
            if (input.className.indexOf("disableInput") == -1) {
                input.className += " disableInput";
                input.readOnly = true;
            }
            input.value = "NA";
            break;
        case 1:
            if (input.className.indexOf("disableInput") == -1) {
                input.className += " disableInput";
                input.readOnly = true;
            }
            input.value = "功能是否正常";
            break;
        case 2:
            if (input.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", input);
                input.readOnly = false;
            }
            var v = input.value;
            if (v == "NA" || v == "功能是否正常")
                input.value = "";
            break;
    }
}

function cannelChange(evt) {
    evt.preventDefault();
    reupdate();
}

//重构界面
function reupdate() {
    document.getElementById("cannel").style.display = "none";
    document.getElementById("sureChange").style.display = "none";
    document.getElementById("changeTable").style.display = "block";
    document.getElementById("addItem").style.display = "block";

    var title = document.getElementById("cycleTitle").innerHTML;
    var cycName;

    switch (title) {
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
    CreateTable(cycName);
}

function sureChange(evt) {
    var update = [];
    var allTD = document.getElementById("tableArea").getElementsByTagName("TD");
    var currentItem = { "ID": "", "UIMRTReference": "", "UIMRTError": "", "IMRTReference":"", "IMRTError":"","SRSReference":"","SRSError":"" };
    var count = 0;
    var select = null;
    var selectValue = "";
    var input = null;
    var inputValue = "";
    for (var i = 0; i < allTD.length; i++) {
        if (allTD[i].className == "ItemName" && allTD[i].getElementsByTagName("INPUT")[0] != null) {//取出当前检查项目ID
            currentItem = { "ID": "", "UIMRTReference": "", "UIMRTError": "", "IMRTReference": "", "IMRTError": "", "SRSReference": "", "SRSError": "" };
            currentItem.ID = allTD[i].getElementsByTagName("INPUT")[0].value;
            count = 1;
            continue;
        }
        if (count >= 1 && count <= 6) {
            select = allTD[i].getElementsByTagName("SELECT")[0];
            if (select.selectedIndex == 0)
                selectValue = "NA";
            else if (select.selectedIndex == 1) {
                selectValue = "IsOK";
            } else {
                selectValue = "write";
                input = allTD[i].getElementsByTagName("INPUT")[0];
                if (input.className.indexOf("invalid") > -1) {
                    alert("有项目填写不正确");
                    input.focus();
                    return false;
                }
                inputValue = input.value;
            }
        }
        switch (count) {
            case 1:                
                if (selectValue != "write") {
                    currentItem.UIMRTReference = selectValue;
                } else {
                    currentItem.UIMRTReference = inputValue;
                }
                ++count;
                break;
            case 2:
                if (selectValue != "write") {
                    currentItem.UIMRTError = selectValue;
                } else {
                    currentItem.UIMRTError = inputValue;
                }
                ++count;
                break;
            case 3:
                if (selectValue != "write") {
                    currentItem.IMRTReference = selectValue;
                } else {
                    currentItem.IMRTReference = inputValue;
                }
                ++count;
                break;
            case 4:
                if (selectValue != "write") {
                    currentItem.IMRTError = selectValue;
                } else {
                    currentItem.IMRTError = inputValue;
                }
                ++count;
                break;
            case 5:
                if (selectValue != "write") {
                    currentItem.SRSReference = selectValue;
                } else {
                    currentItem.SRSReference = inputValue;
                }
                ++count;
                break;
            case 6:
                if (selectValue != "write") {
                    currentItem.SRSError = selectValue;
                } else {
                    currentItem.SRSError = inputValue;
                }
                update.push(currentItem);
                ++count;
                break;
        }
    }
    var jsonStr = toJsonString(update);
    postData(jsonStr);
    SureDelete();
    alert("更改成功");
    reupdate();
}

function SureDelete() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/DeleteItem.ashx";
    xmlHttp.open("POST", url, true);
    xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    xmlHttp.onreadystatechange = function () { };
    var content = "id=" + deleteID;
    xmlHttp.send(content);
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

function postData(str) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/UpdateInspection.ashx";
    xmlHttp.open("POST", url, false);
    xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var content = "date=" + str;
    xmlHttp.send(content);
}

function checkContent(evt) {
    removeClass("invalid",this);
    var value = this.value;
    if (value == "NA" || value == "功能是否正常")
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

//点击新建按钮事件
function addItem(evt) {
    evt.preventDefault();
    document.getElementById("middleArea").style.display = "block";
    document.getElementById("topArea").style.display = "block";
    CreateMainItemSelect();
}

function addCannel(evt) {
    clearAddTable();
    return true;
}

//重置新增表格
function clearAddTable() {
    document.getElementById("middleArea").style.display = "none";
    document.getElementById("topArea").style.display = "none";
    var input = document.getElementById("addItemFrm").getElementsByTagName("INPUT");
    for (var i = 0; i < input.length; i++) {
        if (input[i].type == "text") {
            input[i].readOnly = false;
            input[i].value = "";
            removeClass("disableInput", input[i]);
            removeClass("invalid", input[i]);
        }
    }
    document.getElementById("error").innerHTML = "";
    document.getElementById("MainItem").style.display = "none";
}

function changeInput(evt) {
    var selected = this.selectedIndex;
    switch (this.id) {
        case "UIMRTUnit":
            changeInputContent(selected, "UIMRT");
            break;
        case "IMRTUnit":
            changeInputContent(selected, "IMRT");
            break;
        case "SRSUnit":
            changeInputContent(selected, "SRS");
    }
}

//根据下拉菜单选项改变输入框
function changeInputContent(selected, name) {
    switch (selected) {
        case 0:
            var ref = document.getElementById(name+"Reference");
            var err = document.getElementById(name+"Error");
            if (ref.className.indexOf("disableInput") == -1) {
                ref.className += " disableInput";
            }
            ref.value = "NA";
            ref.readOnly = true;
            if (err.className.indexOf("disableInput") == -1) {
                err.className += " disableInput";
            }
            err.value = "NA";
            err.readOnly = true;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
            break;
        case 1:
            var ref = document.getElementById(name+"Reference");
            var err = document.getElementById(name+"Error");
            if (ref.className.indexOf("disableInput") == -1) {
                ref.className += " disableInput";
            }
            ref.value = "功能正常";
            ref.readOnly = true;
            if (err.className.indexOf("disableInput") == -1) {
                err.className += " disableInput";
            }
            err.value = "功能正常";
            err.readOnly = true;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
            break;
        case 2:
            var ref = document.getElementById(name+"Reference");
            var err = document.getElementById(name+"Error");
            if (ref.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", ref);
            }
            ref.value = "";
            ref.readOnly = false;
            if (err.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", err);
            }
            err.value = "";
            err.readOnly = false;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
            break;
    }
}

function addNewItem(evt) {
    evt.preventDefault();
    if (!checkForm()) {
        return;
    }
    var jsonObj = [];
    var date = { "MainItem": "", "ChildItem": "", "UIMRTReference": "", "UIMRTError": "", "UIMRTUnit": "", "IMRTReference": "", "IMRTError": "", "IMRTUnit": "", "SRSReference": "", "SRSError": "", "SRSUnit": "", "Cycle": ""};
    var form = document.getElementById("addItemFrm");
    var Item = document.getElementById("MainItem").value;
    if (Item == "") {
        var select = document.getElementById("MainItemSelect");
        index = select.selectedIndex;
        Item = select.options[index].value;
    }
    date.MainItem = Item;
    var childItem = document.getElementById("childItem").value;
    date.ChildItem = childItem;
    var inputValue = "";
    var select = form.getElementsByTagName("SELECT");
    for (var i = 0; i < select.length; i++) {
        switch (select[i].id) {
            case "UIMRTUnit":
                switch (select[i].selectedIndex) {
                    case 0:
                        date.UIMRTUnit = "NA";
                        date.UIMRTError = "NA";
                        date.UIMRTReference = "NA";
                        break;
                    case 1:
                        date.UIMRTUnit = "IsOK";
                        date.UIMRTError = "IsOK";
                        date.UIMRTReference = "IsOK";
                        break;
                    case 2:
                        date.UIMRTUnit = "write";
                        date.UIMRTError = document.getElementById("UIMRTError").value;
                        date.UIMRTReference = document.getElementById("UIMRTReference").value;
                        break;
                }
                break;
            case "IMRTUnit":
                switch (select[i].selectedIndex) {
                    case 0:
                        date.IMRTUnit = "NA";
                        date.IMRTError = "NA";
                        date.IMRTReference = "NA";
                        break;
                    case 1:
                        date.IMRTUnit = "IsOK";
                        date.IMRTError = "IsOK";
                        date.IMRTReference = "IsOK";
                        break;
                    case 2:
                        date.IMRTUnit = "write";
                        date.IMRTError = document.getElementById("IMRTError").value;
                        date.IMRTReference = document.getElementById("IMRTReference").value;
                        break;
                }
                break;
            case "SRSUnit":
                switch (select[i].selectedIndex) {
                    case 0:
                        date.SRSUnit = "NA";
                        date.SRSError = "NA";
                        date.SRSReference = "NA";
                        break;
                    case 1:
                        date.SRSUnit = "IsOK";
                        date.SRSError = "IsOK";
                        date.SRSReference = "IsOK";
                        break;
                    case 2:
                        date.SRSUnit = "write";
                        date.SRSError = document.getElementById("SRSError").value;
                        date.SRSReference = document.getElementById("SRSReference").value;
                        break;
                }
                break;
        }
    }
    var cycle = document.getElementById("addCycle");
    var cycIndex = cycle.selectedIndex;
    date.Cycle = cycle.options[cycIndex].value;
    jsonObj.push(date);
    var jsonStr = toJsonString(jsonObj);
    postAddDate(jsonStr);
    alert("新增成功");
    reupdate();
    document.getElementById("addItemFrm").reset();
}

function postAddDate(jsonStr) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/AddnewItem.ashx";
    xmlHttp.open("POST", url, false);
    xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var content = "date=" + jsonStr;
    xmlHttp.send(content);
}

function checkForm() {
    isAllGood = true;
    document.getElementById("error").innerHTML = "";
    var form = document.getElementById("addItemFrm");
    var allTag = form.getElementsByTagName("*");
    for (var i = 0; i < allTag.length; i++) {
        if(!checkElement(allTag[i])){
            isAllGood = false;
        }
    }
    return isAllGood;
}

function checkElement(element) {
    var className = element.className.split(" ");
    var rclassName = "";
    for (var i = 0; i < className.length; i++) {
        rclassName += checkClassName(className[i], element) + " ";
    }
    element.className = rclassName;
    if (rclassName.indexOf("invalid") > -1) {
        element.focus();
        var error = document.getElementById("error");
        switch (element.id) {
            case "MainItem":
                error.innerHTML = "所属项目不能为空";
                break;
            case "childItem":
                error.innerHTML = "项目名不能为空";
                break;
            case "UIMRTReference":
                error.innerHTML = "无调强参考值不正确";
                break;
            case "UIMRTError":
                error.innerHTML = "无调强误差值不正确";
                break;
            case "IMRTReference":
                error.innerHTML = "调强参考值不正确";
                break;
            case "IMRTError":
                error.innerHTML = "调强误差值不正确";
                break;
            case "SRSReference":
                error.innerHTML = "SRS/SBRT参考值不正确";
                break;
            case "SRSError":
                error.innerHTML = "SRS/SBRT误差值不正确";
                break;
        }
        return false;
    }
    return true;
}

function checkClassName(name, element) {
    var backString = "";
    switch (name) {
        case "":
        case "invalid":
            break;
        case "IsEmpty":
            if (isAllGood && element.value == "") {
                backString += "invalid ";
            }
            backString += name;
            break;
        case "rightValue":
            if (isAllGood && !checkValue(element.value)) {
                backString += "invalid ";
            }
            backString += name;
            break;
        case "MainItemSelect":
            if(isAllGood && !checkSelectSelf(element,name)){
                backString += "invalid ";
            }
            backString += name;
            break;
        default:
            backString += name;
    }
    return backString;
}

function checkSelectSelf(element, name) {
    var select = document.getElementById(name);
    if (element.value == "" && (select.selectedIndex == (select.options.length - 1))) {
        return false;
    }
    return true;
}

function checkValue(val) {
    var rep = /(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1})) ?(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1}))? ?(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1}))? *$/g;
    if (!rep.test(val) && val != "NA" && val != "功能正常") {
        return false;
    } else {
        return true;
    }
}

function changeValue(evt) {
    removeClass("invalid", this);
    var error = document.getElementById("error");
    error.innerHTML = "";
    var val = this.value;
    var rep = /(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1})) ?(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1}))? ?(\d{1,3}(\.\d{1,3})?\s*([a-z]{1,5}|%{1}|°{1}))? *$/g;
    if (!rep.test(val) && val != "NA" && val != "功能正常") {
        this.className += " invalid";
        switch (this.id) {
            case "UIMRTReference":
                error.innerHTML = "无调强参考值不正确";
                break;
            case "UIMRTError":
                error.innerHTML = "无调强误差值不正确";
                break;
            case "IMRTReference":
                error.innerHTML = "调强参考值不正确";
                break;
            case "IMRTError":
                error.innerHTML = "调强误差值不正确";
                break;
            case "SRSReference":
                error.innerHTML = "SRS/SBRT参考值不正确";
                break;
            case "SRSError":
                error.innerHTML = "SRS/SBRT误差值不正确";
                break;
        }
        return;
    }
    if (val == "NA" || val == "功能正常") {
        return;
    }
    rep.exec(val);
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

function CreateMainItemSelect(evt){
    var select = document.getElementById("MainItemSelect");
    select.options.length = 0;
    var obj = GetMainItem();
    if (obj[0].MainItem == "false") {
        return;
    }

    for (var i = 0; i < obj.length; i++) {
        select.options[i] = new Option(obj[i].MainItem);
        select.options[i].value = obj[i].MainItem;
    }
    select.options[select.options.length] = new Option("填写新项目");
    select.options[select.options.length - 1].value = "writeNew";
}

function GetMainItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/GetMainItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var json = xmlHttp.responseText;
    return eval("(" + json + ")");
}

function showNewInput() {
    var mainitem = document.getElementById("MainItem");
    if (this.selectedIndex == (this.options.length - 1)) {
        mainitem.style.display = "block";
    } else {
        mainitem.style.display = "none";
    }
}