<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Root-Group.aspx.cs" Inherits="roles_Root_Root_Group" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta charset="utf-8"/>
    <meta http-equiv="X-UA-Compatible" content="IE=edge"/>
    <meta name="viewport" content="width=device-width, initial-scale=1"/>
    <meta name="description" content=""/>
    <meta name="author" content=""/>

    <title>医生分组</title>
    <!-- Main CSS -->
    <link href="../../css/Main/main.css" rel="stylesheet" />
    <link href="../../css/Root/Welcome.css" rel="stylesheet" type="text/css" />

    <!-- Bootstrap Core CSS -->
    <link href="../../plugin/bootstrap/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <!-- MetisMenu CSS -->
    <link href="../../plugin/bootstrap/vendor/metisMenu/metisMenu.min.css" rel="stylesheet" />
    <!-- Custom CSS -->
    <link href="../../plugin/bootstrap/dist/css/sb-admin-2.css" rel="stylesheet" />
    <!-- Morris Charts CSS -->
    <link href="../../plugin/bootstrap/vendor/morrisjs/morris.css" rel="stylesheet" />
    <!-- Custom Fonts -->
    <link href="../../plugin/bootstrap/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <div id="page-wrapper" style="border:0px;margin:0px; min-height: 923px;background:#f8f8f8;">
        <div class="row">
            <div class="col-xs-12">
                <h1 class="page-header">医生分组管理</h1>
            </div>
        </div>
        <div class="row">
            <div class="col-md-12">
                <div class="col-md-3">&nbsp;</div>
                <div class="col-md-4">
                    <div class="form-group input-group">
                        <input type="text" id="GroupSearchID" class="form-control" value="" placeholder="请输入组ID或者姓名"/>
                        <span class="input-group-btn">
                            <button class="btn btn-default" style="height:34px" type="button" id="search">
                                <i class="fa fa-search"></i>
                            </button>
                        </span>
                    </div>
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
                        
                    </div>
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
                                <tbody>
                                    <tr>
                                        <th>组长</th>
                                        <td>
                                            <select id="charger" class="form-control" style="margin-right:0.8em">
                                                <option value="">--请选择组长--</option>
                                            </select>
                                            <input type="hidden" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2">
                                            <a id="addNewMember" href="#">添加成员</a>
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
                        <h4 class="modal-title">修改分组</h4>                     
                    </div>
                        <div id="editTable" class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000" >
                            
                        </div>
                        <div class="modal-footer">
                            <button id="cannelEdit" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                            <input id="deleteGroup" class="btn btn-danger" type="button" value="删除组" />
                            <input id="sureEdit" type="submit" class="btn btn-primary" value="确认" />
                        </div>
                </div>
                                    <!-- /.modal-content -->
            </div>
                                <!-- /.modal-dialog -->
        </div>
    </div>
    <script src="../../plugin/bootstrap/vendor/jquery/jquery.min.js"></script>
    <script src="../../plugin/bootstrap/assets/js/bootstrap.min.js"></script>
    <script src="../../js/Root/GroupJS.js"></script>
</body>
</html>
