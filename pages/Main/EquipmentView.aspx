<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EquipmentView.aspx.cs" Inherits="pages_Main_EquipmentView" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta charset="utf-8"/>
  <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
  <title>放疗质控系统</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport"/>
  <!-- css -->
  <link rel="stylesheet" href="../../css/Main/Records.css"/>
  <link rel="stylesheet" href="../../css/Root/equipment.css" />
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
  <!-- bootstrap datepicker -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datepicker/datepicker3.css" />
  <!-- DataTables -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
  <!-- Ionicons -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
  <!-- Theme style -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css"/>
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>

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
                            <span class="label label-danger">0</span>
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
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-clock-o"></i> <span>预约</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li>
                            <a id="Menu-EquipmentAppointment" href="EquipmentAppointment.aspx" target="_blank"><i class="fa fa-circle-o"></i>设备预约管理</a>
                        </li>
                        <li>
                            <a id="Menu-Appointment" href="Appointment.aspx" target="_blank"><i class="fa fa-circle-o"></i>加速器预约</a>
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
                <li class="active treeview">
                    <a id="Menu-EquipmentView"  href="EquipmentView.aspx">
                        <i class="fa fa-briefcase"></i>
                        <span>设备管理</span>
                    </a>
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
        <section class="content-header">
            <h1>设备预约管理</h1>
        </section>
        <section class="content">
            <input id="type" type="hidden" value="Root" />
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
                        <div class="col-xs-4" style="padding-left:0px;">
                            <input class="btn btn-primary" type="submit" value="查询" id="searchButton" />
                        </div>
                    </div>
                    <div class="col-xs-12" id="gridContent">
                        <div class="box box-primary">
                            <asp:GridView ID="equipmentGridView" runat="server" AllowPaging="True" PageSize="8" AutoGenerateColumns="False" CssClass="table table-bordered" DataSourceID="equipmentObjectDataSource">
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
                                    <asp:TemplateField HeaderText="设备类型">
                                        <EditItemTemplate>
                                            <asp:TextBox ID="TextBox6" runat="server" Text='<%# Bind("Type") %>'></asp:TextBox>
                                        </EditItemTemplate>
                                        <ItemTemplate>
                                            <asp:Label ID="Label6" runat="server" Text='<%# Bind("Type") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="TreatmentItem" HeaderText="隶属治疗项目" />
                                    <asp:TemplateField HeaderText="编辑设备" ShowHeader="False">
                                        <ItemTemplate>
                                            <a href="#" class="selectedUpdate btn btn-default" data-toggle="modal" data-target="#addEquipment">选择</a>
                                            <input type="hidden" value='<%# Eval("ID") %>' />
                                            <input type="hidden" value='<%# equipmentGridView.PageIndex %>' />
                                            <input type="hidden" value='<%# Eval("EquipmentType") %>' />
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                                <RowStyle HorizontalAlign="Center" />
                            </asp:GridView>
                        </div>
                    </div>
                </form>
                <input id="insert" type="button" value="新增设备" class="btn btn-primary" data-toggle="modal" data-target="#addEquipment" style="display:none;"/>
                <div id="addEquipment" class="modal fade" tabindex="-1" role="dialog">
                    <form id="changefrm" method="post" action="Root-equipment.aspx">
                        <div class="modal-dialog" role="document">
                            <div class="modal-content">
                                <div class="modal-header">
                                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                                    <h4 class="modal-title">编辑设备信息</h4>
                                </div>
                                <div class="modal-body">
                                    <label id="error"></label>
                                    <div class="form-group">
                                        <input type="hidden" id="equipID" name="equipID" />
                                        <input type="hidden" id="currentPage" name="currentPage" />
                                        <input type="hidden" name="ispostback" value="true" />
                                        <input type="hidden" name="formType" value="" id="formType" />
                                        <table class="table">
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
                                                    <th class="noborder">
                                                        <select id="allowNext" class="form-item" name="allowNext">
                                                            <option value="afternoon">下午结束时间</option>
                                                            <option value="nextday">次日凌晨结束</option>
                                                        </select>
                                                    </th>
                                                    <td>
                                                        <input type="text" id="PMEnd" name="PMEnd" class="form-control controlHeight Time PMEnd" placeholder="请输入下午结束使用设备时间" />
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th class="noborder"><label for="equipementType" class="height">设备类型</label></th>
                                                    <td>
                                                        <select id="equipmentType" class="form-control" name="equipmentType"></select>
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
                                    </div>
                                </div>
                                <div class="modal-footer">
                                    <div class="col-xs-6" style="text-align:center;">
                                        <input class="btn btn-default" id="Button1" type="button" value="取消" data-dismiss="modal" aria-label="Close" />
                                    </div>
                                    <div class="col-xs-6" style="text-align:center;">
                                        <input class="btn btn-primary" type="submit" value="提交" />
                                    </div>
                                </div>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </section>
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
<!-- Main js-->
<script src="../../js/Root/RootMainJS.js"></script>
<!-- Main JavaScript -->
<script src="../../js/Root/equipment.js"></script>
<script src="../../js/Main/EquipmentView.js"></script>
    
</body>
</html>
