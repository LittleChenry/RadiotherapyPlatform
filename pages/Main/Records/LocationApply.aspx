<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LocationApply.aspx.cs" Inherits="pages_Main_Records_Location" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <!-- css -->
    <link rel="stylesheet" href="../../../css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datepicker/datepicker3.css"/>
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
            <div class="paper-title">
                模拟定位申请
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
                    <div class="item col-xs-4">患病部位：<span id="part" class="underline"></span></div>
                    <div class="item col-xs-4">所属医生：<span id="diaguser" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>填写申请信息：</span>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">扫描部位：</span>
                        <select id="scanpart" name="scanpart" class="form-item"></select>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">扫描方式：</span>
                        <select id="scanmethod" name="scanmethod" class="form-item"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">上界：</span>
                        <input id="up" name="up" type="text" class="form-item" />
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">下界：</span>
                        <input id="down" name="down" type="text" class="form-item" />
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">是否增强：</span>
                        <span>
                            <input  id="yes" type="radio" name="add" checked="true" style="width:20pt" onclick="forchange()" value="1"/>
                            是
                            <input id="No" type="radio" name="add"  style="width:20pt" onclick="forchange()" value="0"/>
                            否
                        </span>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">增强方式：</span>
                        <select id="addmethod" name="addmethod" class="form-item"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">特殊要求：</span>
                        <select id="special" name="special" class="form-item"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-8">
                        <span class="form-text col-xs-3" style="padding-left:0px;">设备与时间：</span>
                        <input id="appointtime" name="appoint" type="text" readonly="true" class="form-item"  />
                        <input id="idforappoint"  value="0" type="hidden" />
                        <input id="chooseappoint" type="button" class="btn btn-default" value="预约"  data-toggle="modal" data-target="#appoint" />
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        备注：
                        <textarea id="remark" class="form-area"></textarea>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">日期：<span  id="time" class="underline"></span></div>
                </div>
            </div>
        </div>
         <div class="modal fade" id="appoint" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="width:600px;margin:150px auto auto auto;">
                    <div class="panel panel-default" style="max-width:1000px;margin:auto;">
                        <div class="panel-heading">
                            <h4 class="modal-title">预约设备与时间窗口</h4>
                        </div>
                        <div class="panel-body">
                            <div class="panel-row">
                                <div class="item col-xs-5">选择设备：<select id="equipmentName" class="form-item"></select></div>
                                <div class="item col-xs-5">预约时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                                <div class="col-xs-2">
                                    <button id="chooseProject" class="btn btn-default" data-toggle="modal" data-target="#appoint">查询该项</button>
                                </div>
                            </div>
                            <div class="panel-row">
                                <table id="apptiontTable" class="table table-bordered col-xs-12"></table>
                            </div>
                            <div class="panel-row">
                                <div class="col-xs-6">
                                    <button class="btn btn-default" id="cannel" type="button" data-dismiss="modal" aria-label="Close" >取消</button>
                                </div>
                                <div class="col-xs-6">
                                    <button class="btn btn-default" id="sure" type="button" data-dismiss="modal">确定</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
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
     <script src="../../../js/Main/LocationApply.js" type="text/javascript"></script>
     <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>
