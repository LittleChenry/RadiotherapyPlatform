var obj = [];
var userJson = [];
var isChanging = false;//是否在编辑状态
var isExsit = 0;
var tempRemove = [];
var canEdit = false;
var removeObj = "";
var existCharger = false;

$(function () {
    GetGroupInformation();//获取分组信息,创建所有的分组表格
    GetUserInformation();

    InsertSelect(document.getElementById("charger"));
    $("#newGroup").bind("click", function () {
        tempRemove.length = 0;
        var charger = document.getElementById("charger");
        charger.options.length = 0;
        charger.options[0] = new Option("--请选择组长--");
        charger.options[0].value = "";
        InsertSelect(charger);
    });
    $("#addNewMember").bind("click", function () {
        $tr = $("<tr><th>组员</th><td><select class=form-control><option  value=>--请选择组员--</option></select><button type=button class=close>×</button><input type=hidden /></td></tr>");
        var temp = $(this).closest("tr").detach();
        $("#addGroup > tbody").append($tr).append(temp);
        var $select = $("#addGroup td > select:last");
        InsertSelect($select[0]);
        $select.bind("change", function (evt) {
            var uid = this.options[this.selectedIndex].value;
            var name = this.options[this.selectedIndex].innerText;
            checkWasInGroup(uid, $(this));
            cutSelected($(this), name, $(this).next().val());
        }).bind("click", function () {
            $(this).next().val(this.options[this.selectedIndex].value);
        });
        $select.next().bind("click", function (evt) {
            var id = $(this).prev().val();
            $(this).closest("tr").remove();
            for (var i = 0; i < tempRemove.length; i++) {
                if (tempRemove[i].ID == id) {
                    $("#addGroup select").not($select).append("<option value" + tempRemove[i].ID + ">" + tempRemove[i].Name + "</option>");//删除恢复逻辑
                    tempRemove.splice(i, 1);
                }
            }
        });
        return false;
    });
    $("#cannelButton").bind("click", function (evt) {
        resetAddModal();
    });
    $(":button.close").bind("click", function (evt) {
        resetAddModal();
    });
    $("#charger").bind("change", function (evt) {
        var uid = this.options[this.selectedIndex].value;
        var name = this.options[this.selectedIndex].innerText;
        checkWasInGroup(uid, $(this));
        cutSelected($(this), name, $(this).next().val());
    }).bind("click", function(){
        $(this).next().val(this.options[this.selectedIndex].value);
    });
    $("#sureAdd").bind("click", function () {
        var $selectedMember = $("#addGroup :selected");
        if ($selectedMember[0].value == "") {
            alert("请选择组长");
            return false;
        }
        var chargersid = "";
        var postAdd = []
        for (var i = 0; i < $selectedMember.length; ++i) {
            postAdd.push({ "Name": $selectedMember[i].innerText, "ID": $selectedMember[i].value });
            chargersid += $selectedMember[i].value + " ";
        }
        isCharger(chargersid)
        if (existCharger) {
            var conti = window.confirm("人员中有其他组组长是否继续？");
            if (conti == false)
                return false;
        }

        postNewGroup(postAdd);
        alert("新增成功");
    });

    $("#changeGroup").bind("click", function () {
        $(this).hide();
        $("#newGroup").hide();
        $("#closeEdite").show(150);
        canEdit = true;
    });

    $("#closeEdite").bind("click", function () {
        $(this).hide();
        $("#changeGroup").show(100);
        $("#newGroup").show(100);
        canEdit = false;
    });
    $("#tableArea").bind("click", function (evt) {
        if (canEdit == false)
            return false;
        removeObj = "";
        tempRemove.length = 0;
        var which = evt.target;
        if (which.nodeName != "TD" && which.nodeName != "TH")
            return false;
        var $chooseGroup = $(which).closest("table");
        $("#EditGroup").trigger("click");
        $("#editTable").empty().append($chooseGroup.clone());
        var $toSelect = $("#editTable td");
        for (var i = 1; i < $toSelect.length; i++) {
            var text = $toSelect[i].innerText;
            $toSelect[i].innerText = "";
            var newSelect = document.createElement("SELECT");
            newSelect.className = "form-control";
            InsertSelect(newSelect);
            findThisName(text, newSelect);           
            $($toSelect[i]).append($(newSelect)).append("<input type=hidden value=" + $toSelect[i].lastChild.value + " />");
            if (i != 1) {
                $($toSelect[i]).append("<button type=button class=close>×</button>");
            } else {
                newSelect.style.marginRight = "0.8em";
            }
            $($toSelect[i]).children(".close").bind("click", function () {
                $(this).closest("tr").remove();
            });
        }
        var allPrimMember = document.getElementById("editTable").getElementsByTagName("INPUT");
        for (var i = 0; i < allPrimMember.length; ++i) {
            removeObj += allPrimMember[i].value + " ";
        }
        $("#editTable").find("tbody").append("<tr><td colspan=2><a id=addNewMember2 href=#>添加成员</a></td></tr>");
        $("#addNewMember2").bind("click", function () {
            $tr = $("<tr><th>组员</th><td><select class=form-control><option  value=>--请选择组员--</option></select><button type=button class=close>×</button><input type=hidden /></td></tr>");
            var temp = $(this).closest("tr").detach();
            $("#editTable tbody").closest("tbody").append($tr).append(temp);
            var $select = $("#editTable td > select:last");
            InsertSelect($select[0]);
            $(this).closest("tr").prev().find(".close").bind("click", function () {
                $(this).closest("tr").remove();
            });
        });
    });
});

