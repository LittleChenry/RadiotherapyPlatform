<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ImportCT.aspx.cs" Inherits="pages_Main_Records_ImportCT" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
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
                 CT图像信息导入
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>基本信息：</span>
                </div>
                <div class="single-row">
                        <div class="item col-xs-3">姓名：<span id="username" class="underline"></span></div>
                        <div class="item col-xs-3">性别：<span id="sex" class="underline"></span></div>
                        <div class="item col-xs-3">年龄：<span id="age" class="underline"></span></div>                   
                    </div>
                    <div class="single-row">
                       <div class="item col-xs-4">放疗号：<span id="radiotherapy" class="underline"></span></div>
                       <div class="item col-xs-4">疗程：<span id="treatID" class="underline"></span></div>
                       <div class="item col-xs-4">主管医生：<span id="Reguser" class="underline"></span></div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-12">诊断结果：<span id="diagnosisresult"  class="underline"></span></div>
                    </div>
                </div>                        
            <div class="paper-content"> 
                <form id="saveImportCT" method="post" runat="server">
                    <input type="hidden" name="ispostback" value="true" />
                    <input type="hidden"  id="treatmentID" name="treatmentID" />
                    <input type="hidden"  id="userID" name="userID" />
                    <div class="content-title">
                        <span>CT图像信息导入：</span>
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
                            <span class="form-text col-xs-4" style="padding-left:0px;">CT-电子密度转换：</span>
                            <select id="DensityConversion" name="DensityConversion" class="form-item" disabled="disabled"></select>
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">CT序列命名：</span>
                            <input id="SequenceNaming" name="SequenceNaming" class="form-item" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">层厚：</span>
                            <div class="group-item">
                                <input id="Thickness" step="0.00001" name="Thickness" type="number" onmousewheel="return false;" class="form-group-input" disabled="disabled"/>
                                <span class="input-group-addon">mm</span>
                            </div>
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">层数：</span>
                            <input id="Number" step="0.00001" name="Number" type="number" onmousewheel="return false;"  class="form-item" disabled="disabled"/>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">参考中心层面：</span>
                            <div class="group-item">
                                <input id="ReferenceScale" step="0.00001" class="form-group-input" type="number" onmousewheel="return false;" name="ReferenceScale" disabled="disabled"/>
                                <span class="input-group-addon">cm</span>
                            </div>
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">多模态图像：</span>
                            <select id="MultimodalImage" name="MultimodalImage" class="form-item" disabled="disabled">
                                <option value="Other">Other</option>
                                <option value="MRI">MRI</option>
                                <option value="PET">PET</option>
                                
                            </select>
                        </div>
                    </div> 
                    <div class="single-row">
                        <div class="item area-group col-xs-12">
                            <span class="form-text col-xs-2" style="padding-left:0px;">备注：</span>
                            <textarea id="Remarks" name="Remarks" class="form-area" disabled="disabled"></textarea>
                        </div>
                    </div>
                    </div>
                     </div>
                </form>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">导入时间：<span  id="time" class="underline"></span></div>
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
    <!-- JQuery PrintArea -->
    <script src="../../../plugin/AdminLTE/jquery.PrintArea.js"></script>
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
    <script src="../../../js/Main/FixedRecordPrint.js"></script>
     <script src="../../../js/Main/importCT.js" type="text/javascript"></script>
     <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>
