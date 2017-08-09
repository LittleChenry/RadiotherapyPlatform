<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientRegister.aspx.cs" Inherits="pages_Main_Records_PatientRegister" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>患者信息登记</title>
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
<body style="width:auto;width:900px;margin:auto;">
    <section>
        <div class="paper">
            <div class="paper-title">
                患者信息登记
            </div>
            <form id="frmRegist" name="frmRegist" method="post" runat="server">
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden" id="progress" name="progress" />
                <input type="hidden" id="picture1" name="picture1" />
               
                <input id="patientID" type="hidden" name="patientID" />
                <input id="treatID" type="hidden" name="treatID" />
                <div class="paper-content">
                    <div class="content-title">
                        <span>基本信息：</span>
                    </div>
                    <div class="head-picture">
                        <div class="imgbox">
                            <div class="boxes">
                                <div class="imgnum">
                                    <input type="file" id="FileUpload" accept="image/jpg,image/png" name="FileUpload" class="singlefilepath filepath" />
                                    <!-- <asp:FileUpload id="FileUpload1" name="FileUpload" class="singlefilepath filepath" runat="server" /> -->
                                    <span class="closecamera resetarra"><i class="fa fa-times"></i></span>
                                    <img id="background-photo" src="../../../img/avatar.jpg" class="camera-picture" />
                                    <!-- <i class="camera fa fa-camera" style="font-size:110px;"></i> -->
                                    <img src="" id="photo" class="img" />
                                </div>
                            </div>
                        </div>
                        <div class="picture-remark">
                            <p>上传头像</p>
                            <p style="font-size:10px;">120*140像素</p>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-5">
                            姓名：
                            <input id="userName" name="userName" type="text" class="form-item" />
                        </div>
                        <div class="item col-xs-5" style="padding-top:5px;">
                            <span class="col-xs-3" style="padding-left:0px;">性别：</span>
                            <span class="col-xs-3" style="padding-left:0px;">
                                <input type="radio" name="Gender" id="male" value="M" />
                                男
                            </span>
                            <span class="col-xs-3" style="padding-left:0px;">
                                <input type="radio" name="Gender" id="female" value="F" />
                                女
                            </span>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-5">
                            民族：
                            <input id="Nation" name="Nation" type="text" class="form-item" />
                        </div>
                        <div class="item col-xs-7">
                            身份证号：
                            <input id="IDcardNumber"  name="IDcardNumber" type="text" class="form-item" />
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-5">
                            出生日期：
                            <input type="text" class="form-item" id="Birthday" name="Birthday" placeholder="选择日期" />
                        </div>
                        <div class="item col-xs-7">
                            地址：
                            <input id="Address"  name="Address" type="text" class="form-item" />
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-5">
                            联系电话1：
                            <input id="Number1" name="Number1" type="text" class="form-item" />
                        </div>
                        <div class="item col-xs-5">
                            联系电话2：
                            <input id="Number2"  name="Number2" type="text" class="form-item" />
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-5">
                            身高：
                            <div class="group-item">
                                <input type="number" id="height" name="height" class="form-group-input" />
                                <span class="input-group-addon">cm</span>
                            </div>
                        </div>
                        <div class="item col-xs-5">
                            体重：
                            <div class="group-item">
                                <input type="number" id="weight" name="weight" class="form-group-input" />
                                <span class="input-group-addon">kg</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="paper-content">
                    <div class="content-title">
                        <span>病案信息：</span>
                    </div>
                     <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">是否住院：</span>
                                <span class="col-xs-2" style="padding-left:0px;">
                                <input  name="RecordNumber" type="radio" value="1"  />是
                                </span>
                                 <span class="col-xs-2" style="padding-left:0px;">
                                <input  name="RecordNumber" type="radio" value="0"  />否
                               </span>
                            </div>
                            <div id="ishospital" class="col-xs-6">
                               住院号：
                                <input id="hospitalnumber" name="hospitalnumber" type="text" class="form-item" />
                            </div>
                        </div>
                    <div class="single-row">              
                        <div class="item col-xs-6">
                            所属医生：
                            <select id="doctor" name="doctor" class="form-item"></select>
                        </div>
                        <div class="item col-xs-6">
                            所属分组：
                            <select id="group" name="group" class="form-item">
                                  <option value="allItem">----分组选择-----</option>
                            </select>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-6">
                            分中心医院：
                            <input id="Hospital" name="Hospital" type="text" class="form-item" />
                        </div>
                        <div class="item col-xs-6">
                            分中心负责人：
                            <input id="Sub" name="Sub" type="text" class="form-item" />
                        </div>
                    </div>
                </div>
                <div class="paper-content">
                    <div class="content-title">
                        <span>疗程信息：</span>
                    </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            当前疗程：
                            <span id="currentTreatment"></span>
                        </div>
                        <div class="col-xs-6">
                            疗程状态：
                            <span id="treatmentState"></span>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="col-xs-6">
                            <button id="addTreatment" class="btn btn-info" type="button">新增疗程</button>
                        </div>
                    </div>
                </div>
                <div class="paper-content">
                    <div class="content-title">
                        <span>预约信息：</span>
                    </div>
                    <div class="single-row">
                        <table id="viewAppoints" class="table" style="text-align:center;">
                            <thead>
                                <tr>
                                    <th>预约项目</th>
                                    <th>预约时间</th>
                                    <th>状态</th>
                                    <th>操作</th>
                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
                <div class="paper-footer">
                    <div class="single-row">
                        <div class="item col-xs-6">医生签字：<span id="operator" class="underline">王医生</span></div>
                        <div class="item col-xs-6">登记时间：<span id="date" class="underline">2017年6月28日</span></div>
                    </div>
                </div>
            </form>
        </div>
    </section>
    <div id="changeAppoint" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document" style="width:700px;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">修改预约时间</h4>
                </div>
                <div class="modal-body" style="overflow:hidden;">
                    <div class="panel-row">
                        <div class="item col-xs-5">选择设备：<select id="equipmentName" class="form-item"></select></div>
                        <div class="item col-xs-5">预约时间：<input type="text" id="AppiontDate" class="form-item" /></div>
                        <div class="col-xs-2">
                            <button id="chooseProject" class="btn btn-default">查询该项</button>
                        </div>
                    </div>
                    <div class="panel-row">
                        <table id="apptiontTable" class="table table-bordered col-xs-12" style="table-layout:fixed;word-wrap:break-word;"></table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button class="btn btn-default" id="cannel" type="button" data-dismiss="modal">取消</button>
                    <button class="btn btn-primary" id="sure" type="button" data-dismiss="modal">确定</button>
                </div>
            </div>
        </div>
    </div>
    <div id="myModal" class="modal fade" tabindex="-1" role="dialog" style="overflow-y:auto">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">新增疗程</h4>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <div class="col-xs-12">
                            新疗程名:
                            <input id="newname" type="text" maxlength="8" class="form-control" />
                        </div>
                    </div>
                    <div class="pull-right" style="margin:10px;">默认数字编号，最多8个字。</div>
                    <table id="addTreatmentRecord" class="table table-bordered" ></table>
                    <input id="Radiotherapy_ID" type="text" hidden="hidden" />
                    <div class="panel box box-primary">
                        <div class="box-header">
                            <h4 class="box-title">
                                <a data-toggle="collapse" data-parent="#accordion" href="#collapseOne" aria-expanded="false" class="collapsed">
                                    新疗程预览
                                </a>
                            </h4>
                        </div>
                        <div id="collapseOne" class="panel-collapse collapse" aria-expanded="false">
                            <div class="box-body">
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">登记信息：</div>
                                    <div class="col-xs-9">
                                        <span id="registerDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">病情诊断：</div>
                                    <div class="col-xs-9">
                                        <span id="diagnoseDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">体位固定：</div>
                                    <div class="col-xs-9">
                                        <span id="fixedDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">CT模拟：</div>
                                    <div class="col-xs-9">
                                        <span id="locationDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">计划设计：</div>
                                    <div class="col-xs-9">
                                        <span id="designDetail">未选择</span>
                                    </div>
                                </div>
                                <div class="row" style="padding-top:10px;">
                                    <div class="col-xs-3" style="text-align:center;">复位验证：</div>
                                    <div class="col-xs-9">
                                        <span id="replaceDetail">未选择</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
                    <button id="saveTreatment" type="button" class="btn btn-primary" data-dismiss="modal">保存</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->
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
    <script src="../../../js/Main/PatientRegister.js" ></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
        $("#Birthday").datepicker({ autoclose: true });
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>
