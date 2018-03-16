<%@ Page Language="C#" AutoEventWireup="true" CodeFile="TreatmentRecord.aspx.cs" Inherits="pages_Main_Records_TreatmentRecord" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>放射治疗记录</title>
     <!-- css -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/Records.css"/>
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/accerateappoint.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css"/>
    <!-- Font Awesome -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/FontAwesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>
</head>
<body style="width:auto;min-width:900px;margin:auto;">
    
    <section class="content">
        <div class="paper" id="needPrint">
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
            
            <div id="referinfo" class="paper-content">
                <div class="content-title">
                    <span>靶区处方剂量：</span>
                </div>  
                <div id="aimdosagetable" class="single-row">
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
                <%--<div class="single-row">
                    <div class="col-xs-12" style="padding-left:40%;" >
                        <a href="javascript:;"   id="viewpdf"  target="_blank"   class="btn btn-default">查看计划PDF文档</a>
                        <a href="javascript:;"   id="viewpdf2"  target="_blank"   class="btn btn-default">查看复核PDF文档</a>
                    </div>
                </div>--%>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>计划信息：</span>
                </div>
                <div class="single-row tab-row">
                    <ul id="tabs" class="nav nav-tabs">
                    </ul>
                </div>
                <div id="tab-content" class="tab-content">
               
                </div>
            </div>
          
        <div id="operatorModal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:700px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">操作成员验证</h4>
                    </div>
                    <div class="modal-body">
                        <div class="form-group">
                            <span>账号：</span>
                            <input type="text" class="form-control" id="OperatorNumber"/>
                        </div>
                        <div class="form-group">
                            <span>密码：</span>
                            <input type="password" class="form-control" id="OperatorPassword"/>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button id="validate" type="button" class="btn btn-primary"  data-dismiss="modal">验证</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="treatmentview" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:850px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">确认治疗信息窗口</h4>
                    </div>
                    <div class="modal-body">
                        <div class="single-row">
                            <div class="item col-xs-4">放疗天数：<span id="treatdays" class="underline"></span></div>
                            <div class="item col-xs-4">放疗次数：<span id="treattimes" class="underline"></span></div>
                            <div class="item col-xs-4">射野数(V)：<span id="treatnumber" class="underline"></span></div>
                        </div>
                        <div class="single-row">
                            <div class="item col-xs-4">机器跳数：<input id="machinenumber" type="number" onmousewheel="return false;" onmousewheel="scrollFunc()" onDOMMouseScroll="scrollFunc()" class="form-item" /></div>
                            <div class="item col-xs-4">单次剂量(cGy)：<input id="singlenumber" type="number" onmousewheel="return false;" onmousewheel="scrollFunc()" onDOMMouseScroll="scrollFunc()"  class="form-item" /></div>
                            <div class="item col-xs-4">累计剂量(cGy)：<span id="sumnumber" class="underline"></span></div>
                        </div>
                        <div class="single-row">
                            <div class="item col-xs-4">主操作：<span id="chief" class="underline"></span></div>
                            <div class="item col-xs-4">副操作：<span id="assist" class="underline"></span></div>
                            <div class="item col-xs-4">备注：<input id="remarks" type="text" class="form-item" /></div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button id="cancel" type="button" class="btn btn-default"  data-dismiss="modal">取消</button>
                        <button id="confirm" type="button" class="btn btn-primary"  data-dismiss="modal">提交</button>
                    </div>
                </div>
            </div>
        </div>
        <div id="igrt" style="margin:auto" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:700px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">IGRT记录</h4>
                    </div>
                    <div class="modal-body" style="overflow:hidden;">
                        <div class="col-xs-12">
                            <div class="item col-xs-4">
                                x方向：
                                <div class="group-item">
                                    <input id="xvalue" type="number" onmousewheel="return false;" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="item col-xs-4">
                                y方向：
                                <div class="group-item">
                                    <input id="yvalue" type="number" onmousewheel="return false;" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="item col-xs-4">
                                z方向：
                                <div class="group-item">
                                    <input id="zvalue" type="number" onmousewheel="return false;" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                    <button id="recordigrt" type="button" class="btn btn-primary" data-dismiss="modal">提交</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal --> 
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
    <!-- FastClick -->
    <script src="../../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../plugin/AdminLTE/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../../../plugin/AdminLTE/dist/js/demo.js"></script>
    <script src="../../../js/Main/TreatRecordPrint.js"></script>
    <!-- javascript -->
    <script src="../../../js/Main/TreatmentRecord.js"></script>
    <script src="../../../js/Main/chromeWindowShowModalDialog.js"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>