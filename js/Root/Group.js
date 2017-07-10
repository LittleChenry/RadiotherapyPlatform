/**
 * 1.获取分组数据生成分组表格
 **/

var groupJsonObj = [];//后台读取的分组信息json对象
var rows = new Array();//一共有多少组
var maxMembers = new Array();//最多成员组成员人数

/**
 * 获取分组数据 -> 1.1
 **/
$(function () {
    $.ajax({
        type: "get",
        url: "../../pages/Root/GetGroupInformation.ashx",
        dataType: "text",
        async: false,
        success: function (data) {
            groupJsonObj = $.parseJSON(data);
            countGroups(groupJsonObj);
            //创建分组表格
            createGroupTable(1);

            //计算并设置总页数           
            $("#sumPage").val(rows.length);
        }
    });
});

/*
 * 创建分组表格 -> 1.2
 * @param group 分组数据(json对象)
 * @Param page 创建第几页,每页12个
 **/
function createGroupTable(page) {
    if (groupJsonObj.length == 0) {
        return;
    }

    var $groupArea = $("#groupArea");
    var groupID = "-1";
    var $tr = null;
    var currentLength = 0;//当前页面表格行数
    var max = maxMembers[page - 1] - 2;//该页最多多少列
    var currentRowcols = 0;

    $groupArea.empty();//清空页面区域

    for (var i = rows[page - 1] + 1; currentLength < 12 && i < groupJsonObj.length; ++i) {
        if (groupID != groupJsonObj[i].gid) {
            ++currentLength;
            if ($tr != null) {
                for (var j = currentRowcols; j < max; j++) {
                    $tr.append("<td>&nbsp;</td>");
                }
                $groupArea.append($tr);
            }
            currentRowcols = 0;
            $tr = $("<tr></tr>");
            $tr.append("<td>" + groupJsonObj[i].groupName + "<input type=hidden value="
 			+ groupJsonObj[i].gid + " /></td><td>" + groupJsonObj[i].userName
 			+ "<input type=hidden value=" + groupJsonObj[i].userID + " /></td>"
            + "<td>" + groupJsonObj[++i].userName + "<input type=hidden value=" + groupJsonObj[i].userID + " /></td>");
            groupID = groupJsonObj[i].gid;
        } else {
            $tr.append("<td>" + groupJsonObj[i].userName + "<input type=hidden value=" + groupJsonObj[i].userID + " /></td>");
            currentRowcols++;
        }
    }
    for (var j = currentRowcols; j < max; j++) {
        $tr.append("<td>&nbsp;</td>");
    }
    $groupArea.append($tr);//插入最后一行
}

/**
 * 计算一共有多少组,同时计算最多成员组成员数 -> 1
 * @param group 分组数据json对象
 * @return max 最多成员组成员数
 **/
function countGroups(group) {
    var currentGid = -1;//当前组id
    var currentLength = 0;
    var currentcounts = 0;//当前是第几条记录
    var max = 0;//最多成员的一组有多少成员
    var preGroupCount = 0;//这一组下标起始位置
    rows.push(-1);
    for (var i = 0; i < group.length; i++) {
        if (currentGid != group[i].gid) {
            ++currentLength;
            max = max < (currentcounts - preGroupCount) ? (currentcounts - preGroupCount) : max;
            preGroupCount = currentcounts;
            currentGid = group[i].gid;
        }
        if (currentLength == 12) {
            rows.push(currentcounts);
            maxMembers.push(max);
            max = 0;
            currentLength = 0;
        }
        currentcounts++;
    }
    if (currentLength != 12) {
        max = max < (currentcounts - preGroupCount) ? (currentcounts - preGroupCount) : max;
        maxMembers.push(max);
    }
}

//翻页
/**
 * 初始翻页事件绑定
 */
$(function () {
    var sumPage = $("#sumPage").val();
    if (parseInt(sumPage) > 1) {
        nextPage();
        lastPage();
    }
});

/**
 * 绑定首页按钮事件
 * 1.设置当前页数为1
 * 2.创建第一页内容
 * 3.样式上首页，上一页按钮不可用，下一页末页按钮可用
 * 4.解绑首页上一页点击事件，绑定末页下一页事件
 */
