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
        <div class="ap-function">
            <div class="info-area col-xs-6">
                <div class="col-xs-4">
                    <span>分割方式：</span>
                    <span>每天一次</span>
                </div>
                <div class="col-xs-4">
                    <span>起止时间：</span>
                    <span>11/11 - 11/19</span>
                </div>
                <div class="col-xs-4">
                    <span>已约次数/总次数：</span>
                    <span>20/25</span>
                </div>
            </div>
            <div class="option-area col-xs-6">
                <div class="col-xs-8">
                    <span>避让方式：</span>
                    <select class="form-item">
                        <option value="1">不避让</option>
                        <option value="2">局部避让</option>
                        <option value="3">无条件避让</option>
                    </select>
                </div>
                <div class="pull-right">
                    <button type="button" class="time-btn">清空预约</button>
                    <button type="button" class="time-btn">确认返回</button>
                </div>
            </div>
        </div>
        <div class="ap-data">
            <div class="btn-area">
                <div id="chooseTime" class="col-xs-2">
                    <button type="button" class="time-btn selected-btn">上午</button>
                    <button type="button" class="time-btn">下午</button>
                    <button type="button" class="time-btn">晚上</button>
                </div>
                <div id="chooseWeek" class="col-xs-8">
                    <button type="button" class="time-btn selected-btn">11/11-11/17</button>
                    <button type="button" class="time-btn">11/18-11/24</button>
                </div>
                <div class="col-xs-2">
                    <button type="button" class="time-btn pull-right">调整</button>
                </div>
            </div>
            <div>
                <div class="col-xs-2">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>时间\日期</th>
                            </tr>
                        </thead>
                        <tr class="morning">
                            <td>6:00-6:10</td>
                        </tr>
                        <tr class="afternoon">
                            <td>14:10-14:20</td>
                        </tr>
                        <tr class="evening">
                            <td>20:10-20:20</td>
                        </tr>
                    </table>
                </div>
                <div id="WeekArea" class="col-xs-10">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>11/11</th>
                                <th>11/12</th>
                                <th>11/13</th>
                                <th>11/14</th>
                                <th>11/15</th>
                                <th>11/16</th>
                                <th>11/17</th>
                            </tr>
                        </thead>
                        <tr class="morning">
                            <td>首次</td>
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                            <td>已预约</td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr class="afternoon">
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                            <td></td>
                            <td>已预约</td>
                        </tr>
                        <tr class="evening">
                            <td>已预约</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                        </tr>
                    </table>
                    <table class="table table-bordered hide-table">
                        <thead>
                            <tr>
                                <th>11/18</th>
                                <th>11/19</th>
                                <th>11/20</th>
                                <th>11/21</th>
                                <th>11/22</th>
                                <th>11/23</th>
                                <th>11/24</th>
                            </tr>
                        </thead>
                        <tr class="morning">
                            <td>首次</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                            <td></td>
                            <td>已预约</td>
                        </tr>
                        <tr class="afternoon">
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                            <td></td>
                            <td>已预约</td>
                            <td></td>
                            <td></td>
                        </tr>
                        <tr class="evening">
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                            <td></td>
                            <td></td>
                            <td></td>
                            <td>已预约</td>
                        </tr>
                    </table>
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

    <script src="../../../js/Main/Appointment.js"></script>
</body>
</html>