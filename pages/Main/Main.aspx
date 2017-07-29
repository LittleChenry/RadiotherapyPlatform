<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="pages_Main_Main" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>放疗质控系统</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- css -->
  <link rel="stylesheet" href="../../css/Main/main.css">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css">
  <!-- bootstrap datepicker -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datepicker/datepicker3.css">
  <!-- DataTables -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css">
  <!-- iCheck for checkboxes and radio inputs -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/iCheck/all.css">
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
          <a href="#">
            <i class="fa fa-calendar"></i>
            <span>科室概况</span>
          </a>
        </li>
        <li class="active treeview">
          <a href="Main.aspx">
            <i class="fa fa-dashboard"></i>
            <span>患者汇总</span>
          </a>
        </li>
        <li class="treeview">
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
          <a href="#">
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
    <div class="content-wrapper">
    <section id="main-content" class="col-xs-4" style="padding:0px;">
        <div class="layout-main-tab">
            <nav class="tab-nav">
                <div class="col-xs-8" style="text-align:center;">
                    <h4 class="box-title" style="font-weight:600;">患者汇总</h4>
                </div>
                <div class="col-xs-4" style="margin-top:2px;">
                    <input id="patient-search" type="search" class="form-control" placeholder="搜索">
                </div>
            </nav>
        </div>
        <div id="patient-content" class="box" style="border-top:0px;margin-bottom:0px;">
        <!-- /.box-header -->
        <div class="box-body" style="padding:0px;">
            <div id="patient-table-content" class="scroll-content">
                <table id="patient-table" class="table table-bordered" style="white-space:nowrap;margin-bottom:0px;"></table>
            </div>
            <div class="row" style="margin:1px;float:right;">
                <div class="col-sm-3">
                    <div class="dataTables_info" id="patient_info" role="status" aria-live="polite"></div>
                </div>
            </div>
        </div>
        <!-- /.box-body -->
        </div>
    </section>
    <section id="progress-content" class="col-xs-2" style="padding:0px;">
        <div class="layout-main-tab">
        <nav class="tab-nav" style="padding-left:0px;padding-top:3px;">
            <div style="text-align:center;">
                <div class="btn-group">
                    <button id="patient-status" type="button" class="btn btn-success"><i class="fa fa-fw fa-forward"></i>进行中</button>
                    <button id="manageTreatment" type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown" disabled="disabled">
                    <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" style="min-width:112px;">
                        <li><a id="addTreatment" data-toggle="modal" data-target="#myModal">新增疗程</a></li>
                        <li><a id="pauseTreatment">暂停疗程</a></li>
                        <li><a id="stopTreatment">结束疗程</a></li>
                    </ul>
                </div>
            </div>
        </nav>
        </div>
        <iframe id="progress-iframe" class="frame-content" src="Records/progress.html"></iframe>
      
    </section>
    <section id="record-content" class="col-xs-6" style="padding:0px;">
        <div class="layout-main-tab">
        <nav class="tab-nav" style="padding-top:3px;">
            <div>
            <button id="edit" class="btn btn-success" disabled="disabled"><i class="fa fa-fw fa-edit"></i>编辑</button>
            <button id="chooseTemplate" class="btn btn-success" data-toggle="modal" data-target="#TemplateList" disabled="disabled"><i class="fa fa-fw fa-send"></i>选择模板</button>
            <div class="btn-group">
                <button id="save" type="button" class="btn btn-success"  disabled="disabled"><i class="fa fa-fw fa-save"></i>保存</button>
                <button id="saveTemplate-list" type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown" disabled="disabled">
                    <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu" style="min-width:100px;">
                    <li><a id="saveTemplate-button">另存模板</a></li>
                </ul>
            </div>
            <button id="printIframe" class="btn btn-success"><i class="fa fa-fw fa-print"></i>打印</button>
            </div>
        </nav>
        </div>
        <iframe id="record-iframe" name="record-iframe" class="frame-content" src="Records/Blank.aspx"></iframe>
    </section>
    </div>
    <!-- /.content-wrapper -->
    <div id="myModal" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">新增疗程</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <div class="col-xs-12">
                            新疗程名:
                            <input id="newname" type="text" maxlength="8" class="form-control" />
                        </div>
                    </div>
                    <div class="pull-right" style="margin:10px;">默认数字编号，最多8个字。</div>
                    <table id="addTreatmentRecord" class="table table-bordered" ></table>
                    <input id="Radiotherapy_ID" type="text" hidden="hidden" />
                    <div class="panel box box-primary">
                        <div class="box-header">
                            <h4 class="box-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" class="collapsed">
                                    新疗程预览
                                </a>
                            </h4>
                        </div>
                        <div id="collapseOne" class="panel-collapse collapse" aria-expanded="false">
                            <div class="box-body">
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">登记信息：</div>
                                    <div class="col-xs-9">
                                        <span id="registerDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">病情诊断：</div>
                                    <div class="col-xs-9">
                                        <span id="diagnoseDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">体位固定：</div>
                                    <div class="col-xs-9">
                                        <span id="fixedDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">CT模拟：</div>
                                    <div class="col-xs-9">
                                        <span id="locationDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">计划设计：</div>
                                    <div class="col-xs-9">
                                        <span id="designDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">复位验证：</div>
                                    <div class="col-xs-9">
                                        <span id="replaceDetail">未选择</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="saveTreatment" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <div id="chooseMachine" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">选择设备</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <span>选择操作项目：</span>
                        <select id="equipmentType" class="form-control"></select>
                    </div>
                    <div class="form-group">
                        <span>选择设备：</span>
                        <select id="equipment" class="form-control"></select>
                    </div>
                    <div class="form-group">
                        <span>开始日期：</span>
                        <input type="text" class="form-control" id="startdate">
                    </div>
                    <div class="form-group">
                        <span>结束日期：</span>
                        <input type="text" class="form-control" id="enddate">
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="getSelectedPatient" type="button" class="btn btn-primary" data-dismiss="modal">查询所有患者</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <div id="Template" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">另存为模板</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <span>模板名称：</span>
                        <input type="text" class="form-control" id="templateName">
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="saveTemplate" type="button" class="btn btn-primary" data-dismiss="modal">保存模板</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
    <div id="TemplateList" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">选择模板</h4>
                </div>
                <div class="modal-body">
                    <table id="TemplateTable" class="table">
                        <tbody></tbody>
                    </table>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="confirm-Template" type="button" class="btn btn-primary" data-dismiss="modal">确定</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
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
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- DataTables -->
<script src="../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.min.js"></script>
<!-- bootstrap datepicker -->
<script src="../../plugin/AdminLTE/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- SlimScroll -->
<script src="../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
<!-- iCheck 1.0.1 -->
<script src="../../plugin/AdminLTE/plugins/iCheck/icheck.min.js"></script>
<!-- AdminLTE App -->
<script src="../../plugin/AdminLTE/dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../plugin/AdminLTE/dist/js/demo.js"></script>
<!-- js -->
<script src="../../js/Main/main.js"></script>

<script type="text/javascript">
    //$("#patient-table-content").slimScroll({  
    //    size: '8px',
    //    color: '#888888',
    //    wheelStep: 4,
    //    height: $(document).height() - 190
    //});
    $("#startdate").datepicker({ autoclose: true });
    $("#enddate").datepicker({ autoclose: true });
</script>
</body>
</html>