function firstPage() {
    $("#firstPage").removeClass("disabled").bind("click", function () {
        $("#currentPage").val(1);

        createGroupTable(1);

        $("#firstPage").addClass("disabled");
        $("#prePage").addClass("disabled");
        $("#nextPage").removeClass("disabled");
        $("#lastPage").removeClass("disabled");

        $(this).unbind("click");
        $("#prePage").unbind("click");
        nextPage();
        lastPage();
    });
}

/**
 * 绑定上一页按钮点击事件
 * 1.获取当前页数并设置当前页数为当前页数-1
 * 2.创建页面内容
 * 3.判断当前页数是否为首页
 *     3.1如果是首页，上一页按钮不可用，并且解绑点击事件
 * 4.判断翻页前页数是否是末页
 *     4.1如果是下一页末页样式可用，绑定点击事件
 */
function prepage() {
    $("#prePage").removeClass("disabled").bind("click", function () {
        var currentPage = parseInt($("#currentPage").val());
        $("#currentPage").val(currentPage - 1);

        createGroupTable(currentPage - 1);

        if ((currentPage - 1) == 1) {
            $("#firstPage").addClass("disabled")
						   .unbind("click");
            $(this).addClass("disabled")
	        	   .unbind("click");
        }

        if (currentPage == parseInt($("#sumPage").val())) {
            nextPage();
            lastPage();
        }
    });
}

/**
 * 绑定下一页事件
 * 1.获取当前页数，计算下一页并设置给当前页数
 * 2.创建页面
 * 3.如果下一页是末页，下一页末页按钮样式不可用解绑点击事件
 * 4.如果当前页是首页，绑定首页，上一页
 */
function nextPage() {
    $("#nextPage").removeClass("disabled").bind("click", function () {
        var currentPage = parseInt($("#currentPage").val());
        $("#currentPage").val(currentPage + 1);

        createGroupTable(currentPage + 1);

        if ((currentPage + 1) == parseInt($("#sumPage").val())) {
            $(this).addClass("disabled")
				   .unbind("click");
            $("#lastPage").addClass("disabled")
		    			  .unbind("click");
        }

        if (currentPage == 1) {
            firstPage();
            prepage();
        }
    });
}

/**
 * 绑定末页事件
 * 1.设置当前页为末页
 * 2.创建页面
 * 3.解绑末页下一页，样式不可用
 * 4.绑定上一页首页，样式可用
 */
function lastPage() {
    $("#lastPage").removeClass("disabled").bind("click", function () {
        var last = parseInt($("#sumPage").val());
        $("#currentPage").val(last);

        createGroupTable(parseInt(last));

        $("#nextPage").addClass("disabled")
 					  .unbind("click");
        $(this).addClass("disabled")
 			   .unbind("click");

        firstPage();
        prepage();
    });
}

/**
 * 2.新增分组(新增分组按钮出现新增界面功能已在模板中)
 *   2.1 ajax获取所有用户
 *   2.2 把用户作为选项插入到选择组长的下拉菜单中(value=用户id，text=用户名)
 *   2.3 点击新增成员生成一行(包含标头:用户,下拉菜单选择用户,X按钮删除该行)，为生成行中的下拉菜单加入所有用户作为选项(value=用户id，text=用户名)
 *   2.4 点击取消时删除除了选择组长的第一行外所有行
 *   2.5 点击确定时将数据录入(ajax)
 */

var allUser = [];//存放所有用户

/**
 * 2.1 获取所有用户
 */
$(function () {
    $.ajax({
        type: "get",
        url: "../../pages/Root/GetUserInformation.ashx",
        dataType: "text",
        async: false,
        success: function (data) {
            allUser = $.parseJSON(data);
            fillSelect($("#charger"));//填入组长下拉菜单
            fillSelect($("#higher"));//填入高资历下拉菜单
            //绑定增加成员点击事件
            $("#addNewMember").bind("click", function () {
                addNewMember($(this));                
            });
            //取消点击事件
            $("#cannelButton").bind("click", function () {
                cannelAddGroup();
            });
            //确定增加事件
            $("#sureAdd").bind("click", function () {
                sureAddGroup();
            });
        }
    });
});

