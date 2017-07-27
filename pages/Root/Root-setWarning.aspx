<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-setWarning.aspx.cs" Inherits="pages_Root_Root_setWarning" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
 <title>预警时间</title>
    <!-- Main CSS -->
    <link href="../../css/Root/Root-userInformation.css" rel="stylesheet" type="text/css" />
    <link href="../../css/Root/equipment.css" rel="stylesheet" type="text/css" />

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
    <link href="../../css/Main/main.css" rel="stylesheet" />
    <link rel="stylesheet" href="../../css/Root/equipmentMain.css" />
</head>
<body class="hold-transition skin-blue sidebar-mini"> 
    <div class="wrapper">
        <header class="main-header">
            <!-- Logo -->
            <a href="RootMain.aspx" class="logo">
                <!-- mini logo for sidebar mini 50x50 pixels -->
                <span class="logo-mini"><b>R</b>QS</span>
                <!-- logo for regular state and mobile devices -->
                <span class="logo-lg"><b>放疗质控系统</b></span>
            </a>
            <!-- Header Navbar: style can be found in header.less -->
            <nav class="navbar navbar-static-top">
                <!-- Sidebar toggle button-->
                <a href="#" class="sidebar-toggle" data-toggle="offcanvas" role="button">
                    <span class="sr-only">Toggle navigation</span>
                </a>

                <div class="navbar-custom-menu">
                    <ul class="nav navbar-nav">
                        <!-- Messages: style can be found in dropdown.less-->
                        <li class="dropdown messages-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="fa fa-envelope-o"></i>
                                <span class="label label-success">4</span>
                            </a>
                            <ul class="dropdown-menu">
                                <li class="header">You have 4 messages</li>
                                <li>
                                    <!-- inner menu: contains the actual data -->
                                    <ul class="menu">
                                        <li>
                                            <!-- start message -->
                                            <a href="#">
                                                <div class="pull-left">
                                                    <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                                                </div>
                                                <h4>Support Team
                        <small><i class="fa fa-clock-o"></i>5 mins</small>
                                                </h4>
                                                <p>Why not buy a new awesome theme?</p>
                                            </a>
                                        </li>
                                        <!-- end message -->
                                        <li>
                                            <a href="#">
                                                <div class="pull-left">
                                                    <img src="../../plugin/AdminLTE/dist/img/user3-128x128.jpg" class="img-circle" alt="User Image">
                                                </div>
                                                <h4>AdminLTE Design Team
                        <small><i class="fa fa-clock-o"></i>2 hours</small>
                                                </h4>
                                                <p>Why not buy a new awesome theme?</p>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <div class="pull-left">
                                                    <img src="../../plugin/AdminLTE/dist/img/user4-128x128.jpg" class="img-circle" alt="User Image">
                                                </div>
                                                <h4>Developers
                        <small><i class="fa fa-clock-o"></i>Today</small>
                                                </h4>
                                                <p>Why not buy a new awesome theme?</p>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <div class="pull-left">
                                                    <img src="../../plugin/AdminLTE/dist/img/user3-128x128.jpg" class="img-circle" alt="User Image">
                                                </div>
                                                <h4>Sales Department
                        <small><i class="fa fa-clock-o"></i>Yesterday</small>
                                                </h4>
                                                <p>Why not buy a new awesome theme?</p>
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <div class="pull-left">
                                                    <img src="../../plugin/AdminLTE/dist/img/user4-128x128.jpg" class="img-circle" alt="User Image">
                                                </div>
                                                <h4>Reviewers
                        <small><i class="fa fa-clock-o"></i>2 days</small>
                                                </h4>
                                                <p>Why not buy a new awesome theme?</p>
                                            </a>
                                        </li>
                                    </ul>
                                </li>
                                <li class="footer"><a href="#">See All Messages</a></li>
                            </ul>
                        </li>
                        <!-- Notifications: style can be found in dropdown.less -->
                        <li class="dropdown notifications-menu">
                            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                                <i class="fa fa-bell-o"></i>
                                <span class="label label-warning">10</span>
                            </a>
                            <ul class="dropdown-menu">
                                <li class="header">You have 10 notifications</li>
                                <li>
                                    <!-- inner menu: contains the actual data -->
                                    <ul class="menu">
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-users text-aqua"></i>5 new members joined today
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-warning text-yellow"></i>Very long description here that may not fit into the
                      page and may cause design problems
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-users text-red"></i>5 new members joined
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-shopping-cart text-green"></i>25 sales made
                                            </a>
                                        </li>
                                        <li>
                                            <a href="#">
                                                <i class="fa fa-user text-red"></i>You changed your username
                                            </a>
                                        </li>
                                    </ul>
                                </li>
                                <li class="footer"><a href="#">View all</a></li>
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
                                        <li>
                                            <!-- Task item -->
                                            <a href="#">
                                                <h3>Design some buttons
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
                                        <li>
                                            <!-- Task item -->
                                            <a href="#">
                                                <h3>Create a nice theme
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
                                        <li>
                                            <!-- Task item -->
                                            <a href="#">
                                                <h3>Some task I need to do
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
                                        <li>
                                            <!-- Task item -->
                                            <a href="#">
                                                <h3>Make beautiful transitions
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
                                <span class="hidden-xs"><%=((UserInformation)Session["loginUser"]).GetUserName() %></span>
                            </a>
                            <ul class="dropdown-menu">
                                <!-- User image -->
                                <li class="user-header">
                                    <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">

                                    <p>
                                        <span class="hidden-xs"><%=((UserInformation)Session["loginUser"]).GetUserName() %></span>
                                        <small id="role">管理员</small>
                                    </p>
                                </li>
                                <!-- Menu Body -->
                                <!-- Menu Footer-->
                                <li class="user-footer">
                                    <div class="pull-left">
                                        <a href="../Login/changeRole.aspx" class="btn btn-default btn-flat">切换角色</a>
                                    </div>
                                    <div class="pull-right">
                                        <a id="signOut" href="#" class="btn btn-default btn-flat">注销</a>
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
                        <p id="user-name"><%=((UserInformation)Session["loginUser"]).GetUserName() %></p>
                        <a href="#" id="user-role">管理员</a>
                    </div>
                </div>
                <!-- search form -->
                <form action="#" method="get" class="sidebar-form">
                    <div class="input-group">
                        <input type="text" name="q" class="form-control" placeholder="Search..." />
                        <span class="input-group-btn">
                            <button type="submit" name="search" id="search-btn" class="btn btn-flat">
                                <i class="fa fa-search"></i>
                            </button>
                        </span>
                    </div>
                </form>
                <!-- /.search form -->
                <!-- sidebar menu: : style can be found in sidebar.less -->
                <ul id="menu" class="sidebar-menu">
                    <li class="header">管理员导航</li>
                    <li>
                        <a href="RootMain.aspx">
                            <i class="fa fa-coffee fa-fw"></i><span>主页</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>
                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-pencil-square-o fa-fw"></i><span>消息模块</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="Root-InfoManage.aspx"><i class="fa fa-circle-o"></i>消息管理</a></li>
                            <li><a href="Root-information.aspx"><i class="fa fa-circle-o"></i>消息发布</a></li>
                        </ul>
                    </li>
                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-user fa-fw"></i><span>用户管理</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="Root-userInformation.aspx"><i class="fa fa-circle-o"></i>用户信息</a></li>
                            <li><a href="Root-user2role.aspx"><i class="fa fa-circle-o"></i>用户绑定</a></li>
                        </ul>
                    </li>

                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-group fa-fw"></i>
                            <span>角色管理</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="Root-role.aspx"><i class="fa fa-circle-o"></i>角色信息</a></li>
                            <li><a href="Root-function2role.aspx"><i class="fa fa-circle-o"></i>功能绑定</a></li>
                        </ul>
                    </li>
                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-sitemap fa-fw"></i>
                            <span>设备管理</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="Root-equipment.aspx"><i class="fa fa-circle-o"></i>设备管理</a></li>
                            <li><a href="EquipmentTypeManage.aspx"><i class="fa fa-circle-o"></i>设备类型管理</a></li>
                            <li><a href="Root-EquipmentInspectionManage.aspx"><i class="fa fa-circle-o"></i>设备检查管理</a></li>
                            <li><a href="Root_EquipmentInspection.aspx"><i class="fa fa-circle-o"></i>设备检查</a></li>
                            <li><a href="Root-EquipmentInspectionResult.aspx"><i class="fa fa-circle-o"></i>设备检查结果</a></li>
                        </ul>
                    </li>

                    <li>
                        <a href="Root-function.aspx">
                            <i class="fa fa-coffee fa-fw"></i><span>功能管理</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>
                    <li>
                        <a href="Root-Group.aspx">
                            <i class="fa fa-group"></i><span>分组管理</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>
                    <li>
                        <a href="Root-parameterSetting.aspx">
                            <i class="fa fa-group"></i><span>基本信息管理</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>
                    <li class="active">
                        <a href="Root-setWarning.aspx">
                            <i class="fa fa-group"></i><span>流程预警设置</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>
                    <li class="treeview">
                        <a href="#">
                            <i class="fa fa-group fa-fw"></i>
                            <span>数据统计</span>
                            <span class="pull-right-container">
                                <i class="fa fa-angle-left pull-right"></i>
                            </span>
                        </a>
                        <ul class="treeview-menu">
                            <li><a href="EquipmentStatistics.aspx"><i class="fa fa-circle-o"></i>设备检查统计</a></li>
                        </ul>
                    </li>
                </ul>
            </section>
            <!-- /.sidebar -->
        </aside>
        <div class="content-wrapper" style="min-height: 916px;">
            <section class="content">
                <input id="type" type="hidden" value="Root" />
                <div class="row">
                    <div class="col-xs-12">
                        <h1 class="page-header">预警时间</h1>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="panel panel-default mintablewidth">
                        <div class="panel-heading mintablewidth">
                            <i class="fa fa-bar-chart-o fa-fw"></i>
                            <span class="panel-title">预警时间</span>
                            <input type="button" class="btn btn-primary btn-sm floatRight" id="changeWarning" value="编辑" style="padding: 2.5px 10px;" />
                            <input type="button" class="btn btn-primary btn-sm floatRight" id="closeEdit" value="结束编辑" style="padding: 2.5px 10px; display: none" />
                            <input type="button" class="tohidden" id="editWarning" data-toggle="modal" data-target="#editModal" />
                        </div>
                        <div id="tableArea" class="panel-body mintablewidth">
                            <table id="warningTable" class="table table-striped table-hover" style="width: 100%">
                                <thead id="thead">
                                    <tr>
                                        <td>预警项目</td>
                                        <td>黄色预警</td>
                                        <td>红色预警</td>
                                    </tr>
                                </thead>
                                <tbody id="tbody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>



                <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close" aria-hidden="true">×</button>
                                <h4 class="modal-title">修改预警</h4>
                            </div>
                            <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000">
                                <label id="error" class="tohidden"></label>
                                <table id="editArea" class="mytable table-bordered table-center">
                                    <tbody style="text-align: center;" id="editTBody">
                                    </tbody>
                                </table>
                            </div>
                            <div class="modal-footer">
                                <button id="cannelEdit" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                                <input id="sureEdit" type="submit" class="btn btn-primary" value="确认" />
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>

            </section>
        </div>
        <footer class="main-footer">
            <div class="pull-right hidden-xs">
                <b>Version</b> 2.0
            </div>
            <strong>Copyright &copy; 2017-2017 <a href="#">医院</a> .</strong> 保留所有权利
        </footer>

        <!-- Control Sidebar -->
        <!-- /.control-sidebar -->
        <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
        <div class="control-sidebar-bg"></div>
    </div>
    

<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/jquery.min.js"></script>
<!-- tablecreate -->
<script src="../../js/Root/createTable.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- SlimScroll -->
<script src="../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- AdminLTE App -->
<script src="../../plugin/AdminLTE/dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../plugin/AdminLTE/dist/js/demo.js"></script>
<!-- Main js-->
<script src="../../js/Root/chooseAll.js" type="text/javascript"></script>
<script src="../../js/Root/RootMainJS.js"></script>
<script src="../../js/Root/createTable.js"></script>
<script src="../../js/Root/setWarning.js"></script>
</body>
</html>