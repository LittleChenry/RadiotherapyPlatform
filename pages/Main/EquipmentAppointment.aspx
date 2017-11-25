<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EquipmentAppointment.aspx.cs" Inherits="pages_Main_EquipmentAppointment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta charset="utf-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--Tell the brower to be responsive to screen width -->
    <meta content="Width=device-width, initial-scale=1, maxmum-scale=1, user-scalable=no" name="viewport" />
    <link rel="stylesheet" href="../../css/Main/Records.css"/>
    <!--Boostrap -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css" />
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css"/>
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css" />
    <!-- Theme style -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css" />
    <!-- AdminLTE Skins. Choose a skin from the css/skins folder instead of downloading all of them to reduce -->
    <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css" />

    <!-- Main Css -->
    <link rel="stylesheet" href="../../css/Main/main.css" />
    <title>设备预约管理</title>
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
                </li>
            </ul>
        </section>
    </aside>
    <div class="content-wrapper">
        <section class="content-header">
            <h1>设备预约管理</h1>
        </section>
        <section class="content">
            <div class="row">
                <div class="col-md-3">
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">选择设备</h3>
                        </div>
                        <div class="box-body">
                            <strong><i class="fa fa-book margin-r-5"></i> 选择项目</strong>
                            <select id="equipmentType" class="form-control"></select>
                            <hr>
                            <strong><i class="fa fa-fw fa-dashboard"></i> 选择设备</strong>
                            <select id="equipment" class="form-control"></select>
                        </div>
                        <div class="box-footer">
                            <button id="sureEquipment" class="btn btn-primary pull-right" type="button">查询<i class="fa fa-fw fa-search"></i></button>
                        </div>
                    </div>
                    <div class="box box-primary">
                        <div class="box-header with-border">
                            <h3 class="box-title">设备详情</h3>
                        </div>
                        <div class="box-body">
                            <strong><i class="fa fa-fw fa-info-circle"></i> 设备信息</strong>
                            <div>
                                <p id="EquipmentInfo" class="text-muted" style="padding-left:20px;margin-top:10px;"></p>
                            </div>
                            <hr>
                            <strong><i class="fa fa-fw fa-unlock-alt"></i> 状态</strong>
                            <div>
                                <p id="EquipmentState" class="text-muted" style="padding-left:20px;margin-top:10px;"></p>
                            </div>
                            <hr>
                            <strong><i class="fa fa-fw fa-clock-o"></i> 工作时间</strong>
                            <div>
                                <p id="EquipmentTime" class="text-muted" style="padding-left:20px;margin-top:10px;"></p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-9">
                    <div class="nav-tabs-custom">
                        <ul class="nav nav-tabs">
                            <li class="active"><a id="AppointType" href="#appointView" data-toggle="tab">预约视图</a></li>
                            <li><a href="#patientView" data-toggle="tab">患者视图</a></li>
                        </ul>
                        <div class="tab-content">
                            <div class="tab-pane" id="patientView" style="overflow:hidden;">
                                <%--<div class="col-md-6">
                                    <table id="viewPatients" class="table" style="text-align:center;">
                                        <thead>
                                            <tr>
                                                <th>疗程号</th>
                                                <th>姓名</th>
                                                <th>疗程</th>
                                                <th>诊断结果</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>--%>
                                <div class="col-md-10 col-md-offset-1">
                                    <table id="viewAppoints" class="table" style="text-align:center;">
                                        <thead>
                                            <tr>
                                                <th>预约项目</th>
                                                <th>预约时间</th>
                                                <th>是否完成</th>
                                                <th>操作</th>
                                            </tr>
                                        </thead>
                                        <tbody></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="active tab-pane" id="appointView" style="overflow:hidden;">
                                <div id="WeekAreaNormal" class="col-md-12">
                                    <table id="appointTable" class="table table-bordered table-hover dataTable">
                                        <thead id="thead"></thead>
                                        <tbody id="tbody"></tbody>
                                    </table>
                                </div>
                            </div>
                            <div class="tab-pane" id="appointViewAccelerate" style="overflow:hidden;">
                                <div class="btn-area col-xs-12">
                                    <div class="col-xs-6">
                                        <button id="startchoose" type="button" class="time-btn">编辑</button>
                                        <input id="currentEquipment" type="hidden" />
                                    </div>
                                    <div id="optionWay" class="col-xs-6" style="display:none;">
                                        <button id="DeleteAppoint" type="button" class="time-btn pull-right" style="margin-left:5px;">删除预约</button>
                                        <button id="CancelTreatment" type="button" class="time-btn pull-right" style="margin-left:5px;">取消选择</button>
                                        <button id="RemoveByDay" type="button" class="time-btn pull-right" data-toggle="modal" data-target="#RemoveAppointment">按天转移</button>
                                    </div>
                                </div>
                                <div class="btn-area col-xs-12">
                                    <div id="chooseTime" class="col-xs-3">
                                        <button type="button" class="time-btn selected-btn">上午</button>
                                        <button type="button" class="time-btn selected-btn">下午</button>
                                        <button type="button" class="time-btn selected-btn">晚上</button>
                                    </div>
                                    <div id="chooseWeek" class="col-xs-6"></div>
                                    <div id="chooseWay" class="col-xs-3" style="display:none;">
                                        <button type="button" class="time-btn pull-right" style="margin-left:5px;">自由选择</button>
                                        <button type="button" class="time-btn selected-btn pull-right">批量选择</button>
                                    </div>
                                </div>
                                <div class="col-xs-12">
                                    <div id="WeekArea" class="col-xs-12"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>
    </div>
    <div id="changeAppoint" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document" style="width:700px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">修改预约时间</h4>
                </div>
                <div class="modal-body" style="overflow:hidden;">
                    <div class="panel-row">
                                <div class="item col-xs-5">选择设备：<select id="equipmentName" class="form-item"></select></div>
                            <div class="item col-xs-4">预约时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                            <div class="item col-xs-3">
                                <button type="button"  id="previousday" class="btn btn-default btn-sm">上一天</button>
                                <button type="button" id="nextday" class="btn btn-default btn-sm">下一天</button>
                                <%-- <button id="chooseProject" class="btn btn-default">查询该项</button>--%>
                            </div>
                        </div>
                        <div id="timechoose" class="panel-row" style="display:none">
                            <div class="item col-xs-7">
                                时间筛选：
                                <select id="timeselect" name="timeselect" class="form-item">
                                    <option value="360-720">06:00-12:00</option>
                                    <option value="720-1080">12:00-18:00</option>
                                    <option value="1080-1440">18:00-24:00</option>
                                    <option value="1440-1800">00:00-06:00(次日)</option>
                                </select>
                            </div>
                            <div class="item col-xs-5" style="padding-left:20px;display:none">
                                是否占用两格：
                                <select id="isspecial" name="isspecial" class="form-item">
                                    <option value="0">否</option>
                                    <%--<option value="1">是</option>--%>
                                </select>
                            </div>
                            </div>
                        <div id="amappoint" class="panel-row">
                            <div id="amlabel">
                                <span class="label label-info" style="float:left;width:10%;height:auto" >上午</span>
                            </div>
                                <table id="apptiontTable" class="table table-bordered col-xs-12" style="table-layout:fixed;word-wrap:break-word;"></table>
                        </div>
                        <div id="pmappoint" class="panel-row">
                            <div id="pmlabel" >
                                <span class="label label-info" style="float:left;width:10%;height:auto" >下午</span>
                            </div>
                            <table id="apptiontTableForPm" class="table table-bordered col-xs-12" style="table-layout:fixed;word-wrap:break-word;"></table>
                        </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" id="cannel" type="button" data-dismiss="modal">取消</button>
                    <button class="btn btn-primary" id="sure" type="button" data-dismiss="modal">确定</button>
                </div>
            </div>
        </div>
    </div>
    <div id="RemoveAppointment" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">按天转移</h4>
                </div>
                <div class="modal-body">
                    <table id="DayRemoveTable" class="table table-bordered"></table>
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
<script src="../../js/Main/EquipmentAppointment.js"></script>
<script>
    $(".nav-tabs-custom").css("minHeight", $(document).height() - 200);
    $("#AppiontDate").datepicker({ autoclose: true });
</script>
</body>
</html>