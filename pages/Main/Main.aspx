<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Main.aspx.cs" Inherits="pages_Main_Main" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>江苏省人民医院放疗同质化平台</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- css -->
  <link rel="stylesheet" href="../../css/Main/main.css">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css">
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
      <span class="logo-mini"><b>JS</b>PH</span>
    </a>
    <!-- Header Navbar: style can be found in header.less -->
    <nav class="navbar navbar-static-top">
      <div style="position: absolute;">
        <h3 style="margin-top: 13px;margin-left: 10px;color: white;">江苏省人民医院放疗同质化平台</h3>
      </div>
      <div class="navbar-custom-menu">
        <ul class="nav navbar-nav">
          <!-- Messages: style can be found in dropdown.less-->
          <li class="dropdown messages-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-envelope-o"></i>
              <span class="label label-success">1</span>
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
                </ul>
              </li>
              <li class="footer"><a href="#">See All Messages</a></li>
            </ul>
          </li>
          <!-- Notifications: style can be found in dropdown.less -->
          <li class="dropdown notifications-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-bell-o"></i>
              <span class="label label-warning">1</span>
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
                </ul>
              </li>
              <li class="footer"><a href="#">View all</a></li>
            </ul>
          </li>
          <!-- Tasks: style can be found in dropdown.less -->
          <li class="dropdown tasks-menu">
            <a href="#" class="dropdown-toggle" data-toggle="dropdown">
              <i class="fa fa-flag-o"></i>
              <span class="label label-danger">1</span>
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
              <span id="out-name" class="hidden-xs"><%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
            </a>
            <ul class="dropdown-menu">
              <!-- User image -->
              <li class="user-header">
                <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                <p>
                  <span id="in-name"><%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                  <small id="role"><%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).GetUserRole() %></small>
                </p>
              </li>
              <!-- Menu Body -->
              <li class="user-body">
                <div class="row">
                  <div class="text-center">
                    <span>操作成员:</span>
                    <a id="changeOperator" href="javascript:;"><span id="operator"></span></a>
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
        <nav class="tab-nav" style="padding-top: 3px;">
            <div class="col-xs-4">
            当前患者：
            <span id="current-patient">张三</span>
            </div>
            <div class="col-xs-4">
            下个患者：
            <span id="next-patient">李四</span>
            </div>
            <button type="button" class="btn btn-primary" ><i class="fa fa-fw fa-forward"></i>叫号</button>
        </nav>
        </div>
        <div id="patient-content" class="box" style="border-top:0px;margin-bottom:0px;">
        <div class="box-header col-xs-8" style="padding-top: 15px;text-align: center;">
            <h3 class="box-title">患者汇总</h3>
        </div>
        <div class="input-group input-group-sm col-xs-4" style="padding-right: 10px;padding-top: 8px;max-width: 180px;">
            <input id="patient-search" type="search" class="form-control input-sm">
            <span class="input-group-btn">
            <button class="btn btn-primary btn-flat" id="search-button">
                <i class="fa fa-fw fa-search"></i>
            </button>
            </span>
        </div>
        <!-- /.box-header -->
        <div class="box-body">
            <table class="table table-bordered">
            <thead>
            <tr>
                <th>放疗号</th>
                <th>姓名</th>
                <th>疗程</th>
                <th>进度</th>
                <th>主治医生</th>
                <!-- <th>登记日期</th>
                <th>年龄</th> -->
            </tr>
            </thead>
            <tbody id="patient-table-body">
            </tbody>
            </table>
            <div class="row">
            <div class="col-sm-3">
                <div class="dataTables_info" id="patient_info" role="status" aria-live="polite"></div>
            </div>
            <div class="col-sm-9">
                <div class="dataTables_paginate paging_simple_numbers" id="example2_paginate">
                <ul id="page-index-content" class="pagination">
                </ul>
                </div>
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
                <button id="addTreatment" type="button" class="btn btn-success" data-toggle="modal" data-target="#myModal" disabled="disabled">新增疗程</button>
                <span id="patient-status"></span>
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
            <div class="btn-group">
                <button type="button" class="btn btn-success" data-toggle="dropdown"><i class="fa fa-fw fa-send"></i>选择模板</button>
                <button type="button" class="btn btn-success dropdown-toggle" data-toggle="dropdown">
                <span class="caret"></span>
                </button>
                <ul class="dropdown-menu" role="menu">
                <li><a href="#">Action</a></li>
                <li><a href="#">Another action</a></li>
                <li><a href="#">Something else here</a></li>
                </ul>
            </div>
            <button id="save" class="btn btn-success" disabled="disabled"><i class="fa fa-fw fa-save"></i>保存</button>
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
                    <table id="addTreatmentRecord" class="table table-bordered" ></table>
                    <input id="Radiotherapy_ID" type="text" hidden="hidden" />
                    <label class="label-control">注：点击选择复用模块，灰色区域不可选择。</label>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="saveTreatment" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
  <footer class="main-footer">
    <div class="pull-right hidden-xs">
      <b>Version</b> 2.0
    </div>
    <strong>Copyright &copy; 2017-2017 <a href="http://www.jsph.org.cn/"> 江苏省人民医院</a> .</strong> 保留所有权利
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
<script src="../../js/Main/main.js"></script>

<script type="text/javascript">
    $(function () {
        $("#printIframe").bind("click", function () {
            $("#record-iframe")[0].contentWindow.print();
        });
        $("#edit").bind("click", function () {
            $("#record-iframe")[0].contentWindow.remove();
        });
        $("#save").bind("click", function () {
            if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 0) {
                    $("#record-iframe")[0].contentWindow.CheckEmpty();                      
                }
                if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 1) {
                    $("#record-iframe")[0].contentWindow.checkAll();
                }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 2) {
                        $("#record-iframe")[0].contentWindow.postfix();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 4) {
                   $("#record-iframe")[0].contentWindow.postimportFIX();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 3) {
                   $("#record-iframe")[0].contentWindow.postlocation();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 5) {
                   $("#record-iframe")[0].contentWindow.postimportlocation();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 6) {
                   $("#record-iframe")[0].contentWindow.postimportCT();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 7) {
                   $("#record-iframe")[0].contentWindow.saveDesignApplyRecord();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 9) {
                   $("#record-iframe")[0].contentWindow.saveDesignSubmit();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 10) {
                   $("#record-iframe")[0].contentWindow.saveDesignConfirm();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 12) {
                   $("#record-iframe")[0].contentWindow.postreplace();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 14) {
                   $("#record-iframe")[0].contentWindow.postfirstaccelerate();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 11) {
                   $("#record-iframe")[0].contentWindow.saveDesignReview();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 13) {
                   $("#record-iframe")[0].contentWindow.postimportReplaceRecord();
               } 
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 16) {
                   $("#record-iframe")[0].contentWindow.putIn();
               }
               if (document.getElementById('record-iframe').contentWindow.document.getElementById('progress').value == 15) {
                   $("#record-iframe")[0].contentWindow.posttreatmentrecord();
               }
        });
    })
</script>
</body>
</html>
