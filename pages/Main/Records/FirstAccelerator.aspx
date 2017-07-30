<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FirstAccelerator.aspx.cs" Inherits="pages_Main_Records_FirstAccelerator" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>加速器治疗管理</title>
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
            <input type="hidden" id="idforappoint" value="0"/>
            <div class="paper-title">
                加速器治疗管理
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
                      <div class="item col-xs-4">照射部位：<span id="lightpart" class="underline"></span></div>
                        <div class="item col-xs-4">住院情况：<span id="hospitalid" class="underline"></span></div> 
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
                    <span>加速器治疗管理：</span>
                </div>
                <div class="single-row">
                    <div class="col-xs-10">
                        <span class="form-text" style="padding-left:0px;">首次加速器治疗预约：</span>
                        <input id="appointtime"  name="appointtime" type="text" class="form-item" readonly="true" />
                        <button id="chooseappoint" class="btn btn-default" disabled="disabled" data-toggle="modal" data-target="#appoint">预约</button>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-8">
                        <span class="form-text col-xs-3" style="padding-left:0px;">治疗总次数：</span>
                        <input id="totalnumber"  name="totalnumber" disabled="disabled"    type="number" class="form-item" style="width:20%;"/>
                        <button id="changetotalnumber" type="button" class="btn btn-success"  disabled="disabled">更改</button>
                        <button id="finish" type="button" class="btn btn-warning" disabled="disabled">结束治疗</button>
                         <input id="finishthistreat" value="0" type="hidden" name="finishthistreat" class="form-item" />
                    </div>
                     <div class="col-xs-4">
                        <span class="form-text" style="padding-left:0px;">已治疗次数：</span>
                        <span id="finishedtimes" class="underline"></span>
                    </div>
                </div>
                 <div id="logholder" class="single-row">
                      <div class="col-xs-8">
                           <span class="form-text" style="padding-left:0px;">修改日志：</span>
                           <table  class="table table-bordered">
                               <thead>
                               <tr>
                                  <th>修改天数</th>
                                  <th>修改时间</th>
                                   <th>修改人</th>
                               </tr>
                                 </thead>
                               <tbody id="log">
                               </tbody>
                           </table>
                          </div>
                     </div>
               <div class="single-row">
                    <div class="col-xs-8">
                        <span class="form-text col-xs-3" style="padding-left:0px;">分割方式：</span>
                           <select  id="splitway" disabled="disabled" class="col-xs-3 form-item" name="splitway">
                           </select>
                    </div>
               </div>
              <div class="single-row">
                    <div class="item area-group col-xs-12">
                      <span class="col-xs-2" style="padding-left:0px;">特殊医嘱：</span>
                          <textarea id="remarks" name="remarks" class="form-area col-xs-10" disabled="disabled"></textarea>
                          </div>                                                                 
                      </div>
            </div>
             <div class="paper-content">
                <div class="content-title">
                    <span>放射治疗知情同意：</span>
                </div>
                <div class="single-row">
                    <span class="col-xs-12">上述为放射治疗信息，已告知本人和/或家属。</span>
                </div>
                <div class="single-row">
                    <span class="col-xs-12">受检者或家属签名：</span>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="operator" class="underline"></span></div>
                    <div class="item col-xs-6">预约时间：<span id="date" class="underline"></span></div>
                </div>
            </div>
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
    <script src="../../../js/Main/addimgs.js"></script> 
    <script src="../../../js/Main/FirstAccelerator.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>                                        
</body>
</html>
