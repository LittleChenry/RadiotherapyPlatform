/**
 * 1.获取分组数据生成分组表格
 * 2.新增分组(新增分组按钮出现新增界面功能已在模板中)
 *   2.1 ajax获取所有用户
 *   2.2 把用户作为选项插入到选择组长的下拉菜单中(value=用户id，text=用户名)
 *   2.3 点击新增成员生成一行(包含标头:用户,下拉菜单选择用户,X按钮删除该行)，为生成行中的下拉菜单加入所有用户作为选项(value=用户id，text=用户名)
 *   2.4 点击取消时删除除了选择组长的第一行外所有行
 *   2.5 点击确定时将数据录入(ajax)
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
    var max = maxMembers[page - 1];//该页最多多少列
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
 			+ groupJsonObj[i].gid + " /></td><td>" + groupJsonObj[i].chargerName
 			+ "<input type=hidden value=" + groupJsonObj[i].chargerID + " /></td>");
            groupID = groupJsonObj[i].gid;
        }
        $tr.append("<td>" + groupJsonObj[i].userName + "<input type=hidden value=" + groupJsonObj[i].userID + " /></td>");
        currentRowcols++;
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