<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Register.aspx.cs" Inherits="pages_Login_Register" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>注册</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
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
<body class="hold-transition register-page">
    <div class="background-img-fixed" style="margin:auto;text-align:center;">
        <img src="../../img/hospital.png" />
    </div>
    <div style="margin-left:15px;margin-top:20px">
        <img src="../../img/title-mini.png" />
    </div>
    <div style="margin-left:15px;margin-top:0px">
        <img src="../../img/title-english-mini.png" />
    </div>
    <div class="register-box-body toCenter toDown slim">
        <h2 class="login-box-msg short">请注册</h2>

        <form action="Register.aspx" method="post">
            <input type="hidden" name="ispostback" value="true" />
            <div class="form-group has-feedback">
                <input id="userName" type="text" class="form-control isEmpty userName" placeholder="请输入账号" />
                <span class="glyphicon glyphicon-envelope form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input type="text" class="form-control isEmpty name" placeholder="请输入姓名" />
                <span class="glyphicon glyphicon-user form-control-feedback"></span>
            </div>
            <div class="form-input form-group has-feedback">
                <label class="word-left col-sm-3 control-label">性别：</label>
				    <div class="col-sm-9">
                        <div class="col-xs-6">
                            <label for="male" >
                            <input id="male" type="radio" name="sex" checked="true" class="checkSex" style="width:20pt" value="M" />
                                    男
                         </label>
                        </div>
                        <div class="col-xs-6">
                            <label for="female">
                            <input id="female" type="radio" name="sex" class="checkSex" style="width:20pt" value="F" />
                                    女
                         </label>
                        </div>                         
					</div>
               </div>
        
            <div class="form-group has-feedback">
                <input id="userKey" type="password" class="form-control isEmpty userKey" placeholder="请输入密码" />
                <span class="glyphicon glyphicon-lock form-control-feedback"></span>
            </div>
            <div class="form-group has-feedback">
                <input id="checkPassWord" type="password" class="form-control checkPassWordError checkUserKey" placeholder="请再次输入密码" />
                <span class="glyphicon glyphicon-log-in form-control-feedback"></span>
            </div>

            <div class="form-group has-feedback">
				    <select id="office" name="office" class="office form-control" >
                        <option value="">--请选择办公室--</option>
                        <option value="登记处">登记处</option>
                        <option value="放疗设备状态监测室">放疗设备状态监测室</option>
                        <option value="加速器治疗室">加速器治疗室</option>
                        <option value="模具摆放室">模具摆放室</option>
                        <option value="模拟定位室">模拟定位室</option>
                        <option value="物理室">物理室</option>
                        <option value="医生工作室">医生工作室</option>
                        <option value="制模室">制模室</option>
                     </select>
            </div>

            <div class="form-group has-feedback">
			    <input id="contact" type="text" class="form-control phone" size="30" name="phoneNumber" placeholder="请输入手机号码" />
				<span class="glyphicon glyphicon-phone form-control-feedback"></span>
            </div>


            <div class="row">
                <div class="col-xs-8">
                    <label>
                        <a href="Login.aspx" class="text-center">I already have a membership</a>
                    </label>
                </div>
                <div class="col-xs-4">
                    <input type="submit" class="btn btn-primary btn-block btn-flat" value="注册" />
                </div>
            </div>        
        <!-- /.col -->
    </form>
    <label id="error"></label>

  </div>
  <!-- /.form-box -->
<!-- /.register-box -->
<footer class="main-footer" style="margin:0px;position:fixed;bottom:0;width:100%;background-color:transparent;border:0px;color:#c1c1c1;font-size:16px;">
    <div class="pull-right hidden-xs">
        <b>Version</b> 2.0
    </div>
    <strong>Copyright &copy; 2017-2017 <a href="#">医院</a> .</strong> 保留所有权利
</footer>

<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/jquery.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- iCheck -->
<script src="../../plugin/AdminLTE/plugins/iCheck/icheck.min.js"></script>
<script src="../../js/Login/RegisterJS.js"></script>

</body>
</html>
