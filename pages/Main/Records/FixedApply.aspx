<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixedApply.aspx.cs" Inherits="pages_Main_Records_Fixed" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>体位固定申请</title>
    <!-- css -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
    <!-- Ionicons -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>
</head>
<body style="width:auto;min-width:900px;margin:auto;">
    <section class="content">
        <div class="paper" id="needPrint">
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
                   <div class="item col-xs-4">放疗号：<span id="radiotherapy" class="underline"></span></div>
                   <div class="item col-xs-4">疗程：<span id="treatID" class="underline"></span></div>
                   <div class="item col-xs-4">主管医生：<span id="Reguser" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">诊断结果：<span id="diagnosisresult"  class="underline"></span></div>
                </div>
            </div>   
            <div class="paper-content">
                <div class="content-title">
                    <span>填写申请信息：</span>
                </div>
                <div class="single-row tab-row">
                    <ul id="tabs" class="nav nav-tabs">
                        <li class="active"><a id="current-tab" href="#tab" data-toggle="tab" aria-expanded="true"></a></li>
                    </ul>
                </div>
                <div id="tab-content" class="tab-content">
                <div class="tab-pane active" id="tab">
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">模具：</span>
                        <select id="modelselect" name="modelselect" class="form-item" disabled="disabled"></select>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">固定装置：</span>
                        <select id="fixEquip" name="fixEquip" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">体位：</span>
                        <select id="bodyPost" name="bodyPost" class="form-item" disabled="disabled">
                            <option value="allItem">----选择体位-----</option>
                            <option value="仰卧">仰卧</option>
                            <option value="俯卧">俯卧</option>
                            <option value="侧卧">侧卧</option>
                        </select>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">特殊要求：</span>
                        <select id="specialrequest" name="specialrequest" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-8">
                        <span class="form-text col-xs-3" style="padding-left:0px;">设备与时间：</span>
                        <input id="appointtime"  name="appointtime" type="text" class="form-item" readonly="true"  disabled="disabled"/>
                        <button id="chooseappoint" class="btn btn-default" data-toggle="modal" data-target="#appoint" disabled="disabled">预约</button>
                    </div>
                </div>
               <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;">备注：</span>
                        <textarea id="Remarks" name="Remarks" class="form-area col-xs-10" disabled="disabled"></textarea>
                    </div>                                                                 
               </div>
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
        <div id="appoint" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:700px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">预约设备与时间窗口</h4>
                    </div>
                    <div class="modal-body" style="overflow:hidden;">
                        <div class="panel-row">
                            <div class="item col-xs-5">选择设备：<select id="equipmentName" class="form-item"></select></div>
                            <div class="item col-xs-5">预约时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                            <div class="col-xs-2">
                                <button id="chooseProject" class="btn btn-default">查询该项</button>
                            </div>
                        </div>
                        <div class="panel-row">
                            <table id="apptiontTable" class="table table-bordered col-xs-12" style="table-layout:fixed;word-wrap:break-word;"></table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" id="cannel" type="button" data-dismiss="modal">取消</button>
                        <button class="btn btn-primary" id="sure" type="button" data-dismiss="modal">确定</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->
    </section>
     <section id="printArea" class="content" style="display:none;width:756px;height:1086px;border:0px;">
                
    </section>
    <!-- jQuery 2.2.3 -->
    <script src="../../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
    <!-- jQuery UI 1.11.4 -->
    <script src="../../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
    <!-- DataTables -->
    <script src="../../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
    <!-- JQuery PrintArea -->
<script src="../../../plugin/AdminLTE/jquery.PrintArea.js"></script>

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
        <script src="../../../js/Main/FixedRecordPrint.js"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>