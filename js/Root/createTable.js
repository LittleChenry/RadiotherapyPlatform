/**
 * 根据json对象生成表格
 * @Author peach
 */

(function ($) {
	$.fn.createTable = function(jsonObj, options){
		var defaults = {
			rows: 10,//一页行数
			headName: new Array(),//表头名
			first: "firstPage",//按钮id
			pre: "prePage",
			next: "nextPage",
			last: "lastPage",
			createButton: true,//是否创建翻页按钮
			buttonClass:"btn btn-primary btn-sm disabled",//按钮样式
			ignoreNull: false,//是否忽略null值
			needDate: false,//是否需要日期
			createDate: "",//创建日期月份格式xxxx-xx
			lessLength: 0,//每行最小列数，0不开启该功能
			pages: 1,//创建第几页
			needKey: false,//是否需要在第一列添加hidden记录id
            key:"id",
			maxcols: 0,//一行最大几列，0不开启
			link: false,
			linkcols: 0,
            linkdata: ""
		}

		var args = $.extend({},defaults,options);
		var _thiss = $(this);

		function init(area){
			var rows = parseInt(args["rows"]);
			var length = jsonObj.length;
			var sumPage = parseInt(length / rows);
			sumPage = (sumPage - (length / rows)) == 0 ? sumPage : sumPage + 1;
			area.append("<input id=sumPage type=hidden value=" + sumPage + " />")
				.append("<input id=currentPage type=hidden value=1 />");
			return sumPage;
		}

		function createButton(area){
			var first = args["first"], pre = args["pre"], next = args["next"], last = args["last"], buttonClass = args["buttonClass"];
			var $div = $("<div class=col-md-12></div>");
			$div.append("<div class=col-sm-6>&nbsp;</div>");
			
			var $buttonArea = $("<div class=col-sm-6></div>");
			var $firstButton = $("<input id=" + first + " type=button style=float:right value=首页 />").addClass(buttonClass);
			var $preButton = $("<input id=" + pre + " type=button style=float:right value=上一页 />").addClass(buttonClass);
			var $nextButton = $("<input id=" + next + " type=button style=float:right value=下一页 />").addClass(buttonClass);
			var $lastButton = $("<input id=" + last + " type=button style=float:right value=末页 />").addClass(buttonClass);

			$buttonArea.append($lastButton).append($nextButton).append($preButton).append($firstButton);
			$div.append($buttonArea);

			area.append($div);
		}

		function createHead(area) {
			var $thead = $("<thead></thead");
			var headName = args["headName"];
			var ignoreNull = args["ignoreNull"];
			if(args["needDate"] == true){
				$thead.append("<th>日期</th>");
			}
			var heads = new Array();
			if(headName.length == 0){
				for(i in jsonObj[0]){
					if(ignoreNull && jsonObj[0][i] == null)
						continue;
					//$thead.append("<th>" + i + "</th>");
					heads.push("<th>" + i + "</th>");
				}
			}else{
				for(var i = 0;i < headName.length;i++){
					//$thead.append("<th>" + headName[i] + "</th>");
					heads.push("<th>" + headName[i] + "</th>");
				}
			}
			$thead.append(heads.join(''));
			
			area.append($thead).append("<tbody></tbody>");
		}

		//@ param page 第几页
		function createPage(area, page){
			var $tbody = area.find("tbody");
			var ignoreNull = args["ignoreNull"];
			var needKey = args["needKey"];
			var max = args["maxcols"];
			var link = args["link"];
			var linkcols = args["linkcols"];
			var linkdata = args["linkdata"];

			var key = args["key"];

			var needDate = args["needDate"];
			var now = "";
			var nows;
			var dayArray = new Array();
			if(needDate == true){
				var days = 0;
				now = args["createDate"];
				nows = now.split("-");
				var year = parseInt(nows[0]), month = parseInt(nows[1]);
				if(month == 1 || month == 3 || month == 5 || month == 7 || month ==8 || month == 10 || month == 12){
					days = 31;
				}else if(month == 2){
					days = 28;
				}else{
					days = 30;
				}
				if(year % 4 == 0 && month == 2){
					days = 29;
				}
				for(var i = 0;i < days;i++){
					dayArray.push(i + 1);
				}
			}

			$tbody.empty();
			var rows = parseInt(args["rows"]);
			for(var i = (page - 1) * rows;i < jsonObj.length && i < page * rows;i++){
				var $tr = $("<tr></tr>");
				if (needDate == true) {
				    if (i >= dayArray.length) {
				        return;
				    }
					$tr.append("<td>" + nows[1] + "月" + dayArray[i] + "日</td>");
				}
				var count = 0;
				var flag = false;
				var tds = new Array();
				for (x in jsonObj[i]) {
				    if (max != 0 && count > max)
				        break;
					if(ignoreNull && jsonObj[i][x] == null)
						continue;
				    //$tr.append("<td>" + jsonObj[i][x] + "</td>");
					if (needKey && key.indexOf(x) > -1 && !flag) {
					    tds.push("<td><input type=hidden value='" + jsonObj[i][x] + "' />");
					    flag = true;
					} else if (needKey && flag) {
					    tds.push(jsonObj[i][x] + "</td>");
					    flag = false;
					} else if (link && count == linkcols && jsonObj[i][linkdata] != null && jsonObj[i][linkdata] != "") {
					    tds.push("<td>" + jsonObj[i][x] + "<br/><a href='" + jsonObj[i][linkdata] + "' target=_blank >文件</a>" + "</td>");
					} else {
					    tds.push("<td>" + jsonObj[i][x] + "</td>");
					}
					count++;
				}
				var less = args["lessLength"];
				if (less != 0) {
				    if(needKey)count--;
					while(count < less ){
						tds.push("<td>&nbsp;</td>");
						count++;
					}
				}
				$tr.append(tds.join(''));
				$tbody.append($tr);
			}
		}

		function initBindPage(page){
		    var sumPage = parseInt($("#sumPage").val());
			if(page == 1 && sumPage > 1){
				pagesChange.nextPage();
				pagesChange.lastPage();
			} else if (page == sumPage && sumPage > 1) {
			    pagesChange.firstPage();
			    pagesChange.prePage();
			} else if(sumPage > 1) {
			    pagesChange.firstPage();
			    pagesChange.prePage();
			    pagesChange.nextPage();
			    pagesChange.lastPage();
			}
		}
		var pagesChange = {
			first: "#" + args["first"],
			pre: "#" + args["pre"],
			next: "#" + args["next"], 
			last: "#" + args["last"],
			firstPage: function firstPage(){
				$(this.first).removeClass("disabled").bind("click", function(){
				$("#currentPage").val("1");
				createPage(_thiss, 1);
				pagesChange.nextPage();
				pagesChange.lastPage();
				$(this).addClass("disabled").unbind("click");
				$(pagesChange.pre).addClass("disabled").unbind("click");
				});
			},

			prePage: function prePage(){
			    $(this.pre).removeClass("disabled").bind("click", function () {
			        var current = parseInt($("#currentPage").val());
					$("#currentPage").val(current - 1);
					createPage(_thiss,current - 1);
					if(current == parseInt($("#sumPage").val())){
						pagesChange.nextPage();
						pagesChange.lastPage();
					}
					if (current == 2) {
					    $(this).addClass("disabled").unbind("click");
					    $(pagesChange.first).addClass("disabled").unbind("click");
					}
				});
			},

			nextPage: function nextPage(){
			    $(this.next).removeClass("disabled").bind("click", function () {
			        var current = parseInt($("#currentPage").val());
					$("#currentPage").val(current + 1);
					createPage(_thiss, current + 1);
					if(current == 1){
						pagesChange.firstPage();
						pagesChange.prePage();
					}
					if ($("#currentPage").val() == $("#sumPage").val()) {
					    $(this).addClass("disabled").unbind("click");
					    $(pagesChange.last).addClass("disabled").unbind("click");
					}
				});
			},

			lastPage: function lastPage(){
			    $(this.last).removeClass("disabled").bind("click", function () {
			        var sum = parseInt($("#sumPage").val());
					$("#currentPage").val(sum);
					createPage(_thiss,sum);
					pagesChange.firstPage();
					pagesChange.prePage();
					$(this).addClass("disabled").unbind("click");
					$(pagesChange.next).addClass("disabled").unbind("click");
				});
			},

		    toPage: function toPage(page){
		        var sum = parseInt($("#sumPage").val());
		        if (page > sum || page < 0)
		            return;
		        createPage(_thiss, page);
		        if (page == 0) {
		            pagesChange.nextPage();
		            pagesChange.lastPage();
		            $(pagesChange.first).addClass("disabled").unbind("click");
		            $(pagesChange.pre).addClass("disabled").unbind("click");
		        } else if (page == sum) {
		            pagesChange.firstPage();
		            pagesChange.prePage();
		            $(pagesChange.last).addClass("disabled").unbind("click");
		            $(pagesChange.next).addClass("disabled").unbind("click");
		        }
		    }
		}

		this.each(function () {
		    var page = args["pages"];
		    var $table = $(this).find("table").detach();
		    $(this).empty().append($table);
		    $table.empty();
			var isCreateButton = args["createButton"];
			var sumpages = init($(this));//计算页数
			if (sumpages < page) {
			    page = sumpages;
			}
			if (page < 1) {
			    page = 1;
			}
			if(isCreateButton){
				createButton($(this));
			}
			createHead($table);
			createPage($table, parseInt(page));//创建第一页
			$("#currentPage").val(page);
			initBindPage(page);
		});
	}
})(jQuery);