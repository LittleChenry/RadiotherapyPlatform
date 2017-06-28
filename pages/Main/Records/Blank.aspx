﻿<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Blank.aspx.cs" Inherits="pages_Main_Records_Blank" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>BLANK</title>
    <!-- css -->
    <link rel="stylesheet" href="../../../css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datepicker/datepicker3.css">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
    <!-- Ionicons -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
    <!-- Theme style -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/AdminLTE.min.css"/>
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>
</head>
<body>
    <section class="content">
        <div class="paper">
            <div class="paper-title">
                EXAMPLE表单
            </div>
            <div class="paper-content">
                <div class="single-row">
                    <span class="item col-xs-4">姓名：<span class="underline">赵一</span></span>
                    <span class="item col-xs-4">性别：<span class="underline">男</span></span>
                    <span class="item col-xs-4">身份证号：<span class="underline">320624196506251100</span></span>
                </div>
                <div class="single-row">
                    <span class="item col-xs-4">民族：<span class="underline">汉族</span></span>
                    <span class="item col-xs-4">年龄：<span class="underline"> 72</span></span>
                    <span class="item col-xs-4">地址：<span class="underline">安徽省滁州市人民大道12号</span></span>
                </div>
                <div class="single-row">
                    <span class="item col-xs-4">分中心医院：<span class="underline">滁州市中西医结合医院</span></span>
                    <span class="item col-xs-4">联系方式1：<span class="underline">189-2001-0020</span></span>
                    <span class="item col-xs-4">联系方式2：<span class="underline">182-1212-1224</span></span>
                </div>
            </div>
            <div class="paper-content">
                <div class="single-row">
                    <span class="item col-xs-4">
                        选择模具：
                        <select class="form-item">
                            <option>模具一</option>
                            <option>模具二</option>
                            <option>模具三</option>
                            <option>模具四</option>
                        </select>
                    </span>
                    <span class="item col-xs-4">
                        设备与时间：
                        <input type="text" class="form-item">
                    </span>
                    <span class="item col-xs-4">
                        特殊要求：
                        <select class="form-item">
                            <option>要求一</option>
                            <option>要求二</option>
                            <option>要求三</option>
                        </select>
                    </span>
                </div>
                <div class="single-row">
                    <span class="item col-xs-4">
                        设备与时间：
                        <input type="text" class="form-item" id="datepicker">
                    </span>
                    <!-- <span class="item col-xs-4">联系方式1：<span class="underline">189-2001-0020</span></span>
                    <span class="item col-xs-4">联系方式2：<span class="underline">182-1212-1224</span></span> -->
                </div><!-- 
                <div class="single-row">
                    <span class="item col-xs-12">
                        备注：
                        <textarea rows="3"></textarea>
                    </span>
                </div> -->
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <span class="item col-xs-6">医生签字：<span class="underline">王医生</span></span>
                    <span class="item col-xs-6">日期：<span class="underline">2017年6月28日</span></span>
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
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
    </script>
</body>
</html>
