<%@ Page Language="C#" AutoEventWireup="true" CodeFile="userTest.aspx.cs" Inherits="pages_Root_userTest" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
<body>
    <section class="content">
        <input id="type" type="hidden" value="Root" />
        <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">用户信息</h1>
            </div>
        </div>
        <div class="col-xs-12 search">
                        <div class="col-xs-4">
                            <select id="role" name="roles" class="form-control" style="width:60%">
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
                        <span class="panel-title">分组表</span>
                        <input type="button" class="btn btn-primary btn-sm buttonToLeft floatRight" id="newGroup" data-toggle="modal" data-target="#myModal" value="新增" style="padding: 2.5px 10px;" />
                        <input type="button" class="btn btn-primary btn-sm floatRight" id="changeGroup" value="编辑" style="padding: 2.5px 10px;" />
                        <input type="button" class="btn btn-primary btn-sm floatRight" id="closeEdite" value="结束编辑" style="padding: 2.5px 10px;display:none" />
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
                        <h4 class="modal-title" id="myModalLabel">新增分组</h4>
                        
                    </div>
                        <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000" >
                            <label id="error" class="tohidden"></label>
                            <table id="addGroup" class="mytable table-bordered table-center">
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
                                                    <h4 class="panel-title">选择角色</h4>
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
                            <table class="mytable table-bordered table-center">
                                <tbody id="editArea">
                                    
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button id="cannelEdit" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                            <input id="deleteGroup" class="btn btn-danger" type="button" value="删除用户" />
                            <input id="sureEdit" type="submit" class="btn btn-primary" value="确认" />
                        </div>
                </div>
                                    <!-- /.modal-content -->
            </div>
                                <!-- /.modal-dialog -->
        </div>
        
    </section>

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
<!-- Main js-->
<script src="../../js/Root/userManageJS.js"></script>
<script src="../../js/Root/chooseAll.js" type="text/javascript"></script>
</body>
</html>
