$(document).ready(function () {
	var session = getSession();
    Notice(session.roleName);
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("../Login/Login.aspx");
    });
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
         $("#Menu-EquipmentInspection").attr("href", "javascript:;");
         $("#Menu-EquipmentInspectionResult").attr("href", "javascript:;");
         $("#Menu-EquipmentStatistics").attr("href", "javascript:;");
         $("#Menu-EquipmentInspection").bind("click", function(){
            alert("权限不够！");
         });
         $("#Menu-EquipmentInspectionResult").bind("click", function(){
            alert("权限不够！");
         });
         $("#Menu-EquipmentStatistics").bind("click", function(){
            alert("权限不够！");
         });
    }
    if (session.role != "医师") {
         $("#Menu-ConditionResultManage").attr("href", "javascript:;");
         $("#Menu-PathologyResultManage").attr("href", "javascript:;");
         $("#Menu-ConditionResultManage").bind("click", function(){
            alert("权限不够！");
         });
         $("#Menu-PathologyResultManage").bind("click", function(){
            alert("权限不够！");
         });
    }
    if (session.role != "治疗技师") {
         $("#Menu-Appointment").attr("href", "javascript:;");
         $("#Menu-Appointment").bind("click", function(){
            alert("权限不够！");
         });
    }
})

function getSession() {
    var Session;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getSession.ashx",
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            Session = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return Session;
}

function getNotice(role){
    var notice;
    $.ajax({
        type: "GET",
        url: "../../pages/Main/Records/getNews.ashx?role=" + role,
        async: false,
        dateType: "text",
        success: function (data) {
            //alert(data);
            notice = $.parseJSON(data);
        },
        error: function () {
            alert("error");
        }
    });
    return notice;
}

function Notice(role){
    var notice = getNotice(role);
    var NoticeContent = $("#Notice");
    var NoticeNum = $("#NoticeNum");
    var allNotice = $("#allNotice");
    NoticeContent.html("");
    for (var i = 0; i < notice.patientInfo.length; i++) {
        var singleNotice = '<li><a href="Notice.aspx?ID=' + notice.patientInfo[i].ID + '" target="_blank"><h4>';
        if (notice.patientInfo[i].Important == '1') {
            singleNotice += '<i class="fa fa-hand-pointer-o"></i>';
        }else{
            singleNotice +='<i class="fa fa-tag"></i>';
        }
        singleNotice += limitString(notice.patientInfo[i].Title, 18);
        singleNotice += '</h4><p class="pull-right"><i class="fa fa-user"></i>'
        singleNotice += notice.patientInfo[i].Release_User_Name;
        singleNotice += '&nbsp;<i class="fa fa-clock-o"></i>';
        singleNotice += formatTime(notice.patientInfo[i].Releasetime);
        singleNotice += '</p>';
        NoticeContent.append(singleNotice);
    }
    NoticeNum.html(NoticeContent.find("li").length);
    allNotice.attr("href", "NewsList.aspx?role=" + role);
}

function formatTime(time){
    NoticeTime = new Date(time).Format("yyyy-MM-dd");
    currentTime = new Date().Format("yyyy-MM-dd");
    preDate = new Date(new Date().getTime() - 24*60*60*1000).Format("yyyy-MM-dd");
    if (NoticeTime == currentTime) {
        return "今天";
    }else{
        if (NoticeTime == preDate) {
            return "昨天";
        }
    }
    return NoticeTime;
}

function limitString(str, num){
    var ls;
    if (str.length > num) {
        ls = str.substring(0, num -1) + "…";
        return ls;
    }else{
        return str;
    }
}

function removeSession() {
    $.ajax({
        type: "GET",
        url: "../../Root/removeSession.ashx"
    });
}

Date.prototype.Format = function (fmt) {
    var o = {
        "M+": this.getMonth() + 1,
        "d+": this.getDate(),
        "h+": this.getHours(),
        "m+": this.getMinutes(),
        "s+": this.getSeconds(),
        "q+": Math.floor((this.getMonth() + 3) / 3),
        "S": this.getMilliseconds()
    };
    if (/(y+)/.test(fmt))
        fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
    for (var k in o)
        if (new RegExp("(" + k + ")").test(fmt))
            fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
    return fmt;
}