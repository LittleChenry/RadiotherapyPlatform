<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FieldInput.aspx.cs" Inherits="pages_Main_Records_FieldInput" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title></title>
    <!-- css -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/Records.css" />
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/bootstrap/css/bootstrap.min.css" />
    <!-- DataTables -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css" />
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css" />
    <!-- Font Awesome -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css" />
    <!-- Ionicons -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css" />
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/dist/css/skins/_all-skins.min.css" />
</head>
<body style="width: auto; min-width: 900px; margin: auto;">
    <section class="content">
        <div class="paper" id="needPrint">
            <form id="saveField" method="post" runat="server">
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden" id="hidetreatID" name="hidetreatID" />
                <input type="hidden" id="userID" name="userID" />
                <input type="hidden" id="diaguserid" name="diaguserid" />
                <input type="hidden" id="progress" />
                <input type="hidden" id="aa" name="aa" />
                <div class="paper-title">
                    放疗计划导入
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
                        <div class="item col-xs-4">诊断结果：<span id="diagnosisresult" class="underline"></span></div>
                        <div class="item col-xs-4">照射部位：<span id="lightpart" class="underline"></span></div>
                        <div class="item col-xs-4">住院情况：<span id="hospitalid" class="underline"></span></div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4"><input type="text" id="subdesignname" placeholder="请输入子计划名称" class="form-item"></div>
                    <div class="item col-xs-4">
                        <input type="button" value="新增子计划" id="addSubDesign" class="btn btn-primary" disabled="disabled">
                        <input type="button" value="保存子计划" id="saveSubDesign" class="btn btn-success" disabled="disabled">
                    </div>
                </div>
                <div class="single-row tab-row">
                    <ul id="designTab" class="nav nav-tabs">
                    </ul>
                </div>
                <div id="tabpanels" class="tab-content">
                   <!--  <div class="tab-pane active" id="tab">
                        <div id="plan">
                            <div class="paper-content">
                                <div class="content-title">
                                    <span>计划信息：</span>
                                </div>
                                <div class="single-row">
                                    <div class="item col-xs-6">
                                        照射技术：
                                <select id="Irradiation" name="Irradiation" class="form-item" disabled="disabled"></select>
                                    </div>
                                    <div class="item col-xs-6">
                                        能量：
                                <select id="ener" class="form-item" name="ener" disabled="disabled"></select>
                                    </div>
                                </div>
                                <div class="single-row">
                                    <div class="item col-xs-6">
                                        射野数量：
                                <input id="IlluminatedNumber" class="form-item" type="number" name="IlluminatedNumber" disabled="disabled" />
                                    </div>
                                    <div class="item col-xs-6">
                                        非共面照射：
                                <select id="Coplanar" name="Coplanar" class="form-item" disabled="disabled">
                                    <option value="0">否</option>
                                    <option value="1">是</option>
                                </select>
                                    </div>
                                </div>
                                <div class="single-row">
                                    <div class="item col-xs-6">
                                        机器跳数：
                                <input id="MachineNumbe" class="form-item" type="number" name="MachineNumbe" disabled="disabled" />
                                    </div>
                                    <div class="item col-xs-6">
                                        控制点数量：
                                <input id="ControlPoint" class="form-item" type="number" name="ControlPoint" disabled="disabled" />
                                    </div>
                                </div>
                                <div class="single-row">
                                    <div class="item col-xs-6">
                                        射野角度：
                                    </div>
                                </div>
                                <div class="single-row">
                                    <div class="col-xs-12">
                                        <table id="Illuminatedangle" class="table table-bordered">
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="paper-content">
                            <div class="content-title">
                                <span>射野信息：</span>
                            </div>
                            <div class="single-row">
                                <div class="col-xs-6">
                                    <div class="group-item" style="width: 80%;">
                                        <input type="text" id="filename" class="form-control" disabled="disabled" style="border-radius: 4px 0px 0px 4px;" />
                                        <span class="input-group-btn">
                                            <a href="javascript:;" class="btn btn-info file">选择文件<input type="file" id="file" /></a>
                                        </span>
                                    </div>
                                </div>
                                <div class="col-xs-6">
                                    <button class="btn btn-success" id="sure" type="button" disabled="disabled"><i class="fa fa-fw fa-reply-all"></i>导入</button>
                                </div>
                            </div>
                            <div class="single-row">
                                <div class="item col-xs-4">
                                    放疗号：<input id="id" class="form-item" name="id" disabled="disabled" />
                                </div>
                                <div class="item col-xs-4">
                                    姓名拼音：<input id="pingyin" class="form-item" name="pingyin" disabled="disabled" />
                                </div>
                                <div class="item col-xs-4">
                                    TPS：<input id="tps" class="form-item" name="tps" disabled="disabled" />
                                </div>

                            </div>
                            <div class="single-row">
                                <div class="item col-xs-4">
                                    总剂量：
                                <div class="group-item">
                                    <input id="total" class="form-group-input" name="total" disabled="disabled" />
                                    <span class="input-group-addon">cGy</span>
                                </div>

                                </div>
                                <div class="item col-xs-4">
                                    分次剂量：
                                <div class="group-item">
                                    <input id="Graded" class="form-group-input" name="Graded" disabled="disabled" />
                                    <span class="input-group-addon">cGy</span>
                                </div>
                                </div>
                                <div class="item col-xs-4">射野总数：<input id="fieldTimes" class="form-item" name="fieldTimes" disabled="disabled" /></div>


                            </div>
                            <div class="single-row">
                                <div class="item col-xs-4">摆位信息：<input id="pos" class="form-item" name="pos" disabled="disabled" /></div>
                            </div>
                            <div class="single-row">
                                <div class="col-xs-6" style="padding-left: 0px;">
                                    <span class="form-text col-xs-5">射野信息：</span>
                                </div>
                            </div>
                            <div class="single-row">
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
                                                <th style="text-align: center;">
                                                    <a id="add" href="javascript:;"><i class="fa fa-fw fa-plus-circle" style="font-size: 18px;"></i></a>
                                                </th>
                                            </tr>
                                        </thead>
                                    </table>
                                </div>
                            </div>
                        </div>
                    </div> -->
                </div>
                <div class="paper-footer">
                    <div class="single-row">
                        <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                        <div class="item col-xs-6">提交日期：<span id="time" class="underline"></span></div>
                    </div>
                </div>
            </form>
        </div>
    </section>
    <section id="printArea" class="content" style="display: none; width: 756px; height: 1086px; border: 0px;">
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
    <!-- javascript -->
    <script src="../../../js/Main/FieldInput.js"></script>
    <!-- Page script -->
    <script src="../../../js/Main/FixedRecordPrint.js"></script>
</body>
</html>
