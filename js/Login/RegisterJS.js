/* ***********************************************************
 * FileName: RegeditJS.js
 * Writer: peach
 * create Date: 2017-4-2
 * ReWriter:
 * Rewrite Date:
 * impact :
 * 注册前端验证
 * **********************************************************/

var isAllGood;//所有检查是否通过

window.addEventListener("load", Init, false);//添加页面加载处理函数

//初始化
function Init() {
    document.forms[0].addEventListener("submit", CheckInput, false);//添加表单提交事件处理函数
    //document.forms[0].addEventListener("reset", resetForm, false);//添加表单rest事件函数
    document.getElementById("contact").addEventListener("change", phoneFormat, false);//电话号码格式化
    document.getElementById("userName").addEventListener("blur", checkExist, false);//ajax实时验证用户名是否重复
    document.getElementById("checkPassWord").addEventListener("blur", checkPassword, false);//检查两次密码是否相同
    document.getElementById("userKey").addEventListener("blur", checkpsw, false);//检查密码格式
}
//表单reset函数
function resetForm(evt) {
    //所有提示清空
    document.getElementById("error").innerHTML = "";
    document.getElementById("error").style.display = "none";

    var allInput = document.getElementsByTagName("INPUT");
    for (var i = 0; i < allInput.length; i++) {
        if (allInput[i].className.indexOf("invalid") > -1) {
            resetInput(allInput[i]);//恢复Input样式
        }
    }
}
//检查各个输入项内容
function CheckInput(evt) {
    isAllGood = true;//初始默认全为通过
    //各个提示项每次初始清空
    document.getElementById("error").innerHTML = "";
    //所有元素节点数组
    var allElements = document.forms[0].getElementsByTagName("*");
    for (var i = 0; i < allElements.length; i++) {
        if (!CheckEmpty(allElements[i])) {
            isAllGood = false;
        }
    }
    if (!isAllGood) {
        evt.preventDefault();//阻止事件进行
    }
}
//检查是否为空
function CheckEmpty(thisElement) {
    var strOutClassName = "";//检查后返回CSS
    var thisClassName = thisElement.className.split(" ");//提取classname中每个class
    for (var i = 0; i < thisClassName.length; i++) {
        strOutClassName += CheckClassName(thisClassName[i], thisElement) + " ";//验证并返回验证后classname
    }

    thisElement.className = strOutClassName;
    //验证后classname包含invalid说明验证不通过
    if (strOutClassName.indexOf("invalid") > -1) {
        AlertLabel(thisElement.parentNode);//对应元素父节点（Label）红色加粗提示
        var error = document.getElementById("error");
        error.style.display = "block";
        if (thisElement.nodeName == "INPUT") {
            thisElement.select();
            if (thisElement.className.indexOf("userName") > -1) {
                error.innerHTML = "用户名不能为空";
            }
            if (thisElement.className.indexOf("userKey") > -1) {
                if (document.getElementById("error").innerHTML == "") {
                    error.innerHTML = "密码不能为空";
                }
            }
            if (thisElement.className.indexOf("checkPassWordError") > -1) {
                error.innerHTML = "两次密码不同";
            }
            if (thisElement.className.indexOf("name") > -1) {
                error.innerHTML = "姓名不能为空";
            }
            if (thisElement.className.indexOf("phone") > -1) {
                error.innerHTML = "手机号不正确";
            }
        } else if (thisElement.nodeName == "SELECT") {
            error.innerHTML = "请选择办公室";
        }
        return false;
    }
    return true;
}
//根据classname做对应的各项检查
function CheckClassName(thisClassName, thisElement) {
    var returnClassName = "";
    switch (thisClassName) {
        case "":
            break;
        case "invalid":
            break;
        case "isEmpty"://判空
            if (isAllGood && (thisElement.value == "" || thisElement.value == "请输入用户名" || thisElement.value == "请输入姓名" || thisElement.value == "请输入手机号码")) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "userKey":
            if (isAllGood && !CheckUserKey(thisElement)) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "checkUserKey"://两次密码输入是否正确
            var strCheckPsw = document.getElementById("userKey").value;
            if (isAllGood && thisElement.value != strCheckPsw) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "checkSex"://性别radio是否选择
            var sexRadios = document.getElementsByName("sex");
            if (isAllGood && !sexRadios[0].checked && !sexRadios[1].checked) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "office"://办公室是否选择
            var officeSelect = document.getElementById("office");
            if (isAllGood && officeSelect.selectedIndex == 0) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "phone"://验证电话号码
            if (isAllGood && !checkPhone(thisElement)) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        default:
            returnClassName += thisClassName;
            break;
    }
    return returnClassName;
}

