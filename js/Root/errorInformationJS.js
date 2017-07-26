var jsonObj = [];//记录对象

/**
 * 获取数据创建初始表格
 */
$(function(){
	getData();
});

function getData(){
    $.ajax({
    	type: "post",
    	url: "getErrorInformation.ashx",
    	dataType: "text",
    	success: function(data){
    		if(data == "]")
    			return;
    		else{
    			jsonObj = $.parseJSON(data);
    			showTable(1);
    		}
    	}
    });
}

/**
 * 刷新并展示表格
 * @param page 第几页
 */
function showTable(page){
	$("#tableArea").createTable(jsonObj,{
		rows: 12,
		needKey:true,
		headName: new Array("名称","编码","描述"),
		pages: page
	});
}

/**
 * 新增按钮事件
 */
$(function(){
    $("#sureAdd").bind("click", function(){
    	var addrow = $("#addrow input");
    	var datas = {"id":"","name": addrow.eq(0).val(), "encode": addrow.eq(1).val(), "description": addrow.eq(2).val()};
    	var page = (($("#currentPage").length == 0 || $("#currentPage") == null ) ? 1 : $("#currentPage").val());
    	$.ajax({
    		type: "post",
    		url: "addErrorInformation.ashx",
    		data: datas,
    		success: function(id){
    			alert("新增成功");
    			addJsonObj(id,datas);
    			showTable(parseInt(page));
    			$("#cannelButton").trigger("click");
    		}
    	});
    });
});

function addJsonObj(id,data){
    data.id = id;
	jsonObj.push(data);
}

/**
 * 新增取消按钮事件
 */
$(function(){
	$("#cannelButton").bind("click", function(){
		$("#addrow input").val("");
	});
})

/**
 * 搜索
 */
$(function(){
    $("#searchInput").bind("input",function(){
    	var text = $(this).val();
    	var obj = findObj(text);
    	$("#tableArea").createTable(obj,{
			rows: 12,
			needKey:true,
			headName: new Array("名称","编码","描述")
	    });
    });
});

/** 
 * 筛选符合搜索条件的对象
 */
function findObj(text){
	if(text == ""){
		return jsonObj;
	}
	var obj = [];
	for(var i = 0;i < jsonObj.length;i++){
		if(jsonObj[i].name.indexOf(text) > -1 || jsonObj[i].encode.indexOf(text) > -1){
			obj.push(jsonObj[i]);
		}
	}
	return obj;
}

/**
 * 修改按钮事件
 */
$(function(){
    $("#changeInformation").bind("click", function(){
        $(this).hide();
        $("#newInformation").hide();
        $("#closeEdit").show();
        bindTable();
    });
});

/**
 * table绑定点击编辑事件
 */
function bindTable(){
	$("#informationTable").bind("click", function(evt){
		var which = evt.target;
		var $tr = $(which).closest("tr");
		var addElement = "<tr><th>名称</th><td><input type=text class=form-control value=" + $tr.find("td").eq(0).text()
						+" /><input type=hidden value=" + $tr.eq(0).find("input").val() + " /></td></tr>"
						+"<tr><th>编码</th><td><input type=text class=form-control value=" + $tr.find("td").eq(1).text()
						+" /></td></tr>"
						+"<tr><th>描述</th><td><input type=text class=form-control value=" + $tr.find("td").eq(2).text()
						+" /></td></tr>";
		$("#editArea").empty().append(addElement);
		$("#EditInformation").trigger("click");

	});
}

/**
 * 确定修改
 */
 var canChange = true;
$(function(){
    $("#sureEdit").bind("click",function(){
    	if(!canChange){
    		return;
    	}else{
    		canChange = false;
    	}
    	var $edit = $("#editArea tr");
    	var datas = {"id":$edit.find(":hidden").val(), "name": $edit.eq(0).find("input[type=text]").val(), "encode":$edit.eq(1).find("input").val(), "description": $edit.eq(2).find("input").val()};
    	var page = (($("#currentPage").length == 0 || $("#currentPage") == null ) ? 1 : $("#currentPage").val());

    	$.ajax({
    		type: "post",
    		url: "updateErrorInformation.ashx",
    		data: datas,
    		success: function(){
    			changeJsonObj(datas);
    			showTable(parseInt(page));
    			alert("修改成功");
    			canChange = true;    			
    			$("#cannelEdit").trigger("click");
    		}
    	})
    });
});

function changeJsonObj(data){
	for(var i = 0;i < jsonObj.length;i++){
		if(jsonObj[i].id == data.id){
			jsonObj[i].name = data.name;
			jsonObj[i].encode = data.encode;
			jsonObj[i].description = data.description;
			break;
		}
	}
}

$(function(){
	$("#deleteInformation").bind("click",function(){
		var sure = window.confirm("确定删除");
		if(!sure){
			return;
		}
		var id = $("#editArea tr").find(":hidden").val();
		var page = (($("#currentPage").length == 0 || $("#currentPage") == null ) ? 1 : $("#currentPage").val());

		$.ajax({
			type: "post",
			url: "deleteErrorInformation.ashx",
			data:{"id":id},
			success: function(){
				deleteJsonObj(id);
				showTable(parseInt(page));
				alert("删除成功");
				$("#cannelEdit").trigger("click");
			}
		})
	});
});

function deleteJsonObj(id){
	for(var i = 0;i < jsonObj.length;++i){
		if(jsonObj[i].id == id){
			jsonObj.splice(i,1);
			break;
		}
	}
}