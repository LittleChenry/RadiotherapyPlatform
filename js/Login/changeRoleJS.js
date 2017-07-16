//将用户角色填入下拉菜单
$(function () {
    getRoles();
});

//切换角色登陆
$(function () {
    $("#login").bind("click", function () {
        var selectRole = $("#userRole").val();
        updateSession(selectRole);
        if(selectRole == "Root"){
            window.location.href = "../../pages/Root/RootMain.aspx";
        }else{
            window.location.href="../../pages/Main/Main.aspx";
        }
    });
});

//获取角色
function getRoles() {
    $.ajax({
        type: "get",
        url: "handlerChangeRole.ashx",
        datatype: "text",
        success: function (data) {
            var jsonObj = $.parseJSON(data);
            fillRoles(jsonObj);
        }
    });
}

//填入角色
function fillRoles(roles) {
    var $select = $("#userRole");
    for (var i = 0; i < roles.length; i++) {
        $select.append("<option value=" + roles[i].Name + " >" + roles[i].Description + "</option>");
    }
}

//更新session中用户当前角色
function updateSession(selectRole){
    $.ajax({
        type: "POST",
        async: false,
        url: "handlerUpdateSession.ashx",
        data: { "role": selectRole }
    });
}