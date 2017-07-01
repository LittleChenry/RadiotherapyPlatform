/**
 * 初始界面显示Part表
 * 用户根据下拉菜单选择需要展示的表(下拉菜单value=数据库表名，text=中文描述)
 * 点击确定生成表单
 * 
 * 各个表单翻页处理
 * 1.每个表单写一个生成指定页函数
 * 2.每页12行根据行数算出总页数
 * 3.全局变量jsonObj记录当前表格数据
 *
 * 新增处理
 * 选择表格时根据表格生成新增表格
 */

var jsonObj = [];//记录当前表数据
var currentTable = "part";//记录当前是哪张表
var currentlength = 0;

//初始默认生成part表格
$(function () {
    createPart(1);
});

/**
 * 根据下拉菜单选项生成对应表格
 */
$(function () {
    $("#sureTable").bind("click", function () {
        var selectedTable = $("#tableSelect").val();

        $(".panel-title").text($("#tableSelect :selected").text());

        currentTable = selectedTable;//设定当前是哪张表

        //翻页按钮和当前页数初始化
        $("#currentPage").val(1);
        $("#firstPage").unbind("click").attr("class", "btn btn-primary btn-sm disabled");
        $("#prePage").unbind("click").attr("class", "btn btn-primary btn-sm disabled");
        $("#nextPage").unbind("click").attr("class", "btn btn-primary btn-sm disabled");
        $("#lastPage").unbind("click").attr("class", "btn btn-primary btn-sm disabled");

        selectCreate(selectedTable, 1);
    });
});

/**
 * 根据选择创建对应视图
 * @param 待创建的视图
 * @page 创建第几页
 */
function selectCreate(type,page) {
    switch (type) {
        case "part":
            createPart(page);
            break;
        case "DiagnosisResult":
            createDiagnosisResult(page);
            break;
        case "FixedEquipment":
            createFixedEquipment(page);
            break;
        case "FixedRequirements":
            createFixedRequirements(page);
            break;
        case "ScanPart":
            createScanPart(page);
            break;
        case "ScanMethod":
            createScanMethod(page);
            break;
        case "EnhanceMethod":
            createEnhanceMethod(page);
            break;
        case "LocationRequirements":
            createLocationRequirements(page);
            break;
        case "DensityConversion":
            createDensityConversion(page);
            break;
        case "EndangeredOrgan":
            createEndangeredOrgan(page);
            break;
        case "Technology":
            createTechnology(page);
            break;
        case "PlanSystem":
            createPlanSystem(page);
            break;
        case "Grid":
            createGrid(page);
            break;
        case "Algorithm":
            createAlgorithm(page);
            break;
        case "ReplacementRequirements":
            createReplacementRequirements(page);
            break;
        default:
            break;
    }
}

/**
 * 计算表格最大页数（12行1页)
 * @param size 数据行数
 * @return 最大页数
 */
function countSumPage(size) {
    var temp = parseInt(size / 12);
    var sumPages = size / 12 - temp == 0 ? temp : temp + 1;
    return sumPages;
}

/**
 * 选择创建那个表的哪一页
 */
function createPage(page) {
    switch (currentTable) {
        case "part":
            createPartTable(page);
            break;
        case "DiagnosisResult":
            createDiagnosisResultTable(page);
            break;
        case "FixedEquipment":
            createFixedEquipmentTable(page);
            break;
        case "FixedRequirements":
            createFixedRequirementsTable(page);
            break;
        case "ScanPart":
            createScanPartTable(page);
            break;
        case "ScanMethod":
            createScanMethodTable(page);
            break;
        case "EnhanceMethod":
            createEnhanceMethodTable(page);
            break;
        case "LocationRequirements":
            createLocationRequirementsTable(page);
            break;
        case "DensityConversion":
            createDensityConversionTable(page);
            break;
        case "EndangeredOrgan":
            createEndangeredOrganTable(page);
            break;
        case "Technology":
            createTechnologyTable(page);
            break;
        case "PlanSystem":
            createPlanSystemTable(page);
            break;
        case "Grid":
            createGridTable(page);
            break;
        case "Algorithm":
            createAlgorithmTable(page);
            break;
        case "ReplacementRequirements":
            createReplacementRequirementsTable(page);
            break;
        default:
            break;
    }
}