function AlertLabel(thisNode) {
    if (thisNode.nodeName == "LABEL")
        thisNode.className += "invalid ";
}
//电话号码验证
function checkPhone(thisElement) {
    var strPhoneNumber = document.getElementById("contact").value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (!rep.test(strPhoneNumber)) {
        return false;
    }
    return true;
}
//电话号码格式规范
function phoneFormat() {
    var thisPhone = this.value;
    var rep = /^(\d{3})\-?(\d{4})\-?(\d{4})$/;
    if (rep.test(thisPhone)) {
        rep.exec(thisPhone);
        this.value = RegExp.$1 + "-" + RegExp.$2 + "-" + RegExp.$3;
    }
}
//reset时Input样式恢复
function resetInput(thisElement) {
    var allClassName = thisElement.className.split(" ");
    var resetClassName = "";
    for (var i = 0; i < allClassName.length; i++) {
        if (allClassName[i] != "invalid") {
            resetClassName += allClassName[i] + " ";
        }
    }
    thisElement.className = resetClassName;
}

//密码格式验证
function CheckUserKey(thisElement) {
    var reg = /^\w{6,12}$/;
    if (!reg.test(thisElement.value)) {
        document.getElementById("error").innerHTML = "请输入6-12位密码";
        return false;
    }
    return true;
}

//ajax异步检查用户名是否已存在
function checkExist() {
    document.getElementById("error").innerHTML = "";
    var xmlHttp = new XMLHttpRequest();
    var userName = document.getElementById("userName").value;
    var url = "CHeckRegeditUserName.ashx?userName=" + userName;
    xmlHttp.open("GET", url, true);
    xmlHttp.onreadystatechange = function () {
        if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
            var checked = xmlHttp.responseText;
            var error = document.getElementById("error");
            if (checked == "false") {
                document.getElementById("userName").className += " invalid";
                error.style.display = "block";
                error.innerHTML = "用户名重复";
            } else {
                recoverClassName(document.getElementById("userName"));
                error.display = "none";
            }
        }
    }
    xmlHttp.send();
}

//恢复样式（取消invalid）
function recoverClassName(thisElement) {
    var returnClassName = "";
    var className = thisElement.className.split(" ");
    for (var i = 0; i < className.length; i++) {
        if (className[i] != "invalid") {
            returnClassName += className[i] + " ";
        }
    }
    thisElement.className = returnClassName;
}

//核查两次密码是否相同
function checkPassword() {
    var error = document.getElementById("error");
    error.innerHTML = "";
    error.style.display = "none";
    var checkPsw = document.getElementById("checkPassWord");
    var psw = document.getElementById("userKey");
    if (checkPsw.value == psw.value) {
        recoverClassName(checkPsw);
        return;
    } else {
        checkPsw.className += " invalid";
        document.getElementById("error").innerHTML = "两次密码不同";
        error.style.display = "block";
    }
}

//核查密码
function checkpsw() {
    document.getElementById("error").innerHTML = "";
    document.getElementById("error").style.display = "none";
    var psw = document.getElementById("userKey");
    if (CheckUserKey(psw)) {
        recoverClassName(psw);
        return;
    } else {
        psw.className += " invalid";
        document.getElementById("error").style.display = "block";
    }
}