<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TreatmentRecord.aspx.cs" Inherits="pages_Main_Records_TreatmentRecord" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>放射治疗记录</title>
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
            <form id="savedesign" name="savedesign" method="post" runat="server" >
                    <input type="hidden" name="ispostback" value="true" />             
                    <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                    <input type="hidden"  id="userID" name="userID" />
                    <input type="hidden" id="diaguserid" name="diaguserid" />
                    <input type="hidden"  id="aa" name="aa" />
                    <input type="hidden"  id="bb" name="bb" />              
            <input type="hidden" id="progress" name="progress"/>
            <div class="paper-title">
                 放射治疗记录
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
                    <div class="item col-xs-4">所属医生：<span id="Reguser" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>填写放射治疗记录：</span>
                </div>
                <div class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-4">IGRT记录：</span>
                        <button type="button" class="btn btn-success" >编辑</button>
                        <button type="button" class="btn btn-info" >完成</button>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <table class="table table-bordered" style="table-layout:fixed;word-wrap:break-word;">
                            <thead>
                                <tr>
                                    <th>次数</th>
                                    <th>方向</th>
                                    <th>要求(cm)</th>
                                    <th>实际(cm)</th>
                                    <th>移床(cm)</th>
                                    <th>
                                        <a href="javascript:;"><i class="fa fa-fw fa-plus-circle" style="font-size:18px;"></i></a>
                                    </th>
                                </tr>
                            </thead>
                            <tbody style="text-align:center;">
                                <tr>
                                    <td rowspan="3">1</td>
                                    <td>x</td>
                                    <td>5</td>
                                    <td style="padding:0px;">
                                        <input id="" name="" type="number" class="td-input" />
                                    </td>
                                    <td>auto</td>
                                    <td rowspan="3">
                                        <a  href="javascript:;"><i class="fa fa-fw fa-minus-circle" style="font-size:18px;"></i></a>
                                    </td>
                                </tr>
                                <tr>
                                    <td>y</td>
                                    <td>4</td>
                                    <td style="padding:0px;">
                                        <input id="Number1" name="" type="number" class="td-input" />
                                    </td>
                                    <td>auto</td>
                                </tr>
                                <tr>
                                    <td>z</td>
                                    <td>5</td>
                                    <td style="padding:0px;">
                                        <input id="Number2" name="" type="number" class="td-input" />
                                    </td>
                                    <td>auto</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-4">放射治疗记录：</span>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <table id="" class="table table-bordered" style="table-layout:fixed;word-wrap:break-word;">
                            <thead>
                                <tr>
                                    <th>日期</th>
                                    <th>放疗天数</th>
                                    <th>放疗次数</th>
                                    <th>射野数(V)</th>
                                    <th>机器跳数</th>
                                    <th>单次量(cGy)</th>
                                    <th>累计剂量(cGy)</th>
                                    <th>IGRT次数</th>
                                    <th>RL(cm)</th>
                                    <th>AP(cm)</th>
                                    <th>SI(cm)</th>
                                    <th>主操作</th>
                                    <th>副操作</th>
                                    <th>周剂量核对</th>
                                </tr>
                            </thead>
                            <tbody style="text-align:center;">
                                <tr>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td style="padding:0px;">
                                        <input id="Number3" name="" type="number" class="td-input" />
                                    </td>
                                    <td style="padding:0px;">
                                        <input id="Number4" name="" type="number" class="td-input" />
                                    </td>
                                    <td style="padding:0px;">
                                        <input id="Number5" name="" type="number" class="td-input" />
                                    </td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td>auto</td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>6-14</td>
                                    <td>23</td>
                                    <td>16</td>
                                    <td>3</td>
                                    <td>912.6</td>
                                    <td>180</td>
                                    <td>2880</td>
                                    <td>1</td>
                                    <td>2</td>
                                    <td>1</td>
                                    <td>0</td>
                                    <td>王医生</td>
                                    <td>张医生</td>
                                    <td rowspan="4" style="padding:0px;vertical-align:middle;">
                                        <button type="button" class="btn btn-success btn-sm" >确认</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>6-13</td>
                                    <td>22</td>
                                    <td>15</td>
                                    <td>3</td>
                                    <td>912.6</td>
                                    <td>180</td>
                                    <td>2700</td>
                                    <td>1</td>
                                    <td>2</td>
                                    <td>1</td>
                                    <td>0</td>
                                    <td>王医生</td>
                                    <td>张医生</td>
                                </tr>
                                <tr>
                                    <td>6-12</td>
                                    <td>21</td>
                                    <td>14</td>
                                    <td>3</td>
                                    <td>912.6</td>
                                    <td>180</td>
                                    <td>2520</td>
                                    <td>1</td>
                                    <td>2</td>
                                    <td>1</td>
                                    <td>0</td>
                                    <td>王医生</td>
                                    <td>张医生</td>
                                </tr>
                                <tr>
                                    <td>6-11</td>
                                    <td>20</td>
                                    <td>13</td>
                                    <td>3</td>
                                    <td>912.6</td>
                                    <td>180</td>
                                    <td>2340</td>
                                    <td>1</td>
                                    <td>2</td>
                                    <td>1</td>
                                    <td>0</td>
                                    <td>王医生</td>
                                    <td>张医生</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">日期：<span  id="time" class="underline"></span></div>
                </div>
            </div>
        </form>
        </div>
       <button type="button" id="showIGRT" class="btn btn-default" data-toggle="modal" data-target="#myModal" style="display:none;">Show</button>
        <div id="myModal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">IGRT记录</h4>
                    </div>
                    <div class="modal-body">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>次数</th>
                                    <th>方向</th>
                                    <th>要求</th>
                                    <th>实际</th>
                                    <th>移床</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td rowspan="3">1</td>
                                    <td>x</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>y</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr>
                                    <td>z</td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                        <button type="button" class="btn btn-primary">确定</button>
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
    <script src="../../../js/Main/DesignApply.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>