<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DesignConfirm.aspx.cs" Inherits="pages_Main_Records_DesignConfirm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>治疗计划确认</title>
     <!-- css -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css"/>
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
            <form id="saveDesignConfirm" method="post" runat="server">
                    <input type="hidden" name="ispostback" value="true" />             
                    <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                    <input type="hidden"  id="userID" name="userID" />
                    <input type="hidden" id="diaguserid" name="diaguserid" />
            <input type="hidden" id="progress" />
            <div class="paper-title">
                 治疗计划确认
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
                       <div class="item col-xs-4">主管医师：<span id="Reguser" class="underline"></span></div>
                </div>
                  <div class="single-row">
                        <div class="item col-xs-4">诊断结果：<span id="diagnosisresult"  class="underline"></span></div>
                      <div class="item col-xs-4">照射部位：<span id="lightpart" class="underline"></span></div>
                        <div class="item col-xs-4">住院情况：<span id="hospitalid" class="underline"></span></div> 
                  </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>确认计划信息：</span>
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
                    <div class="item col-xs-4">射线类型：<span id="Raytype" class="underline"></span></div>                   
                    <div class="item col-xs-4">申请医师：<span id="ApplicationUser" class="underline"></span></div>
                    <div class="item col-xs-4">申请时间：<span id="ApplicationTime" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">领取剂量师：<span id="receiveUser" class="underline"></span></div>
                    <div class="item col-xs-4">领取时间：<span id="receiveTime" class="underline"></span></div>
                    <div class="item col-xs-4">提交剂量师：<span id="Submituser" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">提交时间：<span id="Submittime" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="col-xs-5">
                        <span class="form-text col-xs-5" style="padding-left:0px;">审核状态：</span>
                        <input id="state" name="state" type="text" value="未审核" readonly="true" class="form-item"  />
                    </div>
                    <div class="col-xs-3">
                        <button id="unconfirm" class="btn btn-warning" type="button" disabled="disabled">不合格</button>
                        <button id="confirm" class="btn btn-success" type="button" disabled="disabled">确认通过</button>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-8">
                         <span class="form-text col-xs-3" style="padding-left:0px;">审核意见：</span>
                        <textarea id="advice" name="advice" class="form-area" style="width:80%;" disabled="disabled"></textarea>
                    </div>
                </div>              
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">物理师签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">确认时间：<span  id="time" class="underline"></span></div>
                </div>
            </div>
                </form>
        </div>
    </section>
      <section id="printArea" class="content" style="display:none;width:756px;height:1086px;border:0px;">
                
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
     <!-- JQuery PrintArea -->
    <script src="../../../plugin/AdminLTE/jquery.PrintArea.js"></script>
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
        <script src="../../../js/Main/FixedRecordPrint.js"></script>
    <!-- javascript -->
     <script src="../../../js/Main/DesignConfirm.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>