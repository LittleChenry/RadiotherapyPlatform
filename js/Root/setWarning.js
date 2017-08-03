//初始化
$(function(){
	getData();
});
//绑定事件
$(function(){
	$("#changeWarning").bind("click",function(){
		$(this).hide();
		$("#closeEdit").show();
		$("#tbody").bind("click",function(evt){
            var which = evt.target;
            var $tr = $(which).closest("tr");
            $("#editWarning").trigger("click");
            createEditArea($tr);
        });
	});
	$("#closeEdit").bind("click",function(){
		$(this).hide();
		$("#changeWarning").show();
		$("tbody").unbind("click");
	});
	
	$("#sureEdit").bind("click",function(){
		postEdit();
	});
});


function getData(){
	$.ajax({
        type: "post",
        url: "getWarning.ashx",
        dataType: "text",
        success: function (data) {
            var warningObj = $.parseJSON(data);
            createTable(warningObj);
        }
    });
}
//创建表
function createTable(warningObj){
	$("#tbody").empty();
	for(var i = 0;i < warningObj.length;i++){
		var $tr = $("<tr></tr>");
		$tr.append("<td>" + warningObj[i].WarningItem + "</td>" + "<td>" + warningObj[i].WarningLightTime  + "</td>" + "<td>" + warningObj[i].WarningSeriousTime + "</td>" );
		$("#tbody").append($tr);
	}
}

function createEditArea($tr){
	$("#editTBody").empty();
	$tds = $tr.find("td");
	$("#editTBody").append("<tr><th>预警项目</th><td><input id=item type=text disabled=true class=form-control style=margin-right:0.8em value=" + $tds[0].innerText + " /></td></tr>")
            .append("<tr><th>黄色预警</th><td><input id=light type=text class=form-control style=margin-right:0.8em value=" + $tds[1].innerText + " /></td><td>小时</td></tr>")
            .append("<tr><th>红色预警</th><td><input id=serious type=text class=form-control style=margin-right:0.8em value=" + $tds[2].innerText + " /></td><td>小时</td></tr>");

    $("#light").bind("blur", function(){
		var light = $("#light").val();
		if(checkNumber(light)){
			$("#error").hide();
			$(this).removeClass("invalid");
		}else{
			$("#error").text("请输入正确格式的数字").show();
			$(this).addClass("invalid");
		}
	});
	$("#serious").bind("blur", function(){
		var serious = $("#serious").val();
		if(checkNumber(serious)){
			$("#error").hide();
			$(this).removeClass("invalid");
		}else{
			$("#error").text("请输入正确格式的数字").show();
			$(this).addClass("invalid");
		}
	});
}

function postEdit(){
	var item = $("#item").val();
	var light = $("#light").val();
	var serious = $("#serious").val();
	if(!checkNumber(light)){
		$("#light").addClass("invalid");
		$("#error").text("请输入正确格式的数字").show();
		return false;
	}
	if(!checkNumber(serious)){
		$("#serious").addClass("invalid");
		$("#error").text("请输入正确格式的数字").show();
		return false;
	}
	$.ajax({
		type: "post",
        url: "updateWarning.ashx",
        dataType: "text",
        data: {"item":item, "light":light, "serious":serious},
        success: function (data) {
            alert("修改成功");
            getData();
            $("#cannelEdit").trigger("click");
        }
	});
}

function checkNumber(num){
	var reg = /^\d+(\.\d+)?$/;
	return reg.test(num);
}