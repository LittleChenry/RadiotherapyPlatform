window.addEventListener("load", Init, false);

var obj;
var backString;
var jsonObj = [];
var headName;

$(function () {
    headName = new Array("账号","姓名","办公室","激活状态","绑定角色");
    $.ajax({
        type: "post",
        url: "getAllRoles.ashx",
        async: false,
        success:function(data){
            jsonObj = $.parseJSON(data);
            $("#tableArea").createTable(jsonObj, {
                rows: 10,
                headName:headName
            });
        }
    });

    $("#UserTable").bind("click", function (evt) {
        var which = evt.target;
        var $tr = $(which).closest("tr");
        editModel($tr);
    });

    $("#search").bind("click", function () {
        var role = $("#roles").find("option:selected").val();
        if (role == "1")
            role = "激活";
        else if (role == "0") {
            role = "未激活";
        }
        var office = $("#office").find(":selected").val();
        var temp = [];
        for (var i = 0; i < jsonObj.length; i++) {
            if ((role == "allNumber" || jsonObj[i].Activate == role) && (office == "allOffice" || jsonObj[i].Office == office)) {
                temp.push(jsonObj[i]);
            }
        }
        $("#tableArea").createTable(temp, {
            rows: 10,
            headName: headName
        });
    });

    $("#sureedit").bind("click", function () {
        recordRole();
    });
});

function editModel($tr) {
    $("#recordNumber").val($tr.find("td:eq(0)").text());
    chooseRole($tr.find("td:eq(0)").text());
    $("#model").click();
}

function Init() {
    getAllRole();   //获取所有存在的角色

    createRole();   //生成修改角色的多选框
    document.getElementById("chooseAll").addEventListener("click", chooseAll, false);       //全选按钮添加点击事件
}

//记录角色，保存在hidden里，方便后端查询。保存形式： "ROOT WLS YS "。
function recordRole() {
    var hidden = document.getElementById("updateRoles");
    var area1 = document.getElementById("roles1").getElementsByTagName("INPUT");
    var area2 = document.getElementById("roles2").getElementsByTagName("INPUT");
    var selected = "";
    var next = "";
    for (var i = 0; i < area1.length; i++) {
        if (area1[i].checked == true) {
            selected += area1[i].title + " ";
            next += $(area1[i]).next("span").text() + " ";
        }
    }
    for (var i = 0; i < area2.length; i++) {
        if (area2[i].checked == true) {
            selected += area2[i].title + " ";
            next += $(area2[i]).next("span").text() + " ";
        }
    }
    var page = parseInt($("#currentPage").val());
    $.ajax({
        type: "POST",
        url: "changeRoles.ashx",
        data: { "number": $("#recordNumber").val(), "role":selected},
        success: function (data) {
            changeDate($("#recordNumber").val(), next);
            var role = $("#roles").find("option:selected").val();
            if (role == "1")
                role = "激活";
            else if (role == "0") {
                role = "未激活";
            }
            var office = $("#office").find(":selected").val();
            var temp = [];
            for (var i = 0; i < jsonObj.length; i++) {
                if ((role == "allNumber" || jsonObj[i].Activate == role) && (office == "allOffice" || jsonObj[i].Office == office)) {
                    temp.push(jsonObj[i]);
                }
            }
            $("#tableArea").createTable(temp, {
                rows: 10,
                headName: headName,
                pages: page
            });
            $("#cannel").click();
        }
    });
    hidden.value = selected;
}

function changeDate(number, next) {
    for (var i = 0; i < jsonObj.length; i++) {
        if (jsonObj[i].number == number) {
            jsonObj[i].description = next;
            break;
        }
    }
}

//选择需要修改角色的用户
function selectedUser(evt) {
    var Number = this.parentNode.childNodes[3].value;
    document.getElementById("userNumber").value = Number;
    document.getElementById("getNumber").innerHTML = Number;
    document.getElementById("pageIndex").value = this.parentNode.childNodes[5].value;
    var bindArea = document.getElementById("changeBind");
    var style = (bindArea.currentStyle != undefined) ? bindArea.currentStyle.display : window.getComputedStyle(bindArea, null).display;
    if(style == "none"){
        bindArea.style.display = "block";
    }
    chooseRole(Number);
}
//多选框中将用户已经拥有的角色选中。
function chooseRole(Number) {
    GetchooseRoles(Number);
    var area1 = document.getElementById("roles1").getElementsByTagName("INPUT");
    var area2 = document.getElementById("roles2").getElementsByTagName("INPUT");
    for (var i = 0; i < area1.length; i++) {
        if (backString.indexOf(area1[i].title) > -1) {
            area1[i].checked = true;
        } else {
            area1[i].checked = false;
        }
    }
    for (var i = 0; i < area2.length; i++) {
        if (backString.indexOf(area2[i].title) > -1) {
            area2[i].checked = true;
        } else {
            area2[i].checked = false;
        }
    }
}
//多选框全选
function chooseAll() {
    var area1 = document.getElementById("roles1").getElementsByTagName("INPUT");
    var area2 = document.getElementById("roles2").getElementsByTagName("INPUT");
    for (var i = 0; i < area1.length; i++) {
            area1[i].checked = true;
    }
    for (var i = 0; i < area2.length; i++) {
        area2[i].checked = true;
    }   
}
//ajax请求后端返回此用户已经拥有的角色
function GetchooseRoles(Number) {
    var xmlHttp = new XMLHttpRequest();
    var url = "GetChooseRoles.ashx?Number=" + Number;
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            backString = xmlHttp.responseText;
        }
    }
    xmlHttp.send();
}
//ajax请求后端返回数据库中存在的所有角色
function getAllRole() {
    var xmlHttp = new XMLHttpRequest();
    var url = "getAllRole.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var json = xmlHttp.responseText;
            obj = eval("(" + json + ")");
        }
    }
    xmlHttp.send();
}
//生成左右两组多选框，修改角色使用。
function createRole() {
    var addArea1 = document.getElementById("roles1");
    var addArea2 = document.getElementById("roles2");
    if (obj.role != undefined) {
        if (obj.role.Name == "false") {
            return;
        } else {
            var roles = obj.role;
            for (var i = 0; i < roles.length; i++) {
                if (i % 2 == 0) {
                    createCheckBox(roles[i], addArea1);
                } else {
                    createCheckBox(roles[i], addArea2);
                }
            }
        }
    }
}
//生成多选框的函数
function createCheckBox(role, area) {
    var text = document.createTextNode(role.Description);
    var span = document.createElement("SPAN");
    span.appendChild(text);
    var input = document.createElement("INPUT");
    input.type = "checkbox";
    input.name = "role";
    input.title = role.Name;//我也想用value可是IE不给我用-，-
    label = document.createElement("LABEL");
    label.appendChild(input);
    label.appendChild(span);
    var li = document.createElement("LI");
    li.appendChild(label);
    area.appendChild(li);
}