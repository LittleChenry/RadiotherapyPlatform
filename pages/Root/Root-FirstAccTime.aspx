<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-FirstAccTime.aspx.cs" Inherits="pages_Root_Root_FirstAccTime" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
 <title>首次治疗时间段设置</title>
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
                      <span id="NoticeNum" class="label label-success">0</span>
                  </a>
                  <ul class="dropdown-menu">
                      <li class="header">通知公告</li>
                      <li>
                          <ul id="Notice" class="menu">
                              <li>
                                  <a href="#">
                                      <h4>无
                                      </h4>
                                      <p class="pull-right"><i class="fa fa-user"></i>&nbsp;<i class="fa fa-clock-o"></i></p>
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
                                  <a href="javascript:;">无
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
                      <span class="label label-danger">0</span>
                  </a>
                  <ul class="dropdown-menu">
                      <li class="header">设备动态</li>
                      <li>
                          <ul class="menu">
                              <li>
                                  <a href="javascript:;">
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
                          </ul>
                      </li>
                      <li class="footer">
                          <a href="javascript:;">查看详情</a>
                      </li>
                  </ul>
              </li>
              <!-- User Account: style can be found in dropdown.less -->
              <li class="dropdown user user-menu">
                  <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                      <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                      <span class="hidden-xs"><%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                  </a>
                  <ul class="dropdown-menu">
                      <!-- User image -->
                      <li class="user-header">
                          <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">

                          <p>
                              <span class="hidden-xs"><%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
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
        <li class="">
          <a href="RootMain.aspx">
            <i class="fa fa-coffee"></i> <span>主页</span>
            <span class="pull-right-container">
            </span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-envelope-o"></i> <span>消息模块</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="Root-InfoManage.aspx"><i class="fa fa-circle-o"></i> 消息管理</a></li>
            <li><a href="Root-information.aspx"><i class="fa fa-circle-o"></i> 消息发布</a></li>
          </ul>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-user"></i> <span>用户管理</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="Root-userInformation.aspx"><i class="fa fa-circle-o"></i> 用户信息</a></li>
            <li><a href="Root-user2role.aspx"><i class="fa fa-circle-o"></i>用户绑定</a></li>
          </ul>
        </li>

        <li class="treeview">
          <a href="#">
            <i class="fa fa-user-plus"></i>
            <span>角色管理</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
              <li><a href="Root-role.aspx"><i class="fa fa-circle-o"></i> 角色信息</a></li>
              <li><a href="Root-function2role.aspx"><i class="fa fa-circle-o"></i>功能绑定</a></li>
          </ul>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-briefcase"></i>
            <span>设备管理</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="Root-equipment.aspx"><i class="fa fa-circle-o"></i> 设备管理</a></li>
            <li><a href="EquipmentTypeManage.aspx"><i class="fa fa-circle-o"></i>设备类型管理</a></li>
            <li><a href="Root-EquipmentInspectionManage.aspx"><i class="fa fa-circle-o"></i> 设备检查管理</a></li>
            <li><a href="Root_EquipmentInspection.aspx"><i class="fa fa-circle-o"></i> 设备检查</a></li>
            <li><a href="Root-EquipmentInspectionResult.aspx"><i class="fa fa-circle-o"></i> 设备检查结果</a></li>
          </ul>
        </li>
        <%--<li class="treeview">
          <a href="#">
            <i class="fa fa-sitemap fa-fw"></i>
            <span>设备维修</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="EquipmentErrorrInformation.aspx"><i class="fa fa-circle-o"></i> 维修描述管理</a></li>
            <li><a href="EquipmentTypeManage.aspx"><i class="fa fa-circle-o"></i>设备维修</a></li>
            <li><a href="Root-EquipmentInspectionManage.aspx"><i class="fa fa-circle-o"></i> 设备维修记录</a></li>
          </ul>
        </li>--%>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-plus-square"></i> <span>诊断结果管理</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="morphol.aspx"><i class="fa fa-circle-o"></i> 病理诊断结果管理</a></li>
            <li><a href="icdcode.aspx"><i class="fa fa-circle-o"></i> 病情诊断结果管理</a></li>
          </ul>
        </li>
        <li>
          <a href="Root-function.aspx">
            <i class="fa fa-cart-plus"></i> <span>功能管理</span>
            <span class="pull-right-container">
            </span>
          </a>
        </li>
        <li>
          <a href="Root-Group.aspx">
            <i class="fa fa-group"></i> <span>分组管理</span>
            <span class="pull-right-container">
            </span>
          </a>
        </li>
        <li>
            <a href="Root-parameterSetting.aspx">
                <i class="fa fa-bars"></i> <span>基本信息管理</span>
                <span class="pull-right-container">
                </span>
            </a>
        </li>
          <li>
              <a href="Root-setWarning.aspx">
                  <i class="fa fa-warning"></i><span>流程预警设置</span>
                  <span class="pull-right-container"></span>
              </a>
          </li>
          <li class="active">
              <a href="Root-FirstAccTime.aspx">
                  <i class="fa fa-clone"></i><span>首次治疗预约时间段</span>
                  <span class="pull-right-container"></span>
              </a>
          </li>
                    <li>
                        <a href="Root-WorkTimeTable.aspx">
                            <i class="fa fa-calendar-times-o"></i><span>预约日期配置</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>
                    <li>
                        <a href="Root-PublicTemplate.aspx">
                            <i class="fa fa-clone"></i><span>公共模版设置</span>
                            <span class="pull-right-container"></span>
                        </a>
                    </li>          
        <li class="treeview">
          <a href="#">
            <i class="fa fa-bar-chart"></i>
            <span>数据统计</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
              <li><a href="EquipmentStatistics.aspx"><i class="fa fa-circle-o"></i> 设备检查统计</a></li>
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
                        <h1 class="page-header">首次治疗时间段</h1>
                    </div>
                </div>

                <div class="col-md-12">
                    <div class="panel panel-default mintablewidth">
                        <div class="panel-heading mintablewidth">
                            <i class="fa fa-bar-chart-o fa-fw"></i>
                            <span class="panel-title">首次治疗时间段</span>
                            <input type="button" class="btn btn-primary btn-sm floatRight" id="add" value="新增" style="padding: 2.5px 10px; "/>
                        </div>
                        <div id="tableArea" class="panel-body mintablewidth">
                            <table id="timeTable" class="table table-striped table-hover" style="width: 100%">
                                <thead id="thead">
                                    <tr>
                                        <th>时间段</th>
                                        <th>开始时间</th>
                                        <th>结束时间</th>
                                    </tr>
                                </thead>
                                <tbody id="tbody">
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>



                <div class="modal fade" id="addModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close" aria-hidden="true">×</button>
                                <h4 class="modal-title">新增时间段(24小时制)</h4>
                            </div>
                            <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000">
                                <label id="addError" class="tohidden"></label>
                                <div class="row">
                                  <div class="col-md-3">
                                    <span>时间段</span>
                                  </div>
                                  <div class="col-md-9">
                                    <input type="text" id="addName" class="form-control" />
                                  </div>
                                </div>
                                <div class="row">
                                  <div class="col-md-3">
                                    <span>开始时间</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="addBeginHour" class="form-control" />
                                  </div>
                                  <div class="col-md-1">
                                    <span>:</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="addBeginMinute" class="form-control" />
                                  </div>
                                </div>
                                <div class="row">
                                  <div class="col-md-3">
                                    <span>结束时间</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="addEndHour" class="form-control" />
                                  </div>
                                  <div class="col-md-1">
                                    <span>:</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="addEndMinute" class="form-control" />
                                  </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button id="cannelAdd" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                                <input id="sureAdd" type="submit" class="btn btn-primary" value="确认" />
                            </div>
                        </div>
                        <!-- /.modal-content -->
                    </div>
                    <!-- /.modal-dialog -->
                </div>
                <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
                    <div class="modal-dialog">
                        <div class="modal-content">
                            <div class="modal-header">
                                <button type="button" data-dismiss="modal" class="close" aria-hidden="true">×</button>
                                <h4 class="modal-title">修改时间段(24小时制)</h4>
                            </div>
                            <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000">
                                <input hidden="true" value="" id='editID' />
                                <div class="row">
                                  <div class="col-md-3">
                                    <span>时间段</span>
                                  </div>
                                  <div class="col-md-9">
                                    <input type="text" id="editName" class="form-control" />
                                  </div>
                                </div>
                                <div class="row">
                                  <div class="col-md-3">
                                    <span>开始时间</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="editBeginHour" class="form-control" />
                                  </div>
                                  <div class="col-md-1">
                                    <span>:</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="editBeginMinute" class="form-control" />
                                  </div>
                                </div>
                                <div class="row">
                                  <div class="col-md-3">
                                    <span>结束时间</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="editEndHour" class="form-control" />
                                  </div>
                                  <div class="col-md-1">
                                    <span>:</span>
                                  </div>
                                  <div class="col-md-4">
                                    <input type="number" onmousewheel="return false;" id="editEndMinute" class="form-control" />
                                  </div>
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button id="cannelEdit" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                                <input id="sureEdit" type="submit" class="btn btn-primary" value="确认" />
                                <button id="deleteEdit" type="button" data-dismiss="modal" class="btn btn-danger">删除</button>
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
<script src="../../js/Root/Root-FirstAccTime.js"></script>
</body>
</html>