/**
 * 新增取消按钮事件
 */
$(function () {
    $("#cannelButton").bind("click", function () {
        $("#addrow").find(":input").val("");
    });
});

/**
 * 新增确定事件
 */
$(function () {
    $("#sureAdd").bind("click", function () {
        var input = $("#addrow").find(":input");
        var text = "";
        for (var i = 0; i < input.length; ++i) {
            text += input[i].value + " ";
        }
        $.ajax({
            type: "post",
            url: "addParameter.ashx",
            data: { "type": currentTable, "value": text },
            success: function () {
                alert("新增成功");
                selectCreate(currentTable, parseInt($("#currentPage").val()));
                if (currentlength % 12 == 0) {
                    $("#sumPage").val(countSumPage(currentlength + 1));
                    initBindPage();
                }
                currentlength++;
                $("#cannelButton").trigger("click");
            }
        });
    });
});


/**
 * 编辑处理
 */
$(function () {
    $("#changeGroup").bind("click", function () {
        $(this).hide();
        $("#newGroup").hide();
        $("#closeEdite").fadeIn(360);
        $("#parameterTable").bind("click", function (evt) {
            var which = evt.target;
            var $tr = $(which).closest("tr");
            editParameter($tr);
            $("#EditGroup").trigger("click");
        });
    });
    $("#closeEdite").bind("click", function () {
        $("#parameterTable").unbind("click");
        $(this).hide();
        $("#changeGroup").fadeIn(360);
        $("#newGroup").fadeIn(360);
    })
});

/**
 *编辑对话框初始化
 */
function editParameter($tr) {
    var editArea = $("#editArea");
    editArea.empty();

    var val = $tr.find("td");
    var value = "";
    for(var i = 0;i < val.length;++i){
        value += val[i].innerText + " ";
    }
    var values = value.split(' ');

    var $head = $("#thead").find("th");
    var head = "";
    for (var i = 0; i < $head.length; ++i) {
        head += $head[i].innerText + " ";
    }
    var heads = head.split(" ");

    $("#editID").val($tr.find("td :hidden").val());
    for (var i = 0; i < heads.length - 1; ++i) {
        editArea.append("<tr><th>"
                               + heads[i]
                               + "</th><td><input class=form-control type=text value="
                               + values[i]
                               + " /></td></tr>");
    }
}

/**
 * 确认修改
 */
$(function () {
    $("#sureEdit").bind("click", function () {
        sureEdit();
    });
});

function sureEdit() {
    var $input = $("#editArea").find("input[type=text]");
    var id = $("#editID").val();

    var val = "";
    for (var i = 0; i < $input.length; ++i) {
        val += $input[i].value + " ";
    }

    $.ajax({
        type: "post",
        url: "../../pages/Root/parameterEdit.ashx",
        data: { "type": currentTable, "id": id, "value": val },
        success: function () {
            alert("修改成功");
            selectCreate(currentTable, parseInt($("#currentPage").val()));
            $("#cannelEdit").trigger("click");
        }
    });
}

/**
 * 翻页事件
 */
function initBindPage() {
    var sumPages = $("#sumPage").val();
    if (parseInt(sumPages) > 1) {
        nextPage();
        lastPage();
    }
}

/**
 * 首页事件
 * 1.绑定首页按钮事件
 * 2.创建当前表格首页
 * 3.设定当前页为首页
 * 4.解绑并取消首页上一页
 * 5.如果是从最后一页操作的末页下一页绑定
 */
function firstPage() {
    $("#firstPage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        createPage(1);
        $("#currentPage").val(1);
        $(this).unbind("click").addClass("disabled");
        $("#prePage").unbind("click").addClass("disabled");

        if (currentPage == $("#sumPage").val()) {
            nextPage();
            lastPage();
        }
    });
}

/**
 * 上一页绑定
 * 1.读取当前页数
 * 2.绑定按钮
 * 3.算出上一页
 * 4.生成视图
 * 5.更新当前页码
 * 6.如果当前为首页解绑首页上一页
 * 7.如果原来是末页解绑下一页末页
 */
