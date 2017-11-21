var objuser = [];

$(function () {
    $.ajax({
        type: "post",
        url: "getAllUser.ashx",
        dataType: "text",
        success: function (data) {
            objuser = $.parseJSON(data);
            $("#tableArea").createTable($.parseJSON(data), {
                headName: new Array("用户账号","姓名","性别","联系方式","办公室","用户密码","激活状态")
            });
        }
    });
});

$(function () {
    $("#search").bind("click", function () {
        var activate = $("#Select1").val();
        var office = $("#office").val();

        $.ajax({
            type: "post",
            url: "getAllUser.ashx",
            dataType: "text",
            data: {"activate":activate, "office":office},
            success: function (data) {
                if (data == "]") {
                    var $table = $("#UserTable");
                    $("#tableArea").empty().append($table);
                    $("#UserTable").empty();
                    return;
                }
                objuser = $.parseJSON(data);
                $("#tableArea").createTable(objuser, {
                    headName: new Array("用户账号", "姓名", "性别", "联系方式", "办公室", "用户密码", "激活状态")
                });
            }
        });
    });
});

$(function () {
    createRole();
});

//新增用户区域生成选择角色的多选框
function createRole() {
    var roleArea = document.getElementById("hidePart");
    getAllRole();
    var role = obj.role;
    if (role[0].Name == "false") {
        roleArea.removeChild(roleArea.firstChild);
        var text = document.createTextNode("无角色");
        var Label = document.createElement("LABEL");
        span.appendChild(Label);//到这无角色时，下面写有角色时
    }
    //var allRoleText = document.createTextNode("所有角色");
    //var inputCheckBox = document.createElement("INPUT");
    //inputCheckBox.type = "checkbox";
    //inputCheckBox.id = "allRole";
    //var allRoleLabel = document.createElement("LABEL");
    //allRoleLabel.appendChild(inputCheckBox);
    //allRoleLabel.appendChild(allRoleText);
    //var allRoleLi = document.createElement("LI");
    //allRoleLi.appendChild(allRoleLabel);
    //roleArea.appendChild(allRoleLi);
    for (var i = 0; i < role.length; i++) {
        createDropDowmList(role[i], roleArea);
    }
}
//ajax请求后端返回存在的所有角色
function getAllRole() {
    var xmlHttp = new XMLHttpRequest();
    var url = "/RadiotherapyPlatform/pages/Root/getAllRole.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var json = xmlHttp.responseText;
            obj = eval("(" + json + ")");
        }
    }
    xmlHttp.send();
}
//生成角色选择多选框的函数
function createDropDowmList(role, roleArea) {
    var roleNameString = document.createTextNode(role.Description);
    var span = document.createElement("SPAN");
    span.appendChild(roleNameString);
    var input = document.createElement("INPUT");
    //input.value = role.Name;
    input.title = role.Name;
    input.name = "role";
    input.type = "checkbox";
    var label = document.createElement("LABEL");
    label.appendChild(input);
    label.appendChild(span);
    li = document.createElement("LI");
    li.appendChild(label);
    roleArea.appendChild(li);
}
//新增取消
$(function () {
    $("#cannelButton").bind("click", function () {
        $("#addGroup input").val("");
        $("#addGroup input").removeClass("invalid");
        $("#addGroup select").val("");
        $("#hidePart").empty().append("<li>"
                                      +"<label class=control-label>"
                                      +"<input id=allRole type=checkbox />"
                                      +"全部角色"
                                      +"</label>"
                                      + "</li>");
        createRole();
    });
});
$(function () {
    document.getElementById("phoneContact").addEventListener("blur", checkPhone, false);    //电话号码输入框的blur事件
    document.getElementById("userNumber").addEventListener("blur", checkNumber, false);     //账号输入框的blur事件
    document.getElementById("userPassword").addEventListener("blur", checkUserkey, false);  //第一次密码输入框
    document.getElementById("checkPassword").addEventListener("blur", checkRePswRight, false);//第二次密码输入框
    $("#sureAdd").bind("click", function (evt) {
        checkAll(evt);
    });
});
//编辑
$(function(){
    $("#changeUser").bind("click",function(){
        $(this).hide();
        $("#newGroup").hide();
        $("#closeEdit").show();
        $("#UserTable").bind("click",function(evt){
            var which = evt.target;
            var $tr = $(which).closest("tr");
            $("#EditGroup").trigger("click");
            createEditArea($tr);
        });
    });
    $("#closeEdit").bind("click",function(){
        $(this).hide();
        $("#changeUser").show();
        $("#newGroup").show();
        $("#UserTable").unbind("click");
    });
});

