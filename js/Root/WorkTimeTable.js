$(function () {
    $("#sureChoose").off("click").on("click",function(){
    	add();
    });
    $("#sureChooseMonth").off("click").on("click",function(){
    	get($("#chooseShowMonth").val());
    });
    $("#tbody").off("click").on("click",function(evt){
            var which = evt.target;
            var $tr = $(which).closest("tr");
            if(confirm("确定删除这一天吗？"+$tr.find("td").eq(1).text())){
            	deleteItem($tr.find("td").eq(0).text());
            }
      });
});

function add(){
	var date = $("#chooseDate").val();
	$.ajax({
		url:"WorkTimeTable.ashx",
		type:"post",
		data:{"code":"add","date":date},
		success:function(data){
			if("success" == data){
				alert("新增成功");
				get(date.substring(5,7));
				$("#chooseShowMonth").val(date.substring(5,7));
			}
		}
	});
}

function get(month){
	
	$.ajax({
		url:"WorkTimeTable.ashx",
		type:"post",
		data:{"code":"get","month":month},
		success:function(data){
			showData(data);
		}
	});
}

function deleteItem(id){
	$.ajax({
		url:"WorkTimeTable.ashx",
		type:"post",
		data:{"code":"delete","ID":id},
		success:function(data){
			if("success" == data){
				alert("删除成功");
				get($("#chooseShowMonth").val());
			}
		}
	});
}
 function showData(data){
 	if(data == "]"){
 		$("#tbody").empty();
 		return;
 	}
 	var dataJSON = $.parseJSON(data);
 	$("#tbody").empty();
	for(var i = 0;i < dataJSON.length;i++){
		var $tr = $("<tr></tr>");
		$tr.append("<td hidden='true' id='ID'>" + dataJSON[i].ID + "</td>" + "<td id='date'>" + dataJSON[i].Date  + "</td>");
		$("#tbody").append($tr);
	}
 }