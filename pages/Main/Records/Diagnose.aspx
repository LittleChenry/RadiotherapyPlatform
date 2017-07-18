<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Diagnose.aspx.cs" Inherits="pages_Main_Records_Diagnose" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>病情诊断</title>
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
            <input type="hidden" id="progress" name="progress" />
            <input type="hidden" id="diaguserid" name="diaguserid" />
            <div class="paper-title">
                病情诊断
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>基本信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-3">姓名：<span id="username" class="underline"></span></div>
                    <div class="item col-xs-3">性别：<span id="sex" class="underline"></span></div>
                    <div class="item col-xs-3">年龄：<span id="age" class="underline"></span></div>
                    <div class="item col-xs-3">民族：<span id="nation" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-6">身份证号：<span id="idnumber" class="underline"></span></div>
                    <div class="item col-xs-6">家庭地址：<span id="address" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-6">联系方式1：<span id="contact" class="underline"></span></div>
                    <div class="item col-xs-6">联系方式2：<span id="contact2" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-6">分中心医院：<span id="hospital" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>病案信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">疗程：<span id="treatID" class="underline"></span></div>
                    <div class="item col-xs-4">放疗号：<span id="radiotherapy" class="underline"></span></div>
                    <div class="item col-xs-4">所属医生：<span id="Reguser" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">病案号：<span id="RecordNumber" class="underline"></span></div>
                    <div class="item col-xs-4">住院号：<span id="hospitalid" class="underline"></span></div>                
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>诊断：</span>
                </div>
                <div class="single-row tab-row">
                    <ul id="tabs" class="nav nav-tabs">
                        <li class="active"><a id="current-tab" href="#tab" data-toggle="tab" aria-expanded="true"></a></li>
                    </ul>
                </div>
                <div id="tab-content" class="tab-content">
                    <div class="tab-pane active" id="tab">
                        <div class="single-row">
                            <div class="item col-xs-4">
                                患病部位：
                                <select id="part" name="part" class="form-item" disabled="disabled"></select>
                            </div>
                            <div class="item col-xs-4">
                                诊断结果：
                                <select id="diagresult" name="part" class="form-item" disabled="disabled"></select>
                            </div>                                  

                        </div>
                        <div class="single-row">
                            <div class="item area-group col-xs-12">
                                备注：
                                <textarea id="remark" name="remark" class="form-area" disabled="disabled"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="operator" class="underline"></span></div>
                    <div class="item col-xs-6">日期：<span id="date" class="underline"></span></div>
                     <button type="button" name="test" id="test" style="display:none" class="btn btn-flat"> </button>
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
    <script src="../../../js/Main/Diagnose.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
    </script>
</body>
</html>