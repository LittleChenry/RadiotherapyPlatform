﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-equipment.aspx.cs" Inherits="Root_Root_equipment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
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
    <title></title>

    <!-- Main CSS -->
    <link href="../../css/Root/Root-userInformation.css" rel="stylesheet" type="text/css" />
    <link href="../../css/Root/equipment.css" rel="stylesheet" type="text/css" />
</head>
<body class="hold-transition skin-blue sidebar-mini">
<div class="wrapper">

  <header class="main-header">
    <!-- Logo -->
    <a href="RootMain.aspx" class="logo">
      <!-- mini logo for sidebar mini 50x50 pixels -->
      <span class="logo-mini"><b>js</b>ph</span>
      <!-- logo for regular state and mobile devices -->
      <span class="logo-lg"><b>江苏省</b>人民医院</span>
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
            <li class="active"><a href="Root-equipment.aspx"><i class="fa fa-circle-o"></i> 设备管理</a></li>
            <li><a href="Root-EquipmentInspectionManage.aspx"><i class="fa fa-circle-o"></i> 设备检查管理</a></li>
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
                <h1 class="page-header">设备管理</h1>
            </div>
        </div>
        <div class="row">
            <form id="frm" runat="server">
                <asp:ObjectDataSource ID="equipmentObjectDataSource" runat="server" SelectMethod="Select" TypeName="equipment" OnDeleting="equipmentObjectDataSource_Deleting" DeleteMethod="Delete">
                    <DeleteParameters>
                        <asp:Parameter Name="id" Type="String" />
                    </DeleteParameters>
                    <SelectParameters>
                        <asp:FormParameter DefaultValue="allEquipment" FormField="equipState" Name="state" Type="String" />
                        <asp:FormParameter DefaultValue="allItem" FormField="TreatmentItem" Name="item" Type="String" />
                    </SelectParameters>
                </asp:ObjectDataSource>
                <asp:ScriptManager ID="ScriptManager" runat="server"></asp:ScriptManager>
                <div class="col-xs-12 search">
                    <div class="col-xs-4">
                        <select id="equipState" class="form-control" name="equipState" style="width:60%;">
                                <option value="allEquipment">全部设备</option>
                                <option value="1">可用设备</option>
                                <option value="2">检查中设备</option>
                                <option value="3">维修中设备</option>
                            </select>
                    </div>
                    <div class="col-xs-4">
                        <select id="TreatmentItem" class="form-control" name="TreatmentItem" style="width:60%;">                
                        </select>
                    </div>
                    <div class="col-xs-4">
                        <input class="btn btn-primary" type="submit" value="查询" id="searchButton" />
                    </div>
                </div>
                <div class="col-xs-12" id="gridContent">
                    <asp:GridView ID="equipmentGridView" runat="server" AllowPaging="True" PageSize="8" AutoGenerateColumns="False" CssClass="table table-striped table-bordered table-hover" DataSourceID="equipmentObjectDataSource">
                        <PagerSettings Mode="NextPreviousFirstLast" FirstPageText="首页" LastPageText="末页" NextPageText="下一页" PreviousPageText="上一页" />
                        <Columns>
                            <asp:BoundField DataField="Name" HeaderText="设备名" />
                            <asp:TemplateField HeaderText="设备状态">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox1" runat="server" Text='<%# Bind("State") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label1" runat="server" Text='<%# GetState(Eval("State")) %>'></asp:Label>
                                    <asp:HiddenField Value='<%# Eval("ID") %>' ID="equipmentID" runat="server" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Timelength" HeaderText="一次治疗时间" />
                            <asp:TemplateField HeaderText="上午起始时间">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox2" runat="server" Text='<%# Bind("BeginTimeAM") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label2" runat="server" Text='<%# GetTime(Eval("BeginTimeAM"))%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="上午结束时间">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox3" runat="server" Text='<%# Bind("EndTimeAM") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label3" runat="server" Text='<%# GetTime(Eval("EndTimeAM"))%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="下午起始时间">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox4" runat="server" Text='<%# Bind("BegTimePM") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label4" runat="server" Text='<%# GetTime(Eval("BegTimePM"))%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="下午结束时间">
                                <EditItemTemplate>
                                    <asp:TextBox ID="TextBox5" runat="server" Text='<%# Bind("EndTimeTPM") %>'></asp:TextBox>
                                </EditItemTemplate>
                                <ItemTemplate>
                                    <asp:Label ID="Label5" runat="server" Text='<%# GetTime(Eval("EndTimeTPM"))%>'></asp:Label>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="TreatmentItem" HeaderText="隶属治疗项目" />
                            <asp:TemplateField HeaderText="移除设备" ShowHeader="False">
                                <ItemTemplate>
                                    <asp:LinkButton ID="LinkButton1" runat="server" CausesValidation="False" CommandName="Delete" OnClick="LinkButton1_Click" Text="删除" CssClass="btn btn-default"></asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="编辑设备" ShowHeader="False">
                                <ItemTemplate>
                                    <a href="#" class="selectedUpdate btn btn-default" data-toggle="modal" data-target="#addEquipment">选择</a>
                                    <input type="hidden" value='<%# Eval("ID") %>' />
                                    <input type="hidden" value='<%# equipmentGridView.PageIndex %>' />
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                    </asp:GridView>
                </div>
            </form>
            <input id="insert" type="button" value="新增设备" class="btn btn-primary" data-toggle="modal" data-target="#addEquipment" style="margin:15px;float:right;" />
            <div class="modal fade changebindArea" id="addEquipment" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top:100px;">
                <form id="changefrm" method="post" action="Root-equipment.aspx">
                    <div class="panel panel-default" style="max-width:520px;margin:auto;">
                        <div class="panel-heading">
                            新增设备
                        </div>
                        <div class="panel-body">
                            <label id="error"></label>
                            <div class="form-group">
                                <input type="hidden" id="equipID" name="equipID" />
                                <input type="hidden" id="currentPage" name="currentPage" />
                                <input type="hidden" name="ispostback" value="true" />
                                <input type="hidden" name="formType" value="" id="formType" />
                                <table class="table" style="width:100%">
                                    <tbody>
                                        <tr>
                                            <th class="noborder"><label for="equipmentName" class="height">设备名</label></th>
                                                <td>
                                                    <input id="equipmentName" name="equipmentName" type="text" class="form-control controlHeight IsEmpty" placeholder="请输入设备名" />
                                                </td>                                           
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="equipmentState" class="height">设备状态</label></th>
                                                <td>
                                                    <select id="equipmentState" name="equipmentState" class="form-control">
                                                        <option value="1">可用</option>
                                                        <option value="2">检查中</option>
                                                        <option value="3">维修中</option>
                                                    </select>
                                                </td>
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="onceTime" class="height">一次治疗时间</label></th>
                                            <td>
                                                <input type="text" id="onceTime" name="onceTime" class="form-control controlHeight OnceTreatment" placeholder="请输入一次治疗时间(单位分钟)" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="AMBeg" class="height">上午开始时间</label></th>
                                            <td>
                                                <input type="text" id="AMbeg" name="AMbeg" class="form-control controlHeight Time" placeholder="请输入上午开始使用设备时间" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="AMEnd" class="height">上午结束时间</label></th>
                                            <td>
                                                <input type="text" id="AMEnd" name="AMEnd" class="form-control controlHeight Time AMEnd" placeholder="请输入上午结束使用设备时间" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="PMBeg" class="height">下午开始时间</label></th>
                                            <td>
                                                <input type="text" id="PMBeg" name="PMBeg" class="form-control controlHeight Time" placeholder="请输入下午开始使用设备时间" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="PMEnd" class="height">下午结束时间</label></th>
                                            <td>
                                                <input type="text" id="PMEnd" name="PMEnd" class="form-control controlHeight Time PMEnd" placeholder="请输入下午结束使用设备时间" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th class="noborder"><label for="changeTreatmentItem" class="height">隶属项目</label></th>
                                            <td>
                                                <select id="changeTreatmentItem" name="changeTreatmentItem" class="form-control treatItem">                
                                                </select>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div class="row" style="margin-bottom:10px;text-align:center;">
                                    <div class="col-xs-6">
                                        <input class="btn btn-default" id="cannel" type="button" value="取消" data-dismiss="modal" aria-label="Close" />
                                    </div>
                                    <div class="col-xs-6">
                                        <input class="btn btn-primary" type="submit" value="提交" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
        </div>
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
<script src="../../js/Root/equipment.js"></script>
</body>    
</html>

