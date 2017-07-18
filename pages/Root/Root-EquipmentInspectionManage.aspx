<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-EquipmentInspectionManage.aspx.cs" Inherits="Root_Root_EquipmentInspectionManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta charset="utf-8"/>
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

    <title>设备检查管理</title>
    <!-- Main CSS -->
    <link href="../../css/Root/equipmentMain.css" rel="stylesheet" type="text/css" />

    
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
                  <li><!-- start message -->
                    <a href="#">
                      <div class="pull-left">
                        <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                      </div>
                      <h4>
                        Support Team
                        <small><i class="fa fa-clock-o"></i> 5 mins</small>
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
                      <h4>
                        AdminLTE Design Team
                        <small><i class="fa fa-clock-o"></i> 2 hours</small>
                      </h4>
                      <p>Why not buy a new awesome theme?</p>
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <div class="pull-left">
                        <img src="../../plugin/AdminLTE/dist/img/user4-128x128.jpg" class="img-circle" alt="User Image">
                      </div>
                      <h4>
                        Developers
                        <small><i class="fa fa-clock-o"></i> Today</small>
                      </h4>
                      <p>Why not buy a new awesome theme?</p>
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <div class="pull-left">
                        <img src="../../plugin/AdminLTE/dist/img/user3-128x128.jpg" class="img-circle" alt="User Image">
                      </div>
                      <h4>
                        Sales Department
                        <small><i class="fa fa-clock-o"></i> Yesterday</small>
                      </h4>
                      <p>Why not buy a new awesome theme?</p>
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <div class="pull-left">
                        <img src="../../plugin/AdminLTE/dist/img/user4-128x128.jpg" class="img-circle" alt="User Image">
                      </div>
                      <h4>
                        Reviewers
                        <small><i class="fa fa-clock-o"></i> 2 days</small>
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
                      <i class="fa fa-users text-aqua"></i> 5 new members joined today
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <i class="fa fa-warning text-yellow"></i> Very long description here that may not fit into the
                      page and may cause design problems
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <i class="fa fa-users text-red"></i> 5 new members joined
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <i class="fa fa-shopping-cart text-green"></i> 25 sales made
                    </a>
                  </li>
                  <li>
                    <a href="#">
                      <i class="fa fa-user text-red"></i> You changed your username
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
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
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
            <i class="fa fa-coffee fa-fw"></i> <span>主页</span>
            <span class="pull-right-container">
            </span>
          </a>
        </li>
        <li class="treeview">
          <a href="#">
            <i class="fa fa-pencil-square-o fa-fw"></i> <span>消息模块</span>
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
            <i class="fa fa-user fa-fw"></i> <span>用户管理</span>
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
            <i class="fa fa-group fa-fw"></i>
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
        <li class="treeview active">
          <a href="#">
            <i class="fa fa-sitemap fa-fw"></i>
            <span>设备管理</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li><a href="Root-equipment.aspx"><i class="fa fa-circle-o"></i> 设备管理</a></li>
              <li><a href="EquipmentTypeManage.aspx"><i class="fa fa-circle-o"></i>设备类型管理</a></li>
            <li class="active"><a href="Root-EquipmentInspectionManage.aspx"><i class="fa fa-circle-o"></i> 设备检查管理</a></li>
            <li><a href="Root_EquipmentInspection.aspx"><i class="fa fa-circle-o"></i> 设备检查</a></li>
            <li><a href="Root-EquipmentInspectionResult.aspx"><i class="fa fa-circle-o"></i> 设备检查结果</a></li>
          </ul>
        </li>

        <li>
          <a href="Root-function.aspx">
            <i class="fa fa-coffee fa-fw"></i> <span>功能管理</span>
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
                <i class="fa fa-group"></i> <span>基本信息管理</span>
                <span class="pull-right-container">
                </span>
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
              <li><a href="EquipmentStatistics.aspx"><i class="fa fa-circle-o"></i> 设备检查统计</a></li>
          </ul>
        </li>
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper" style="min-height: 916px;" >


    <!-- Main content -->
    <section class="content" style="overflow-x:auto;">
        <div class="row">
            <div class="col-lg-12">
                <h1 class="page-header">设备检查管理</h1>
            </div>
            <!-- /.col-lg-12 -->
        </div>
        <!-- /.row -->
        <div class="row">
            <div class="col-md-12">
                <div class="col-md-3">&nbsp;</div>
                <div class="col-md-6 toCenter">
                    <label for="cycle" style="margin-top:0.46em;float:left;">检查周期:</label>
                        <select id="cycle" class="form-control">
                            <option value="">请选择检查周期</option>
                            <option value="day">日检</option>
                            <option value="month">月检</option>
                            <option value="year">年检</option>
                        </select>
                </div>
                <div class="col-md-3 toCenter">
                    <input type="button" value="确定" id="sure" class="btn btn-primary btn-sm" />
                    <%--<input type="hidden" value="false" id="fillATable" />--%>
                </div>
            </div>
            <div class="col-md-12 todown minw">
                <div class="panel panel-default minw">
                    <div class="panel-heading">
                        <span id="cycleTitle">日检表</span>
                        <input type="button" value="修改" id="changeTable" class="floatRight btn btn-info btn-sm clearTBPadding" />
                        <input type="button" value="新增" id="addItem" class="floatRight btn btn-info btn-sm clearTBPadding" />
                        <input type="button" value="确定" id="sureChange" class="floatRight btn btn-info btn-sm clearTBPadding" />
                        <input type="button" value="取消" id="cannel" class="floatRight btn btn-info btn-sm clearTBPadding" />
                    </div>
                    <div class="panel-body">
                        <div>
                            <div class="row">
                                <%--<form id="tablefrm" method="post" action="Root-EquipmentInspectionManage.aspx">--%>
                                    <input type="hidden" id="sumPage" value="0" />
                                    <input type="hidden" id="currentPage" value="0" />
                                    <div class="col-sm-12" id="tableArea">

                                    </div>
                               <%-- </form>--%>
                            </div>
                            <div class="row">
                                <div class="col-sm-6">&nbsp;</div>
                                <div class="col-sm-6 todown">
                                    <div class="toright">
                                        <button type="button" id="firstPage" class="btn btn-primary btn-sm disabled">首页</button>
                                        <button type="button" id="prePage" class="btn btn-primary btn-sm disabled">上一页</button>
                                        <button type="button" id="nexrPage" class="btn btn-primary btn-sm">下一页</button>
                                        <button type="button" id="lastPage" class="btn btn-primary btn-sm">末页</button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-md-12" id="middleArea"></div>
            <div class="col-md-12" id="topArea">
                <form id="addItemFrm" method="post">
                    <label id="error" class="error"></label>
                        <table class="table table-bordered table-striped tableWidth">
                            <tbody>
                                <tr>
                                    <th class="noborder"><label for="roleName" class="height">所属项目</label></th>
                                    <td>
                                        <select id="MainItemSelect" class="form-control">

                                        </select>
                                        <input id="MainItem" type="text" class="form-control controlHeight tohidden MainItemSelect" placeholder="请输入所属项目" />
                                    </td>                                           
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">项目名</label></th>
                                    <td>
                                        <input id="childItem" type="text" class="form-control controlHeight IsEmpty" placeholder="请输入项目名称" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="function2role" class="height">无调强检查</label></th>
                                    <td>
                                        <select id="UIMRTUnit" class="form-control">
                                            <option value="NA">NA</option>
                                            <option value="IsOK">功能正常</option>
                                            <option value="write" selected="true">填写</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">无调强参考值</label></th>
                                    <td>
                                        <input id="UIMRTReference" type="text" class="form-control controlHeight rightValue" placeholder="请输入无调强参考值" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">无调强误差</label></th>
                                    <td>
                                        <input id="UIMRTError" type="text" class="form-control controlHeight rightValue" placeholder="请输入无调强误差" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">调强检查</label></th>
                                    <td>
                                        <select id="IMRTUnit" class="form-control">
                                            <option value="NA">NA</option>
                                            <option value="IsOK">功能正常</option>
                                            <option value="write" selected="true">填写</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">调强参考值</label></th>
                                    <td>
                                        <input id="IMRTReference" type="text" class="form-control controlHeight rightValue" placeholder="请输入调强参考值" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">调强误差</label></th>
                                    <td>
                                        <input id="IMRTError" type="text" class="form-control controlHeight rightValue" placeholder="请输入调强误差" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">SRS/SBRT检查</label></th>
                                    <td>
                                        <select id="SRSUnit" class="form-control">
                                            <option value="NA">NA</option>
                                            <option value="IsOK">功能正常</option>
                                            <option value="write" selected="true">填写</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">SRS/SBRT参考值</label></th>
                                    <td>
                                        <input id="SRSReference" type="text" class="form-control controlHeight rightValue" placeholder="请输入SRS参考值" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">SRS/SBRT误差</label></th>
                                    <td>
                                        <input id="SRSError" type="text" class="form-control controlHeight rightValue" placeholder="请输入SRS误差值" />
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">检查周期</label></th>
                                    <td>
                                        <select id="addCycle" class="form-control">
                                            <option value="day">日检</option>
                                            <option value="month">月检</option>
                                            <option value="year">年检</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align:center">
                                        <input id="submitAdd" type="button" value="提交" class="btn btn-success btn-sm buttonMar" />
                                        <input id="addCannel" type="reset" value="取消" class="btn btn-success btn-sm" />
                                    </td>
                                </tr>     
                            </tbody>
                       </table>
                    </form>
            </div>
        </div>
        <!-- /.row -->
    </section>
  </div>

  <!-- /.content-wrapper -->
  <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 2.0
    </div>
    <strong>Copyright &copy; 2017-2017 <a href="http://www.jsph.org.cn/"> 江苏省人民医院</a> .</strong> 保留所有权利
  </footer>

  <!-- Control Sidebar -->
  <!-- /.control-sidebar -->
  <!-- Add the sidebar's background. This div must be placed
       immediately after the control sidebar -->
  <div class="control-sidebar-bg"></div>
</div>
<!-- ./wrapper -->

<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/jquery.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="../../plugin/AdminLTE/dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../plugin/AdminLTE/dist/js/demo.js"></script>
<!-- Main js-->
<script src="../../js/Root/RootMainJS.js"></script>
<!-- Main JavaScript -->
<script src="../../js/Root/EquipmentInspectionJS.js"></script>
</body>
</html>