$(function () {
    $("#sureEdit").bind("click", function () {
        var groupID = $("#editTable td:eq(0)").text();
        var $selected = $("#editTable :selected");
        var changeObj = [];
        for (var i = 0; i < $selected.length; i++) {
            changeObj.push({ "ID": $selected[i].value, "Name": $selected[i].innerText });
        }
        changeObj.push({ "GroupID": groupID });
        var xmlHttp = new XMLHttpRequest();
        var url = "../../pages/Root/UpdateGroup.ashx";
        xmlHttp.open("POST", url, false);
        xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        var content = "data=" + toJsonString(changeObj)+"&delete="+ removeObj;
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                $("#tableArea").empty();
                GetGroupInformation();
                $("#cannelEdit").trigger("click");
            }
        }
        xmlHttp.send(content);
    });

    $("#deleteGroup").bind("click", function () {
        var gid = $("#editTable td:eq(0)").text();
        var xmlHttp = new XMLHttpRequest();
        var url = "../../pages/Root/DeleteGroup.ashx";
        xmlHttp.open("POST", url, false);
        xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
        var content = "data=" + gid + "&delete=" + removeObj;
        xmlHttp.onreadystatechange = function () {
            if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
                $("#tableArea").empty();
                GetGroupInformation();
                $("#cannelEdit").trigger("click");
            }
        }
        xmlHttp.send(content);
    });
});

$(function () {
    $("#search").bind("click", function () {
        var search = $("#GroupSearchID").val();
        if (search == "") {
            $("#tableArea").empty();
            CreateAllGroup();
            return false;
        }
        $("#tableArea").empty();
        CreateAllGroup(search);
    });
});

//重置新增表
function resetAddModal() {
    var firstChild = $("#addGroup > tbody").children("tr:first").clone(true);
    var lastChild = $("#addGroup > tbody").children("tr:last").clone(true);
    $("#addGroup > tbody").empty();
    $("#addGroup > tbody").append(firstChild).append(lastChild);
}

//创建所有分组
function CreateAllGroup(which) {
    if (obj.user[0].Name == "null") {
        return;
    }
    $("#tableArea").empty();
    var currentGroupID = -1;
    var $currentTable = $("<table id=table0 style=width:100%><tbody></tbody></table>");
    $("#tableArea").append($currentTable);
    var $currentTr = $("<tr></tr>");
    $currentTable.append($currentTr);
    var currentcols = 0;
    var currentRows = 0;
    for (var i = 0; i < obj.user.length; ++i) {
        var group_id = obj.user[i].GroupID;
        if (which != null && which != undefined) {
            if (!isNaN(which) && group_id != which) {
                continue;
            }
            if (isNaN(which) && obj.user[i].Name.indexOf(which) == -1) {
                continue;
            }
        }
        if (currentGroupID != group_id) {
            var charger = FindCharger(group_id);
            if (charger == "false")
                return;
            currentGroupID = group_id;
            $table = CreateOneGroup(charger, i, currentGroupID);
            if (currentRows >= 4) {
                //$currentTable = $("<table id=table1 style=width:100%><tbody></tbody></table>");
                //currentRows = 0;
            }
            if (currentcols >= 4) {
                $currentTr = $("<tr></tr>");
                $currentTable.append($currentTr);
                currentRows++;
                currentcols = 0;
            }
            $td = $("<td></td>").append($table);
            $currentTr.append($td);
            $currentTr.append("<td><div class=tableInterval></div></td>");
            currentcols++;
        }
    }
    //$("#tableArea table").append("<tbody id=tempbody></tbody>");
}

//获取所有分组信息
function GetGroupInformation() {
    $.ajax({
        type: "GET",
        url: "../../pages/Root/GetGroupInformation.ashx",
        dateType: "text",
        success: function (date) {
            obj = $.parseJSON(date);
            CreateAllGroup();
        }
    });
}

//二分搜索寻找组负责人
function FindCharger(gid) {
    var left = 0;
    var right = obj.group.length - 1;
    while (left <= right) {
        var mid = parseInt((left + right) / 2);
        var id = obj.group[mid].ID;
        if (id == gid) {
            return { "Name": obj.group[mid].Name, "ID": obj.group[mid].UID };
        } else if (parseInt(id) < parseInt(gid)) {
            left = mid + 1;
        } else if (parseInt(id) > parseInt(gid)) {
            right = mid - 1;
        }
    }
    return "false";
}

