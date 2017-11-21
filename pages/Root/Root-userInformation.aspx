<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-userInformation.aspx.cs" Inherits="Root_Root_userInformation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-6"/>
    <title>用户信息</title>

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
                      <span class="label label-danger">9</span>
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
                <button type="submit" name="search" id="search-btn" class="btn btn-flat"><i class="fa fa-search"></i>
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
        <li class="treeview active">
          <a href="#">
            <i class="fa fa-user"></i> <span>用户管理</span>
            <span class="pull-right-container">
              <i class="fa fa-angle-left pull-right"></i>
            </span>
          </a>
          <ul class="treeview-menu">
            <li class="active"><a href="Root-userInformation.aspx"><i class="fa fa-circle-o"></i> 用户信息</a></li>
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
                  <i class="fa fa-plus-square"></i><span>诊断结果管理</span>
                  <span class="pull-right-container">
                      <i class="fa fa-angle-left pull-right"></i>
                  </span>
              </a>
              <ul class="treeview-menu">
                  <li><a href="morphol.aspx"><i class="fa fa-circle-o"></i>病理诊断结果管理</a></li>
                  <li><a href="icdcode.aspx"><i class="fa fa-circle-o"></i>病情诊断结果管理</a></li>
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
      </ul>
    </section>
    <!-- /.sidebar -->
  </aside>

  <!-- Content Wrapper. Contains page content -->
  <div class="content-wrapper" style="min-height: 916px;" >


    <!-- Main content -->
    <section class="content">
        <input id="type" type="hidden" value="Root" />
        <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">用户信息</h1>
            </div>
        </div>
        <div class="col-xs-12 search">
                        <div class="col-xs-4">
                            <select id="Select1" name="roles" class="form-control" style="width:60%">
                                <option value="">全部账号</option>
                                <option value="1">已激活账号</option>
                                <option value="0">未激活账号</option>
                            </select>
                        </div>
                        <div class="col-xs-4">
                            <select id="office" name="office" class="form-control" style="width:60%">
                                <option value="">全部办公室</option>
                                <option value="登记处">登记处</option>
                                <option value="放疗设备状态监测室">放疗设备状态监测室</option>
                                <option value="加速器治疗室">加速器治疗室</option>
                                <option value="模具摆放室">模具摆放室</option>
                                <option value="模拟定位室">模拟定位室</option>
                                <option value="物理室">物理室</option>
                                <option value="医生工作室">医生工作室</option>
                                <option value="制模室">制模室</option>
                            </select>
                        </div>
                        <div class="col-xs-4">
                            <input id="search" type="button" value="查询" class="btn btn-primary" />
                        </div>
                    </div>
                    <div class="col-md-12">
                <div class="panel panel-default mintablewidth">
                    <div class="panel-heading mintablewidth">
                        <i class="fa fa-bar-chart-o fa-fw"></i>
                        <span class="panel-title">用户信息</span>
                        <input type="button" class="btn btn-primary btn-sm buttonToLeft floatRight" id="newGroup" data-toggle="modal" data-target="#myModal" value="新增" style="padding: 2.5px 10px;" />
                        <input type="button" class="btn btn-primary btn-sm floatRight" id="changeUser" value="编辑" style="padding: 2.5px 10px;" />
                        <input type="button" class="btn btn-primary btn-sm floatRight" id="closeEdit" value="结束编辑" style="padding: 2.5px 10px;display:none" />
                        <input type="button" class="tohidden" id="EditGroup" data-toggle="modal" data-target="#editModal" />
                    </div>
                    <div id="tableArea" class="panel-body mintablewidth">
                        <table id="UserTable" class="table table-striped table-hover" style="width:100%">
                        </table>
                    </div>
                </div>
            </div>

        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" data-dismiss="modal" class="close" aria-hidden="true">×</button>
                        <h4 class="modal-title" id="myModalLabel">新增用户</h4>
                        
                    </div>
                        <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000" >
                            <label id="error" class="tohidden"></label>
                            <table id="addGroup" class="mytable table-bordered table-center">
                                <tbody style="text-align:center;">
                                        <tr>
                                            <th style="width:30%;">账号</th>
                                            <td>
                                                <input id="userNumber" class="form-control IsEmpty number" name="userNumber" type="text" placeholder="请输入账号" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>姓名</th>
                                            <td>
                                                <input id="name" name="userName" type="text" placeholder="请输入姓名" class="form-control IsEmpty" />
                                            </td>
                                        </tr><tr>
                                            <th>性别</th>
                                            <td>
                                                <div class="col-xs-4">
                                                    <input id="male" type="radio" name="gender" checked="checked" value="M" />
                                                    <label for="male">男</label>
                                                </div>
                                                <div class="col-xs-3">
                                                    <input id="female" type="radio" name="gender" value="F" />
                                                    <label for="female">女</label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>密码</th>
                                            <td>
                                                <input id="userPassword" name="userKey" type="password" placeholder="请输入密码" class="form-control userKey" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>确认密码</th>
                                            <td>
                                                <input id="checkPassword" type="password" placeholder="请再次输入密码" class="form-control checkPassword" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>联系方式</th>
                                            <td>
                                                <input id="phoneContact" name="phoneNumber" type="text" placeholder="请输入联系方式" class="form-control contact" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>办公室</th>
                                            <td>
                                                <select id="Select2" name="officeSelect" class="form-control office" >
                                                    <option value="">--请选择办公室--</option>
                                                    <option value="登记处">登记处</option>
                                                    <option value="放疗设备状态监测室">放疗设备状态监测室</option>
                                                    <option value="加速器治疗室">加速器治疗室</option>
                                                    <option value="模具摆放室">模具摆放室</option>
                                                    <option value="模拟定位室">模拟定位室</option>
                                                    <option value="物理室">物理室</option>
                                                    <option value="医生工作室">医生工作室</option>
                                                    <option value="制模室">制模室</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>绑定角色</th>
                                            <td>
                                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" style="text-decoration:none;">
                                                    <h4 class="panel-title">选择角色</h4>
                                                </a>
                                                <div id="collapseOne" class="info-option panel-collapse collapse" aria-expanded="true">
                                                    <div class="form-group">
                                                        <ul id="hidePart" class="list-inline checkRole" style="text-align:left;">
                                                            <li>
                                                                <label class="control-label">
                                                                    <input id="allRole" type="checkbox" />
                                                                    全部角色
                                                                </label>
                                                            </li>
                                                        </ul>
                                                    </div>
                                                </div>
                                                <input id="selectedRole" type="hidden" value="" name="selectedRole" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>激活状态</th>
                                            <td>
                                                <div class="col-xs-4">
                                                    <input id="activated" type="radio" name="activate" value="1"checked="checked" />
                                                    <label for="activated">激活</label>
                                                </div>
                                                <div class="col-xs-4">
                                                    <input id="unactivate" type="radio" name="activate" value="0" />
                                                    <label for="unactivate">不激活</label>
                                                </div>
                                            </td>
                                        </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button id="cannelButton" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
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
                        <h4 class="modal-title">修改用户</h4>                     
                    </div>
                        <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000" >
                            <label id="editError" class="tohidden"></label>
                             <table id="EditTable" class="mytable table-bordered table-center">
                                 <tbody style="text-align:center;">
                                        <tr>
                                            <th style="width:30%;">账号</th>
                                            <td>
                                                <input id="numberEdit" class="form-control IsEmpty number" name="numberEdit" type="text"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>姓名</th>
                                            <td>
                                                <input id="nameEdit" name="nameEdit" type="text" class="form-control IsEmpty" />
                                            </td>
                                        </tr><tr>
                                            <th>性别</th>
                                            <td>
                                                <div class="col-xs-4">
                                                    <input id="genderEdit1" type="radio" name="genderEdit" checked="checked" value="M" />
                                                    <label for="male">男</label>
                                                </div>
                                                <div class="col-xs-3">
                                                    <input id="genderEdit2" type="radio" name="genderEdit" value="F" />
                                                    <label for="female">女</label>
                                                </div>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>密码</th>
                                            <td>
                                                <input id="pwdEdit" name="pwdEdit" type="text" class="form-control userKey"/>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>联系方式</th>
                                            <td>
                                                <input id="phoneEdit" name="phoneEdit" type="text" class="form-control contact" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>办公室</th>
                                            <td>
                                                <select id="officeEdit" name="officeEdit" class="form-control office" >
                                                    <option value="">--请选择办公室--</option>
                                                    <option value="登记处">登记处</option>
                                                    <option value="放疗设备状态监测室">放疗设备状态监测室</option>
                                                    <option value="加速器治疗室">加速器治疗室</option>
                                                    <option value="模具摆放室">模具摆放室</option>
                                                    <option value="模拟定位室">模拟定位室</option>
                                                    <option value="物理室">物理室</option>
                                                    <option value="医生工作室">医生工作室</option>
                                                    <option value="制模室">制模室</option>
                                                </select>
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>激活状态</th>
                                            <td>
                                                <div class="col-xs-4">
                                                    <input id="activateEdit1" type="radio" name="activateEdit" value="1"checked="checked" />
                                                    <label for="activated">激活</label>
                                                </div>
                                                <div class="col-xs-4">
                                                    <input id="activateEdit2" type="radio" name="activateEdit" value="0" />
                                                    <label for="unactivate">不激活</label>
                                                </div>
                                            </td>
                                        </tr>
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button id="cannelEdit" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                            <!--<input id="deleteUser" class="btn btn-danger" type="button" value="删除用户" />-->
                            <input id="sureEdit" type="submit" class="btn btn-primary" value="确认" />
                        </div>
                </div>
                                    <!-- /.modal-content -->
            </div>
                                <!-- /.modal-dialog -->
        </div>
        
    </section>
  </div>

  <!-- /.content-wrapper -->
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
<!-- ./wrapper -->
<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/jquery.min.js"></script>
<!-- tablecreate -->
<script src="../../js/Root/createTable.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="../../plugin/AdminLTE/dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../plugin/AdminLTE/dist/js/demo.js"></script>
<!-- SlimScroll -->
<script src="../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- Main js-->
<script src="../../js/Root/userManageJS.js"></script>
<script src="../../js/Root/chooseAll.js" type="text/javascript"></script>
<script src="../../js/Root/RootMainJS.js"></script>
<!-- Main JavaScript -->
</body>
</html>
