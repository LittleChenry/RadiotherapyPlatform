<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Test.aspx.cs" Inherits="pages_Main_Records_Test" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>record</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- css -->
  <link rel="stylesheet" href="../../../css/Main/main.css">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css">
  <!-- DataTables -->
  <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
</head>
<body>
  <div class="panel-body" id="singlepatientpanelbody" style="text-align:center">
    <form id="saveFixRecord" method="post" runat="server">
        <input type="hidden" name="ispostback" value="true" />
        <input type="hidden"  id="CTID" name="CTID" />
        <input type="hidden"  id="userID" name="userID" />
        <table class="table table-bordered table-hover" style="width:80%;margin:auto;">
            <tbody>
                <tr class="warning">
                    <td colspan="6" style="height:45px;">病人信息</td>
                </tr>
                <tr>
                    <td style="width:16.6%;">姓名</td>
                    <td id="Name" style="width:16.6%;"></td>
                    <td style="width:16.6%;">性别</td>
                    <td id="Gender" style="width:16.6%;"></td>
                    <td style="width:16.6%;">年龄</td>
                    <td id="Age" style="width:16.6%;"></td>
                </tr>
                <tr>
                    <td>住址</td>
                    <td id="Address" colspan="2"></td>
                    <td>联系方式</td>
                    <td id="Contact" colspan="2"></td>
                </tr>
                <tr>
                    <td>疗程号</td>
                    <td id="treatID"></td>
                    <td>诊断结果</td>
                    <td id="diagnosisresult"></td>
                    <td>诊断医生</td>
                    <td id="doctor"></td>
                </tr>
                <tr class="success">
                    <td colspan="6" style="height:45px;">CT图像导入记录</td>
                </tr>
                <tr>
                    <td>CT-电子密度转换</td>
                    <td colspan="2">
                        <select id="DensityConversion" class="form-control" name="DensityConversion">
                        </select>
                    </td>
                    <td>CT序列命名</td>
                    <td colspan="2">
                        <input id="SequenceNaming" class="form-control" name="SequenceNaming"/>
                    </td>
                </tr>
                <tr>
                    <td>层厚</td>
                    <td colspan="2">
                        <input id="Thickness" class="form-control" type="number" name="Thickness"/>
                    </td>
                    <td>层数</td>
                    <td colspan="2">
                        <input id="Number" class="form-control" type="number" name="Number"/>
                    </td>
                </tr>
                <tr>
                    <td>参考中心层面</td>
                    <td colspan="2">
                        <input id="ReferenceScale" class="form-control" type="number" name="ReferenceScale"/>
                    </td>
                    <td>多模态图像</td>
                    <td colspan="2">
                        <select id="MultimodalImage" name="MultimodalImage" class="form-control">
                            <option >--选择多模态图像--</option>
                            <option value="MRI">MRI</option>
                            <option value="PET">PET</option>
                            <option value="Other">Other</option>
                        </select>
                    </td>
                </tr>
                <tr>
                     <td>备注</td>
                    <td colspan="5">
                        <textarea id="Remarks" class="form-control" rows="2" name="Remarks"></textarea>                                                      
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="row" style="margin-top:30px;margin-bottom:30px;">
            <input id="cancel" class="btn btn-default" type="button" value="取消" style="margin-right:40px;" />
            <input id="save" class="btn btn-success" type="submit" value="保存" />
        </div>
    </form>
</div>
<!-- jQuery 2.2.3 -->
<script src="../../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
<!-- DataTables -->
<script src="../../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.min.js"></script>
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
</body>
</html>