//创建一组
function CreateOneGroup(charger, index, currentID) {
    $table = $("<table name=group><tbody></tbody></table>");
    $table.append($("<tr><th style=padding-top:1em;padding-left:2em;padding-bottom:1em;padding-right:2em>组号</th><td style=padding-top:1em;padding-left:2.5em;padding-bottom:1em;padding-right:2.5em>" + currentID + "</td></tr><tr><th style=padding-top:1em;padding-left:2em;padding-bottom:1em;padding-right:2em>组长</th><td style=padding-top:1em;padding-left:2.5em;padding-bottom:1em;padding-right:2.5em>" + charger.Name + "<input type=hidden value=" + charger.ID + "</td></tr>"));
    $table.addClass("table table-bordered table-center table-hover");
    for (var i = index; i < obj.user.length; ++i) {
        if (obj.user[i].GroupID == currentID && obj.user[i].Name != charger.Name) {
            $tr = $("<tr><th style=padding-top:1em;padding-left:2em;padding-bottom:1em;padding-right:2em>组员</th><td style=padding-top:1em;padding-left:2.5em;padding-bottom:1em;padding-right:2.5em>" + obj.user[i].Name + "<input type=hidden value=" + obj.user[i].UID + "></td></tr>");
            $table.append($tr);
        }
    }
    return $table;
}

//获取所有激活有医生角色的用户名
function GetUserInformation() {
    $.ajax({
        type: "GET",
        url: "../../pages/Root/GetUserInformation.ashx",
        dateType: "text",
        async: false,
        success: function (data) {
            userJson = $.parseJSON(data);
        }
    });
}

//给select插入option
function InsertSelect(select) {
    for (var i = 0; i < userJson.length; ++i) {
        //var selected = $("#addGroup select :selected").val();
        if (!inSelected(userJson[i].ID)) {
            select.options[select.options.length] = new Option(userJson[i].Name);
            select.options[select.options.length - 1].value = userJson[i].ID;
        } //else {
            //tempRemove.push($("<option value=" + userJson[i].ID + ">" + userJson[i].Name + "</>"))
        //}
    }
}

function inSelected(id) {
    for (var i = 0; i < tempRemove.length; i++) {
        if (id == tempRemove[i].ID) {
            return true;
        }
    }
    return false;
}

//验证该角色是否有组了
function checkWasInGroup(id, $select) {
    var $error = $("#error");
    $.ajax({
        type: "GET",
        url: "../../pages/Root/CheckWasInGroup.ashx?id=" + id,
        dateType: "text",
        success: function (data) {
            if (data == "true") {
                $select.addClass("warning");
                $error.text("有成员目前已经有组");
                $error.show("fast");
                isExsit++;
            } else {
                if ($select.attr("class").indexOf("warning") > -1) {
                    $select.removeClass("warning");
                    --isExsit;
                    if (isExsit <= 0) {
                        $error.hide();
                        $error.text("");
                    }
                }
            }
        }
    });
}

function cutSelected($select, name, preID) {
    var id = $select.children(":selected").val();
    tempRemove.push({ "ID": id, "Name": name });
    var $allOptions = $("#addGroup select").not($select).children("option");
    for (var i = 0; i < $allOptions.length; ++i) {
        if ($allOptions[i].innerText == name) {
            $($allOptions[i]).remove();
        }
    }
    if (preID == "")
        return;
    for (var i = 0; i < tempRemove.length; i++) {
        if (tempRemove[i].ID == preID) {
            $("#addGroup select").not($select).append("<option value" + tempRemove[i].ID + ">" + tempRemove[i].Name + "</option>");//删除恢复逻辑
            tempRemove.splice(i, 1);
        }
    }
}

function postNewGroup(postAdd) {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/AddNewGroup.ashx";
    xmlHttp.open("POST", url, true);
    xmlHttp.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    var content = "data=" + toJsonString(postAdd);
    xmlHttp.onreadystatechange = function () {
        if(xmlHttp.readyState == 4 && xmlHttp.status == 200)
        window.location = '../../pages/Root/Root-Group.aspx';
    }
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

function findThisName(text,newSelect) {
    for (var i = 0; i < newSelect.options.length; i++) {
        if (text == newSelect.options[i].innerText) {
            newSelect.options[i].selected = true;
            break;
        }
    }
}

function isCharger(postAdd) {
    $.ajax({
        type: "GET",
        url: "../../pages/Root/isCharger.ashx?data=" + postAdd,
        dateType: "text",
        async: false,
        success: function (data) {
            if (data == "true")
                existCharger = true;
            else
                existCharger = false;
        }
    });
}