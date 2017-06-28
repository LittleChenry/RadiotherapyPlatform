/**
 * 管理员主界面
 *
 **/


$(function () {
    //用户注销处理
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("../../pages/Login/Login.aspx");
    });

    //
})

/**
 * ajax 让后台注销用户Session
 **/
function removeSession() {
    $.ajax({
        type: "GET",
        url: "../../pages/Root/removeSession.ashx"
    });
}



