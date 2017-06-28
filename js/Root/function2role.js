/* ***********************************************************
 * FileName: function2role.js
 * Writer: peach
 * create Date: 2017-4-20
 * ReWriter:
 * Rewrite Date:
 * impact :
 * Root-function2role前端脚本
 * ************************************************************/

window.addEventListener("load", Init, false);

var obj;
var backString = "";

function Init() {
    createFunction();
    var allLink = document.getElementsByTagName("A");
    for (var i = 0; i < allLink.length; i++) {
        allLink[i].addEventListener("click", showBindArea, false);
    }

    document.getElementById("chooseAll").addEventListener("click", chooseAll, false);
    document.getElementById("bindFrm").addEventListener("submit", recordFunction, false);
    document.getElementById("refresh").addEventListener("click", Refresh, false);
}

function Refresh(evt) {
    evt.preventDefault();
    window.location = 'Root-function2role.aspx';
}

function showBindArea(evt) {
    var bindArea = document.getElementById("changeBind");
    var parent = this.parentNode;
    var hiddens = parent.getElementsByTagName("INPUT");
    var id = hiddens[0].value;
    var name = hiddens[1].value;
    var pageIndex = hiddens[2].value;

    document.getElementById('getSelectRole').innerHTML = name;
    document.getElementById('RoleID').value = id;
    document.getElementById('pageIndex').value = pageIndex;

    GetChooseFunction(id);
    ChooseFunction();

}

function GetChooseFunction(id) {
    var xmlHttp = new XMLHttpRequest();
    var url = "getChooseFunctions.ashx?id=" + id;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            backString = xmlHttp.responseText;
        }
    }
    xmlHttp.send();
}

function ChooseFunction() {
    var select = backString.split(" ");
    var isSelect;
    var checkbox1 = document.getElementById('function1').getElementsByTagName("INPUT");
    var checkbox2 = document.getElementById('function2').getElementsByTagName("INPUT");

    for (var i = 0; i < checkbox1.length; i++) {
        isSelect = false;
        var j = 0;
        for (j; j < select.length - 1; j++) {
            if (parseInt(checkbox1[i].title) == parseInt(select[j])) {
                isSelect = true;
                break;
            }
        }
        if (isSelect) {
            checkbox1[i].checked = true;
        } else {
            checkbox1[i].checked = false;
        }
    }

    for (var i = 0; i < checkbox2.length; i++) {
        isSelect = false;
        var j = 0;
        for (j; j < select.length - 1; j++) {
            if (parseInt(checkbox2[i].title) == parseInt(select[j])) {
                isSelect = true;
                break;
            }
        }
        if (isSelect) {
            checkbox2[i].checked = true;
        } else {
            checkbox2[i].checked = false;
        }
    }
}

function createFunction() {
    var function1 = document.getElementById('function1');
    var function2 = document.getElementById('function2');
    getFunction();
    if (obj != undefined) {
        var func = obj.func;
        if (func.ID == "false") {
            var text = document.createTextNode("无角色");
            var label = document.createElement("LABEL");
            label.appendChild(text);
            var li = document.createElement("LI");
            li.appendChild(label);
            function1.appendChild(li);
        } else {
            for (var i = 0; i < func.length; i++) {
                if (i % 2 == 0) {
                    createLi(func[i], function1);
                } else {
                    createLi(func[i], function2);
                }
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
    var label = document.createElement("LABEL");
    label.appendChild(input);
    label.appendChild(span);
    li = document.createElement("LI");
    li.appendChild(label);
    functionList.appendChild(li);
}

function chooseAll() {
    var area1 = document.getElementById("function1").getElementsByTagName("INPUT");
    var area2 = document.getElementById("function2").getElementsByTagName("INPUT");
    for (var i = 0; i < area1.length; i++) {
        area1[i].checked = true;
    }
    for (var i = 0; i < area2.length; i++) {
        area2[i].checked = true;
    }
}

function recordFunction() {
    var hidden = document.getElementById("updateFunctions");
    var area1 = document.getElementById("function1").getElementsByTagName("INPUT");
    var area2 = document.getElementById("function2").getElementsByTagName("INPUT");
    var selected = "";
    for (var i = 0; i < area1.length; i++) {
        if (area1[i].checked == true) {
            selected += area1[i].title + " ";
        }
    }
    for (var i = 0; i < area2.length; i++) {
        if (area2[i].checked == true) {
            selected += area2[i].title + " ";
        }
    }
    hidden.value = selected;
}