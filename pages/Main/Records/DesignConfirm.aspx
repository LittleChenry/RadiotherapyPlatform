<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DesignConfirm.aspx.cs" Inherits="pages_Main_Records_DesignConfirm" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>治疗计划确认</title>
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
<body style="width:auto;min-width:900px;margin:auto;">
   <section class="content">
        <div class="paper">
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
                    <div class="item col-xs-4">民族：<span id="nation" class="underline"></span></div>
                    <div class="item col-xs-4">身份证号：<span id="idnumber" class="underline"></span></div>
                    <div class="item col-xs-4">地址：<span id="address" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">联系方式1：<span id="contact" class="underline"></span></div>
                    <div class="item col-xs-4">联系方式2：<span id="contact2" class="underline"></span></div>
                    <div class="item col-xs-4">分中心医院：<span id="hospital" class="underline"></span></div>
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
                                    <th>外放</th>
                                    <th>PTV</th>
                                    <th>单次量cGy</th>
                                    <th>次数</th>
                                    <th>总剂量cGy</th>
                                    <th>备注</th>
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
                                    <th>D/V</th>
                                    <th>限制</th>
                                    <th>数值</th>
                                    <th>PRV/V</th>
                                    <th>限制</th>
                                    <th>数值</th>
                                    <th>优先级</th>
                                    <th>体积</th>
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
                    <div class="item col-xs-4">射野数量：<span id="IlluminatedNumber" class="underline"></span></div>
                    <div class="item col-xs-4">非共面照射：<span id="Coplanar" class="underline"></span></div>
                    <div class="item col-xs-4">机器跳数：<span id="MachineNumbe" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">控制点数量：<span id="ControlPoint" class="underline"></span></div>
                    <div class="item col-xs-4">计算网络：<span id="Grid" class="underline"></span></div>
                    <div class="item col-xs-4">优化算法：<span id="Algorithm" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">计划可执行度：<span id="Feasibility" class="underline"></span></div>
                    <div class="item col-xs-4">申请医生：<span id="ApplicationUser" class="underline"></span></div>
                    <div class="item col-xs-4">申请时间：<span id="ApplicationTime" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">领取医生：<span id="receiveUser" class="underline"></span></div>
                    <div class="item col-xs-4">领取时间：<span id="receiveTime" class="underline"></span></div>
                    <div class="item col-xs-4">填写医生：<span id="Submituser" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">填写时间：<span id="Submittime" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="col-xs-4">
                        <span class="form-text" style="padding-left:0px;">审核状态：</span>
                        <input id="state" name="state" type="text" value="未审核" readonly="true" class="form-item"  />
                    </div>
                    <div class="col-xs-3">
                        <button id="unconfirm" class="btn btn-warning" type="button" disabled="disabled">不合格</button>
                        <button id="confirm" class="btn btn-success" type="button" disabled="disabled">确认通过</button>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        审核意见：
                        <textarea id="advice" name="advice" class="form-area" style="width:80%;" disabled="disabled"></textarea>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12">
                        <div class="col-xs-2" style="padding-left:0px;">
                            <span class="form-text" style="padding-left:0px;">上传计划文件：</span>
                        </div>
                        <div class="col-xs-10">
                             <asp:FileUpload ID="fp_upload" runat="server" />
                        </div>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">日期：<span  id="time" class="underline"></span></div>
                </div>
            </div>
                </form>
        </div>
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
    <!-- FastClick -->
    <script src="../../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../plugin/AdminLTE/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../../../plugin/AdminLTE/dist/js/demo.js"></script>
    <!-- javascript -->
     <script src="../../../js/Main/DesignConfirm.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>