<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Appointment.aspx.cs" Inherits="pages_Main_Records_Appointment" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>预约</title>
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
        <div class="ap-title">
            <h3>预约</h3>
        </div>
        <input type="hidden" id="selectedrownum" value="0" />
        <div class="ap-function">
            <div class="info-area col-xs-12">
                <div class="col-xs-3">
                    <span>分割方式：</span>
                    <span id="Ways" class="underline"></span>
                </div>
                <div class="col-xs-3">
                    <span>预约设备：</span>
                    <span id="equipmentname" class="underline"></span>
                </div>
                <div class="col-xs-3">
                    <span>首次时间：</span>
                    <span id="firstdate" class="underline"></span>
                </div>
                <div class="col-xs-3">
                    <span>已约次数/总次数：</span>
                    <span class="underline">
                        <span id="appointnumber"></span>
                        <span>/</span>
                        <span id="total"></span>
                    </span>
                </div>
            </div>
            <div class="option-area col-xs-12">
                <div class="col-xs-4">
                    <span>避让方式：</span>
                    <select id="avoidway" class="form-item">
                        <option value="1">不避让</option>
                        <option value="2">局部避让</option>
                        <option value="3">无条件避让</option>
                    </select>
                </div>
                <div class="col-xs-4 col-xs-offset-4">
                    <button id="confirm" type="button" class="time-btn pull-right" style="margin-left:5px;">确认返回</button>
                    <button id="removeAppointment" type="button" class="time-btn pull-right">清空预约</button>
                </div>
            </div>
        </div>
        <div class="ap-data">
            <div class="btn-area col-xs-12">
                <div id="chooseTime" class="col-xs-2">
                    <button type="button" class="time-btn selected-btn">上午</button>
                    <button type="button" class="time-btn">下午</button>
                    <button type="button" class="time-btn">晚上</button>
                </div>
                <div id="chooseWeek" class="col-xs-8"></div>
                <div id="chooseWay" class="col-xs-2">
                    <button type="button" class="time-btn pull-right" style="margin-left:5px;">自由预约</button>
                    <button type="button" class="time-btn selected-btn pull-right">批量预约</button>
                </div>
            </div>
            <div class="col-xs-12">
                <div id="WeekArea" class="col-xs-12"></div>
            </div>
        </div>
    </section>
    <div id="showinfo" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="info-content">
                <div class="info-close">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><i aria-hidden="true">&times;</i></button>
                </div>
                <div class="info-text">
                    <span></span>
                </div>
            </div>
        </div>
    </div>
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

    <script src="../../../js/Main/chromeWindowShowModalDialog.js"></script>
    <script src="../../../js/Main/Appointment.js"></script>
    
</body>
</html>