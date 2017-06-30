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
    <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datepicker/datepicker3.css">
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
            <div class="paper-title">
                患者信息登记
            </div>
            <form id="frmRegist" name="frmRegist" method="post" runat="server">
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden" id="progress" name="progress" />
                <input id="patientID" type="hidden" name="patientID" />
                <input id="treatID" type="hidden" name="treatID" />
                <div class="paper-content">
                    <div class="head-picture">
                        <div class="imgbox">
                            <div class="boxes">
                                <div class="imgnum">
                                    <input type="file" id="FileUpload" name="FileUpload" class="singlefilepath filepath" />
                                    <!-- <asp:FileUpload id="FileUpload1" name="FileUpload" class="singlefilepath filepath" runat="server" /> -->
                                    <span class="closecamera resetarra"><i class="fa fa-times"></i></span>
                                    <img id="background-photo" src="../../../img/avatar.jpg" class="camera-picture" />
                                    <!-- <i class="camera fa fa-camera" style="font-size:110px;"></i> -->
                                    <img id="photo" class="img" />
                                </div>
                            </div>
                        </div>
                        <div class="picture-remark">
                            <p>上传头像</p>
                            <p style="font-size:10px;">图片大小：120*140像素</p>
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
                    <div class="single-row">
                        <div class="item col-xs-4">
                            病案号：
                            <input id="RecordNumber" name="RecordNumber" type="text" class="form-item" />
                        </div>
                        <div class="item col-xs-4">
                            患病部位：
                            <select id="SickPart" name="SickPart" class="form-item"></select>
                        </div>
                        <div class="item col-xs-4">
                            所属医生：
                            <select id="doctor" name="doctor" class="form-item"></select>
                        </div>
                    </div>
                    <div class="single-row">
                        <div class="item col-xs-6">
                            分中心医院：
                            <input id="Hospital" name="Hospital" type="text" class="form-item" />
                        </div>
                        <div class="item col-xs-6">
                            分中心负责人：
                            <select id="Sub" name="Sub" class="form-item"></select>
                        </div>
                    </div>
                </div>
                <div class="paper-footer">
                    <div class="single-row">
                        <div class="item col-xs-6">医生签字：<span id="operator" class="underline">王医生</span></div>
                        <div class="item col-xs-6">日期：<span id="date" class="underline">2017年6月28日</span></div>
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
    <script src="../../../js/Main/addimgs.js"></script>
    <script src="../../../js/Main/PatientRegister.js" ></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
        $("#Birthday").datepicker({ autoclose: true });
    </script>
</body>
</html>
