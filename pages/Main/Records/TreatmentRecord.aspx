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
                        <div class="item col-xs-4">放疗号：<span id="radiotherapy" class="underline"></span></div>
                        <div class="item col-xs-4">病案号：<span id="RecordNumber"  class="underline"></span></div>
                        <div class="item col-xs-4">住院号：<span id="hospitalid" class="underline"></span></div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-4">疗程：<span id="treatID" class="underline"></span></div>
                        <div class="item col-xs-4">诊断结果：<span id="diagnosisresult"  class="underline"></span></div>
                        <div class="item col-xs-4">所属医生：<span id="Reguser" class="underline"></span></div>
                    </div>
            </div>
             <div class="paper-content">
                  <div class="content-title">
                    <span>计划详细信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;">特殊情况(放疗史)：</span>
                        <span id="Remarks" class="col-xs-10"></span>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-4">靶区处方剂量：</span>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <table id="Priority" class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>靶区</th>
                                    <th>外放/mm</th>
                                    <th>PTV</th>
                                    <th>单次量cGy</th>
                                    <th>次数</th>
                                    <th>总剂量cGy</th>
                                    <th>体积/%</th>
                                    <th>优先级</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-4">危及器官限量：</span>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <table id="Dosage" class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>危及器官</th>
                                    <th>剂量cGy</th>
                                    <th>限制</th>
                                    <th>体积/%</th>
                                    <th>外放mm</th>
                                    <th>PRV</th>
                                    <th>剂量cGy</th>
                                    <th>限制</th>
                                    <th>体积/%</th>
                                    <th>优先级</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">治疗技术：<span id="technology" class="underline"></span></div>
                    <div class="item col-xs-4">放疗设备：<span id="equipment" class="underline"></span></div>
                    <div class="item col-xs-4">计划系统：<span id="PlanSystem" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">射野数量：<span id="IlluminatedNumber" class="underline"></span></div>
                    <div class="item col-xs-4">非共面照射：<span id="Coplanar" class="underline"></span></div>
                    <div class="item col-xs-4">机器跳数：<span id="MachineNumbe" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">控制点数量：<span id="ControlPoint" class="underline"></span></div>
                    <div class="item col-xs-4">计算网络：<span id="Grid" class="underline"></span></div>
                    <div class="item col-xs-4">优化算法：<span id="Algorithm" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">计划可执行度：<span id="Feasibility" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>填写放射治疗记录与IGRT记录：</span>
                </div>
                <div class="single-row">
                    <div class="col-xs-7">
                     <span class="form-text col-xs-6" style="padding-left:0px;">放疗总次数：
                     <input id="totalnumber" type="number" name="totalnumber" class="form-item" disabled="disabled"/>
                     </span>
                     <span class="form-text col-xs-5" style="padding-left:0px;">
                     <button id="rest" disabled="disabled" type="button" data-toggle="modal" data-target="#appoint" class="btn btn-warning" >剩余加速器预约</button> 
                     </span>
                    </div>
                   <div class="col-xs-5">
                    <span class="form-text col-xs-12" style="padding-left:0px;">是否结束治疗：
                        <input id="finishthistreat" value="0" type="hidden" name="finishthistreat" class="form-item" />
                        <button id="finish" disabled="disabled" type="button" class="btn btn-warning" >结束</button>
                    </span>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12" style="padding-left:40%;">
                        <button id="treatmentedit" disabled="disabled" type="button" class="btn btn-success" >记载放疗记录</button>
                        <button id="finishigrt"  disabled="disabled" type="button" data-toggle="modal" data-target="#igrt" class="btn btn-info" >记载IGRT记录</button>
                    </div>
                </div>
                </div>
            <div class="paper-footer">
           <div class="content-title">
                    <span>放射治疗记录：</span>
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
                                    <th>主操作</th>
                                    <th>副操作</th>
                                    <th>周剂量核对</th>
                                </tr>
                            </thead>
                            <tbody id="treatment" style="text-align:center;"> 
                            </tbody>
                        </table>
                   </div>
                 </div>
                <div class="content-title">
                    <span>IGRT记录：</span>
                </div>
                 <div class="single-row">
                   <div class="item area-group col-xs-12">
                   <table id="" class="table table-bordered" style="table-layout:fixed;word-wrap:break-word;">
                        <thead>
                           <tr>
                                    <th>日期</th>
                                    <th>X(cm)</th>
                                    <th>Y(cm)</th>
                                    <th>Z(cm)</th>
                                    <th>主操作</th>
                                    <th>副操作</th>
                            </tr>
                       </thead>
                            <tbody id="IGRT" style="text-align:center;"> 
                            </tbody>
                  </table>
                       </div>
                     </div>
                    </div>
              </div>
    <div id="operatorModal" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">操作成员验证</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <span>账号：</span>
                        <input type="text" class="form-control" id="OperatorNumber" />
                    </div>
                    <div class="form-group">
                        <span>密码：</span>
                        <input type="text" class="form-control" id="OperatorPassword" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="validate" type="button" class="btn btn-primary"  data-dismiss="modal">验证</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
       <div id="igrt" style="width:80%;margin:auto" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">IGRT记录</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <span>X方向：
                        <input type="number" class="form-control" id="xvalue" />
                        </span>
                    </div>
                    <div class="form-group">
                        <span>y方向：
                        <input type="number" class="form-control" id="yvalue" />
                        </span>
                    </div>
                     <div class="form-group">
                        <span>z方向：
                        <input type="number" class="form-control" id="zvalue" />
                        </span>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="recordigrt" type="button" class="btn btn-primary"  data-dismiss="modal">提交记录</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
       <div class="modal fade" id="appoint" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="width:700px;margin:50px auto;">
            <div class="panel panel-default" style="max-width:1000px;margin:auto;">
                <div class="panel-heading">
                    <h4 class="modal-title">预约设备与时间窗口</h4>
                </div>
                <div class="panel-body">
                    <div class="panel-row">
                        <div class="item col-xs-5">选择设备：<select id="equipmentName" class="form-item"></select></div>
                        <div class="item col-xs-5">预约时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                        <div class="col-xs-2">
                            <button id="chooseProject" class="btn btn-default">查询该项</button>
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
    <script src="../../../js/Main/TreatmentRecord.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>