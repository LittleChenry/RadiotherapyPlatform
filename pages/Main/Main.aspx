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
        <a class="logo">
            <span class="logo-mini"><b>R</b>QS</span>
        </a>
        <nav class="navbar navbar-static-top">
            <div style="position: absolute;">
                <h3 style="margin-top: 13px;margin-left: 10px;color: white;">放疗质控系统</h3>
            </div>
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown messages-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-envelope-o"></i>
                            <span id="NoticeNum" class="label label-success">0</span>
                        </a>
                        <ul class="dropdown-menu">
                        <li class="header">通知公告</li>
                        <li>
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
                    <li class="dropdown notifications-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-bell-o"></i>
                            <span id="WarningNum" class="label label-warning">0</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li id="WarningTask" class="header">你有0条工作任务预警</li>
                            <li>
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
                    <li class="dropdown tasks-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-flag-o"></i>
                            <span class="label label-danger">9</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">设备动态</li>
                            <li>
                                <ul class="menu">
                                    <li>
                                        <a href="javascript:;">
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
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="javascript:;">查看详情</a>
                            </li>
                        </ul>
                    </li>
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                            <span id="out-name" class="hidden-xs"><%=((UserInformation)Session["loginUser"]) == null ?  "未登录" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="user-header">
                                <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                                <p>
                                    <span id="in-name"><%=((UserInformation)Session["loginUser"]) == null ?  "未登录" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                                    <small id="role"><%=((UserInformation)Session["loginUser"]) == null ?  "无" : ((UserInformation)Session["loginUser"]).GetUserRole() %></small>
                                </p>
                            </li>
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
                            </li>
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
    <aside class="main-sidebar">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image" />
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="header">MAIN NAVIGATION</li>
                <li class="active treeview">
                    <a href="Main.aspx">
                        <i class="fa fa-users"></i>
                        <span>患者汇总</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="EquipmentAppointment.aspx" target="_blank">
                        <i class="fa fa-clock-o"></i>
                        <span>设备预约管理</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="AddPatient.aspx">
                        <i class="fa fa-pencil"></i>
                        <span>患者登记</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="NewsList.aspx?role=<%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).getRoleName() %>">
                        <i class="fa fa-bell-o"></i>
                        <span>通知公告</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-briefcase"></i> <span>设备管理</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li>
                            <a id="Menu-EquipmentInspection" href="EquipmentInspection.aspx"><i class="fa fa-circle-o"></i>设备检查</a>
                        </li>
                        <li>
                            <a id="Menu-EquipmentInspectionResult" href="EquipmentInspectionResult.aspx"><i class="fa fa-circle-o"></i>设备检查结果</a>
                        </li>
                        <li>
                            <a id="Menu-EquipmentStatistics" href="EquipmentStatistics.aspx"><i class="fa fa-circle-o"></i>设备检查统计</a>
                        </li>
                    </ul>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-plus-square"></i> <span>诊断结果管理</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li>
                            <a id="Menu-ConditionResultManage" href="ConditionResultManage.aspx"><i class="fa fa-circle-o"></i>病情诊断结果管理</a>
                        </li>
                        <li>
                            <a id="Menu-PathologyResultManage" href="PathologyResultManage.aspx"><i class="fa fa-circle-o"></i>病理诊断结果管理</a>
                        </li>
                    </ul>
                </li>
                <%--<li class="treeview">
                    <a href="#">
                        <i class="fa fa-rmb"></i>
                        <span>收费</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-tasks"></i>
                        <span>任务管理</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-pie-chart"></i>
                        <span>信息统计</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-table"></i>
                        <span>排队叫号</span>
                    </a>
                </li>--%>
            </ul>
        </section>
    </aside>
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
        <nav class="tab-nav" style="padding-left:0px;padding-top:5px;">
            <div style="text-align:center;">
                <span>疗程状态：</span>
                <span id="patient-status">无</span>
                <%--<div class="btn-group">
                    <button id="patient-status" type="button" class="btn btn-success"><i class="fa fa-fw fa-forward"></i>进行中</button>
                    <button id="manageTreatment" type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown" disabled="disabled">
                    <span class="caret"></span>
                    </button>
                    <ul class="dropdown-menu" role="menu" style="min-width:112px;">
                        <li><a id="addTreatment" data-toggle="modal" data-target="#myModal">新增疗程</a></li>
                        <li><a id="pauseTreatment">暂停疗程</a></li>
                        <li><a id="stopTreatment">结束疗程</a></li>
                    </ul>
                </div>--%>
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
<script src="../../js/Main/HeaderOperate.js"></script>
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
