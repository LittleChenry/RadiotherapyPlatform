<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FieldInput.aspx.cs" Inherits="pages_Main_Records_FieldInput" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>治疗计划提交</title>
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
            <form id="saveDesignSubmit" method="post" runat="server">
                <input type="hidden" name="ispostback" value="true" />             
                <input type="hidden"  id="hidetreatID" name="hidetreatID" />
                <input type="hidden"  id="userID" name="userID" />
                <input type="hidden" id="diaguserid" name="diaguserid" />              
                <input type="hidden" id="progress" />
            <div class="paper-title" >
                 治疗计划提交
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
            <div class="paper-content">

                <div class="content-title">
                    <span>射野信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-6"><input type="file" id="file" /></div>
                    <div class="item col-xs-6"><button id="sure" type="button">确定</button></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">tps：<span id="technology" class="underline"></span></div>
                    <div class="item col-xs-4">总剂量：<span id="equipment" class="underline"></span></div>
                    <div class="item col-xs-4">分次剂量：<span id="ApplicationUser" class="underline"></span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">射野总数：<span id="ApplicationTime" class="underline"></span></div>
                    <div class="item col-xs-4">摆位信息：<span id="receiveUser" class="underline"></span></div>
                   
                </div>
                <div class="single-row">
                    <div class="col-xs-6" style="padding-left:0px;">
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
                                </tr>
                            </thead>
                        </table>
                    </div>
                </div>
            </div>             
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">提交日期：<span  id="time" class="underline"></span></div>
                </div>
            </div>
            </form>
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
       <script src="../../../js/Main/FixedRecordPrint.js"></script>
    <!-- javascript -->
    <script src="../../../js/Main/DesignSubmit.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>
