/* ***********************************************************
 * FileName: chooseAllJS.js
 * Writer: peach
 * create Date: 2017-4-10
 * ReWriter:
 * Rewrite Date:
 * impact :
 * Root-information控件内容验证
 * **********************************************************/

window.addEventListener("load", checkControl, false);
$(function () {
    $.ajax({
        type: "post",
        url: "getAllRole.ashx",
        success: function (data) {
            var roleObj = $.parseJSON(data).role;
            var ul = $("#all-options");
            for (var i = 0; i < roleObj.length; i++) {
                var li = $("<li><label><input type=checkbox name=role value=" + roleObj[i].Name + " /><span>"
                    + roleObj[i].Description + "</span></label></li>");
                ul.append(li);
            }
        }
    });
});
var isAllgood;

function checkControl() {
    document.getElementById("postName").value = "false";
    document.getElementById("newsForm").addEventListener("submit", checkForm, false);
    document.getElementById("title").addEventListener("blur", checkTitle, false);
}

function Refresh(evt) {
    evt.preventDefault();
    window.location = 'Root-information.aspx';
}

function checkForm(evt) {
    isAllgood = true;
    var error = document.getElementById("titleError");
    error.innerHTML = "";
    document.getElementById("error").innerHTML = ""
    var allTags = document.getElementById("newsForm").getElementsByTagName('*');
    for (var i = 0; i < allTags.length; i++) {
        if (!checkEmpty(allTags[i])) {
            isAllgood = false;
        }
    }
    if (!isAllgood) {
        evt.preventDefault();
        return false;
    } else {
        document.getElementById("selectedRole").value = getSelectedRole();
        document.getElementById("postName").value = true;
    }
}

function checkEmpty(thisElement) {
    var titleError = document.getElementById("titleError");
    var error = document.getElementById("error");
    var newClassName = "";
    var allClassNames = thisElement.className.split(" ");
    for (var i = 0; i < allClassNames.length; i++) {
        newClassName += checkClassName(allClassNames[i], thisElement) + " ";
    }
    thisElement.className = newClassName;
    if (newClassName.indexOf("invalid") > -1) {
        if (thisElement.name == "title") {
            var title = thisElement.value;
            if (title == "") {
                titleError.innerHTML = "标题不能为空";
            }
            if (title.length > 45) {
                titleError.innerHTML = "标题过长"
            }
        } else if (thisElement.name == "mainText") {
            error.innerHTML = "内容不能为空";
        } else {
           error.innerHTML = "请选择可见角色";
           //document.getElementById("collapseOne").style.display = "block";
        }
        return false;
    }
    return true;
}

function checkClassName(thisClassName, thisElement) {
    var returnClassName = "";
    switch (thisClassName) {
        case "invalid":
        case "":
            break;
        case "isEmpty":
            if (isAllgood && thisElement.value == "") {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "roles":
            if (isAllgood && !checkSelectRole(thisElement)) {
                returnClassName += "invalid ";
            }
            returnClassName += thisClassName;
            break;
        case "title":
            if (isAllgood && thisElement.value.length > 45) {
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

function checkSelectRole(thisElement) {
    var Checked = false;
    var allSelected = thisElement.getElementsByTagName("INPUT");
    for (var i = 0; i < allSelected.length; i++) {
        if (allSelected[i].checked == true) {
            Checked = true;
            break;
        }
    }
    return Checked;
}

function checkTitle(evt) {
    clearClassName(this);
    var title = this.value;
    var error = document.getElementById("titleError");
    error.innerHTML = "";
    if (title == "") {
        error.innerHTML = "标题不能为空";
        this.className += " invalid";
        return;
    }
    if (title.length > 45) {
        error.innerHTML = "标题过长"
        this.className += " invalid";
        return;
    }
}

function clearClassName(thisElement) {
    var classNames = thisElement.className.split(" ");
    var rClassName = "";
    for (var i = 0; i < classNames.length; i++) {
        if (classNames[i] != "invalid") {
            rClassName += classNames[i] + " ";
        }
    }
    thisElement.className = rClassName;
}

function getSelectedRole() {
    var allRoles = document.getElementById("all-options").getElementsByTagName("INPUT");
    var strSelected = "";
    for (var i = 0; i < allRoles.length; i++) {
        if (allRoles[i].checked == true && allRoles[i].name == "role") {
            strSelected += allRoles[i].value + " ";
        }
    }
    return strSelected;
}