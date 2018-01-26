$(function () {
	getData();
	$("#add").off("click").on("click",function(){
		$("#addModal").modal({
			backdrop:false
		});
		$("#sureAdd").off("click").on("click",function(){
			addData();
		})
	});


});

function getData(){
	$.ajax({
		url:"FirstAccTime.ashx",
		type:"post",
		data:{
			type:"get"
		},
		success:function(data){
			fillData(data);
		}
	});
}

function fillData(data){
	$("#tbody").empty();
	var dataObj = $.parseJSON(data);
	for(var i = 0; i < dataObj.length; i++){
		var $tr = $("<tr></tr");
		var $td_id = $("<td hidden='true'>"+dataObj[i].id+"</td>");
		var $td_name = $("<td>"+dataObj[i].name+"</td>");
		var $begintime = $("<td>"+intToTime(dataObj[i].begintime)+"</td>");
		var $endtime = $("<td>"+intToTime(dataObj[i].endtime)+"</td>");

		$td_id.appendTo($tr);
		$td_name.appendTo($tr);
		$begintime.appendTo($tr);
		$endtime.appendTo($tr);
		$tr.appendTo($("#tbody"));
	}
	$("#tbody>tr").off("click").on("click",function(){
		$("#editModal").modal({
			backdrop:false
		});
		prepareEditData($(this));
		$("#sureEdit").off("click").on("click",function(){
			editData();
		});
		$("#deleteEdit").off("click").on("click",function(){
			deleteData();
		})
	});
}

function intToTime(time) {
    var thisTime = parseInt(time);
    var hour = parseInt(thisTime / 60);
    var minute = parseInt(thisTime - hour * 60);
    return (hour.toString() + ":" + (minute < 10 ? "0" : "") + minute.toString());
}

function addData(){
	var name = $("#addName").val();
	var addBeginHour = $("#addBeginHour").val();
	var addBeginMinute = $("#addBeginMinute").val();
	var addEndHour = $("#addEndHour").val();
	var addEndMinute = $("#addEndMinute").val();

	if(name == ""){
		alert("请输入时间段名称");
		return false;
	}
	if(addBeginHour == "" || addBeginMinute == ""){
		alert("开始时间尚未填写完整");
		return false;
	}

	if(addEndHour == "" || addEndMinute == ""){
		alert("结束时间尚未填写完整");
		return false;
	}

	if((parseInt(addBeginHour) * 60 + parseInt(addBeginMinute)) > (parseInt(addEndHour) * 60 + parseInt(addEndMinute))){
		alert("开始时间大于结束时间，请重填");
		return false;
	}

	$.ajax({
		url:"FirstAccTime.ashx",
		type:"post",
		data:{
			type:"add",
			name:name,
			addBeginHour:addBeginHour,
			addBeginMinute:addBeginMinute,
			addEndHour:addEndHour,
			addEndMinute:addEndMinute
		},
		success:function(data){
			if(data == "success"){
				alert("添加成功");
				$("#addModal").modal("hide");
				getData();
			}
			if(data == "repeat"){
				alert("时间段有重叠，请检查");
			}
			if(data == "failure"){
				alert("添加失败");
			}
		}
	});
}

function prepareEditData($tr){
	var editID = $tr.find("td").eq(0).text();
	var editName = $tr.find("td").eq(1).text();
	var begintime = $tr.find("td").eq(2).text();
	var endtime = $tr.find("td").eq(3).text();

	$("#editID").val(editID);
	$("#editName").val(editName);
	$("#editBeginHour").val(begintime.split(':')[0]);
	$("#editBeginMinute").val(begintime.split(':')[1]);
	$("#editEndHour").val(endtime.split(':')[0]);
	$("#editEndMinute").val(endtime.split(':')[1]);
}

function editData(){
	var name = $("#editName").val();
	var editBeginHour = $("#editBeginHour").val();
	var editBeginMinute = $("#editBeginMinute").val();
	var editEndHour = $("#editEndHour").val();
	var editEndMinute = $("#editEndMinute").val();
	var editID = $("#editID").val();

	if(name == ""){
		alert("请输入时间段名称");
		return false;
	}
	if(editBeginHour == "" || editBeginMinute == ""){
		alert("开始时间尚未填写完整");
		return false;
	}

	if(editEndHour == "" || editEndMinute == ""){
		alert("结束时间尚未填写完整");
		return false;
	}

	if((parseInt(editBeginHour) * 60 + parseInt(editBeginMinute)) > (parseInt(editEndHour) * 60 + parseInt(editEndMinute))){
		alert("开始时间大于结束时间，请重填");
		return false;
	}

	$.ajax({
		url:"FirstAccTime.ashx",
		type:"post",
		data:{
			type:"edit",
			editID:editID,
			name:name,
			editBeginHour:editBeginHour,
			editBeginMinute:editBeginMinute,
			editEndHour:editEndHour,
			editEndMinute:editEndMinute
		},
		success:function(data){
			if(data == "success"){
				alert("修改成功");
				$("#editModal").modal("hide");
				getData();
			}
			if(data == "repeat"){
				alert("时间段有重叠，请检查");
			}
			if(data == "failure"){
				alert("修改失败");
			}
		}
	});
}

function deleteData(){
	var editID = $("#editID").val();
	$.ajax({
		url:"FirstAccTime.ashx",
		type:"post",
		data:{
			type:"delete",
			editID:editID,
		},
		success:function(data){
			if(data == "success"){
				alert("删除成功");
				$("#editModal").modal("hide");
				getData();
			}
			if(data == "failure"){
				alert("修改失败");
			}
		}
	});
}