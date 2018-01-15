<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DesignSubmit.aspx.cs" Inherits="pages_Main_Records_DesignSubmit" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
    <!-- css -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css">
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
            <form id="saveDesignSubmit" method="post" runat="server">
                <input type="hidden" name="ispostback" value="true" />             
                <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                <input type="hidden"  id="userID" name="userID" />
                <input type="hidden" id="diaguserid" name="diaguserid" />
                 <input type="hidden" id="a1" name="a1" />
                 <input type="hidden" id="a2" name="a2" />
            <input type="hidden" id="progress" />
            <div class="paper-title" >
                 治疗计划提交
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
                    <span>计划信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-12">
                        <span class="col-xs-3" style="padding-left:0px;">特殊情况(放疗史)：</span>
                        <span id="Remarks" class="col-xs-9"></span>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-5">靶区处方剂量：</span>
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
                        <span class="form-text col-xs-5">危及器官限量：</span>
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
                   
                    <div class="item col-xs-6">申请医生：<span id="ApplicationUser" class="underline"></span></div>
                    <div class="item col-xs-6">申请时间：<span id="ApplicationTime" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-6">领取医生：<span id="receiveUser" class="underline"></span></div>
                    <div class="item col-xs-6">领取时间：<span id="receiveTime" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>提交计划信息：</span>
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
                                <span class="form-text col-xs-4" style="padding-left:0px;">计划系统：</span>
                                <select id="PlanSystem" name="PlanSystem" class="form-item" disabled="disabled"></select>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" >放疗设备：</span>
                                <select id="equipment" name="equipment" class="form-item" disabled="disabled"></select>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">射线类型：</span>
                                <select id="Raytype" name="Raytype" class="form-item" disabled="disabled"></select>
                            </div> 
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">治疗技术：</span>
                                <select id="technology" name="technology" class="form-item" disabled="disabled"></select>
                            </div>                          
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">移床参数：</span>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">左：</span>
                                <div class="group-item">
                                    <input id="left" name="left" type="number" class="form-group-input" disabled="disabled"/>
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">右：</span>
                                <div class="group-item">
                                    <input id="right" name="right" type="number" class="form-group-input" disabled="disabled"/>
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">升：</span>
                                <div class="group-item">
                                    <input id="rise" name="rise" type="number" class="form-group-input" disabled="disabled"/>
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">降：</span>
                                <div class="group-item">
                                    <input id="drop" name="drop" type="number" class="form-group-input" disabled="disabled"/>
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">进：</span>
                                <div class="group-item">
                                    <input id="enter" name="enter" type="number" class="form-group-input" disabled="disabled"/>
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">出：</span>
                                <div class="group-item">
                                    <input id="out" name="out" type="number" class="form-group-input" disabled="disabled"/>
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div> 
                
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">提交日期：<span  id="time" class="underline"></span></div>
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
    <script src="../../../js/Main/DesignSubmit.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>