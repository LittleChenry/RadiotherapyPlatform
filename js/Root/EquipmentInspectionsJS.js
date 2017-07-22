var currentModel = 0;
var currentCycle = "";

$(function(){
	$("#cycle").bind("change", function(){
		var selected = this.selectedIndex;
		createModelSelect(selected);
	});

	$("#sure").bind("click", function(){
		var cycle = $("#cycle :selected").val();
		var model = $("#model :selected").val();
		if(cycle == "" || model == ""){
			return;
		}else{
			currentCycle = cycle;
			createTables(cycle,model);
		}
	});
});

$(function(){
	$("#addItem").bind("click", function(){
		addItem();
	});

    document.getElementById("MainItemSelect").addEventListener("change", showNewInput, false);//新建中主项目名选择
    document.getElementById("Unit").addEventListener("change", changeInput, false);

    $(function(){
    	$("#addCannel").bind("click", function(){
    		cannelAdd();
    	});
    });
});

//点击新建按钮事件
function addItem() {
    document.getElementById("middleArea").style.display = "block";
    document.getElementById("topArea").style.display = "block";
    CreateMainItemSelect();
}

function cannelAdd(){
	$("#middleArea").hide();
	$("#topArea").hide();
	$("#MainItem").hide();
	var ref = document.getElementById("Reference");
	var err = document.getElementById("explain");
	if (ref.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", ref);
            }
            ref.value = "";
            ref.readOnly = false;
            if (err.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", err);
            }
            err.value = "";
            err.readOnly = false;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
}

function CreateMainItemSelect(){
    var select = document.getElementById("MainItemSelect");
    select.options.length = 0;
    var obj = GetMainItem();
    if (obj[0].MainItem == "false") {
        return;
    }

    for (var i = 0; i < obj.length; i++) {
        select.options[i] = new Option(obj[i].MainItem);
        select.options[i].value = obj[i].MainItem;
    }
    select.options[select.options.length] = new Option("填写新项目");
    select.options[select.options.length - 1].value = "writeNew";
}

function GetMainItem() {
    var xmlHttp = new XMLHttpRequest();
    var url = "../../pages/Root/GetMainItem.ashx";
    xmlHttp.open("GET", url, false);
    xmlHttp.send();
    var json = xmlHttp.responseText;
    return eval("(" + json + ")");
}

function showNewInput() {
    var mainitem = document.getElementById("MainItem");
    if (this.selectedIndex == (this.options.length - 1)) {
        mainitem.style.display = "block";
    } else {
        mainitem.style.display = "none";
    }
}

function changeInput(evt) {
    var selected = this.selectedIndex;
    changeInputContent(selected);
}

//根据下拉菜单选项改变输入框
function changeInputContent(selected) {
    var ref = document.getElementById("Reference");
    var err = document.getElementById("explain");	
    switch (selected) {
        case 0:
            if (ref.className.indexOf("disableInput") == -1) {
                ref.className += " disableInput";
            }
            ref.value = "NA";
            ref.readOnly = true;
            if (err.className.indexOf("disableInput") == -1) {
                err.className += " disableInput";
            }
            err.value = "NA";
            err.readOnly = true;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
            break;
        case 1:
            if (ref.className.indexOf("disableInput") == -1) {
                ref.className += " disableInput";
            }
            ref.value = "功能正常";
            ref.readOnly = true;
            if (err.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", err);
            }
            err.value = "";
            err.readOnly = false;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
            break;
        case 2:
            if (ref.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", ref);
            }
            ref.value = "";
            ref.readOnly = false;
            if (err.className.indexOf("disableInput") > -1) {
                removeClass("disableInput", err);
            }
            err.value = "";
            err.readOnly = false;
            removeClass("invalid", ref);
            removeClass("invalid", err);
            document.getElementById("error").innerHTML = "";
            break;
    }
}

function removeClass(rClass, thisElement) {
    var classNames = thisElement.className.split(" ");
    var rClassName = "";
    for (var i = 0; i < classNames.length; i++) {
        if (classNames[i] != rClass) {
            rClassName += classNames[i] + " ";
        }
    }
    thisElement.className = rClassName;
}