var canDelete = true;
var nowEditNumberBefore = "";
//创建编辑用户的modal内容
function createEditArea($tr) {
    var $tds = $tr.find("td");
    nowEditNumberBefore = $tds[0].innerText;
    $("#numberEdit").val($tds[0].innerText);
    $("#nameEdit").val($tds[1].innerText);
    if($tds[2].innerText == "男"){
        $("#genderEdit1").attr("checked","checked");
    }else{
        $("#genderEdit2").attr("checked","checked");
    }
    $("#pwdEdit").val($tds[5].innerText);
    $("#phoneEdit").val($tds[3].innerText);
    $("#officeEdit").val($tds[4].innerText);
    if($tds[6].innerText == "已激活"){
        $("#activateEdit1").attr("checked","checked");
    }else{
        $("#activateEdit2").attr("checked","checked");
    }


    /*$("#deleteUser").bind("click", function () {
        if (canDelete) {
            canDelete = false;
        } else {
            return;
        }
        deleteUser();
    });*/
}
function editUser(){
    var numberEdit = $("#numberEdit").val();
    var nameEdit = $("#nameEdit").val();
    var genderEdit = $("input:radio[name='genderEdit']:checked").val();
    var phoneEdit = $("#phoneEdit").val();
    var officeEdit = $("#officeEdit").val();
    var activateEdit = $("input:radio[name='activateEdit']:checked").val();
    var current = parseInt($("#currentPage").val());
    var key = $("#pwdEdit").val();
    $.ajax({
        type: "post",
        url: "/RadiotherapyPlatform/pages/Root/editUser.ashx",
        data: {"beforeNumber":nowEditNumberBefore,"numberEdit":numberEdit,"pwd": key,"nameEdit":nameEdit,"genderEdit":genderEdit,"phoneEdit":phoneEdit,"officeEdit":officeEdit,"activateEdit":activateEdit},
        dataType: "text",
        success: function () {
            alert("修改成功");
            changeObj(numberEdit,nameEdit,genderEdit,phoneEdit,officeEdit,activateEdit,key);
            $("#tableArea").createTable(objuser, {
                headName: new Array("用户账号", "姓名", "性别", "联系方式", "办公室", "用户密码", "激活状态"),
                pages: current
            });
            $("#cannelEdit").trigger("click");
        }
    });
}

function changeObj(num,name,gender,contact,office,activate,pwd) {
    for (var i = 0; i < objuser.length; ++i) {
        if (nowEditNumberBefore == objuser[i].Number) {
            objuser[i].Number = num;
            objuser[i].Name = name;
            objuser[i].Gender = (gender == "M" ? "男":"女");
            objuser[i].Contact = contact;
            objuser[i].Office = office;
            objuser[i].Activate = (activate == 0 ? "未激活" : "激活");
            objuser[i].password = pwd;
            break;
        }
    }
}

function deleteUser(){
    var numberEdit = $("#numberEdit").val();
    var current = parseInt($("#currentPage").val());
    $.ajax({
        type: "post",
        url: "/RadiotherapyPlatform/pages/Root/deleteUser.ashx",
        data: {"numberEdit":numberEdit},
        dataType: "text",
        success: function () {
           
            findObj(numberEdit);
            $("#tableArea").createTable(objuser, {
                headName: new Array("用户账号", "姓名", "性别", "联系方式", "办公室", "用户密码", "激活状态"),
                pages:current
            });
            canDelete = true;
            alert("删除成功");
            $("#cannelEdit").trigger("click");
        },
        error: function () {
            canDelete = true;
        }
    });
}

