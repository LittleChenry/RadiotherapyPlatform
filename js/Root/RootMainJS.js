/**
 * 管理员主界面
 *
 **/


$(function () {
    //用户注销处理
    $("#signOut").bind("click", function () {
        removeSession();//ajax 注销用户Session
        window.location.replace("/RadiotherapyPlatform/pages/Login/Login.aspx");
    });

    //
})

/**
 * ajax 让后台注销用户Session
 **/
function removeSession() {
    $.ajax({
        type: "GET",
        url: "/RadiotherapyPlatform/pages/Root/removeSession.ashx",
        error: function () {
            window.location.replace("/RadiotherapyPlatform/pages/Login/Login.aspx");
        }
    });
}



