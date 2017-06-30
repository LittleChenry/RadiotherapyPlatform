<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixedApply.aspx.cs" Inherits="pages_Main_Records_Fixed" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>体位固定申请</title>
    <!-- css -->
    <link rel="stylesheet" href="../../../css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datepicker/datepicker3.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>
</head>
<body style="width:auto;min-width:900px;margin:auto;">
    <section class="content">
        <div class="paper">
            <input type="hidden" id="progress" />
            <input type="hidden" id="idforappoint" />
            <div class="paper-title">
                体位固定申请
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>基本信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">姓名：<span id="username" class="underline"></span></div>
                    <div class="item col-xs-4">性别：<span id="sex" class="underline"></span></div>
                    <div class="item col-xs-4">年龄：<span id="age" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">民族：<span id="nation" class="underline"></span></div>
                    <div class="item col-xs-4">身份证号：<span id="idnumber" class="underline"></span></div>
                    <div class="item col-xs-4">地址：<span id="address" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">联系方式1：<span id="contact" class="underline"></span></div>
                    <div class="item col-xs-4">联系方式2：<span id="contact2" class="underline"></span></div>
                    <div class="item col-xs-4">分中心医院：<span id="hospital" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>病案信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">疗程号：<span id="treatID" class="underline"></span></div>
                    <div class="item col-xs-4">患病部位：<select id="part" name="part" class="form-item"></select></div>
                    <div class="item col-xs-4">所属医生：<span id="diaguser" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>填写申请信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">
                        模具：
                        <select id="modelselect" name="modelselect" class="form-item"></select>
                    </div>
                    <div class="item col-xs-4">
                        固定装置：
                        <select id="fixEquip" name="fixEquip" class="form-item"></select>
                    </div>
                    <div class="item col-xs-4">
                        特殊要求：
                        <select id="specialrequest" name="specialrequest" class="form-item"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">
                        体位：
                        <select id="bodyPost" name="bodyPost" class="form-item">
                            <option value="allItem">----选择体位-----</option>
                            <option value="仰卧">仰卧</option>
                            <option value="俯卧">俯卧</option>
                            <option value="侧卧">侧卧</option>
                        </select>
                    </div>
                    <div class="item col-xs-8">
                        设备与时间：
                        <input id="appointtime"  name="appointtime" type="text" class="form-item" />
                        <button id="chooseappoint" class="btn btn-default" data-toggle="modal" data-target="#appoint">预约</button>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">申请时间：<span id="time" class="underline"></span></div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="appoint" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top:100px;">  
            <div class="panel panel-default" style="max-width:1000px;margin:auto;">
                <div class="panel-heading" style="text-align:center">
                    预约设备与时间窗口         
                </div>
                <div class="panel-body">
                    <table class="table table-striped table-bordered table-hover" style="float:left;border: solid thin;width:38%;">
                        <tr style="height:30px;text-align:center">
                            <td style="width:45%;">选择设备:</td>
                            <td>
                                <select style="width:150px;height:40px" id="equipmentName">
                                </select>
                            </td>
                        </tr>
                        <tr style="height:30px;text-align:center">
                            <td style="width:45%">预约时间:</td>
                            <td>
                                <input id="AppiontDate" style="width:150px;height:40px" placeholder="请输入时间" />
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-align:center">
                                <input type="button" class="btn btn-default" id="chooseProject" value="查询该项" />
                                <input class="btn btn-default" style="margin-left:40px;" id="cannel" type="button" value="取消" data-dismiss="modal" aria-label="Close" />
                                <input class="btn btn-default" id="sure" type="button" value="确定" data-dismiss="modal" />
                            </td>
                        </tr>
                    </table>
                    <table class="table table-striped table-bordered table-hover" style="margin-top:0px;width:60%;float:right" id="apptiontTable">
                    </table>
                </div>
            </div>
        </div>
        <div id="" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Modal title</h4>
                    </div>
                    <div class="modal-body">
                        <p>One fine body&hellip;</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Save changes</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->
    </section>
    <!-- jQuery 2.2.3 -->
    <script src="../../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="../../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
    <!-- DataTables -->
    <script src="../../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
    <script src="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.min.js"></script>
    <!-- bootstrap datepicker -->
    <script src="../../../plugin/AdminLTE/plugins/datepicker/bootstrap-datepicker.js"></script>
    <!-- SlimScroll -->
    <script src="../../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <!-- FastClick -->
    <script src="../../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../plugin/AdminLTE/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../../../plugin/AdminLTE/dist/js/demo.js"></script>
    <!-- javascript -->
    <script src="../../../js/Main/fixApply.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>