/*
 * 把用户作为选项插入到下拉菜单中(value=用户id，text=用户名)
 * @param $select 带填入下拉菜单
 */
function fillSelect($select) {
    for (var i = 0; i < allUser.length; ++i) {
        $select.append("<option value=" + allUser[i].ID + " >" + allUser[i].Name + "</option>");
    }
}

/**
 * 增加一个成员选择栏
 * @param $add 增加成员按钮
 */
function addNewMember($add) {
    var $tr = $add.closest("tr");
    var element = "<tr><th>组员<input type=button class=close value=× /></th><td>"
        + "<select class=form-control style=margin-right:0.8em >"
        + "<option value=\"\">--请选择组员--</option>";
    for (var i = 0; i < allUser.length; ++i) {
        element += "<option value=" + allUser[i].ID + ">" + allUser[i].Name + "</option>";
    }
    element += "</td></tr>";    
    $tr.before(element);
    var $deleteButton = $tr.prev("tr").find(".close");
    $deleteButton.bind("click", function () {
        $deleteButton.closest("tr").remove();        
    });
}

/**
 * 取消增加组
 * 
 */
function cannelAddGroup() {
    $("#addGroup > tbody").children("tr:first").find("input").val("");
    var firstChild = $("#addGroup > tbody").children("tr:first").clone();
    var secondChild = $("#addGroup > tbody").children("tr:eq(1)").clone(true);
    var thirdChild = $("#addGroup > tbody").children("tr:eq(2)").clone(true);
    var lastChild = $("#addGroup > tbody").children("tr:last").clone(true);
    $("#addGroup > tbody").empty();
    $("#addGroup > tbody").append(firstChild).append(secondChild).append(thirdChild).append(lastChild);
}

/**
 * 确定新增一组
 */
function sureAddGroup() {
    var $selectedMember = $("#addGroup :selected");
    if ($("#groupName").val() == "") {
        alert("请填写组名");
        return false;
    }
        if ($selectedMember[0].value == "") {
            alert("请选择高资历");
            return false;
        }
        if ($selectedMember[1].value == "") {
            alert("请选择组长");
            return false;
        }

        var postAdd = []
        for (var i = 0; i < $selectedMember.length; ++i) {
            postAdd.push({ "Name": $selectedMember[i].innerText, "ID": $selectedMember[i].value });
        }

        postNewGroup(postAdd, $("#groupName").val());

}

/**
 * 后台处理新增一组事件
 */
