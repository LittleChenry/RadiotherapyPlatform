var currentModel = 0;
var currentCycle = "";
var objData = [];

$(function(){
	$("#cycle").bind("change", function(){
		var selected = this.selectedIndex;
		createModelSelect(selected);
	});

	$("#sure").bind("click", function(){
		var cycle = $("#cycle :selected").val();
		var model = $("#model :selected").val();
		$("#cannel").trigger("click");
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
    CreateMainItemSelect("MainItemSelect");
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

function CreateMainItemSelect(name){
    var select = document.getElementById(name);
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
    var url = "../../pages/Root/GetMainItems.ashx";
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
					$("#cycleTitle").text(cycleChinese(currentCycle) + "-" + name);
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
		$("#tableArea").empty().append("<table class='table table-striped table-hover'></table>");
		return;
	}
	$("#changeTable").show();
		$("#addItem").show();
		$("#deleteModel").show();
		$("#tableArea").empty().append("<table class='table table-striped table-hover'></table>");
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
			objData = $.parseJSON(data);
			$("#tableArea").createTable(objData,{
				headName: new Array("隶属项目","项目名称","说明","参考值"),
				rows: 12,
				needKey: true,
				maxcols: 4,
				link: true,
				linkcols: 3,
                linkdata:"files"
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
    $("#deleteModel").bind("click", function () {
        var sure = window.confirm("确认删除？");
        if (sure == false) {
            return;
        }
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

var reAdd = false;
$(function(){
    $("#submitAdd").bind("click", function () {
        if (reAdd) {
            return;
        } else {
            reAdd = true;
        }
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
		
		var main = $("#MainItemSelect :selected").val();
		main = (main == "writeNew") ? $("#MainItem").val() : main;
		var formDate = new FormData();
		if ($("#file")[0].files[0] == null) {
		    formDate.append("exist", "false");
		} else {
		    formDate.append("file", $("#file")[0].files[0]);
		    formDate.append("exist", "true");
		}
		formDate.append("file", file);
		formDate.append("MainItem",main);
		formDate.append("ChildItem", $("#childItem").val());
		formDate.append("checkWay", $("#Unit :selected").val());
		formDate.append("explain", $("#explain").val());
		formDate.append("reference", $("#Reference").val());
		formDate.append("cycle", currentCycle);
		formDate.append("model", currentModel);
		$.ajax({
			type: "post",
			url: "addNewItemInModel.ashx",
			data: formDate,
		    // 告诉jQuery不要去处理发送的数据
			processData: false,
		    // 告诉jQuery不要去设置Content-Type请求头
			contentType: false,
			success: function(){
			    showTable(currentCycle, currentModel);
			    reAdd = false;
				$("#addCannel").trigger("click");
			}
		})
	});
});

$(function(){
    $("#changeTable").bind("click", function(){
        $(this).hide();
        $("#addItem").hide();
        $("#cannel").show();
        tableBindClick();
    });
});

function tableBindClick(){
	$("#tableArea").bind("click", function(evt){
		var which = evt.target;
		var $tr = $(which).closest("tr");
		$tds = $tr.find("td");
		createEditTable($tds);
		$("#EditGroup").trigger("click");
	})
}
var oldlink = ""
var del = false;
function createEditTable($tds) {
    oldlink = "";
    del = false;
	$editArea = $("#editArea");
	var reference = $tds[3].innerText;
	var link = $($tds[2]).find("a").attr("href");
	var text = $tds[2].innerText.substring(0, $tds[2].innerText.length - 2);
	if (link == null) {
	    text = $tds[2].innerText;
	} else {
        oldlink = link;
	}
	var item = "<tr><th>隶属项目</th><td><select id=editMainItemSelect class=form-control /><input id=editMainItem type=text class='form-control controlHeight tohidden MainItemSelect' placeholder=请输入所属项目 /><input id=editID type=hidden value="+ $($tds[0]).find(":hidden").val() + " /></td></tr>"
			 + "<tr><th>项目名称</th><td><input id=editName class=form-control type=text value="+$tds[1].innerText + " /></td></tr>"
			 + "<tr><th>检查类型</th><td><select id=editTypeSelect class=form-control ><option value=NA>NA</option><option value=IsOk>功能正常</option><option value=write>填写</option></select></td></tr>"
			 + "<tr><th rowspan=2>说明</th><td><textarea id=editexplain class=form-control style=resize:vertical; rows=5 >" + text + "</textarea>" + ((link == null) ? "" : ("<a id=editfile target=_blank href=" + link + " >文件</a><button id=filedelete type=button class=close>×</button>")) + "</td></tr>"
             + "<tr><td><input id=changefile type=file></td></tr>"
			 + "<tr><th>参考值</th><td><input id=editReference class=form-control type=text value="+ reference + " /></td></tr>";
	$editArea.empty().append(item);
	if (link != null) {
	    $("#filedelete").bind("click", function () {
	        $(this).prev("a").remove();
	        $(this).remove();
	        del = true;
	    });
	}
	CreateMainItemSelect("editMainItemSelect");
	$("#editMainItemSelect [value=" + $tds[0].innerText+"]").attr("selected", true);
	if(reference == "NA"){
		$("#editTypeSelect [value=NA]").attr("selected", true);
		$("#editReference").addClass("disableInput").attr("readOnly",true);
		$("#editexplain").addClass("disableInput").attr("readOnly",true);
	}else if(reference == "功能正常"){
		$("#editTypeSelect [value=IsOk]").attr("selected", true);
		$("#editReference").addClass("disableInput").attr("readOnly",true);
	}else{
		$("#editTypeSelect [value=write]").attr("selected", true);
	}
	$("#editMainItemSelect").bind("change", function(){
		var hidden = $("#editMainItem");
		if (this.selectedIndex == (this.options.length - 1)){
			hidden.show();
		}else{
			hidden.hide();
		}
	});
	$("#editTypeSelect").bind("change", function(){
		changeInputeditContent(this.selectedIndex);
	});
}

function changeInputeditContent(selected) {
    var ref = document.getElementById("editReference");
    var err = document.getElementById("editexplain");	
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

$(function(){
    $("#deleteGroup").bind("click",function(){
    	var current = parseInt($("#currentPage").val());
    	var id = $("#editID").val();
    	var links = $("#editArea a")
        var link = (links == null) ? "" : links.attr("href");
    	$.ajax({
    		type: "post",
    		url: "deleteItems.ashx",
    		data: {"id":id, "link":link},
    		success: function(){
    			alert("删除成功");
    			changeObj(objData,id);
    			$("#tableArea").createTable(objData,{
				headName: new Array("隶属项目","项目名称","说明","参考值"),
				rows: 12,
				needKey: true,
				pages: current,
				maxcols: 4,
				link: true,
				linkcols: 3,
				linkdata: "files"
			});
    			$("#cannelEdit").trigger("click");
    		}
    	});
    });
});

function changeObj(obj,id){
	for(var i = 0;i < objData.length;i++){
		if(objData[i].id == id){
			objData.splice(i,1);
			break;
		}
	}
}

$(function(){
    $("#cannel").bind("click", function(){
    	$("#tableArea").unbind("click");
    	$(this).hide();
        $("#addItem").show();
        $("#changeTable").show();
    });
});

$(function(){
	$("#sureEdit").bind("click", function(){
		var current = parseInt($("#currentPage").val());
		var id = $("#editID").val();
		var mainItem = $("#editMainItemSelect").val();
		mainItem == "writeNew" ? $("#editMainItem").val() : mainItem;
		var childItem = $("#editName").val();
		var type = $("#editTypeSelect :selected").val();
		var explain = $("#editexplain")[0].value;

		var reference = $("#editReference").val();
		var link = $("#editArea a");
		var formDate = new FormData();
		if (del) {
		    formDate.append("del", "true");
		} else {
		    formDate.append("del", "false");
		}
		if ($("#changefile")[0].files[0] == null) {
		    formDate.append("exist", "false");
		} else {
		    formDate.append("exist", "true");
		    formDate.append("file", $("#changefile")[0].files[0]);
		}
		formDate.append("id",id);
		formDate.append("mainItem", mainItem);
		formDate.append("childItem", childItem);
		formDate.append("type", type);
		formDate.append("explain", explain);
		formDate.append("reference", reference);
		formDate.append("oldlink", oldlink);
		var datas = {"id": id, "mainItem": mainItem, "childItem": childItem, "type": type, "explain": explain, "reference": reference };
		$.ajax({
			type: "post",
			url: "updateItem.ashx",
		    // 告诉jQuery不要去处理发送的数据
			processData: false,
		    // 告诉jQuery不要去设置Content-Type请求头
			contentType: false,
			data: formDate,
			success:function(data){
				updateObj(datas,data);
				$("#tableArea").createTable(objData,{
				headName: new Array("隶属项目","项目名称","说明","参考值"),
				rows: 12,
				needKey: true,
				pages: current,
				maxcols: 4,
				link: true,
				linkcols: 3,
				linkdata: "files"
			});
				alert("修改成功");
    			$("#cannelEdit").trigger("click");
			}
		})
	});
})

function updateObj(datas,file){
	for(var i = 0;i < objData.length;i++){
		if(objData[i].id == datas.id){
			objData[i].mainItem = datas.mainItem;
			objData[i].childItem = datas.childItem;
			objData[i].explain = datas.explain;
			objData[i].reference = datas.reference;
			if (file != "") {
			    objData[i].files = file;
			} else {
			    objData[i].files = null;
			}
			break;
		}
	}
}