function prePage() {
    $("#prePage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        var prePage = currentPage - 1;
        createPage(prePage);
        $("#currentPage").val(prePage);

        if (prePage == 1) {
            $(this).addClass("disabled").unbind("click");
            $("#firstPage").addClass("disabled").unbind("click");
        }

        if (currentPage == parseInt($("#sumPage").val())) {
            nextPage();
            lastPage();
        }
    });
}

/**
 * 下一页
 * 1.读取当前页数
 * 2.绑定按钮
 * 3.算出下一页
 * 4.生成视图
 * 5.更新当前页
 * 6.如果当前是末页解绑下一页末页
 * 7.如果原来是首页绑定首页上一页
 */
function nextPage() {
    $("#nextPage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        if (currentPage == $("#sumPage").val()) {
            return;
        }
        var nextPage = parseInt(currentPage) + 1;
        createPage(nextPage);
        $("#currentPage").val(nextPage);

        if (nextPage == parseInt($("#sumPage").val())) {
            $(this).unbind("click").addClass("disabled");
            $("#lastPage").unbind("click").addClass("disabled");
        }

        if (currentPage == "1") {
            firstPage();
            prePage();
        }
    });
}

/**
 * 末页
 * 1.获取当前页
 * 2.绑定按钮
 * 3.生成末页视图
 * 4.更新当前页
 * 5.解绑末页下一页
 * 6.如果当前页为1绑定首页上一页
 */
function lastPage() {
    $("#lastPage").removeClass("disabled").bind("click", function () {
        var currentPage = $("#currentPage").val();
        createPage(parseInt($("#sumPage").val()));
        $("#currentPage").val($("#sumPage").val());

        $(this).unbind("click").addClass("disabled");
        $("#nextPage").unbind("click").addClass("disabled");

        if (currentPage == "1") {
            firstPage();
            prePage();
        }
    });
}

/**
 * 生成part表   ->1
 * 1.清空parameterTable区域
 * 2.生成表头
 * 3.ajax拉取后台数据
 * 4.根据数据计算最大页数
 * 5.根据后台获取的数据生成表格
 */
function createPart(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>部位编码</th>"
                       + "<th>部位名称</th>"
                       + "<th>部位描述</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddPart();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "part" },
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createPartTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

/**
 * 生成表格指定页（每页12行）-->2
 * @param page 指定页数
 */
function createPartTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].code + "<input type=hidden value=" + jsonObj[i].id
           + " /></td><td>" + jsonObj[i].Name + "</td><td>" + jsonObj[i].Description
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * part部分新增表初始化 -->3
 */
