<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ChangeKey.aspx.cs" Inherits="pages_Login_ChangeKey" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <title>修改密码</title>
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
</head>
<body class="hold-transition login-page">
     <div class="background-img-fixed" style="margin:auto;text-align:center;">
        <img src="../../img/hospital.png" />
    </div>
    <div style="margin:auto;text-align:center;padding-top:6%;">
        <img src="../../img/title.png" style="width:65%;max-width: 1300px;" />
        <img src="../../img/title-english.png" style="width:65%;max-width: 1300px;" />
    </div>
    <div id="loginDiv" class="login-box-body toCenter littleDown">
    <h3 class="login-box-msg">修改密码</h3>
    <form method="post">
      <div class="form-group has-feedback" style="margin-top:15px;">
        <input id="userNumber" type="text" class="form-control isEmpty userName" placeholder="请输入账号" />
        <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
      </div>
      <div class="form-group has-feedback">
        <input id="userKey" type="password" class="form-control isEmpty userKey" placeholder="请输入旧密码" />
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
        <div class="form-group has-feedback">
        <input id="newKey" type="password" class="form-control isEmpty userKey" placeholder="请输入新密码" />
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
        <div class="form-group has-feedback">
        <input id="reKey" type="password" class="form-control isEmpty userKey" placeholder="请再次输入密码" />
        <span class="glyphicon glyphicon-lock form-control-feedback"></span>
      </div>
      <div class="row">
        <div class="col-sm-8">&nbsp;</div>
        <!-- /.col -->
        <div class="col-sm-4">
          <input id="sureChange" type="button" class="btn btn-primary btn-block btn-flat" value="确定" />
        </div>
        <!-- /.col -->
      </div>
    </form>

    <div class="social-auth-links text-center">
      <p>- OR -</p>
    </div>
    <!-- /.social-auth-links -->
    <label id="errors" class="tohidden" style="float:left;"></label>
    <a id="back" href="Login.aspx" class="text-center" style="float:right;">返回</a>
    </div>

    <footer class="main-footer" style="margin:0px;position:fixed;bottom:0;width:100%;background-color:transparent;border:0px;color:#c1c1c1;font-size:16px;">
        <div class="pull-right hidden-xs">
            <b>Version</b> 2.0
        </div>
        <strong>Copyright &copy; 2017-2017 <a href="#">医院</a> .</strong> 保留所有权利
    </footer>
<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/jquery.min.js"></script>
<!-- mainJS -->
<script src="../../js/Login/changeKeyJS.js"></script>
</body>
</html>