function createModelSelect(selected){
	var cycle = "";
	switch(selected){
		case 0:
			return;
		case 1:
			cycle = "day";
			break;
		case 2:
			cycle = "month";
			break;
		case 3:
			cycle = "year";
			break;
	}
	$.ajax({
		type: "post",
		url: "getModel.ashx",
		data: {"cycle": cycle},
		async: false,
		dataType: "text",
		success: function(data){
			var $select = $("#model");
			$select.empty().append("<option value=''>请选择模板</option>"
                            + "<option value=add>新增模板</option>");
			if(data == "]")
				return;
			var obj = $.parseJSON(data);
			
			for(var i = 0;i < obj.length;i++){
				$select.append("<option value=" + obj[i].id + " >" + obj[i].Name + " </option");
			}
		}
	});
}

function createTables(cycle,model){
	var suc = true;
	if(model == "add"){
		var name  = prompt("请输入新建模板名");
		if(name != null){
			$.ajax({
				type: "get",
				url: "../../pages/Root/addNewModel.ashx?name=" + name+"&cycle=" + currentCycle,
				async: false,
				success: function(data){
					currentModel = parseInt(data);
					$("#cycleTitle").text(currentCycle + "-" + name);
				},
				error: function(){
					suc=false;
				}
			});
		}else{
			return;
		}
		if(!suc){
			alert("新建失败");
			return;
		}
		$("#changeTable").show();
		$("#addItem").show();
		$("#deleteModel").show();
		$("#tableArea").empty().append("<table class=mytable table-bordered table-center></table>");
		return;
	}
	$("#changeTable").show();
		$("#addItem").show();
		$("#deleteModel").show();
		$("#tableArea").empty().append("<table class=mytable table-bordered table-center></table>");
	currentModel = parseInt(model);
	showTable(cycle,model);
}

function showTable(cycle,model){
	$.ajax({
		type: "post",
		url: "../../pages/Root/getEquipmentModel.ashx",
		data: {"cycle":cycle,"model":model},
		dataType: "text",
		success: function(data){
			$("#cycleTitle").text(cycleChinese(currentCycle) + "-" + $("#model option[value="+currentModel+"]").text());
			if(data == "]")
				return;
			var obj = $.parseJSON(data);
			$("#tableArea").createTable(obj,{
				headName: new Array("隶属项目","项目名称","说明","参考值"),
				rows: 12
			});
		}
	});
}

function cycleChinese(cycle){
	switch(cycle){
		case "day":
			return "日检";
		case "month":
			return "月检";
		case "year":
			return "年检";
	}
}

$(function(){
	$("#deleteModel").bind("click",function(){
		$.ajax({
			type: "post",
			url: "../../pages/Root/deleteModel.ashx",
			data: {"cycle":currentCycle, "model":currentModel},
			success:function(){
				alert("删除成功");
				window.location.reload();
			}
		})
	})
});

$(function(){
	$("#submitAdd").bind("click", function(){
		var $error= $("#error");
		$error.text("");
		$error.hide();
		if($("#childItem").val() == ""){
			$error.text("请填写项目名");
			$error.show();
			return false;
		}
		if($("#Unit :selected").val() == "write" && $("#Reference").val() == ""){
			$error.text("请填写参考值");
			$error.show();
			return false;
		}
		var datas = {"MainItem":"", "ChildItem":$("#childItem").val(), "checkWay":$("#Unit :selected").val(), "explain":$("#explain").val(), "reference":$("#Reference").val(), "cycle":currentCycle,"model": currentModel};
		var main = $("#MainItemSelect :selected").val();
		main = (main == "writeNew") ? $("#MainItem").val() : main;
		datas.MainItem = main;
		$.ajax({
			type: "post",
			url: "addNewItemInModel.ashx",
			data: datas,
			success: function(){
				showTable(currentCycle,currentModel);
				$("#addCannel").trigger("click");
			}
		})
	});
});