function initAddPart() {
    $("#addrow").empty()
                .append("<tr><th>部位编码</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr><tr><th>部位名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr><tr><th>部位描述</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

/**
 * 创建DiagnosisResult表格  -->1
 */
function createDiagnosisResult(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>肿瘤编码</th>"
                       + "<th>肿瘤名称</th>"
                       + "<th>病情描述</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddDiagnosisResult();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "DiagnosisResult" },
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createDiagnosisResultTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

/**
 * 初始化新增 -->2
 */
function initAddDiagnosisResult() {
    $("#addrow").empty()
                .append("<tr><th>肿瘤编码</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr><tr><th>肿瘤名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr><tr><th>病情描述</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

/*
 * --3
 */
function createDiagnosisResultTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].code + "<input type=hidden value=" + jsonObj[i].id
           + " /></td><td>" + jsonObj[i].TumorName + "</td><td>" + jsonObj[i].Description
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * FixedEquipment  ->1
 */
function createFixedEquipment(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>装置名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddFixedEquipment();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "FixedEquipment" },
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createFixedEquipmentTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddFixedEquipment() {
    $("#addrow").empty()
                .append("<tr><th>装置名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createFixedEquipmentTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * FixedEquipment  ->1
 */
function createFixedRequirements(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>固定要求</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddFixedRequirements();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "FixedRequirements" },
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createFixedRequirementsTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddFixedRequirements() {
    $("#addrow").empty()
                .append("<tr><th>固定要求</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createFixedRequirementsTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Requirements + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * FixedEquipment  ->1
 */
function createScanPart(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>部位名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddScanPart();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "ScanPart" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createScanPartTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddScanPart() {
    $("#addrow").empty()
                .append("<tr><th>部位名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createScanPartTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * FixedEquipment  ->1
 */
function createScanMethod(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>扫描方式</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddScanMethod();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "ScanMethod" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createScanMethodTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddScanMethod() {
    $("#addrow").empty()
                .append("<tr><th>扫描方式</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createScanMethodTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Method + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * FixedEquipment  ->1
 */
function createEnhanceMethod(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>增强方式</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddEnhanceMethod();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "EnhanceMethod" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createEnhanceMethodTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddEnhanceMethod() {
    $("#addrow").empty()
                .append("<tr><th>增强方式</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createEnhanceMethodTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Method + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}


/**
 * FixedEquipment  ->1
 */
function createLocationRequirements(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>模拟定位特殊要求</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddLocationRequirements();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "LocationRequirements" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createLocationRequirementsTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddLocationRequirements() {
    $("#addrow").empty()
                .append("<tr><th>模拟定位特殊要求</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createLocationRequirementsTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Requirements + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * FixedEquipment  ->1
 */
function createDensityConversion(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>转换名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddDensityConversion();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "DensityConversion" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createDensityConversionTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddDensityConversion() {
    $("#addrow").empty()
                .append("<tr><th>转换名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createDensityConversionTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * EndangeredOrgan  ->1
 */
function createEndangeredOrgan(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>器官名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddEndangeredOrgan();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "EndangeredOrgan" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createEndangeredOrganTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddEndangeredOrgan() {
    $("#addrow").empty()
                .append("<tr><th>器官名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createEndangeredOrganTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * Technology  ->1
 */
function createTechnology(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>技术名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddTechnology();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "Technology" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createTechnologyTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddTechnology() {
    $("#addrow").empty()
                .append("<tr><th>技术名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createTechnologyTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * PlanSystem  ->1
 */
function createPlanSystem(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>系统名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddPlanSystem();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "PlanSystem" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createPlanSystemTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddPlanSystem() {
    $("#addrow").empty()
                .append("<tr><th>系统名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createPlanSystemTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * Grid  ->1
 */
function createGrid(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>网络名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddGrid();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "Grid" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createGridTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddGrid() {
    $("#addrow").empty()
                .append("<tr><th>网络名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createGridTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * Algorithm  ->1
 */
function createAlgorithm(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>算法名称</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddAlgorithm();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "Algorithm" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createAlgorithmTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddAlgorithm() {
    $("#addrow").empty()
                .append("<tr><th>算法名称</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createAlgorithmTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Name + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}

/**
 * ReplacementRequirements  ->1
 */
function createReplacementRequirements(page) {
    //生成表头
    $("#thead").empty()
               .append("<tr>"
                       + "<th>复位要求</th>"
                       + "</tr>");
    $("#tbody").empty();

    //新增表格
    initAddReplacementRequirements();

    //获取表格数据
    $.ajax({
        type: "post",
        url: "getParameterTable.ashx",
        data: { table: "ReplacementRequirements" },//哪个表格
        dataType: "text",
        success: function (data) {
            jsonObj = $.parseJSON(data);
            currentlength = jsonObj.length;
            $("#sumPage").val(countSumPage(jsonObj.length));
            createReplacementRequirementsTable(page);//生成表格第一页
            initBindPage();//绑定翻页事件
        }
    });
}

//2
function initAddReplacementRequirements() {
    $("#addrow").empty()
                .append("<tr><th>复位要求</th><td>"
                + "<input type=text class=form-control style=margin-right:0.8em />"
                + "</td></tr>");
}

//3
function createReplacementRequirementsTable(page) {
    var $tbody = $("#tbody");//清空当前表格
    $tbody.empty();

    var tr = "";

    for (var i = (page - 1) * 12; i < jsonObj.length && i < page * 12; ++i) {
        tr += "<tr><td>" + jsonObj[i].Requirements + "<input type=hidden value=" + jsonObj[i].id
           + " />"
           + "</td></tr>";
    }

    $tbody.append(tr);
}