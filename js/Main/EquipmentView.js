$(document).ready(function () {
    var session = getSession();
    if (session.role != "物理师" && session.role != "模拟技师" && session.role != "治疗技师") {
         $("#Menu-EquipmentView").attr("href", "javascript:;");
         $("#Menu-EquipmentView").bind("click", function(){
            alert("权限不够！");
         });
    }
});