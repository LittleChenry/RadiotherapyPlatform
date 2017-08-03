<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-role.aspx.cs" Inherits="Root_Root_role" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>角色信息</title>

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

        <li class="treeview active">
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
                <h1 class="page-header">角色信息</h1>
            </div>
        </div>
        <div class="row" style="margin-top:10px;">
            <form id="frm" runat="server">
                <div class="col-xs-12">
                    <asp:ScriptManager ID="ScriptManager1" runat="server"></asp:ScriptManager>
                        <asp:ObjectDataSource ID="roleObjectDataSource" runat="server" InsertMethod="Delete" SelectMethod="Select" TypeName="roleManagement" UpdateMethod="Update" OnDeleting="roleObjectDataSource_Deleting" OnUpdating="roleObjectDataSource_Updating" DeleteMethod="Delete">
                            <DeleteParameters>
                                <asp:Parameter Name="id" Type="String" />
                            </DeleteParameters>
                            <InsertParameters>
                                <asp:Parameter Name="id" Type="String" />
                            </InsertParameters>
                            <UpdateParameters>
                                <asp:Parameter Name="id" Type="String" />
                                <asp:Parameter Name="Description" Type="String" />
                            </UpdateParameters>
                        </asp:ObjectDataSource>
                    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                        <ContentTemplate>

                        <asp:GridView ID="roleGridView" AutoGenerateColumns="False" AllowPaging="True" PageSize="8" runat="server" CssClass="table table-striped table-bordered table-hover" DataSourceID="roleObjectDataSource">
                            <PagerSettings Mode="NextPreviousFirstLast" NextPageText="下一页" PreviousPageText="上一页" LastPageText="末页" FirstPageText="首页" />
                            <Columns>
                                <asp:TemplateField HeaderText="角色编号">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# Bind("ID") %>'></asp:Label>
                                    </ItemTemplate>
                                    <EditItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# Eval("ID") %>'></asp:Label>
                                        </label>
                                    </EditItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="Description" HeaderText="角色名" />
                                <asp:TemplateField HeaderText="删除角色" ShowHeader="False">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="deleteLinkButton" runat="server" CausesValidation="False" CommandName="Delete" OnClick="LinkButton1_Click" Text="删除" CssClass="btn btn-default"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="编辑角色" ShowHeader="False">
                                    <EditItemTemplate>
                                        <asp:LinkButton ID="updateLinkButton" runat="server" CausesValidation="True" CommandName="Update" Text="更新" CssClass="btn btn-default"></asp:LinkButton>
                                        &nbsp;<asp:LinkButton ID="canelLinkButton" runat="server" CausesValidation="False" CommandName="Cancel" Text="取消" CssClass="btn btn-default"></asp:LinkButton>
                                    </EditItemTemplate>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="EditLinkButton" runat="server" CausesValidation="False" CommandName="Edit" Text="编辑" CssClass="btn btn-default"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        </ContentTemplate>
                    </asp:UpdatePanel>
                </div>
            </form>
            <input id="showAdd" type="button" value="新增角色" class="btn btn-primary" data-toggle="modal" data-target="#addRole" style="margin:15px;float:right;" />
            <div class="modal fade changebindArea" id="addRole" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top:100px;">
                <form id="addRoleFrm" method="post" action="Root-role.aspx">
                    <div class="panel panel-default" style="max-width:520px;margin:auto;">
                        <div class="panel-heading">
                            新增角色
                        </div>
                        <div class="panel-body">
                            <input type="hidden" name="ispostback" value="true" />
                            <label id="error" class="error"></label>
                            <div class="form-group">
                                <table class="table">
                                    <tbody>
                                        <tr>
                                            <td style="width:20%">角色简称</td>
                                            <td>
                                                <input id="roleName" name="roleName" type="text" class="form-control controlHeight IsEmpty" placeholder="角色简称，由字母组成" />
                                            </td>                                           
                                        </tr>
                                        <tr>
                                            <td>角色名称</td>
                                            <td>
                                                <input id="roleDescription" name="roleDescription" type="text" class="form-control controlHeight IsEmpty" placeholder="请输入角色名称" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>绑定功能</td>
                                            <td>
                                                <ul id="hidePart" class="list-inline">
                                                </ul>
                                                <input id="selectedFunction" type="hidden" value="" name="selectedFunction" />
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                                <div class="row" style="margin-bottom:10px;text-align:center;">
                                    <div class="col-xs-6">
                                        <input class="btn btn-default" id="Button1" type="button" value="取消" data-dismiss="modal" aria-label="Close" />
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
<!-- SlimScroll -->
<script src="../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- Main JavaScript -->
<script src="../../js/Root/function.js" type="text/javascript"></script>
</body>
</html>
