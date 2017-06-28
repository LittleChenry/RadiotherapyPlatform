window.addEventListener("load", Init, false);

var obj;
var isAllGood;

function Init() {
    document.getElementById('showAdd').addEventListener("click", showAddArea, false);
    document.getElementById('addRoleFrm').addEventListener("submit", checkAll, false);
    document.getElementById('addRoleFrm').addEventListener("reset", resetForm, false);
    document.getElementById('roleName').addEventListener("blur", checkReapt, false);
}

function Refresh(evt) {
    evt.preventDefault();
    window.location = 'Root-role.aspx';
}

function cannel(evt) {
    evt.preventDefault();
    document.getElementById("error").innerHTML = "";

    var allInput = document.getElementById('addRoleFrm').getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("invalid") > -1) {
            recoverClassName(allInput[i]);//恢复Input样式
        }
        if (allInput[i].id == "roleName" || allInput[i].id == "roleDescription") {
            allInput[i].value = "";
        }
        if (allInput[i].type == "checkbox") {

        } allInput[i].checked = false;
    }
    document.getElementById("hidePart").style.display = "none";
    document.getElementById('enableSeeSpan').className = "fa fa-angle-double-left";

    document.getElementById("middleArea").style.display = "none";
    document.getElementById("topArea").style.display = "none";
}

function showAddArea(evt) {
    createFunction();
    //var addArea = document.getElementById("addArea");
    //var style = (addArea.currentStyle != undefined ? addArea.currentStyle.display : window.getComputedStyle(addArea, null).display);
    //if (style == "none") {
    //    addArea.style.display = "block";
    //    this.value = "隐藏";
    //} else {
    //    addArea.style.display = "none";
    //    this.value = "新增用户";
    //}
}

function createFunction() {
    var functionList = document.getElementById('hidePart');
    getFunction();
    if (obj != undefined) {
        var func = obj.func;
        if (func.ID == "false") {
            while (functionList.hasChildNodes()) {//删除当前所有孩子（选项）
                functionList.removeChild(functionList.firstChild);
            }
            var text = document.createTextNode("当前无角色");
            var span = document.createElement("SPAN");
            span.appendChild(text);
            var li = document.createElement("LI");
            li.appendChild(span);
            functionList.appendChild(li);
        } else {
            for (var i = 0; i < func.length; i++) {
                createLi(func[i], functionList);
            }
        }
    }
}

function getFunction() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getFunction.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var json = xmlHttp.responseText;
            obj = eval("(" + json + ")");
        }
    };
    xmlHttp.send();
}

function createLi(func, functionList) {
    var text = document.createTextNode(func.Name);
    var span = document.createElement("SPAN");
    span.appendChild(text);
    var input = document.createElement("INPUT");
    //input.value = role.Name;
    input.title = func.ID;
    input.name = "function";
    input.type = "checkbox";
    input.addEventListener("click", cannelChooseAll, false)
    var label = document.createElement("LABEL");
    label.appendChild(input);
    label.appendChild(span);
    li = document.createElement("LI");
    li.appendChild(label);
    functionList.appendChild(li);
}

function InitChooseAll() {
    document.getElementById("allFunction").addEventListener("click", chooseAll, false);
}

function chooseAll(evt) {
    if (this.checked == true) {
        var allSelect = document.getElementsByName("function");
        for (var i = 0; i < allSelect.length; i++) {
            allSelect[i].checked = true;
        }
    }
}

function cannelChooseAll(evt) {
    if (this.checked == false) {
        document.getElementById("allFunction").checked = false;
    }
}

function checkAll(evt) {
    isAllGood = true;
    document.getElementById('error').innerHTML = "";
    var allTag = this.getElementsByTagName("*");
    for (var i = 0; i < allTag.length; i++) {
        if (!checkElement(allTag[i])) {
            isAllGood = false;
        }
    }
    if (!isAllGood) {
        evt.preventDefault();
    } else {
        recordSelected();
    }
}

function recordSelected() {
    var hidden = document.getElementById('selectedFunction');
    var select = document.getElementsByName('function');
    for (var i = 0; i < select.length; i++) {
        if (select[i].checked == true) {
            hidden.value += select[i].title + " ";
        }
    }
}

function checkElement(thisElement) {
    var rClassName = "";
    var allClassName = thisElement.className.split(" ");
    for (var i = 0; i < allClassName.length; i++) {
        rClassName += checkClassName(allClassName[i], thisElement) + " ";
    }

    thisElement.className = rClassName;
    if (rClassName.indexOf("invalid") > -1) {
        var error = document.getElementById('error');
        if (thisElement.id == "roleName") {
            error.innerHTML = "角色Name不能为空";
        }
        if (thisElement.id == "roleDescription") {
            error.innerHTML = "角色名称不能为空";
        }
        if (thisElement.id == "hidePart") {
            error.innerHTML = "请选择绑定功能";
            thisElement.style.display = "block";
            document.getElementById('enableSeeSpan').className = "fa fa-angle-double-down";
        }
        return false;
    }
    return true;
}

function checkClassName(thisClassName, thisElement) {
    var backString = "";
    switch (thisClassName) {
        case "":
        case "invalid":
            break;
        case "IsEmpty":
            if (isAllGood && thisElement.value == "") {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        case "checkFunction":
            if (isAllGood && !selectedOne(thisElement)) {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        default:
            backString += thisClassName;
    }
    return backString;
}

function selectedOne(thisElement) {
    var checkboxs = thisElement.getElementsByTagName("INPUT");
    var isSelected = false;
    for (var i = 0; i < checkboxs.length; i++) {
        if (checkboxs[i].checked == true) {
            isSelected = true;
            break;
        }
    }
    return isSelected;
}

function resetForm(evt) {
    //所有提示清空
    document.getElementById("error").innerHTML = "";

    var allInput = this.getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("invalid") > -1) {
            recoverClassName(allInput[i]);//恢复Input样式
        }
    }
    document.getElementById("hidePart").style.display = "none";
    document.getElementById('enableSeeSpan').className = "fa fa-angle-double-left";
}

function recoverClassName(thisElement) {
    var thisClassNames = thisElement.className.split(" ");
    var backString = "";
    for (var i = 0; i < thisClassNames.length; i++) {
        if (thisClassNames[i] != "invalid") {
            backString += thisClassNames[i] + " ";
        }
    }
    thisElement.className = backString;
}

function checkReapt() {
    var error = document.getElementById('error');
    error.innerHTML = "";
    recoverClassName(this);
    if (this.value == "") {
        error.innerHTML = "角色Name不能为空";
        this.className += " invalid";
        return false;
    }
    var element = this;
    var xmlHttp = new XMLHttpRequest();
    var url = "checkNameReapt.ashx?name=" + this.value;
    xmlHttp.open("GET", url, true);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            if (xmlHttp.responseText == "repeat") {
                error.innerHTML = "角色Name重复,请换一个";
                element.className += " invalid";
            }
        }
    }
    xmlHttp.send();
}