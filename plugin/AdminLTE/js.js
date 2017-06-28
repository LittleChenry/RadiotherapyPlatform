var patient;
var dataroot="../../plugin/AdminLTE/patient.json"; 


$(document).ready(function(){
	//$("body").removeClass("skin-purple").addClass("skin-blue");
	$(".frame-content").height($(document).height() - 151);
	$("#patient-content").height($(document).height() - 151);
	$("#record-iframe").width($("#record-content").width());
	$("#progress-iframe").width($("#progress-content").width());
	Paging();
})

/*window.onresize=function(){
	document.location.reload();
}*/

function getActive(){
	var ul = $("#page-index-content li");
	var active;
	ul.each(function(index,element){
		if ($(this).hasClass("active")) {
			active = index - 1;
		}
	});
	return active;
}

function getChose(){
	var tr = $("#patient-table-body tr");
	tr.each(function(index,element){
		if ($(this).hasClass("chose")) {
			return index;
		}else{
			return null;
		}
	});
}

function adjustPage(pages){
	var active = getActive();
	switch(active){
		case 1:
			$("#table_omitted_previous").css("display","none");
			$("#table_omitted_next").css("display","inline");
			for (var i = 1; i <= pages; i++) {
				$("#page_"+ i +"").css("display","inline");
			}
			for (var i = 4; i <= pages; i++) {
				$("#page_"+ i +"").css("display","none");
			}
			break;
		case 2:
			$("#table_omitted_previous").css("display","none");
			$("#table_omitted_next").css("display","inline");
			for (var i = 1; i <= pages; i++) {
				$("#page_"+ i +"").css("display","inline");
			}
			for (var i = 4; i <= pages; i++) {
				$("#page_"+ i +"").css("display","none");
			}
			break;
		case pages - 1:
			$("#table_omitted_next").css("display","none");
			$("#table_omitted_previous").css("display","inline");
			for (var i = 1; i <= pages; i++) {
				$("#page_"+ i +"").css("display","inline");
			}
			for (var i = pages - 3; i > 0 ; i--) {
				$("#page_"+ i +"").css("display","none");
			}
			break;
		case pages:
			$("#table_omitted_next").css("display","none");
			$("#table_omitted_previous").css("display","inline");
			for (var i = 1; i <= pages; i++) {
				$("#page_"+ i +"").css("display","inline");
			}
			for (var i = pages - 2; i > 0 ; i--) {
				$("#page_"+ i +"").css("display","none");
			}
			break;
		default:
			$("#table_omitted_next").css("display","inline");                                                                 
			$("#table_omitted_previous").css("display","inline");
			for (var i = 1; i <= pages; i++) {
				$("#page_"+ i +"").css("display","inline");
			}
			for (var i = 1; i < active - 1 ; i++) {
				$("#page_"+ i +"").css("display","none");
			}
			for (var i = active + 2; i <= pages ; i++) {
				$("#page_"+ i +"").css("display","none");
			}
	}
}

function CreateTable(start,end,patient){
	var tbody = $("#patient-table-body");
	tbody.html("");
	var num = end - start;
	$("#patient_info").text("本页共"+ num +"条记录");
	for (var i = start; i < end; i++) {
		TreatmentID = patient.PatientInfo[i].TreatmentID;
		Name = patient.PatientInfo[i].Name;
		diagnosisresult = patient.PatientInfo[i].diagnosisresult;
		state = patient.PatientInfo[i].state;
		doctor = patient.PatientInfo[i].doctor;
		date = patient.PatientInfo[i].date;
		age = patient.PatientInfo[i].age;
		progress = patient.PatientInfo[i].progress;
		/*var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
		+"</td><td>"+doctor+"</td><td>"+date+"</td><td>"+age+"</td></tr>";*/
		var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
		+"</td><td>"+doctor+"</td></tr>";
		tbody.append(tr);
	}
	for (var i = start; i < end; i++) {
		$("#"+patient.PatientInfo[i].TreatmentID+"").click({count:patient.PatientInfo[i].progress,state:patient.PatientInfo[i].state},function(e){
			$("#patient-status").text(e.data.state);
			var tr = $("#patient-table-body tr");
			tr.each(function(index,element){
				if ($(this).hasClass("chose")) {
					$(this).removeClass("chose");
				}
			});
			$(this).addClass("chose");
			var ul = $("#progress-iframe").contents().find("#ul-progress a");
			ul.each(function(index,element){
				if(index < e.data.count){
					$(this).find('li').removeClass().addClass("progress-finished");
					$(this).find('i').removeClass().addClass("fa fa-fw fa-check");
				}else if(index == e.data.count){
					$(this).find('li').removeClass().addClass("progress-active");
					$(this).find('i').removeClass().addClass("fa fa-fw fa-edit");
				}else{
					$(this).find('li').removeClass().addClass("progress-unfinished");
					$(this).find('i').removeClass().addClass("fa fa-fw fa-ban");
				}
			});
		});
	}
}

