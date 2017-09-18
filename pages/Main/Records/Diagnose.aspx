<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Diagnose.aspx.cs" Inherits="pages_Main_Records_Diagnose" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>病情诊断</title>
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
            <input type="hidden" id="progress" name="progress" />
            <input type="hidden" id="diaguserid" name="diaguserid" />
               <input type="hidden" id="diagid" name="diaguserid" />
            <input type="hidden" id="diagid2" name="diaguserid" />
            <div class="paper-title">
                病情诊断
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
                    <div class="item col-xs-4">主管医生：<span id="Reguser" class="underline"></span></div>
                </div>
            </div>
            
            <div class="paper-content">
                <div class="content-title">
                    <span>添加诊断：</span>
                </div>
                <div class="single-row tab-row">
                    <ul id="tabs" class="nav nav-tabs">
                        <li class="active"><a id="current-tab" href="#tab" data-toggle="tab" aria-expanded="true"></a></li>
                    </ul>
                </div>
                <div id="tab-content" class="tab-content">
                    <div class="tab-pane active" id="tab">
                          <div class="single-row">
                            <div id="bingqing" class="col-xs-12">
                                <span class="form-text col-xs-2" style="padding-left:0px;width:120.2px;">病情诊断结果：</span>
                                <select id="bingqing1"  class="form-item col-xs-3" disabled="disabled"  onChange="loadone();" style="width:196.4px;">
                                    <option value="">无</option>
                                </select>
                                <select id="bingqing2" class="form-item col-xs-3" disabled="disabled"  onChange="loadtwo();" style="width:196.4px;">
                                    <option value="">无</option>
                                </select>
                                <select id="bingqing3" class="form-item col-xs-3" disabled="disabled"  onChange="loadthree();"  style="width:196.4px;">
                                    <option value="">无</option>
                                </select>
                            </div>
                            <input type="hidden"  id="copybingqing1" value=""/>
                            <input type="hidden"  id="copybingqing2" value="" />
                            <input type="hidden"  id="copybingqing3" value="" />
                        </div>
                         <div class="single-row">
                            <div id="bingli" class="col-xs-12">
                                <span class="form-text col-xs-2" style="padding-left:0px;width:120.2px;">病理诊断结果：</span>
                                <select id="bingli1"  class="form-item col-xs-3" disabled="disabled"  onChange="loadonenext();" style="width:196.4px;">
                                    <option value="">无</option>
                                </select>
                                <select id="bingli2" class="form-item col-xs-3" disabled="disabled"  onChange="loadtwonext();" style="width:196.4px;">
                                    <option value="">无</option>
                                </select>
                            </div>
                            <input type="hidden"  id="copybingli1" value=""/>
                            <input type="hidden"  id="copybingli2" value="" />
                        </div>

                        <div class="single-row">
                            <div class="item col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">病变部位：</span>
                                <select id="part" name="part" class="form-item" disabled="disabled"></select>
                            </div>
                            <div class="item col-xs-6">
                                 <span class="form-text col-xs-4"> 照射部位：</span>
                                <select id="newpart" name="part" class="form-item" disabled="disabled"></select>
                            </div>                                  
                        </div>
                        
                        <div class="single-row">
                            <div class="item col-xs-6">
                                   <span class="form-text col-xs-4" style="padding-left:0px;">  疗程编辑：</span>
                                <input id="treatname" class="form-item" disabled="disabled" />
                            </div>
                            <div class="item col-xs-6">
                                 <span class="form-text col-xs-4"> 治疗目标：</span>
                                <select id="Aim"  class="form-item" disabled="disabled"></select>
                            </div>                                  
                        </div>
                      <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">普放选择：</span>
                                <span class="col-xs-2" style="padding-left:0px;">
                                <input  name="patientjudge" type="radio" checked="checked" value="1"  />是
                                </span>
                                 <span class="col-xs-2" style="padding-left:0px;">
                                <input  name="patientjudge" type="radio" value="0"  />否
                               </span>
                            </div>
                          </div>
                        <div class="single-row">
                            <div class="item area-group col-xs-12">
                                  <span class="col-xs-2" style="padding-left:0px;">备注：</span>
                                <textarea id="remark" name="remark" class="form-area" disabled="disabled"></textarea>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="operator" class="underline"></span></div>
                    <div class="item col-xs-6">诊断时间：<span id="date" class="underline"></span></div>
                     <button type="button" name="test" id="test" style="display:none" class="btn btn-flat"> </button>
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
    <!-- javascript -->
    <script src="../../../js/Main/Diagnose.js" type="text/javascript"></script>
    <script src="../../../js/Main/FixedRecordPrint.js"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
    </script>
</body>
</html>