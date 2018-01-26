<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Appointment.aspx.cs" Inherits="pages_Main_Appointment" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <title>放疗质控系统</title>
    <!-- Tell the browser to be responsive to screen width -->
    <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
    <!-- css -->
    <link rel="stylesheet" href="../../css/Main/main.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css">
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datepicker/datepicker3.css">
    <!-- DataTables -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css">
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/iCheck/all.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css">
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css">
    <!-- iCheck for checkboxes and radio inputs -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/iCheck/all.css">
    <!-- Theme style -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css">
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css">
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
                <li class="treeview">
                    <a href="Main.aspx">
                        <i class="fa fa-users"></i>
                        <span>患者汇总</span>
                    </a>
                </li>
                <li class="active treeview">
                    <a href="#">
                        <i class="fa fa-clock-o"></i> <span>预约</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li>
                            <a id="A1" href="EquipmentAppointment.aspx" target="_blank"><i class="fa fa-circle-o"></i>设备预约管理</a>
                        </li>
                        <li class="active">
                            <a id="A2" href="Appointment.aspx"><i class="fa fa-circle-o"></i>加速器预约</a>
                        </li>
                    </ul>
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
        <section id="main-content" class="col-xs-4" style="padding:0px;display:none;">
            <div class="layout-main-tab">
                <nav class="tab-nav">
                    <div class="col-xs-8" style="text-align:center;">
                        <h4 class="box-title" style="font-weight:600;">预约患者列表</h4>
                    </div>
                    <div class="col-xs-4" style="margin-top:2px;">
                        <input id="patient-search" type="search" class="form-control" placeholder="搜索">
                    </div>
                </nav>
            </div>
            <div id="patient-content" class="box" style="border-top:0px;margin-bottom:0px;">
                <div class="box-body" style="padding:0px;">
                    <div id="patient-table-content" class="scroll-content">
                        <table id="patient-table" class="table table-bordered" style="white-space:nowrap;margin-bottom:0px;"></table>
                    </div>
                    <div class="row">
                        <div id="legend" class="col-sm-9" style="padding-top:8px;padding-left:25px;">
                            <span id="legend-waiting" style="display:none;">
                                <span style="background-color:wheat;">&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp&nbsp</span>
                                <span>：等待中</span>
                            </span>
                            <span id="legend-enhance" style="display:none;">
                                <span style="color:#00A65A;margin-left:10px;">患者纪录</span>
                                <span>：CT增强</span>
                            </span>
                        </div>
                        <div class="col-sm-3 pull-right">
                            <div class="dataTables_info" id="patient_info" role="status" aria-live="polite"></div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
        <section id="appointment-content" class="col-xs-8 apoointment-area" style="padding:0px;display:none;">
            <div class="col-xs-12">
                <div class="title">
                    <span>加速器治疗预约</span>
                </div>
                <div class="patient-info">
                    <input id="patientid" type="hidden" value="" />
                    <div class="col-xs-3">患者姓名：<span id="patient-name"></span></div>
                    <div class="col-xs-3">主治医生：<span id="doctor"></span></div>
                    <div class="col-xs-3">医疗组：<span id="group"></span></div>
                    <div class="col-xs-3">
                        <button id="confirm" type="button" class="btn btn-primary pull-right" disabled>确认预约</button>
                    </div>
                </div>
                <div class="plan-info">
                    <div class="col-xs-4 info-title">
                        <span>计划预约信息：</span>
                    </div>
                    <div class="col-xs-12">
                        <table id="PlanInfo" class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>计划</th>
                                    <th>疗程</th>
                                    <th>总次数</th>
                                    <th>剩余次数</th>
                                    <th>分割方式</th>
                                    <th>最新首次</th>
                                    <th>选择预约</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-xs-12">
                <div class="col-xs-12">
                    <div class="info-title">
                        <span>选择预约起始日期：</span>
                    </div>
                    <table id="AppointDate" class="table table-bordered"></table>
                </div>
                <div class="col-xs-12">
                    <div class="info-title">
                        <span>选择预约时间段：</span>
                    </div>
                    <table id="AppointTime" class="table table-bordered"></table>
                </div>
            </div>
        </section>
    </div>

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
                </div>
                <div class="modal-footer">
                    <button id="getSelectedPatient" type="button" class="btn btn-primary" data-dismiss="modal">查询所有患者</button>
                </div>
            </div>
        </div>
    </div>
    <footer class="main-footer">
        <div class="pull-right hidden-xs">
            <b>Version</b> 2.0
        </div>
    <strong>Copyright &copy; 2017 <a href="#"> 医院</a> .</strong> 保留所有权利
    </footer>

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
<script src="../../js/Main/appoint.js"></script>
<script src="../../js/Main/HeaderOperate.js"></script>
</body>
</html>