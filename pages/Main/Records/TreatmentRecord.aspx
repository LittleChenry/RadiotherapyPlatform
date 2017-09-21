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
                    <span>参考信息：</span>
                </div>  
                <div class="single-row">
                    <div class="col-xs-12" style="padding-left:30%;" >
                        <a href="javascript:;"   id="viewpdf"  target="_blank"   class="btn btn-default">查看计划PDF文档</a>
                        <a href="javascript:;"   id="viewpdf2"  target="_blank"   class="btn btn-default">查看复核PDF文档</a>
                        <button type="button" class="btn btn-default" id="CTpicture" data-toggle="modal" data-target="#ct">查看模拟定位图片</button>
                    </div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>计划信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-6">分割方式：<span id="split"  class="underline"></span></div>
                </div>
                <div id="aimdosage" class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-4">靶区处方剂量：</span>
                    </div>
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
                <div id="fieldinfo" class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
                        <span class="form-text col-xs-4">射野信息：</span>
                    </div>
                </div>
                <div id="fieldinfotable" class="single-row">
                    <div class="item area-group col-xs-12">
                        <table id="Field" class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>射野ID</th>
                                    <th>MU</th>
                                    <th>放疗设备</th>
                                    <th>照射技术</th>
                                    <th>射野类型</th>
                                    <th>能量</th>
                                    <th>源皮距</th>
                                    <th>机架角</th>
                                    <th>机头角</th>
                                    <th>床转交</th>
                                    <th>子野数</th>
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>

                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;">特殊医嘱：</span>
                        <textarea id="enjoin" disabled="disabled" name="enjoin" class="form-area col-xs-10" ></textarea>
                    </div>                                                                 
                </div>
            </div>
            <div id="operate" class ="paper-content">
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
                    <div class="col-xs-5" >
                        <button id="treatmentedit" disabled="disabled" type="button"   data-toggle="modal" data-target="#treatmentview" class="btn btn-success" >记载放疗记录</button>
                        <button id="finishigrt"  disabled="disabled" type="button" data-toggle="modal" data-target="#igrt" class="btn btn-info" >记载IGRT记录</button>
                   </div>
                </div>
                <div  id="ask" class="single-row">
                     <div  class="col-xs-7">
                      （备注：请预约完剩余次数，再进行此次加速治疗记录）
                    </div>
                </div>
            </div>
            <div class="paper-content">
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
                                    <th>单次剂量(cGy)</th>
                                    <th>累计剂量(cGy)</th>
                                    <th>主操作</th>
                                    <th>副操作</th>
                                    <th>备注</th>
                                    <th>周剂量核对</th>
                                </tr>
                            </thead>
                            <tbody id="treatment" style="text-align:center;"> 
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="paper-content">
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
            <div class="modal-dialog" role="document" style="width:700px;">
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
                            <div class="item col-xs-4">机器跳数：<span id="machinenumber" class="underline"></span></div>
                            <div class="item col-xs-4">单次剂量(cGy)：<span id="singlenumber" class="underline"></span></div>
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
                                    <input id="xvalue" type="number" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="item col-xs-4">
                                y方向：
                                <div class="group-item">
                                    <input id="yvalue" type="number" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="item col-xs-4">
                                z方向：
                                <div class="group-item">
                                    <input id="zvalue" type="number" class="form-group-input" />
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
        <div id="appoint"  class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:800px;">
                <div class="modal-content"  >
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">预约设备与时间窗口</h4>
                    </div>
                    <div class="modal-body">
                        <div class="panel-row">
                            <div class="item col-xs-5">选择设备：<select id="equipmentName" class="form-item"></select></div>
                            <div class="item col-xs-5">初始时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                            
                            <div class="col-xs-2">
                                <button id="chooseProject" class="btn btn-default">查询该项</button>
                            </div>
                        </div>

                        <div class="panel-row" style="overflow:auto;margin-bottom:0px;">
                            <div id="loading" style="display:none;font-size:30px;">
                                <i class="icon-spinner icon-spin icon-2x"></i>
                            </div>
                            <table id="apptiontTable" class="table table-bordered table-hover" >
                            </table>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" id="cannel" type="button" data-dismiss="modal">取消</button>
                        <button class="btn btn-primary" id="sure" type="button" data-dismiss="modal">确定</button>
                    </div>
                </div>
            </div>
        </div>
       
        <div id="ct" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:700px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">CT模拟图片查看</h4>
                    </div>
                    <div class="modal-body" style="overflow:hidden;">
                        <div id="ctpictureshow" class="panel-body">
                            <div class="single-row">
                                <div class="item col-xs-12">
                                    <div id="multipic" class="imgbox multifile"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" type="button" data-dismiss="modal">取消</button>
                    </div>
                </div>
            </div>
        </div>
        <button id="showPic" class="btn btn-default" data-toggle="modal" data-target="#myModal" style="display:none;"></button>
        <div id="myModal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document" style="width:800px;">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">查看图片</h4>
                    </div>
                    <div class="modal-body" style="overflow:hidden;">
                        <img src="" id="pic" class="showPicture" />
                    </div>
                    <div class="modal-footer">
                        <button class="btn btn-default" type="button" data-dismiss="modal">取消</button>
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
    <script src="../../../js/Main/TreatmentRecord.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>