<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LocationRecord.aspx.cs" Inherits="pages_Main_Records_LocationRecord" %>

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
            <input type="hidden" id="progress" name="progress" />
            <input type="hidden" id="diaguserid" name="diaguserid" />
            <div class="paper-title">
                模拟定位记录
            </div>
            <form id="frmlocation" name="frmlocation" method="post" runat="server" enctype="multipart/form-data">
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                <input type="hidden"  id="userID" name="userID" />
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
                        <div class="item col-xs-12">诊断结果：<span id="diagnosisresult"  class="underline"></span></div>
                    </div>
                </div>               
                <div class="paper-content">
                    <div class="content-title">
                        <span>模拟定位记录：</span>
                    </div>
                    <div class="single-row tab-row">
                        <ul id="tabs" class="nav nav-tabs">
                            <li class="active"><a id="current-tab" href="#tab" data-toggle="tab" aria-expanded="true"></a></li>
                        </ul>
                    </div>
                    <div id="tab-content" class="tab-content">
                        <div class="tab-pane active" id="tab">
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
                    <div class="item area-group col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;"> 申请备注：</span>                     
                        <textarea id="remark" name="remark" class="form-area col-xs-10" disabled="disabled"></textarea>
                    </div>
                </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">层厚：</span>
                            <div class="group-item">
                                <input id="Thickness" step="0.00001" class="form-group-input" type="number" onmousewheel="return false;" name="Thickness" disabled="disabled"/>
                                <span class="input-group-addon">mm</span>
                            </div>
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">层数：</span>
                            <input id="Number" step="0.00001" class="form-item col-xs-6" type="number" onmousewheel="return false;" name="Number" disabled="disabled" style="padding-left:5px;"/>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">参考中心层面：</span>
                            <div class="group-item">
                                <input id="ReferenceNumber" step="0.00001" class="form-group-input" type="number" onmousewheel="return false;" name="ReferenceNumber" disabled="disabled"/>
                                <span class="input-group-addon">cm</span>
                            </div>
                            
                        </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4">体表参考刻度：</span>
                            <div class="group-item">
                                <input id="ReferenceScale" class="form-group-input" type="text" name="ReferenceScale" disabled="disabled"/>
                                <span class="input-group-addon">cm</span>
                            </div>
                        </div>
                    </div>
                    <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <span class="col-xs-2" style="padding-left:0px;"> 记录备注：</span>                     
                        <textarea id="Remarks" name="Remarks" class="form-area col-xs-10" disabled="disabled"></textarea>
                    </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-12">
                            <span class="col-xs-2" style="padding-left:0px;">定位图片：</span>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-12">
                            <div id="multipic" class="imgbox multifile">
                                <div class="boxes">
                                    <div class="imgnum">
                                        <input type="file" accept="image/jpeg,image/png"  name="f1" id="f1" class="multifilepath filepath" />
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
                        <div class="item col-xs-6">技师签字：<span id="operator" class="underline"></span></div>
                        <div class="item col-xs-6">日期：<span id="date" class="underline"></span></div>
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
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
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
    <script src="../../../js/Main/Location.js" type="text/javascript"></script>  
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
        $("#Birthday").datepicker({ autoclose: true });
    </script>                                          
    
</body>
</html>

