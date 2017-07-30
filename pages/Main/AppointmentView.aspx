<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AppointmentView.aspx.cs" Inherits="pages_Main_AppointmentView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
 <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--Tell the brower to be responsive to screen width -->
    <meta content="Width=device-width, initial-scale=1, maxmum-scale=1, user-scalable=no" name="viewport" />
    <!--Boostrap -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css" />
    <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css" />

    <!-- Main Css -->
    <link rel="stylesheet" href="../../css/Root/rootMain.css" />
    <%--<link rel="stylesheet" href="../../css/Main/appointmentCss.css" />--%>
    <title>预约展示</title>
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
          <a href="AppointmentView.aspx">
            <i class="fa fa-list-alt"></i>
            <span>预约视图</span>
          </a>
        </li>
        <li class="treeview">
          <a href="AddPatient.aspx">
            <i class="fa fa-files-o"></i>
            <span>患者登记</span>
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

  <!-- Content Wrapper. Contains page content -->
  <!--  style="background-image:url(../../img/hospital.png)" -->
  <div class="content-wrapper">
    <section class="content">
         <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">预约视图</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="col-md-4">&nbsp;</div>
                <div class="col-md-4">
                    <div class="form-group input-group">
                        <select id="equipmentSelect" class="form-control">
                            
                        </select>
                        <span class="input-group-btn">
                            <button class="btn btn-default" style="height:34px" type="button" id="sureTable">
                                确定
                            </button>
                        </span>
                    </div>
                </div>
            </div>
            <!-- 搜索框 -->
            <div class="col-md-12">
                <div class="panel panel-default mintablewidth">
                    <div class="panel-heading mintablewidth">
                        <i class="fa fa-bar-chart-o fa-fw"></i>
                        <span class="panel-title">预约表</span>
                    </div>
                    <div id="tableArea" class="panel-body mintablewidth">
                        <table id="appointTable" class="table table-bordered table-hover dataTable" style="width:100%;text-align:center;">
                            <thead id="thead">

                            </thead>
                            <tbody id="tbody">

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            
        </div>
        <!-- body row-->
    </section>
  </div>
  <!-- /.content-wrapper -->
  <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 2.0
    </div>
    <strong>Copyright &copy; 2017 <a href="#"> 医院</a> .</strong> 保留所有权利
  </footer>

  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

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
<!-- Main javascript -->
<script src="../../js/Main/HeaderOperate.js"></script>
<script src="../../js/Main/AppiontmentViewJS.js"></script>
</body>
</html>
