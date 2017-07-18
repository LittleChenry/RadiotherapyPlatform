<%@ Page Language="C#" AutoEventWireup="true" CodeFile="changeRole.aspx.cs" Inherits="pages_Login_changeRole" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport" />
    <!-- BootStrap -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css" />
    <!-- iCheck-->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/iCheck/square/blue.css" />

    <!-- Main Css -->
    <link rel="stylesheet" href="../../css/Main/Login.css" />
    <link rel="stylesheet" href="../../css/Main/loginmain.css" />
    <title>切换角色</title>
</head>
<body class="hold-transition login-page">
     <div class="background-img-fixed" style="margin:auto;text-align:center;">
        <img src="../../img/hospital.png" />
    </div>
    <div style="margin:auto;text-align:center;padding-top:6%;">
        <img src="../../img/title.png" style="width:65%;max-width: 1300px;" />
        <img src="../../img/title-english.png" style="width:65%;max-width: 1300px;" />
    </div>
     <div id="changeroles" class="login-box-body toCenter toDown" >
        <h2 class="login-box-msg">请选择登录角色</h2>
            <div class="form-group has-feedback">
                <select id="userRole" class="form-control"></select>
            </div>
            <br />
        <input id="login" type="button" value="登陆" class="btn btn-primary btn-block btn-flat"/>
      </div>
    <footer class="main-footer" style="margin:0px;position:fixed;bottom:0;width:100%;background-color:transparent;border:0px;color:#c1c1c1;font-size:16px;">
        <div class="pull-right hidden-xs">
            <b>Version</b> 2.0
        </div>
        <strong>Copyright &copy; 2017-2017 <a href="http://www.jsph.org.cn/"> 江苏省人民医院</a> .</strong> 保留所有权利
    </footer>
<script src="../../plugin/AdminLTE/jquery.min.js"></script>  
<script src="../../js/Login/changeRoleJS.js"></script>
</body>
</html>