function postNewGroup(postAdd, name) {
    $.ajax({
        type: "post",
        url: "AddNewGroup.ashx",
        data: { "data": toJsonString(postAdd), "name": name },
        success:function(){
            alert("新增成功");
            window.location.href = "../../pages/Root/Root-Group.aspx";
        }
    });
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

/**
 * 搜索功能
 * 1.获取搜索栏内容
 * 2.根据内容对分组对象查找找到则压入数组
 * 3.找到则克隆并压入数组
 * 4.如果为空则直接刷新界面
 * 5.根据数组创建界面
 */

var searchArray = new Array();

$(function () {
    //搜索状态下复原全部显示（刷新）
    $("#searchRecover").bind("click", function () {
        window.location.href = "../../pages/Root/Root-Group.aspx";
    });

    $("#search").bind("click", function () {
        var searchText = $("#GroupSearchID").val();
        searchArray.length = 0;//清空

        if (searchText == "") {
            window.location.href = "../../pages/Root/Root-Group.aspx";
            return;
        }
        searchArray.length = 0;//清空
        getSearch(searchText);//获取符合搜索条件的对象
        createSearchTable();//根据符合条件对象生成搜索结果
    });

    $("#GroupSearchID").bind("input", function () {
        var searchText = $("#GroupSearchID").val();
        if (searchText == "") {
            window.location.href = "../../pages/Root/Root-Group.aspx";
            return;
        }
        searchArray.length = 0;//清空

        getSearch(searchText);//获取符合搜索条件的对象
        createSearchTable();//根据符合条件对象生成搜索结果
    });
})

/**
 * 获取符合搜索条件的对象
 * @param text 搜索条件
 */
function getSearch(text) {    
    var startIndex = 0;//该组开始的对象下标
    var currentGid = -1;//当前对象组id
    var begin = 0;

    while (begin < groupJsonObj.length) {
        if (currentGid != groupJsonObj[begin].gid) {
            currentGid = groupJsonObj[begin].gid;
            startIndex = begin;
        }
        if (groupJsonObj[begin].groupName.indexOf(text) > -1 || groupJsonObj[begin].userName.indexOf(text) > -1) {
            begin = pushGroup(startIndex);//压入组返回结束位置 + 1
        } else {
            ++begin;
        }
    }
}

/**
 * 压入组返回结束位置+1
 * @param startIndex 组开始下标
 * @return 组结束位置+1
 */
function pushGroup(startIndex) {
    if (startIndex >= groupJsonObj.length)
        return;
    var currentGid = groupJsonObj[startIndex].gid;
    while (startIndex < groupJsonObj.length && currentGid == groupJsonObj[startIndex].gid) {
        searchArray.push(groupJsonObj[startIndex]);
        ++startIndex;
    }
    return startIndex;
}

/**
 * 根据符合条件数组生成结果视图
 */
function createSearchTable() {
    var $groupArea = $("#groupArea");
    if (searchArray.length == 0) {
        $groupArea.empty();
        return;
    }

    var groupID = -1;
    var $tr = null;
    var currentRowcols = 0;
    var max = countMax() - 2;

    $groupArea.empty();
    $("#pageButton").hide();
    $("#searchRecover").show();

    for (var i = 0; i < searchArray.length; ++i) {
        if (groupID != searchArray[i].gid) {
            if ($tr != null) {
                for (var j = currentRowcols; j < max; j++) {
                    $tr.append("<td>&nbsp;</td>");
                }
                $groupArea.append($tr);
            }
            currentRowcols = 0;
            $tr = $("<tr></tr>");
            $tr.append("<td>" + searchArray[i].groupName + "<input type=hidden value="
 			+ searchArray[i].gid + " /></td><td>" + searchArray[i].userName
 			+ "<input type=hidden value=" + searchArray[i].userID + " /></td>"
            + "<td>" + groupJsonObj[++i].userName + "<input type=hidden value=" + groupJsonObj[i].userID + " /></td>");
            groupID = searchArray[i].gid;
        } else {
            $tr.append("<td>" + searchArray[i].userName + "<input type=hidden value=" + searchArray[i].userID + " /></td>");
            currentRowcols++;
        }
    }
    $groupArea.append($tr);
}

function countMax() {
    var max = 1;
    var current = 0;
    var gid = -1;

    for (var i = 0; i < searchArray.length; ++i) {
        if (gid != searchArray[i].gid) {
            max = max < current ? current : max;
            gid = searchArray[i].gid;
            current = 0;
        }
        current++;
    }
    return max < current ? current : max;
}

/**
 * 编辑分组包括修改和删除
 * 1.点击编辑进入编辑状态
 * 2.编辑状态下可以点击某行来对其进行编辑
 * 3.
 */

var $currentTr = null;
var idStr = ""//记录该组当前所有角色id

/**
 * 点击编辑进入编辑状态
 * 1.隐藏编辑和新增按钮，显示结束编辑按钮
 * 2.table绑定点击事件点击对一组进行编辑
 * 3.结束编辑隐藏结束编辑按钮显示编辑和新增按钮，解除table的点击事件
 */
$(function () {
    $("#changeGroup").bind("click", function () {
        $(this).hide();
        $("#newGroup").hide();
        $("#closeEdite").fadeIn(360);
        $("#groupArea").bind("click", function (evt) {
            var which = evt.target;
            var $tr = $(which).closest("tr");
            $currentTr = $tr;
            editGroup($tr);
            $("#EditGroup").trigger("click");
        });
    });
    $("#closeEdite").bind("click", function () {
        $("#groupArea").unbind("click");
        $(this).hide();
        $("#changeGroup").fadeIn(360);
        $("#newGroup").fadeIn(360);
    })
});

/**
 * 点击某行对该组编辑
 * @param $tr 待编辑组所在行
 */
function editGroup($tr) {
    var $editArea = $("#editArea");
    $editArea.empty();

    $tds = $tr.find("td");

    $editArea.append("<tr><th>组名</td><th><input type=text class=form-control style=margin-right:0.8em value=" + $tds[0].innerText + " /><input type=hidden value=" + $($tds[0]).find(":hidden").val() + " /></td></tr>")
             .append("<tr><th id=editHigher>高资历</th></tr>")
             .append("<tr><th id=editCharger>组长</th></tr>");
    var $select = $("<select class=form-control style=margin-right:0.8em></select>");

    for (var i = 0; i < allUser.length; ++i) {
        $select.append("<option value=" + allUser[i].ID + " >" + allUser[i].Name + "</option>");
    }

    $td = $("<td></td>");
    $td.append($select.clone(true).val($($tds[1]).find("input").val()));
    $td.append("<input type=hidden value=" + $($tds[1]).find(":hidden").val() + " />");
    $editArea.find("#editHigher").after($td);

    $td = $("<td></td>");
    $td.append($select.clone(true).val($($tds[2]).find("input").val()));
    $td.append("<input type=hidden value=" + $($tds[2]).find(":hidden").val() + " />");
    $editArea.find("#editCharger").after($td);

    for (var i = 3; i < $tds.length; ++i) {
        if ($tds[i].innerHTML == "&nbsp;") {
            continue;
        }
        if ($($tds[i]).find(":hidden").val() == $($tds[1]).find(":hidden").val()) {
            continue;
        }
        $grouptr = $("<tr><th>组员<input type=button class=close value=× /></th></tr>")
        $grouptd = $("<td></td>");
        $hide = $("<input type=hidden value=" + $($tds[i]).find(":hidden").val() + " />");
        $grouptd.append($select.clone(true).val($($tds[i]).find("input").val()))
                .append($hide);
        $grouptr.append($grouptd);
        $editArea.append($grouptr);
    }

    var ids = $("#editArea").find("input[type=hidden]");
    idStr = "";
    for (var i = 0; i < ids.length; ++i) {
        idStr += ids[i].value + " ";
    }

    $editArea.find(".close").bind("click", function () {
        $(this).closest("tr").remove();
    });

    $editArea.append("<tr><td colspan=2><a id=editAddNewMember href=#>添加成员</a></td></tr>");
    $("#editAddNewMember").bind("click", function () {
        addNewMember($(this));
    });
};

/**
 * 删除组处理
 */
$(function () {
    $("#deleteGroup").bind("click", function () {
        //var groupID = $("#editArea").find("td:first").find(":hidden").val();

        $.ajax({
            type: "post",
            url: "../../pages/Root/DeleteGroup.ashx",
            data: {"ids" :idStr},
            success: function () {
                alert("删除成功");
                $currentTr.remove();
                //deleteJsonObj(idStr.split(" ")[0]);
                updateView();
                $("#cannelEdit").trigger("click");
            }
        });
    });
});

function deleteJsonObj(id) {
    var cont = true;
    for (var i = 0; i < groupJsonObj.length; i++) {
        if (groupJsonObj[i].gid == id) {
            groupJsonObj.splice(i, 1);
            cont = false;
        } else if (groupJsonObj[i].gid != id && cont == false) {
            break;
        }
    }
}

/**
 * 修改组
 */
$(function () {
    $("#sureEdit").bind("click", function () {
        var str = "";
        var $editArea = $("#editArea");
        var groupName = $editArea.find("input[type=text]").val();
        var members = $editArea.find(":selected");
        for (var i = 0; i < members.length; ++i) {
            str += members[i].value + " ";
        }

        $.ajax({
            type: "post",
            url: "../../pages/Root/UpdateGroup.ashx",
            data: { "pre": idStr, "now": str, "name":groupName },
            success: function () {
                alert("修改成功");
                //window.location.href = "../../pages/Root/Root-Group.aspx";
                updateView();
            }
        });
    });
});

function updateView() {
    $.ajax({
        type: "get",
        url: "../../pages/Root/GetGroupInformation.ashx",
        dataType: "text",
        async: false,
        success: function (data) {
            groupJsonObj = $.parseJSON(data);
            countGroups(groupJsonObj);
            //创建分组表格
            createGroupTable(parseInt($("#currentPage").val()));

            //计算并设置总页数           
            $("#sumPage").val(rows.length);
            $("#cannelEdit").trigger("click");
        }
    });
}