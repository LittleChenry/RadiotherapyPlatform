<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddPatient.aspx.cs" Inherits="pages_Main_AddPatient" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>放疗质控系统</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- css -->
  <link rel="stylesheet" href="../../css/Main/Records.css">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css">
  <!-- bootstrap datepicker -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datepicker/datepicker3.css" />
  <!-- DataTables -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<body class="hold-transition skin-blue sidebar-mini sidebar-collapse">
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>R</b>QS</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <div style="position: absolute;">
        <h3 style="margin-top: 13px;margin-left: 10px;color: white;">放疗质控系统</h3>
      </div>
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
            <!-- Messages: style can be found in dropdown.less-->
            <li class="dropdown messages-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="fa fa-envelope-o"></i>
                    <span id="NoticeNum" class="label label-success">0</span>
                </a>
                <ul class="dropdown-menu">
                <li class="header">通知公告</li>
                <li>
                    <!-- inner menu: contains the actual data -->
                    <ul id="Notice" class="menu">
                        <li>
                            <a href="#">
                                <h4>
                                    无
                                </h4>
                                <p class="pull-right"><i class="fa fa-user"></i> &nbsp;<i class="fa fa-clock-o"></i></p>
                            </a>
                        </li>
                    </ul>
                </li>
                <li class="footer"><a id="allNotice" href="javascript:;" target="_blank">查看全部</a></li>
                </ul>
            </li>
            <!-- Notifications: style can be found in dropdown.less -->
            <li class="dropdown notifications-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="fa fa-bell-o"></i>
                    <span id="WarningNum" class="label label-warning">0</span>
                </a>
                <ul class="dropdown-menu">
                    <li id="WarningTask" class="header">你有0条工作任务预警</li>
                    <li>
                        <!-- inner menu: contains the actual data -->
                        <ul id="TaskWarning-content" class="menu">
                            <li>
                                <a href="javascript:;">
                                    无
                                </a>
                            </li>
                        </ul>
                    </li>
                    <li class="footer"><a href="javascript:;">请及时处理</a></li>
                </ul>
            </li>
            <!-- Tasks: style can be found in dropdown.less -->
            <li class="dropdown tasks-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <i class="fa fa-flag-o"></i>
                    <span class="label label-danger">9</span>
                </a>
                <ul class="dropdown-menu">
                    <li class="header">You have 9 tasks</li>
                    <li>
                        <!-- inner menu: contains the actual data -->
                        <ul class="menu">
                        <li><!-- Task item -->
                            <a href="#">
                                <h3>
                                    Design some buttons
                                    <small class="pull-right">20%</small>
                                </h3>
                                <div class="progress xs">
                                    <div class="progress-bar progress-bar-aqua" style="width: 20%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
                                        <span class="sr-only">20% Complete</span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <!-- end task item -->
                        <li><!-- Task item -->
                        <a href="#">
                            <h3>
                                Create a nice theme
                                <small class="pull-right">40%</small>
                            </h3>
                            <div class="progress xs">
                                <div class="progress-bar progress-bar-green" style="width: 40%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
                                    <span class="sr-only">40% Complete</span>
                                </div>
                            </div>
                        </a>
                        </li>
                        <!-- end task item -->
                        <li><!-- Task item -->
                            <a href="#">
                                <h3>
                                    Some task I need to do
                                    <small class="pull-right">60%</small>
                                </h3>
                                <div class="progress xs">
                                    <div class="progress-bar progress-bar-red" style="width: 60%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
                                        <span class="sr-only">60% Complete</span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <!-- end task item -->
                        <li><!-- Task item -->
                            <a href="#">
                                <h3>
                                    Make beautiful transitions
                                    <small class="pull-right">80%</small>
                                </h3>
                                <div class="progress xs">
                                    <div class="progress-bar progress-bar-yellow" style="width: 80%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
                                        <span class="sr-only">80% Complete</span>
                                    </div>
                                </div>
                            </a>
                        </li>
                        <!-- end task item -->
                        </ul>
                    </li>
                    <li class="footer">
                        <a href="#">View all tasks</a>
                    </li>
                </ul>
            </li>
            <!-- User Account: style can be found in dropdown.less -->
            <li class="dropdown user user-menu">
                <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                    <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                    <span id="out-name" class="hidden-xs"><%=((UserInformation)Session["loginUser"]) == null ?  "未登录" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                </a>
                <ul class="dropdown-menu">
                    <!-- User image -->
                    <li class="user-header">
                        <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                        <p>
                            <span id="in-name"><%=((UserInformation)Session["loginUser"]) == null ?  "未登录" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                            <small id="role"><%=((UserInformation)Session["loginUser"]) == null ?  "无" : ((UserInformation)Session["loginUser"]).GetUserRole() %></small>
                        </p>
                    </li>
                    <!-- Menu Body -->
                    <li class="user-body">
                        <div class="row">
                            <div class="text-center">
                                <div>
                                    <span>操作成员:</span>
                                    <a id="changeOperator" href="javascript:;"><span id="operator"></span></a>
                                </div>
                                <div>
                                    <span>操作设备:</span>
                                    <a id="changeEquipment" href="javascript:;"><span id="chosenEquipment"></span></a>
                                </div>
                                <div>
                                    <span>时间范围:</span>
                                    <a id="changeDate" href="javascript:;"><span id="dateRange"></span></a>
                                </div>
                            </div>
                        </div>
                        <!-- /.row -->
                    </li>
                    <!-- Menu Footer-->
                    <li class="user-footer">
                        <div class="pull-left">
                            <a href="../Login/changeRole.aspx" class="btn btn-default btn-flat">切换角色</a>
                        </div>
                        <div class="pull-right">
                            <a id="signOut" href="javascript:;" class="btn btn-default btn-flat">注销</a>
                        </div>
                    </li>
                </ul>
            </li>
        </ul>
      </div>
    </nav>
  </header>
  <!-- Left side column. contains the logo and sidebar -->
  <aside class="main-sidebar">
    <!-- sidebar: style can be found in sidebar.less -->
    <section class="sidebar">
      <!-- Sidebar user panel -->
      <div class="user-panel">
        <div class="pull-left image">
          <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
        </div>
        <div class="pull-left info">
          <p>Alexander Pierce</p>
          <a href="#"><i class="fa fa-circle text-success"></i> Online</a>
        </div>
      </div>
      <!-- search form -->
      <form action="#" method="get" class="sidebar-form">
        <div class="input-group">
          <input type="text" name="q" class="form-control" placeholder="Search...">
              <span class="input-group-btn">
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
                </button>
              </span>
        </div>
      </form>
      <!-- /.search form -->
      <!-- sidebar menu: : style can be found in sidebar.less -->
      <ul class="sidebar-menu">
        <li class="header">MAIN NAVIGATION</li>
        <li>
          <a href="pages/calendar.html">
            <i class="fa fa-calendar"></i>
            <span>科室概况</span>
          </a>
        </li>
        <li class="treeview">
          <a href="Main.aspx">
            <i class="fa fa-dashboard"></i>
            <span>患者汇总</span>
          </a>
        </li>
        <li class="active treeview">
          <a href="AddPatient.aspx">
            <i class="fa fa-files-o"></i>
            <span>患者登记</span>
          </a>
        </li>
        <li class="treeview">
          <a href="AppointmentView.aspx">
            <i class="fa fa-list-alt"></i>
            <span>预约视图</span>
          </a>
        </li>
        <li>
          <a href="pages/widgets.html">
            <i class="fa fa-th"></i>
            <span>计划</span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-pie-chart"></i>
            <span>收费</span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-laptop"></i>
            <span>任务管理</span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-edit"></i>
            <span>信息统计</span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-table"></i>
            <span>排队叫号</span>
          </a>
        </li>
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

    <div class="content-wrapper">
        <section id="choosepatient-content" class="outlist-content col-md-1 col-md-offset-2" style="padding:0px;width:200px;">
            <div class="outlist-title">
                外系统信息同步
                <a href="javascript:;" style="color:white;"><i class="fa fa-fw fa-refresh"></i></a>
            </div>
            <div style="padding:3px 0px;">
                <input class="form-control" type="text" placeholder="搜索" />
            </div>
            <table class="table table-condensed table-hover">
                <tbody style="text-align:center;">
                    <tr>
                        <th>姓名</th>
                        <th>病案号</th>
                    </tr>
                    <tr>
                        <td>赵一雷</td>
                        <td>2017072301</td>
                    </tr>
                    <tr>
                        <td>王二江</td>
                        <td>2017072302</td>
                    </tr>
                </tbody>
            </table>
        </section>
        <section id="addpatient-content" class="content table-responsive col-md-9" style="background-color:#fff;width:1000px;">
            <form id="frmaddpatient" name="frmaddpatient" method="post" runat="server">
                <div class="paper">
                <div class="paper-title">
                    患者信息登记
                </div>
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden" id="progress" name="progress" />
                <input type="hidden" id="userID" name="userID" />
                <input type="hidden" id="regdoctor" name="regdoctor" />
                <input id="patientID" type="hidden" name="patientID" />
                <input id="treatID" type="hidden" name="treatID" />
                    <div class="paper-content">
                        <div class="content-title">
                            <span>基本信息：</span>
                        </div>
                        <div class="head-picture" style="margin-left:800px;top:175px;">
                            <div class="imgbox">
                                <div class="boxes">
                                    <div class="imgnum">
                                        <input type="file" id="FileUpload" name="FileUpload" class="singlefilepath filepath" />
                                        <span class="closecamera resetarra"><i class="fa fa-times"></i></span>
                                        <img id="background-photo" src="../../img/avatar.jpg" class="camera-picture" />
                                        <img src="" id="photo" class="img" />
                                    </div>
                                </div>
                            </div>
                            <div class="picture-remark">
                                <p>上传头像</p>
                                <p style="font-size:10px;">120*140像素</p>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">姓名：</span>
                                <input id="userName" name="userName" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                            <div class="item col-xs-5"> 
                                <span class="col-xs-4">性别：</span>
                                <span class="col-xs-4" style="padding-left:0px;">
                                <input type="radio" name="Gender" id="male" value="M" />
                                    男
                                </span>
                                <span class="col-xs-4" style="padding-left:0px;">
                                <input type="radio" name="Gender" id="female" value="F" />
                                    女
                                </span>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">民族：</span>
                                <input id="Nation" name="Nation"  class="form-item" type="text" AUTOCOMPLETE="OFF" />
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">出生日期：</span>
                                <input class="form-item" id="Birthday" name="Birthday"type="text" placeholder="选择日期" AUTOCOMPLETE="OFF"/>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">身份证号：</span>
                                <input id="IDcardNumber"  name="IDcardNumber" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-10">
                                <span class="form-text col-xs-2" style="padding-left:0px;width:120.2px;">地址：</span>
                                <select id="id_provSelect"  class="form-item col-xs-3" name="provSelect" onChange="loadCity(this.value);" style="width:196.4px;">
                                    <option value="">请选择省份</option>
                                </select>
                                <select id="id_citySelect" class="form-item col-xs-3" name="citySelect" onChange="loadArea(this.value);" style="width:196.4px;">
                                    <option value="">请选择城市</option>
                                </select>
                                <select id="id_areaSelect" class="form-item col-xs-3" name="areaSelect" style="width:196.4px;">
                                    <option value="">请选择区域</option>
                                </select>
                            </div>
                            <input type="hidden" name="provSelect_text" id="provSelect_text" />
                            <input type="hidden" name="citySelect_text" id="citySelect_text" />
                            <input type="hidden" name="areaSelect_text" id="areaSelect_text" />
                        </div>
                        <div class="single-row">
                            <div class="col-xs-10">
                                <span class="form-text col-xs-2" style="padding-left:0px;width:120.2px;">详细地址：</span>
                                <input id="addressmore" name="addressmore" class="form-item" type="text" AUTOCOMPLETE="OFF" style="width:52%;"/>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">联系电话1：</span>
                                <input id="Number1" name="Number1" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">联系电话2：</span>
                                <input id="Number2" name="Number2" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">身高：</span>
                                <div class="group-item" style="padding:0px;">
                                    <input type="number" id="height" name="height" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">体重：</span>
                                <div class="group-item" style="padding:0px;">
                                    <input type="number" id="weight" name="weight" class="form-group-input" />
                                    <span class="input-group-addon">kg</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="paper-content">
                        <div class="content-title">
                            <span>病案信息：</span>
                        </div>
                          <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">是否住院：</span>
                                <span class="col-xs-2" style="padding-left:0px;">
                                <input  name="RecordNumber" type="radio" value="1"  />是
                                </span>
                                 <span class="col-xs-2" style="padding-left:0px;">
                                <input  name="RecordNumber" type="radio" value="0"  />否
                               </span>
                            </div>
                            <div id="ishospital" class="col-xs-6">
                                <span class="form-text col-xs-4">住院号：</span>
                                <input id="hospitalnumber" name="hospitalnumber" type="text" class="form-item" AUTOCOMPLETE="OFF" />
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">所属医生：</span>
                                <select id="doctor" name="doctor" class="form-item"></select>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">所选分组：</span>
                                <select id="group" name="group" class="form-item">
                                    <option value="allItem">----分组选择-----</option>
                                </select>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">分中心负责人：</span>
                                <input id="Sub" name="Sub" class="form-item" AUTOCOMPLETE="OFF"/>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">分中心医院：</span>
                                <input id="Hospital" name="Hospital" type="text" class="form-item" AUTOCOMPLETE="OFF" />
                            </div>
                        </div>
                    </div>
                    <div class="paper-footer">
                        <div class="single-row">
                            <div class="item col-xs-6">登记人：<span id="operate" class="underline"></span></div>
                            <div class="item col-xs-6">登记时间：<span id="date" class="underline"></span></div>
                        </div>
                    </div>
                </div>          
                <div class="row" style="text-align:center;margin-top:20px;">
                    <button id="save" type="button" class="btn btn-block btn-success" style="margin:auto;width:20%;">保存</button>
                </div>
            </form>
        </section>
    </div>
    <footer class="main-footer">
        <div class="pull-right hidden-xs">
            <b>Version</b> 2.0
        </div>
        <strong>Copyright &copy; 2017 <a href="#"> 医院</a> .</strong> 保留所有权利
    </footer>
    <div class="control-sidebar-bg"></div>
</div>

<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
      <!-- bootstrap datepicker -->
    <script src="../../plugin/AdminLTE/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- DataTables -->
<script src="../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.min.js"></script>
<!-- SlimScroll -->
<script src="../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="../../plugin/AdminLTE/dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../plugin/AdminLTE/dist/js/demo.js"></script>
<!-- js -->
<script src="../../js/Main/AddPatient.js"></script>
 <script src="../../js/Main/addimgs.js"></script>
<script type="text/javascript" src="../../js/Main/TestAddress.js"></script>
<script type="text/javascript" src="../../js/Main/TestChooseAddress.js"></script>
<script>
    $("#addpatient-content").css("minHeight", $(document).height() - 101);
    $("#choosepatient-content").css("minHeight", $(document).height() - 101);
    $("#Birthday").datepicker({ autoclose: true });
</script>
</body>
</html>