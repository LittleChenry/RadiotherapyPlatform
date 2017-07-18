<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixedRecord.aspx.cs" Inherits="pages_Main_Records_FixedRecord" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
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
            <div class="paper-title">
                体位固定记录
            </div>
            <form id="saveFixRecord" name="saveFixRecord" method="post" runat="server" enctype="multipart/form-data">
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                <input type="hidden"  id="userID" name="userID" />
                <div class="paper-content">
                    <div class="content-title">
                        <span>基本信息：</span>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-3">姓名：<span id="username" class="underline"></span></div>
                        <div class="item col-xs-3">性别：<span id="sex" class="underline"></span></div>
                        <div class="item col-xs-3">年龄：<span id="age" class="underline"></span></div>
                        <div class="item col-xs-3">民族：<span id="nation" class="underline"></span></div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-6">身份证号：<span id="idnumber" class="underline"></span></div>
                        <div class="item col-xs-6">家庭地址：<span id="address" class="underline"></span></div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-6">联系方式1：<span id="contact" class="underline"></span></div>
                        <div class="item col-xs-6">联系方式2：<span id="contact2" class="underline"></span></div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-6">分中心医院：<span id="hospital" class="underline"></span></div>
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
                        <span>体位固定申请信息：</span>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-4">固定装置：<span id="fixedEquipment" class="underline"></span></div>
                        <div class="item col-xs-4">固定模具：<span id="modelID" class="underline"></span></div> 
                        <div class="item col-xs-4">体位：<span id="body" class="underline"></span></div>  
                    </div>               
                    <div class="single-row">
                        <div class="item col-xs-4">特殊要求：<span id="requireID" class="underline"></span></div>
                        <div class="item col-xs-4">申请医生：<span id="ApplicationUser" class="underline"></span></div>
                        <div class="item col-xs-4">申请时间：<span id="ApplicationTime" class="underline"></span></div>   
                    </div>
                </div>
                <div class="paper-content">
                    <div class="content-title">
                        <span>体位固定记录：</span>
                    </div>
                    <div class="single-row tab-row">
                        <ul id="tabs" class="nav nav-tabs">
                            <li class="active"><a id="current-tab" href="#tab" data-toggle="tab" aria-expanded="true"></a></li>
                        </ul>
                    </div>
                    <div id="tab-content" class="tab-content">
                        <div class="tab-pane active" id="tab">
                            <div class="single-row">
                                <div class="item area-group col-xs-12">
                                    <span class="col-xs-2" style="padding-left:0px;">体位详细描述：</span>
                                    <textarea id="BodyPositionDetail" class="form-area col-xs-10" name="BodyPositionDetail" disabled="disabled"></textarea>
                                </div>
                            </div>                   
                            <div class="single-row">
                                <div class="item area-group col-xs-12">
                                    <span class="col-xs-2" style="padding-left:0px;">备注：</span>
                                    <textarea id="Remarks" name="Remarks" class="form-area col-xs-10" disabled="disabled"></textarea>
                                </div>                                                                 
                            </div>
                            <div class="single-row">
                                <div class="item col-xs-12">
                                    <span class="col-xs-2" style="padding-left:0px;">体位图片：</span>
                                </div>
                            </div>
                            <div class="single-row">
                                <div class="item col-xs-12">
                                    <div id="multipic" class="imgbox multifile">
                                        <div class="boxes">
                                            <div class="imgnum">
                                                <input type="file" name="f1" class="multifilepath filepath" />
                                                <span class="closecamera closearea"><i class="fa fa-times"></i></span>
                                                <img src="../../../img/camera.png" class="camera-picture" />
                                                <img class="img"/>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="paper-footer">
                    <div class="single-row">
                        <div class="item col-xs-6">医生签字：<span id="operator" class="underline"></span></div>
                        <div class="item col-xs-6">记录时间：<span id="date" class="underline"></span></div>
                    </div> 
                </div>
            </form>
        </div>
        <button id="showPic" class="btn btn-default" data-toggle="modal" data-target="#myModal" style="display:none;"></button>
        <div id="myModal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">查看图片</h4>
                    </div>
                    <div class="modal-body">
                        <img src="" id="pic" class="showPicture" />
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
<script src="../../../js/Main/addimgs.js"></script> 
<script src="../../../js/Main/FixedRecordPrint.js"></script>
<script src="../../../js/Main/Fixed.js"></script>
<!-- Page script -->
<script type="text/javascript">
    $("#datepicker").datepicker({ autoclose: true });
    $("#Birthday").datepicker({ autoclose: true });
</script>
</body>
</html>
