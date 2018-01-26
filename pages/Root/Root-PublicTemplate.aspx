<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-PublicTemplate.aspx.cs" Inherits="pages_Root_Root_PublicTemplate" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <!--Tell the brower to be responsive to screen width -->
    <meta content="Width=device-width, initial-scale=1, maxmum-scale=1, user-scalable=no" name="viewport" />
        <title>公共模板设置</title>
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
    <link rel="stylesheet" href="../../plugin/jqueryui/jquery-ui.min.css" />
    <link rel="stylesheet" href="../../plugin/multiselect/bootstrap-multiselect.css" />

    <!-- Main CSS -->
    <link href="../../css/Main/main.css" rel="stylesheet" />
    <link rel="stylesheet" href="../../css/Root/equipmentMain.css" />
    <link href="../../css/Root/rootMain.css" rel="stylesheet" />
    <style>
        .td-input {
    border-radius: 0;
    box-shadow: none;
    border-color: #000000;
    padding: 4px 2px;
    width: 100%;
    height: 36px;
    line-height: 1.42857143;
    color: #555;
    background-color: #fff;
    background-image: none;
    border: 0px;
}

         .multiselect-wrapper {
    display: inline-block;
    position: relative;
    vertical-align: middle;
    text-align: left;
}

    .multiselect-wrapper button {
        text-align: left;
    }

    .multiselect-wrapper span {
        margin-left: 3px;
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
        display: block;
    }

    .multiselect-wrapper .dropdown-menu {
        width: 100%;
    }

    .multiselect-wrapper .caret {
        position: absolute;
        top: 13px;
        right: 10px;
        width: 0;
        height: 0;
    }

    .multiselect-wrapper label.checkbox, .multiselect-wrapper label.radio {
        padding: 3px 20px 3px 30px !important;
        width: 100%;
    }
    </style>
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
          <li>
              <a href="Root-FirstAccTime.aspx">
                  <i class="fa fa-clone"></i><span>首次治疗预约时间段</span>
                  <span class="pull-right-container"></span>
              </a>
          </li>
          <li class="active">
              <a href="Root-PublicTemplate.aspx">
                  <i class="fa fa-clone"></i><span>公共模板设置</span>
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
        <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">公共模板设置</h1>
            </div>
        </div>
        <%--选择项目--%>
        <div class="row">
            <div class="col-xs-3 col-xs-offset-4">
                <select id="typeSelect" class="form-control">
                    <option value="1">病情诊断</option>
                    <option value="2">体位固定申请</option>
                    <option value="3">模拟定位申请</option>
                    <option value="7">计划申请</option>
                </select>
            </div>
            <div class="col-xs-2">
                <input type="button" value="确定" id="sureSelect" class="btn btn-primary"/>
            </div>
        </div>
        <%--模板列表--%>
        <div class="row">
            <div class="col-xs-12">
                <div class="panel panel-default mintablewidth">
                    <div class="panel-heading mintablewidth">
                        <i class="fa fa-bar-chart-o fa-fw"></i>
                        <span class="panel-title" id="tabletitle"></span>
                        <input type="button" class="btn btn-primary btn-sm buttonToLeft floatRight" id="addModal" value="新增" style="padding: 2.5px 10px;" />
                        <%--<input type="button" class="btn btn-primary btn-sm floatRight" id="editModal" value="查看" style="padding: 2.5px 10px;" />
                        <input type="button" class="btn btn-primary btn-sm floatRight" id="closeEdit" value="结束编辑" style="padding: 2.5px 10px; display: none" />--%>
                    </div>
                    <div id="tableArea" class="panel-body mintablewidth">
                        <table id="listTable" class="table table-striped table-hover" style="width: 100%">
                            <thead>

                            </thead>
                            <tbody id="body">

                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        
        <%--病情诊断add modal--%>
        <div class="modal fade" id="add_diagnose" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title" id="myModalLabel">病情诊断</h4>
                    </div>
                    <div class="modal-body">
                       <form class="form-horizontal">
                           <div class="form-group">
                               <label for="templateName" class="col-sm-3 control-label">模版名称</label>
                               <div class="col-sm-9">
                                   <input type="text" class="form-control" id="templateName">
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">病情诊断结果</label>
                               <div class="col-sm-3">
                                   <select id="bingqing1" class="form-control" onchange="loadone();">
                                       <option value="">无</option>
                                   </select>
                               </div>
                               <div class="col-sm-3">
                                   <select id="bingqing2" class="form-control" onchange="loadtwo();">
                                       <option value="">无</option>
                                   </select>
                               </div>
                               <div class="col-sm-3">
                                   <select id="bingqing3" class="form-control" onchange="loadthree();">
                                       <option value="">无</option>
                                   </select>
                               </div>
                               <input type="hidden"  id="copybingqing1" value=""/>
                                <input type="hidden"  id="copybingqing2" value="" />
                                <input type="hidden"  id="copybingqing3" value="" />
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">病理诊断结果</label>
                               <div class="col-sm-4">
                                   <select id="bingli1" class="form-control" onchange="loadonenext();">
                                       <option value="">无</option>
                                   </select>
                               </div>
                               <div class="col-sm-4">
                                   <select id="bingli2" class="form-control" onchange="loadtwonext();">
                                       <option value="">无</option>
                                   </select>
                               </div>
                               <input type="hidden"  id="copybingli1" value=""/>
                                <input type="hidden"  id="copybingli2" value="" />
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">病变部位</label>
                               <div class="col-sm-9">
                                   <select multiple class="form-control" size="1" id="part">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">照射部位</label>
                               <div class="col-sm-9">
                                   <select multiple class="form-control" size="1" id="newpart">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">治疗目标</label>
                               <div class="col-sm-9">
                                   <select class="form-control" size="1" id="Aim">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">备注</label>
                               <div class="col-sm-9">
                                   <textarea class="form-control" rows="5" id="remark"></textarea>
                               </div>
                           </div>
                       </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" id="sureAddDiagnose">确定</button>
                        <button type="button" class="btn btn-danger" id="sureDeleteDiagnose">删除</button>
                    </div>
                </div>
            </div>
        </div>
        <%-- 体位固定modal --%>
        <div class="modal fade" id="add_fix" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">体位固定</h4>
                    </div>
                    <div class="modal-body">
                       <form class="form-horizontal">
                           <div class="form-group">
                               <label class="col-sm-3 control-label">模版名称</label>
                               <div class="col-sm-9">
                                   <input type="text" class="form-control" id="templateName_fix">
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">模具：</label>
                               <div class="col-sm-9">
                                   <select id="modelselect" class="form-control">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">固定装置：</label>
                               <div class="col-sm-9">
                                   <select id="fixEquip" class="form-control">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">体位：</label>
                               <div class="col-sm-9">
                                   <select id="bodyPost" class="form-control">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">特殊要求：</label>
                               <div class="col-sm-9">
                                   <select id="specialrequest" class="form-control">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">备注：</label>
                               <div class="col-sm-9">
                                   <textarea class="form-control" rows="5" id="Remarks_fix"></textarea>
                               </div>
                           </div>
                           
                           
                           
                       </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" id="sureAddFix">确定</button>
                        <button type="button" class="btn btn-danger" id="sureDeleteFix">删除</button>
                    </div>
                </div>
            </div>
        </div>
        <%-- 模拟定位modal --%>
        <div class="modal fade" id="add_locate" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">模拟定位</h4>
                    </div>
                    <div class="modal-body">
                       <form class="form-horizontal">
                           <div class="form-group">
                               <label class="col-sm-3 control-label">模版名称：</label>
                               <div class="col-sm-9">
                                   <input type="text" class="form-control" id="templateName_locate">
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">扫描部位：</label>
                               <div class="col-sm-9">
                                   <select multiple class="form-control" size="1" id="scanpart">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">扫描方式：</label>
                               <div class="col-sm-9">
                                   <select class="form-control" id="scanmethod">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">上界：</label>
                               <div class="col-sm-9">
                                   <input type="text" class="form-control" id="up">
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">下界：</label>
                               <div class="col-sm-9">
                                   <input type="text" class="form-control" id="down">
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">是否增强：</label>
                               <div class="col-sm-2">
                                   <input id="yes" type="radio" name="add" onclick="forchange()" value="1"/>
                                   是
                                   <input id="No" type="radio" name="add" onclick="forchange()" value="0"  checked="true" />
                                   否
                               </div>
                               <label class="control-label col-sm-3">增强方式：</label>
                               <div class="col-sm-4">
                                   <select id="addmethod" name="addmethod" class="form-control" disabled></select>
                              </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">特殊要求：</label>
                               <div class="col-sm-9">
                                   <select class="form-control" id="special_locate">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-3 control-label">备注</label>
                               <div class="col-sm-9">
                                   <textarea class="form-control" rows="5" id="remark_locate"></textarea>
                               </div>
                           </div>
                       </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" id="sureAddLocate">确定</button>
                        <button type="button" class="btn btn-danger" id="sureDeleteLocate">删除</button>
                    </div>
                </div>
            </div>
        </div>
        <%-- 计划申请modal --%>
        <div class="modal fade" id="add_design" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
            <div class="modal-dialog modal-lg" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">计划申请</h4>
                    </div>
                    <div class="modal-body">
                       <form class="form-horizontal" id="design_form">
                           <input type="hidden"  id="aa" name="aa"/>
                            <input type="hidden"  id="bb" name="bb" />
                           <input type="hidden" id="updateID" name="updateID" />
                           <div class="form-group">
                               <label class="col-sm-2 control-label">模版名称：</label>
                               <div class="col-sm-10">
                                   <input type="text" class="form-control" id="templateName_design" name="templateName_design">
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-2 control-label">特殊情况(放疗史)：</label>
                               <div class="col-sm-10">
                                   <textarea class="form-control" rows="5" id="Remarks_design" name="Remarks_design"></textarea>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-2 control-label">靶区处方剂量：</label>
                                   <div class="col-sm-10 table-responsive" >
                                       <table id="Priority" class="table table-bordered">
                                           <thead>
                                               <tr>
                                                   <th>靶区</th>
                                                   <th>外放/mm</th>
                                                   <th>PTV</th>
                                                   <th>单次量cGy</th>
                                                   <th>次数</th>
                                                   <th>总剂量cGy</th>
                                                   <th>体积/%</th>
                                                   <th>优先级</th>
                                                   <th style="text-align: center;">
                                                       <a href="javascript:addDosagePriority();"><i class="fa fa-fw fa-plus-circle" style="font-size: 18px;"></i></a>
                                                   </th>
                                               </tr>
                                           </thead>
                                           <tbody style="text-align: center;">
                                               <tr>
                                                   <td style="padding: 0px;">
                                                       <input id="Prioritytype0" name="Prioritytype0" type="text" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Priorityout0" name="Priorityout0" type="text" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Prioritptv0" name="Prioritptv0" type="text" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Prioritcgy0" name="Prioritcgy0" type="number" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Priorittime0" name="Priorittime0" type="number" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Prioritsum0" name="Prioritsum0" type="number" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Prioritremark0" name="Prioritremark0" type="text" class="td-input"/>
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="Priorit0" name="Priorit0" type="number" class="td-input"/>
                                                   </td>
                                                   <td id="delete0" style="text-align: center; padding: 0px; vertical-align: middle;">
                                                       <a href="javascript:deleteDosagePriority(0);"><i class="fa fa-fw fa-minus-circle" style="font-size: 18px;"></i></a>
                                                   </td>
                                               </tr>
                                           </tbody>
                                       </table>
                                   </div>
                               </div>
                           <div class="form-group">
                               <label class="col-sm-2 control-label">危及器官限量：</label>
                                   <div class="col-sm-10 table-responsive" >
                                       <table id="Dosage" class="table table-bordered">
                                           <thead>
                                               <tr>
                                                   <th>危及器官</th>
                                                   <th>剂量cGy</th>
                                                   <th>限制</th>
                                                   <th>体积/%</th>
                                                   <th>外放mm</th>
                                                   <th>PRV</th>
                                                   <th>剂量cGy</th>
                                                   <th>限制</th>
                                                   <th>体积/%</th>
                                                   <th>优先级</th>
                                                   <th style="text-align: center;">
                                                       <a href="javascript:addDosage();"><i class="fa fa-fw fa-plus-circle" style="font-size: 18px;"></i></a>
                                                   </th>
                                               </tr>
                                           </thead>
                                           <tbody style="text-align: center;">
                                               <tr>
                                                   <td style="padding: 0px;">
                                                       <input id="type0" name="type0" type="text" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="dv0" name="dv0" type="text" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input type="text" class="td-input" value="<" readonly="true" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="number0" name="number0" type="number" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="out0" name="out0" type="text" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="prv0" name="prv0" type="text" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="num0" name="num0" type="text" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input type="text" class="td-input" value="<" readonly="true" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="numbers0" name="numbers0" type="number" class="td-input" />
                                                   </td>
                                                   <td style="padding: 0px;">
                                                       <input id="pp0" name="pp0" type="number" class="td-input" />
                                                   </td>
                                                   <td id="deletes0" style="text-align: center; padding: 0px; vertical-align: middle;">
                                                       <a href="javascript:deleteDosage(0);"><i class="fa fa-fw fa-minus-circle" style="font-size: 18px;"></i></a>
                                                   </td>
                                               </tr>
                                           </tbody>
                                       </table>
                                   </div>
                               </div>
                           <div class="form-group">
                               <label class="col-sm-2 control-label">治疗技术：</label>
                               <div class="col-sm-10">
                                   <select class="form-control" id="technology_design" name="technology_design">

                                   </select>
                               </div>
                           </div>
                           <div class="form-group">
                               <label class="col-sm-2 control-label">放疗设备：</label>
                               <div class="col-sm-10">
                                   <select class="form-control" id="equipment_design" name="equipment_design">

                                   </select>
                               </div>
                           </div>
                       </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary" id="sureAddDesign">确定</button>
                        <button type="button" class="btn btn-danger" id="sureDeleteDesign">删除</button>
                    </div>
                </div>
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
    <script src="../../plugin/multiselect/bootstrap-multiselect.js"></script>
<script src="../../js/Root/Root-PublicTemplate.js"></script>
</body>
</html>
