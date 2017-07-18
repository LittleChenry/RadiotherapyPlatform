<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-userInformation.aspx.cs" Inherits="Root_Root_userInformation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-6"/>
    <title></title>

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
        <li class="treeview active">
          <a href="#">
            <i class="fa fa-user fa-fw"></i> <span>用户管理</span>
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
        <li class="treeview">
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
    <section class="content">
        <input id="type" type="hidden" value="Root" />
        <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">用户信息</h1>
            </div>
        </div>
        <div class="row" style="margin-top:10px;">
            <form id="frm" method="post" runat="server">
                <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                <asp:ObjectDataSource ID="userDataSource" runat="server" SelectMethod="Select" TypeName="userDataSource" UpdateMethod="Update" OnUpdating="userDataSource_Updating" DeleteMethod="Delete" OnDeleting="userDataSource_Deleting">
                    <SelectParameters>
                        <asp:FormParameter DefaultValue="allNumber" FormField="roles" Name="activate" Type="String" />
                        <asp:FormParameter FormField="office" Name="office" Type="String" DefaultValue="allOffice" />
                    </SelectParameters>
                    <UpdateParameters>
                        <asp:Parameter Name="Number" Type="String" />
                        <asp:Parameter Name="name" Type="String" />
                        <asp:Parameter Name="Gender" Type="String" />
                        <asp:Parameter Name="contact" Type="String" />
                        <asp:Parameter Name="office" Type="String" />
                        <asp:Parameter Name="Password" Type="String" />
                    </UpdateParameters>
                    <DeleteParameters>
                        <asp:Parameter Name="Number" Type="String" />
                    </DeleteParameters>
                </asp:ObjectDataSource>
                <div>
                    <div class="col-xs-12 search">
                        <div class="col-xs-4">
                            <select id="role" name="roles" class="form-control" style="width:60%">
                                <option value="allNumber">全部账号</option>
                                <option value="1">已激活账号</option>
                                <option value="0">未激活账号</option>
                            </select>
                        </div>
                        <div class="col-xs-4">
                            <select id="office" name="office" class="form-control" style="width:60%">
                                <option value="allOffice">全部办公室</option>
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
                            <input type="submit" value="查询" class="btn btn-primary" />
                        </div>
                    </div>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>
                    <div class="col-xs-12">
                        <asp:GridView ID="User" runat="server" CssClass="table table-striped table-bordered table-hover" AutoGenerateColumns="False" AllowPaging="True" PageSize="6" DataSourceID="userDataSource" >
                            <PagerSettings Mode="NextPreviousFirstLast" NextPageText="下一页" PreviousPageText="上一页" FirstPageText="首页" LastPageText="末页" />
                            <Columns>
                                <asp:TemplateField HeaderText="用户账号">
                                    <EditItemTemplate>
                                        <input name="Number" type="text" readonly="true" value="<%# Eval("Number") %>" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="userNumber" runat="server" Text='<%# Bind("Number") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Name" HeaderText="姓名" />
                                <asp:TemplateField HeaderText="性别">
                                    <ItemTemplate>
                                        <asp:Label ID="sexLabel" runat="server" Text='<%# GetGender(Eval("Gender")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:RadioButtonList ID="sexRadio" runat="server" RepeatColumns="2" CssClass="center" SelectedValue='<%# Bind("Gender") %>' >
                                            <asp:ListItem Value="M" Text="男"></asp:ListItem>
                                            <asp:ListItem Value="F" Text="女"></asp:ListItem>
                                        </asp:RadioButtonList>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="联系方式">
                                    <EditItemTemplate>
                                        <input type="text" value="<%# Eval("Contact") %>" id="contact" name="contact" />
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("Contact") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="办公室">
                                    <EditItemTemplate>
                                        <asp:DropDownList ID="office" runat="server" SelectedValue='<%# Bind("Office") %>' >
                                            <asp:ListItem value="">--请选择办公室--</asp:ListItem>
                                            <asp:ListItem value="登记处">登记处</asp:ListItem>
                                            <asp:ListItem value="放疗设备状态监测室">放疗设备状态监测室</asp:ListItem>
                                            <asp:ListItem value="加速器治疗室">加速器治疗室</asp:ListItem>
                                            <asp:ListItem value="模具摆放室">模具摆放室</asp:ListItem>
                                            <asp:ListItem value="模拟定位室">模拟定位室</asp:ListItem>
                                            <asp:ListItem value="物理室">物理室</asp:ListItem>
                                            <asp:ListItem value="医生工作室">医生工作室</asp:ListItem>
                                            <asp:ListItem value="制模室">制模室</asp:ListItem>
                                        </asp:DropDownList>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:Label ID="OfficeLabel" runat="server" Text='<%# Bind("Office") %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Password" HeaderText="用户密码" />
                                <asp:TemplateField HeaderText="激活状态">
                                    <ItemTemplate>
                                        <asp:Label ID="ActivateLabel" runat="server" Text='<%# GetActive(Eval("Activate")) %>'></asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="编辑" ShowHeader="False">
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="UpdateLinkButton" runat="server" CausesValidation="True" CommandName="Update" Text="更新" CssClass="btn btn-default"></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="CannelLinkButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消" CssClass="btn btn-default"></asp:LinkButton>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditLinkButton" runat="server" CausesValidation="False" CommandName="Edit" Text="编辑" CssClass="btn btn-default"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="激活用户">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="Activate" runat="server" Text='<%# GetButtonText(Eval("Activate")) %>' OnClick="Activate_Click" CssClass="btn btn-default"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="删除用户" ShowHeader="False" HeaderStyle-Width="5%">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="DeleteLinkButton" runat="server" CausesValidation="False" CommandName="Delete" Text="删除" OnClick="DeleteLinkButton_Click" CssClass="btn btn-default"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </div>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </form>
            <input id="showAdd" type="button" value="新增用户" class="btn btn-primary" data-toggle="modal" data-target="#addUser" style="margin:15px;float:right;" />
            <div class="modal fade changebindArea" id="addUser" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top:100px;">
                <form id="addNewFrm" action="Root-userInformation.aspx" method="post">
                    <div class="panel panel-default" style="max-width:520px;margin:auto;">
                        <div class="panel-heading">
                            新增用户
                        </div>
                        <div class="panel-body">
                            <input type="hidden" name="ispostback" value="true" />
                            <label id="error"></label>
                            <div class="form-group">
                                <table class="table">
                                    <tbody style="text-align:center;">
                                        <tr>
                                            <td style="width:30%;">账号</td>
                                            <td>
                                                <input id="userNumber" class="form-control" name="userNumber" type="text" placeholder="请输入账号" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>姓名</td>
                                            <td>
                                                <input id="name" name="userName" type="text" placeholder="请输入姓名" class="form-control" />
                                            </td>
                                        </tr><tr>
                                            <td>性别</td>
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
                                            <td>密码</td>
                                            <td>
                                                <input id="userPassword" name="userKey" type="password" placeholder="请输入密码" class="form-control" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>确认密码</td>
                                            <td>
                                                <input id="checkPassword" type="password" placeholder="请再次输入密码" class="form-control" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>联系方式</td>
                                            <td>
                                                <input id="phoneContact" name="phoneNumber" type="text" placeholder="请输入联系方式" class="form-control" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>办公室</td>
                                            <td>
                                                <select id="Select1" name="officeSelect" class="form-control" >
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
                                            <td>绑定角色</td>
                                            <td>
                                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" style="text-decoration:none;">
                                                    <h4 class="panel-title">选择可见角色</h4>
                                                </a>
                                                <div id="collapseOne" class="info-option panel-collapse collapse" aria-expanded="true">
                                                    <div class="form-group">
                                                        <ul id="hidePart" class="list-inline" style="text-align:left;">
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
                                            <td>激活状态</td>
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
    <script src="../../js/Root/userInformation.js" type="text/javascript"></script>
    <script src="../../js/Root/chooseAll.js" type="text/javascript"></script>
<!-- Main JavaScript -->
</body>
</html>
