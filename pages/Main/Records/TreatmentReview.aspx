<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TreatmentReview.aspx.cs" Inherits="pages_Main_Records_TreatmentReview" %>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>复查管理</title>
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
            <input type="hidden" id="progress" />

            <div class="paper-title">
               治疗复查
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
                    <span>复查申请：</span>
                </div>
                   <div class="single-row">
                    <div class="col-xs-6" style="position:static;">
                        <span class="form-text col-xs-4" style="padding-left:0px;">扫描部位：</span>
                        <input id="scanpart" name="scanpart" class="form-item" disabled="disabled"></input>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">扫描方式：</span>
                        <select id="scanmethod" name="scanmethod" class="form-item" disabled="disabled"></select>
                    </div>
                 </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">上界：</span>
                        <input id="up" name="up" type="text" class="form-item" disabled="disabled"/>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">下界：</span>
                        <input id="down" name="down" type="text" class="form-item" disabled="disabled"/>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">是否增强：</span>
                        <span>
                            <input  id="yes" type="radio" name="add" checked="true" style="width:20pt" onclick="forchange()" value="1" disabled="disabled"/>
                            是
                            <input id="No" type="radio" name="add"  style="width:20pt" onclick="forchange()" value="0" disabled="disabled"/>
                            否
                        </span>
                    </div>
                    <div  id="enhancemethod" class="col-xs-6">
                        <span class="form-text col-xs-4">增强方式：</span>
                        <select id="addmethod" name="addmethod" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">特殊要求：</span>
                        <select id="special" name="special" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-8">
                        <span class="form-text col-xs-3" style="padding-left:0px;">设备与时间：</span>
                        <input id="appointtime" name="appoint" type="text" readonly="true" class="form-item" disabled="disabled" />
                        <input id="idforappoint"  value="0" type="hidden" />
                        <button id="chooseappoint" type="button" class="btn btn-default"   data-toggle="modal" data-target="#appoint" disabled="disabled">预约</button>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                       <span class="col-xs-2" style="padding-left:0px;">备注：</span>
                        <textarea id="remark" class="form-area" disabled="disabled"></textarea>
                    </div>
                </div>
             </div>
  
          <%--  <div class="paper-content"> 
                <div class="content-title">
                    <span>复查填写：</span>
                </div>
               <div class="single-row">
                    <div class="col-xs-6" style="position:static;">
                        <span class="form-text col-xs-4" style="padding-left:0px;">扫描部位：</span>
                        <input id="scanpart1" name="scanpart1" class="form-item" disabled="disabled"></input>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">扫描方式：</span>
                        <select id="scanmethod1" name="scanmethod1" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">上界：</span>
                        <input id="up1" name="up1" type="text" class="form-item" disabled="disabled"/>
                    </div>
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4">下界：</span>
                        <input id="down1" name="down1" type="text" class="form-item" disabled="disabled"/>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">是否增强：</span>
                        <span>
                            <input  id="add1" type="radio" name="add1" checked="true" style="width:20pt" onclick="forchange()" value="1" disabled="disabled"/>
                            是
                            <input id="add2" type="radio" name="add1"  style="width:20pt" onclick="forchange()" value="0" disabled="disabled"/>
                            否
                        </span>
                    </div>
                    <div  id="Div1" class="col-xs-6">
                        <span class="form-text col-xs-4">增强方式：</span>
                        <select id="addmethod1" name="addmethod1" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-6">
                        <span class="form-text col-xs-4" style="padding-left:0px;">特殊要求：</span>
                        <select id="special1" name="special1" class="form-item" disabled="disabled"></select>
                    </div>
                </div>
                 <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;"> 申请备注：</span>                     
                        <textarea id="remark1" name="remark1" class="form-area col-xs-10" disabled="disabled"></textarea>
                    </div>
                </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">层厚：</span>
                            <div class="group-item">
                                <input id="Thickness" step="0.00001" class="form-group-input" type="number" name="Thickness1" disabled="disabled"/>
                                <span class="input-group-addon">mm</span>
                            </div>
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">层数：</span>
                            <input id="Number" step="0.00001" class="form-item col-xs-6" type="number" name="Number1" disabled="disabled" style="padding-left:5px;"/>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">参考中心层面：</span>
                            <div class="group-item">
                                <input id="ReferenceNumber" step="0.00001" class="form-group-input" type="number" name="ReferenceNumber1" disabled="disabled"/>
                                <span class="input-group-addon">mm</span>
                            </div>
                            
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">体表参考刻度：</span>
                            <div class="group-item">
                                <input id="ReferenceScale" step="0.00001" class="form-group-input" type="number" name="ReferenceScale1" disabled="disabled"/>
                                <span class="input-group-addon">mm</span>
                            </div>
                        </div>
                    </div>
                    <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;"> 记录备注：</span>                     
                        <textarea id="Remarks" name="Remarks" class="form-area col-xs-10" disabled="disabled"></textarea>
                    </div>
                    </div>

            </div>--%>
           <div class="paper-footer"> 
                <div class="content-title">
                    <span>复查记录：<button id="appointtreat" class="btn btn-primary"  disabled="disabled">确认复查</button></span>
                </div>
                <div class="single-row">
                     <div class="item area-group col-xs-12">
                        <table  class="table table-bordered" style="table-layout:fixed;word-wrap:break-word;">
                            <thead>
                                <tr>
                                    <th>扫描信息</th>
                                    <th>备注信息</th>
                                    <th>实施人员</th>
                                </tr>
                            </thead>
                            <tbody id="checkrecord" style="text-align:center;"> 
                            </tbody>
                        </table>
                    </div>
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
                            <div class="item col-xs-4">预约时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                            <div class="item col-xs-3">
                                <button type="button"  id="previousday" class="btn btn-default btn-sm">上一天</button>
                                <button type="button" id="nextday" class="btn btn-default btn-sm">下一天</button>
                               <%-- <button id="chooseProject" class="btn btn-default">查询该项</button>--%>
                            </div>
                        </div>
                         <div id="amappoint" class="panel-row">
                        <div id="amlabel">
                            <span class="label label-info" style="float:left;width:10%;height:auto" >上午</span>
                        </div>
                            <table id="apptiontTable" class="table table-bordered col-xs-12" style="table-layout:fixed;word-wrap:break-word;"></table>
                        </div>
                          <div id="pmappoint" class="panel-row">
                         <div id="pmlabel" >
                            <span class="label label-info" style="float:left;width:10%;height:auto" >下午</span>
                        </div>
                            <table id="apptiontTableForPm" class="table table-bordered col-xs-12" style="table-layout:fixed;word-wrap:break-word;"></table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" id="cannel" type="button" data-dismiss="modal">取消</button>
                        <button class="btn btn-primary" id="sure" type="button" data-dismiss="modal">确定</button>
                    </div>
                </div>
            </div>
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
    <!-- SlimScroll -->
    <script src="../../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
        <script src="../../../plugin/AdminLTE/jquery.PrintArea.js"></script>
    <!-- SlimScroll -->
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
    <script src="../../../js/Main/addimgs.js"></script> 
    <script src="../../../js/Main/treatmentreview.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>                                        
</body>
</html>
