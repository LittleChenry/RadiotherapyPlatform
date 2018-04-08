/* ***********************************************************
 * FileName: ChangePatient.js
 * Writer: xubixiao
 * create Date: --
 * ReWriter:xubixiao
 * Rewrite Date:--
 * impact :
 * 病人库存信息修改JS界面，将以前已经结束治疗的病人重新置于治疗队列中
 * **********************************************************/


var isAllGood;//所有检查是否通过

var userName;
var userID;
var docandgroup;

window.addEventListener("load", Init, false);//添加页面加载处理函数

//初始化
function Init() {
    //获取Session会话，包括角色身份，角色ID，姓名等。
    var session = getSession();
    var role = session.role;
    getUserID();
    //如果当前session失效，则跳到登录界面
    if ((typeof (userID) == "undefined")) {
        if (confirm("用户身份已经失效,是否选择重新登录?")) {
            parent.window.location.href = "/RadiotherapyPlatform/pages/Login/Login.aspx";
        }
    }
    //你们权限不够，此界面的权限给物理师、技师
    var session = getSession();
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
        $("#Menu-EquipmentView").attr("href", "javascript:;");
        $("#Menu-EquipmentView").bind("click", function () {
            alert("权限不够！");
        });
    }

    getUserName();
    

}



//获取当前会话session
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}



//获取当前操作用户ID
function getUserID() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetUserID.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userID = xmlHttp.responseText;
            }

        }
    }
    xmlHttp.send();
}

//获取当前用户的姓名
function getUserName() {
    var xmlHttp = new XMLHttpRequest();
    var url = "Records/GetUserName.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4) {//正常响应
            if (xmlHttp.status == 200) {//正确接受响应数据
                userName = xmlHttp.responseText;
            }
        }
    }
    xmlHttp.send();
}




//或取当前会话
function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}
