<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EquipmentInspectionManage.aspx.cs" Inherits="pages_Root_EquipmentInspectionManage" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
<body>
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
                <div class="col-md-3 toCenter">
                        <select id="cycle" class="form-control">
                            <option value="">请选择检查周期</option>
                            <option value="day">日检</option>
                            <option value="month">月检</option>
                            <option value="year">年检</option>
                        </select>
                </div>
                <div class="col-md-3 toCenter">
                    <div class="col-xs-8">
                        <select id="model" class="form-control">
                            <option value="">请选择模板</option>
                            <option value="add">新增模板</option>
                        </select>
                    </div>
                </div>
                <div class="col-md-3 toCenter">
                    <input type="button" value="确定" id="sure" class="btn btn-primary btn-sm" />
                </div>
            </div>
            <div class="col-md-12 todown minw">
                <div class="panel panel-default minw">
                    <div class="panel-heading">
                        <span id="cycleTitle">&nbsp;</span>
                        <input type="button" value="修改" id="changeTable" class="floatRight btn btn-info btn-sm clearTBPadding tohidden" />
                        <input type="button" value="新增" id="addItem" class="floatRight btn btn-info btn-sm clearTBPadding tohidden" />
                        <input type="button" value="结束修改" id="cannel" class="floatRight btn btn-info btn-sm clearTBPadding" />
                        <input type="button" value="删除模板" id="deleteModel" class="floatRight btn btn-info btn-sm clearTBPadding tohidden" />
                    </div>
                    <div id="tableArea" class="panel-body">
                        <table class="table table-striped table-hover">

                        </table>
                    </div>
                </div>
            </div>
            <div class="col-md-12" id="middleArea"></div>
            <div class="col-md-12" id="topArea">
                <form id="addItemFrm" method="post">
                    <label id="error" class="error" style="display:none;"></label>
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
                                    <th class="noborder"><label for="roleDescription" class="height">调强检查</label></th>
                                    <td>
                                        <select id="Unit" class="form-control">
                                            <option value="NA">NA</option>
                                            <option value="IsOK">功能正常</option>
                                            <option value="write" selected="true">填写</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">说明</label></th>
                                    <td>
                                        <textarea id="explain" style="resize: vertical;" class="form-control controlHeight rightValue"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th class="noborder"><label for="roleDescription" class="height">参考值</label></th>
                                    <td>
                                        <input id="Reference" type="text" class="form-control controlHeight rightValue" placeholder="请输入调强参考值" />
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
        <input type="button" class="tohidden" id="EditGroup" data-toggle="modal" data-target="#editModal" />

        <div class="modal fade" id="editModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" data-dismiss="modal" class="close" aria-hidden="true">×</button>
                        <h4 class="modal-title">修改检查项目</h4>                     
                    </div>
                        <div class="modal-body" data-scrollbar="true" data-height="200" data-scrollcolor="#000" >
                            <table class="mytable table-bordered table-center">
                                <tbody id="editArea">
                                    
                                </tbody>
                            </table>
                        </div>
                        <div class="modal-footer">
                            <button id="cannelEdit" type="button" data-dismiss="modal" class="btn btn-default">取消</button>
                            <input id="deleteGroup" class="btn btn-danger" type="button" value="删除该项" />
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
<!-- createtable -->
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
<script src="../../js/Root/RootMainJS.js"></script>
<!-- Main JavaScript -->
<script src="../../js/Root/EquipmentInspectionsJS.js"></script>
</body>
</html>
