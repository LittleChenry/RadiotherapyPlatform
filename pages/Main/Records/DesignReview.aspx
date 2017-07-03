<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DesignReview.aspx.cs" Inherits="pages_Main_Records_DesignReview" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>治疗计划复核</title>
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
            <input type="hidden" id="progress" />
            <div class="paper-title">
                 治疗计划复核
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
                    <div class="item col-xs-4">疗程号：<span id="treatID" class="underline"></span></div>
                    <div class="item col-xs-4">患病部位：<span id="part" class="underline"></span></div>
                    <div class="item col-xs-4">所属医生：<span id="diaguser" class="underline"></span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>复核计划信息：</span>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th style="width:8%;text-align:center;">序号</th>
                                    <th style="width:22%;text-align:center;">复核项</th>
                                    <th style="width:30%;text-align:center;">复核内容</th>
                                    <th style="width:20%;text-align:center;">状态</th>
                                    <th style="width:20%;text-align:center;">操作</th>
                                </tr>
                            </thead>
                            <tbody style="text-align: center;">
                                <tr>
                                    <td>1</td>
                                    <td>治疗技术</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>计划系统</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>放疗设备</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                    <td>射野角度</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>5</td>
                                    <td>非共面照射</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>6</td>
                                    <td>机器跳数</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>7</td>
                                    <td>控制点数量</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>8</td>
                                    <td>计算网格</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>9</td>
                                    <td>优化算法</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>放疗计划可执行度</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>11</td>
                                    <td>放疗计划再优化程度</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">不可再优化</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>12</td>
                                    <td>摆位野信息</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>13</td>
                                    <td>DRR</td>
                                    <td></td>
                                    <td>未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>14</td>
                                    <td>计划和图像导出到放疗网络</td>
                                    <td></td>
                                    <td>否</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button class="btn btn-block btn-success">是</button>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">参考等中心：</span>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">x</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">y</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">z</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">治疗等中心：</span>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">x</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">y</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">z</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">移床参数：</span>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">左</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">头</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">腹</span>
                            <input type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
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
    
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>