function findObj(num) {
    for (var i = 0; i < objuser.length; i++) {
        if (num == objuser[i].Number) {
            objuser.splice(i, 1);
        }
    }
}
//新增用户表单提交时的验证
function checkAll(evt) {
    isAllGood = true;
    document.getElementById("error").innerHTML = "";
    $("#error").hide();
    var allElements = document.getElementById("addGroup").getElementsByTagName("*");
    for (var i = 0; i < allElements.length; i++) {
        if (!checkElement(allElements[i])) {
            isAllGood = false;
            break;
        }
    }
    if (!isAllGood) {
        evt.preventDefault();
        return false;
    } else {
        recordRole();
    }
}
//新增用户表单元素的一些错误提示
function checkElement(element) {
    var classNames = element.className.split(" ");
    var rclassName = "";
    for (var i = 0; i < classNames.length; i++) {
        rclassName += checkClassName(classNames[i], element) + " ";
    }
    element.className = rclassName;
    if (rclassName.indexOf("invalid") > -1) {
        if (element.nodeName == "Input" || element.nodeName == "SELECT") {
            element.select;
        }
        if (element.nodeName == "UL") {
            $("#hidePart").show();
            //document.getElementById('enableSeeSpan').className = "fa fa-angle-double-down";
        }
        var error = document.getElementById("error");
        $(error).show();
        switch (element.id) {
            case "userNumber":
                error.innerHTML = "请输入账号";
                if(numberrepeat){
                     error.innerHTML = "账号重复";
                }
                break;
            case "userPassword":
                error.innerHTML = "请输入6-12位密码";
                break;
            case "checkPassword":
                error.innerHTML = "两次密码不同";
                break;
            case "name":
                error.innerHTML = "请输入姓名";
                break;
            case "phoneContact":
                error.innerHTML = "请输入正确的手机号码";
                break;
            case "officeSelect":
                error.innerHTML = "请选择办公室";
                break;
            case "hidePart":
                error.innerHTML = "请绑定角色";
                break;
        }
        return false;
    }
    return true;
}
//检查class
function checkClassName(thisClassName, thisElement) {
    var backString = "";
    switch (thisClassName) {
        case "":
        case "invalid":
            break;
        case "IsEmpty":
            if (isAllGood && !checkEmpty(thisElement)) {
                backString += "invalid ";
                isAllGood = false;
            }
            backString += thisClassName;
            break;
        case "number":
            if(!isAllGood){
                backString += thisClassName;
                break;
            }
            checkRepeatNumber();

            if(numberrepeat){
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        case "userKey":
            if (isAllGood && !checkKey(thisElement)) {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        case "checkPassword":
            if (isAllGood && !checkPassword(thisElement)) {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        case "office":
            if (isAllGood && (thisElement.selectedIndex == 0)) {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        case "checkRole":
            if (isAllGood && !checkRole(thisElement)) {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        case "contact":
            if (isAllGood && !checkContact(thisElement)) {
                backString += "invalid ";
            }
            backString += thisClassName;
            break;
        default:
            backString += thisClassName;
    }
    return backString;
}
//检查是否为空的函数
function checkEmpty(thisElement) {
    if (thisElement.value == "") {
        return false;
    }
    return true;
}
//检查密码是否6-12位的函数
function checkKey(thisElement) {
    var psw = thisElement.value;
    var rep = /^\w{6,12}$/;
    return rep.test(psw);
}
//检查两次密码是否相同的函数
function checkPassword(thisElement) {
    var psw = document.getElementById("userPassword").value;
    return (thisElement.value == psw);
}
//检查是否选择角色的函数
function checkRole(thisElement) {
    var roles = document.getElementsByName("role");
    var isCheck = false;
    for (var i = 0; i < roles.length; i++) {
        if (roles[i].checked == true) {
            isCheck = true;
        }
    }
    return isCheck;
}
//检查手机号码的函数
function checkContact(thisElement) {
    var thisPhone = thisElement.value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    return rep.test(thisPhone);
}
//检查手机号码格式
function checkPhone() {
    var error = document.getElementById("error");
    error.innerHTML = "";
    $(error).hide();
    recoverClassName(this);
    if (checkContact(this)) {
        var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
        rep.exec(this.value);
        this.value = RegExp.$1 + "-" + RegExp.$2 + "-" + RegExp.$3;
    } else {
        error.innerHTML = "请输入正确的手机号码";
        this.className += " invalid";
        $(error).show();
    }
}
//记录所选角色，形式:"ROOT WLS YS "
function recordRole() {
    var hidden = document.getElementById("selectedRole");
    var roles = document.getElementsByName("role");
    var seleced = "";
    for (var i = 0; i < roles.length; i++) {
        if (roles[i].checked == true) {
            seleced += roles[i].title + " ";
        }
    }
    hidden.value = seleced;
    postNewUser(seleced);
}
//新增提交
function postNewUser(seleced) {
    var userNumber = $("#userNumber").val();
    var userName = $("#name").val();
    var gender = $("input:radio[name='gender']:checked").val();
    var userPassword = $("#userPassword").val();
    var phoneContact = $("#phoneContact").val();
    var office = $("#Select2").val();
    var roles = seleced;
    var activate = $("input:radio[name='activate']:checked").val();
    $.ajax({
        type: "post",
        url: "addUser.ashx",
        data: {"userNumber":userNumber,"userName":userName,"gender":gender,"userPassword":userPassword,
                "phoneContact":phoneContact,"office":office,"roles":roles,"activate":activate},
         dataType: "text",
        success: function () {
            alert("新增成功");
            location.reload();
        }
    });
}

//重置class
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
//检测输入的账号在数据库中是否存在
var numberrepeat = false;
function checkRepeatNumber(){
    var number = $("#userNumber");
    numberrepeat = false;
    $.ajax({
        type: "get",
        url: "../../pages/Root/checkNumberReapt.ashx?userName=" + number.val(),
        async: false,
        success: function(data){
            if(data == "false"){
                numberrepeat = true;
            }
        }
    })
}


function checkNumber() {
    var error = document.getElementById("error");
    error.innerHTML = "";
    $(error).hide();
    recoverClassName(this);
    var id = this.value;
    if (id == "") {
        error.innerHTML = "账号不能为空";
        this.className += " invalid";
        $(error).show();
        return false;
    }
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/checkNumberReapt.ashx?userName=" + id;
    xmlHttp.open("GET", url, true);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.status == 200 && xmlHttp.readyState == 4) {
            var back = xmlHttp.responseText;
            if (back == "false") {
                $(error).show();
                error.innerHTML = "账号重复"
                document.getElementById("userNumber").className += " invalid";
            }
        }
    }
    xmlHttp.send();
}
//检查密码是否6-12位
function checkUserkey() {
    var error = document.getElementById("error");
    error.innerHTML = "";
    $(error).hide();
    recoverClassName(this);
    if (!checkKey(this)) {
        error.innerHTML = "请输入6-12位密码";
        this.className += " invalid";
        $(error).show();
    }
}
//检查两次密码是否重复
function checkRePswRight() {
    var error = document.getElementById("error");
    error.innerHTML = "";
    $(error).hide();
    recoverClassName(this);
    if (this.value != document.getElementById("userPassword").value) {
        error.innerHTML = "两次密码不同";
        this.className += " invalid";
        $(error).show();
    }
}
//重置新增用户的表单
function resetForm(evt) {
    //所有提示清空
    document.getElementById("error").innerHTML = "";

    var allInput = this.getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("invalid") > -1) {
            recoverClassName(allInput[i]);//恢复Input样式
        }
    }
}

$(function(){
    $("#phoneEdit").blur(function(){
        var error = document.getElementById("editError");
        error.innerHTML = "";
        $(error).hide();
        $(this).removeClass("invalid");
        if (checkContact(this)) {
            var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
            rep.exec(this.value);
            this.value = RegExp.$1 + "-" + RegExp.$2 + "-" + RegExp.$3;
        } else {
            error.innerHTML = "请输入正确的手机号码";
            $(this).addClass("invalid");
            $(error).show();
        }
    });
    $("#nameEdit").blur(function(){
        var error = document.getElementById("editError");
        error.innerHTML = "";
        $(error).hide();
        $(this).removeClass("invalid");
        if ($(this).val() == "") {
            error.innerHTML = "请输入姓名";
            $(this).addClass("invalid");
            $(error).show();
        }
    });
    $("#sureEdit").bind("click", function (evt) {
        checkEditAll(evt);
    });
});

function checkEditAll(evt){
    if($("#phoneEdit").val() == ""){
        $("#phoneEdit").addClass("invalid");
        $("#editError").html("请输入正确的手机号码").show();
        evt.preventDefault();
        return false;
    }
    if($("#nameEdit").val() == ""){
        $("#nameEdit").addClass("invalid");
        $("#editError").html("请输入姓名").show();
        evt.preventDefault();
        return false;
    }
    editUser();
}