function Paging(){
	$.getJSON(dataroot, function(data){ 
		patient = eval(data);
		if (patient.PatientInfo != "") {
			var pageindex = new Array();
			tableheight = $("#patient-content").height() - 160;
			var pagecount = 0;
			var tbody = $("#patient-table-body");
			tbody.html("");
			var ul = $("#page-index-content");
			ul.html("");
			var TreatmentID,Name,diagnosisresult,state,doctor,date,age,progress;
			for (var i = 0; i < patient.PatientInfo.length; i++) {
				if (tbody.height() > tableheight) {
					pageindex[pagecount] = i;
					tbody.html("");
					pagecount++;
				}
				if (i == patient.PatientInfo.length-1) {
					pageindex[pagecount] = i+1;
					tbody.html("");
					break;
				}
				TreatmentID = patient.PatientInfo[i].TreatmentID;
				Name = patient.PatientInfo[i].Name;
				diagnosisresult = patient.PatientInfo[i].diagnosisresult;
				state = patient.PatientInfo[i].state;
				doctor = patient.PatientInfo[i].doctor;
				date = patient.PatientInfo[i].date;
				age = patient.PatientInfo[i].age;
				progress = patient.PatientInfo[i].progress;
				var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
				+"</td><td>"+doctor+"</td></tr>";
				/*var tr = "<tr id='"+TreatmentID+"'><td>"+TreatmentID+"</td><td>"+Name+"</td><td>"+diagnosisresult+"</td><td>"+state
				+"</td><td>"+doctor+"</td><td>"+date+"</td><td>"+age+"</td></tr>";*/
				tbody.append(tr);
			}
			/*for (var i = 0; i < pageindex.length; i++) {
				alert(pageindex[i]);
			}*/
			var ul = $("#page-index-content");
			var ul_content = "<li class='paginate_button previous' id='table_previous'><a href='javascript:;'><i class='fa fa-fw fa-arrow-left'></i></a></li>";
			var omitted_previous = "<li class='paginate_button' id='table_omitted_previous'><a><i>···</i></a></li>";
			var omitted_next = "<li class='paginate_button' id='table_omitted_next'><a><i>···</i></a></li>";
			ul_content = ul_content + omitted_previous;
			for (var i = 0; i < pageindex.length; i++) {
				var page = i+1;
				var li = "<li id='page_"+ page +"' class='paginate_button'><a href='javascript:;'>"+ page +"</a></li>";
				ul_content = ul_content + li;
			}
			ul_content = ul_content + omitted_next;
			ul_content = ul_content + "<li class='paginate_button next' id='table_next'><a href='javascript:;'><i class='fa fa-fw fa-arrow-right'></i></a></li>";
			ul.append(ul_content);
			$("#table_previous").click({pageindex_length: pageindex.length}, function(e) {
				var currentactive = getActive();
				$("#page_"+ currentactive +"").removeClass("active");
				var active = currentactive - 1;
				$("#page_"+ active +"").addClass("active");
				if (currentactive == e.data.pageindex_length) {
					$("#table_next").removeClass("disabled");
				}
				if (active == 1) {
					$("#table_previous").addClass("disabled");
				}
				var k,j;
				j=pageindex[currentactive - 2];
				if(currentactive == 2){
					k = 0;
				}else{
					k = pageindex[currentactive - 3];
				}
				CreateTable(k,j,patient);
				adjustPage(pageindex.length);
			});
			$("#table_next").click({pageindex_length: pageindex.length}, function(e) {
				var currentactive = getActive();
				$("#page_"+ currentactive +"").removeClass("active");
				var active = currentactive + 1;
				$("#page_"+ active +"").addClass("active");
				if (currentactive == 1) {
					$("#table_previous").removeClass("disabled");
				}
				if (active == e.data.pageindex_length) {
					$("#table_next").addClass("disabled");
				}
				var k,j;
				j=pageindex[currentactive];
				k = pageindex[currentactive - 1];
				CreateTable(k,j,patient);
				adjustPage(pageindex.length);
			});
			CreateTable(0,pageindex[0],patient);
			$("#page_1").addClass("active");
			$("#table_previous").removeClass("disabled").addClass("disabled");
			for (var i = 0; i < pageindex.length; i++) {
				var page = i + 1;
				$("#page_"+page+"").click({i: i,page: page,pageindex_length: pageindex.length}, function(e) {
					var k,j;
					j=pageindex[e.data.i]
					if(e.data.i == 0){
						k = 0;
					}else{
						k = pageindex[e.data.i - 1];
					}
					CreateTable(k,j,patient);
					for (var m = 0; m < e.data.pageindex_length; m++) {
						var n = m + 1;
						$("#page_"+ n +"").removeClass("active");
					}
					$("#table_previous").removeClass("disabled");
					$("#table_next").removeClass("disabled");
					$("#page_"+e.data.page+"").addClass("active");
					if (e.data.i == e.data.pageindex_length - 1) {
						$("#table_previous").removeClass("disabled");
						$("#table_next").removeClass("disabled").addClass("disabled");
					}
					if (e.data.i == 0) {
						$("#table_previous").removeClass("disabled").addClass("disabled");
						$("#table_next").removeClass("disabled");
					}
					adjustPage(pageindex.length);
				});
			}
			if (pageindex.length > 5) {
				adjustPage(pageindex.length);
			}else{
				$("#table_omitted_previous").css("display","none");
				$("#table_omitted_next").css("display","none");
			}
		}else{
			var tbody = $("#patient-table-body");
			var tr = "<tr><td colspan='7' style='text-align:center'>没有病人</td></tr>";
			tbody.append(tr);
			$("#patient_info").text("本页共0条记录");
		}
	});
}





