<%@ Page Language="C#" AutoEventWireup="true" CodeFile="AddPatient.aspx.cs" Inherits="pages_Main_AddPatient" %>

<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <meta http-equiv="X-UA-Compatible" content="IE=edge">
  <title>放疗质控系统</title>
  <!-- Tell the browser to be responsive to screen width -->
  <meta content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no" name="viewport">
  <!-- css -->
  <link rel="stylesheet" href="../../css/Main/Records.css">
  <!-- Bootstrap 3.3.6 -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css">
  <!-- bootstrap datepicker -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datepicker/datepicker3.css" />
  <!-- DataTables -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css">
  <!-- Font Awesome -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css">
  <!-- Ionicons -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css">
  <!-- Theme style -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/AdminLTE.min.css">
  <!-- AdminLTE Skins. Choose a skin from the css/skins
       folder instead of downloading all of them to reduce the load. -->
  <link rel="stylesheet" href="../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css">

  <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
  <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
  <!--[if lt IE 9]>
  <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
  <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
  <![endif]-->
<link rel="stylesheet" href="../../plugin/cropper/cropper.min.css">
</head>
<body class="hold-transition skin-blue sidebar-mini sidebar-collapse">
<div class="wrapper">
    <header class="main-header">
        <a class="logo">
            <span class="logo-mini"><b>R</b>QS</span>
        </a>
        <nav class="navbar navbar-static-top">
            <div style="position: absolute;">
                <h3 style="margin-top: 13px;margin-left: 10px;color: white;">放疗质控系统</h3>
            </div>
            <div class="navbar-custom-menu">
                <ul class="nav navbar-nav">
                    <li class="dropdown messages-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-envelope-o"></i>
                            <span id="NoticeNum" class="label label-success">0</span>
                        </a>
                        <ul class="dropdown-menu">
                        <li class="header">通知公告</li>
                        <li>
                            <ul id="Notice" class="menu">
                                <li>
                                    <a href="#">
                                        <h4>
                                            无
                                        </h4>
                                        <p class="pull-right"><i class="fa fa-user"></i> &nbsp;<i class="fa fa-clock-o"></i></p>
                                    </a>
                                </li>
                            </ul>
                        </li>
                        <li class="footer"><a id="allNotice" href="javascript:;" target="_blank">查看全部</a></li>
                        </ul>
                    </li>
                    <li class="dropdown notifications-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-bell-o"></i>
                            <span id="WarningNum" class="label label-warning">0</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li id="WarningTask" class="header">你有0条工作任务预警</li>
                            <li>
                                <ul id="TaskWarning-content" class="menu">
                                    <li>
                                        <a href="javascript:;">
                                            无
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer"><a href="javascript:;">请及时处理</a></li>
                        </ul>
                    </li>
                    <li class="dropdown tasks-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <i class="fa fa-flag-o"></i>
                            <span class="label label-danger">9</span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="header">设备动态</li>
                            <li>
                                <ul class="menu">
                                    <li>
                                        <a href="javascript:;">
                                            <h3>
                                                Design some buttons
                                                <small class="pull-right">20%</small>
                                            </h3>
                                            <div class="progress xs">
                                                <div class="progress-bar progress-bar-aqua" style="width: 20%" role="progressbar" aria-valuenow="20" aria-valuemin="0" aria-valuemax="100">
                                                    <span class="sr-only">20% Complete</span>
                                                </div>
                                            </div>
                                        </a>
                                    </li>
                                </ul>
                            </li>
                            <li class="footer">
                                <a href="javascript:;">查看详情</a>
                            </li>
                        </ul>
                    </li>
                    <li class="dropdown user user-menu">
                        <a href="#" class="dropdown-toggle" data-toggle="dropdown">
                            <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="user-image" alt="User Image">
                            <span id="out-name" class="hidden-xs"><%=((UserInformation)Session["loginUser"]) == null ?  "未登录" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                        </a>
                        <ul class="dropdown-menu">
                            <li class="user-header">
                                <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image">
                                <p>
                                    <span id="in-name"><%=((UserInformation)Session["loginUser"]) == null ?  "未登录" : ((UserInformation)Session["loginUser"]).GetUserName() %></span>
                                    <small id="role"><%=((UserInformation)Session["loginUser"]) == null ?  "无" : ((UserInformation)Session["loginUser"]).GetUserRole() %></small>
                                </p>
                            </li>
                            <li class="user-body">
                                <div class="row">
                                    <div class="text-center">
                                        <div>
                                            <span>操作成员:</span>
                                            <a id="changeOperator" href="javascript:;"><span id="operator"></span></a>
                                        </div>
                                        <div>
                                            <span>操作设备:</span>
                                            <a id="changeEquipment" href="javascript:;"><span id="chosenEquipment"></span></a>
                                        </div>
                                        <div>
                                            <span>时间范围:</span>
                                            <a id="changeDate" href="javascript:;"><span id="dateRange"></span></a>
                                        </div>
                                    </div>
                                </div>
                            </li>
                            <li class="user-footer">
                                <div class="pull-left">
                                    <a href="../Login/changeRole.aspx" class="btn btn-default btn-flat">切换角色</a>
                                </div>
                                <div class="pull-right">
                                    <a id="signOut" href="javascript:;" class="btn btn-default btn-flat">注销</a>
                                </div>
                            </li>
                        </ul>
                    </li>
                </ul>
            </div>
        </nav>
    </header>
    <aside class="main-sidebar">
        <section class="sidebar">
            <div class="user-panel">
                <div class="pull-left image">
                    <img src="../../plugin/AdminLTE/dist/img/user2-160x160.jpg" class="img-circle" alt="User Image" />
                </div>
            </div>
            <ul class="sidebar-menu">
                <li class="header">MAIN NAVIGATION</li>
                <li class="treeview">
                    <a href="Main.aspx">
                        <i class="fa fa-users"></i>
                        <span>患者汇总</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="EquipmentAppointment.aspx" target="_blank">
                        <i class="fa fa-clock-o"></i>
                        <span>设备预约管理</span>
                    </a>
                </li>
                <li class="active treeview">
                    <a href="AddPatient.aspx">
                        <i class="fa fa-pencil"></i>
                        <span>患者登记</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="NewsList.aspx?role=<%=((UserInformation)Session["loginUser"]) == null ?  "" : ((UserInformation)Session["loginUser"]).getRoleName() %>">
                        <i class="fa fa-bell-o"></i>
                        <span>通知公告</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-briefcase"></i> <span>设备管理</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li>
                            <a id="Menu-EquipmentInspection" href="EquipmentInspection.aspx"><i class="fa fa-circle-o"></i>设备检查</a>
                        </li>
                        <li>
                            <a id="Menu-EquipmentInspectionResult" href="EquipmentInspectionResult.aspx"><i class="fa fa-circle-o"></i>设备检查结果</a>
                        </li>
                        <li>
                            <a id="Menu-EquipmentStatistics" href="EquipmentStatistics.aspx"><i class="fa fa-circle-o"></i>设备检查统计</a>
                        </li>
                    </ul>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-plus-square"></i> <span>诊断结果管理</span>
                        <span class="pull-right-container">
                            <i class="fa fa-angle-left pull-right"></i>
                        </span>
                    </a>
                    <ul class="treeview-menu">
                        <li>
                            <a id="Menu-ConditionResultManage" href="ConditionResultManage.aspx"><i class="fa fa-circle-o"></i>病情诊断结果管理</a>
                        </li>
                        <li>
                            <a id="Menu-PathologyResultManage" href="PathologyResultManage.aspx"><i class="fa fa-circle-o"></i>病理诊断结果管理</a>
                        </li>
                    </ul>
                </li>
                <%--<li class="treeview">
                    <a href="#">
                        <i class="fa fa-rmb"></i>
                        <span>收费</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-tasks"></i>
                        <span>任务管理</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-pie-chart"></i>
                        <span>信息统计</span>
                    </a>
                </li>
                <li class="treeview">
                    <a href="#">
                        <i class="fa fa-table"></i>
                        <span>排队叫号</span>
                    </a>
                </li>--%>
            </ul>
        </section>
    </aside>

    <div class="content-wrapper">
        <section id="addpatient-content" class="content table-responsive" style="background-color:#fff;width:1000px;">
            <form id="frmaddpatient" name="frmaddpatient" method="post" runat="server">
                <div class="paper">
                <div class="paper-title">
                    患者信息登记
                </div>
                <input type="hidden" name="ispostback" value="true" />
                <input type="hidden" id="progress" name="progress" />
                <input type="hidden" id="userID" name="userID" />
                <input type="hidden" id="regdoctor" name="regdoctor" />
                <input id="patientID" type="hidden" name="patientID" />
                <input id="treatID" type="hidden" name="treatID" />
                <input id="pic" type="hidden" name="pic" />
                    <div class="paper-content">
                        <div class="content-title">
                            <span>基本信息：</span>
                        </div>
                        <div class="head-picture">
                            <img id="self-photo" src="../../img/avatar.jpg" class="camera-picture" />
                            <input id="mypic"  type="file"  style="display:none" accept="image/*" onchange="handleFiles(event)"/> 
                        </div>
                        <div class="card-reader">
                            <button id="ReadIDCard" type="button" class="btn btn-info btn-sm btn-flat" style="width:70px;">读身份证</button>
                            <button id="importPhoto" type="button" class="btn btn-info btn-sm btn-flat" style="width:70px;">导入图片</button>
                            <div class="CardReaderInfo">
                                <span id="ReturnInfo"></span>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">就诊卡号：</span>
                                <input id="CardID" name="CardID" class="form-item" type="text" AUTOCOMPLETE="OFF" style="width:37%;"/>
                                <button id="sync" type="button" class="btn btn-info btn-sm btn-flat" style="margin-left:-1px;margin-top:-3px;">HIS同步</button>
                            </div>
                        </div>
                         <div class="single-row">
                             <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">姓名：</span>
                                <input id="userName" name="userName" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">姓名拼音：</span>
                                <input id="usernamepingyin" name="usernamepingyin" class="form-item" type="text" AUTOCOMPLETE="OFF" placeholder="示例：ZHANG YUNFENG"/>
                            </div>
                        </div>

                        <div class="single-row">
                            <div class="item col-xs-5"> 
                                <span class="form-text col-xs-4" style="padding-left:0px;">性别：</span>
                                <select id="Gender" name="Gender" class="form-item">
                                    <option value="M">男</option>
                                    <option value="F">女</option>
                                </select>
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">身份证号：</span>
                                <input id="IDcardNumber"  name="IDcardNumber" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">民族：</span>
                                <input id="Nation" value="汉族" name="Nation"  class="form-item" type="text" AUTOCOMPLETE="OFF" />
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">出生日期：</span>
                                <input class="form-item" id="Birthday" name="Birthday" type="text" readonly="readonly"/>
                            </div>
                        </div>
                        <div id="ChooseAddress" class="single-row">
                            <div class="col-xs-10">
                                <span class="form-text col-xs-2" style="padding-left:0px;width:16%;">家庭住址：</span>
                                <input type="text" id="Address" name="Address" class="form-item"/>
                                <input type="hidden" id="Address_province" />
                                <input type="hidden" id="Address_city" />
                                <input type="hidden" id="Address_area" />
                                <a id="selectAddress" href="javasscript:;" style="font-size:18px;"><i class="fa fa-fw fa-map-marker"></i></a>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">联系电话1：</span>
                                <input id="Number1" name="Number1" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">联系电话2：</span>
                                <input id="Number2" name="Number2" class="form-item" type="text" AUTOCOMPLETE="OFF"/>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4" style="padding-left:0px;">身高：</span>
                                <div class="group-item" style="padding:0px;">
                                    <input type="number" id="height" name="height" class="form-group-input" />
                                    <span class="input-group-addon">cm</span>
                                </div>
                            </div>
                            <div class="col-xs-5">
                                <span class="form-text col-xs-4">体重：</span>
                                <div class="group-item" style="padding:0px;">
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
                                <span class="form-text col-xs-4">住院号：</span>
                                <input id="hospitalnumber" name="hospitalnumber" type="text" class="form-item" AUTOCOMPLETE="OFF" />
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">主管医生：</span>
                                <select id="doctor" name="doctor" class="form-item"></select>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">所选分组：</span>
                                <select id="group" name="group" class="form-item">
                                    <option value="allItem">----分组选择-----</option>
                                </select>
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">分中心负责人：</span>
                                <input id="Sub" name="Sub" class="form-item" value="孙新臣" AUTOCOMPLETE="OFF"/>
                            </div>
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4">分中心医院：</span>
                                <input id="Hospital" name="Hospital" type="text" value="江苏省人民医院" class="form-item" AUTOCOMPLETE="OFF" />
                            </div>
                        </div>
                        <div class="single-row">
                            <div class="col-xs-6">
                                <span class="form-text col-xs-4" style="padding-left:0px;">放疗号：</span>
                                <input id="radionumber" name="radionumber" class="form-item" placeholder="年份+4位编码，例：20170001" AUTOCOMPLETE="OFF"/>
                            </div>
                        </div>
                    </div>
                    <div class="paper-footer">
                        <div class="single-row">
                            <div class="item col-xs-6">登记人：<span id="operate" class="underline"></span></div>
                            <div class="item col-xs-6">登记时间：<span id="date" class="underline"></span></div>
                        </div>
                    </div>
                </div>          
                <div class="row" style="text-align:center;margin-top:20px;">
                    <button id="save" type="button" class="btn btn-block btn-success" style="margin:auto;width:20%;">保存</button>
                </div>
            </form>
        </section>
    </div>
    <div id="cutphoto" class="modal fade" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">选择照片</h4>
                </div>
                <div class="modal-body">
                    <div>
                        <div style="text-align: right;">
                            <label for="input" class="btn btn-danger" id="">
                            <span>选择图片</span>
                            <input type="file" id="input" class="sr-only">
                            </label>
                            <a class="btn btn-primary" onclick="crop()" data-dismiss="modal">确定</a>
                        </div>
                    </div>
                    <div class="row" style="margin-top:10px;">
                        <div class="col-sm-8 col-sm-offset-2" style="height:200px;border:1px solid #c1c1c1;">
                            <img src="" id="photo">
                        </div>
                        <%--<div class="col-sm-8 col-sm-offset-2">
                            <div class="col-sm-4 col-sm-offset-4">
                                <p>
                                    预览(102*126)：
                                </p>
                                <div class="img-preview">
                                </div>
                            </div>
                        </div>--%>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <footer class="main-footer">
        <div class="pull-right hidden-xs">
            <b>Version</b> 2.0
        </div>
        <strong>Copyright &copy; 2017 <a href="#"> 医院</a> .</strong> 保留所有权利
    </footer>
    <div class="control-sidebar-bg"></div>
</div>

<!-- jQuery 2.2.3 -->
<script src="../../plugin/AdminLTE/plugins/jQuery/jquery-2.2.3.min.js"></script>
<!-- jQuery UI 1.11.4 -->
<script src="../../plugin/AdminLTE/plugins/jQueryUI/jquery-ui.min.js"></script>
      <!-- bootstrap datepicker -->
    <script src="../../plugin/AdminLTE/plugins/datepicker/bootstrap-datepicker.js"></script>
<!-- DataTables -->
<script src="../../plugin/AdminLTE/plugins/datatables/jquery.dataTables.min.js"></script>
<script src="../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.min.js"></script>
<!-- SlimScroll -->
<script src="../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
<!-- FastClick -->
<script src="../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
<!-- Bootstrap 3.3.6 -->
<script src="../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
<!-- AdminLTE App -->
<script src="../../plugin/AdminLTE/dist/js/app.min.js"></script>
<!-- AdminLTE for demo purposes -->
<script src="../../plugin/AdminLTE/dist/js/demo.js"></script>
<!-- js -->
<script src="../../js/Main/HeaderOperate.js"></script>
<script src="../../js/Main/AddPatient.js"></script>
<script src="../../plugin/cropper/cropper.min.js"></script>
<script src="../../js/Main/TestAddress.js"></script>
<script src="../../js/Main/TestChooseAddress.js"></script>
<script>
    $("#addpatient-content").css("minHeight", $(document).height() - 101);
    $("#choosepatient-content").css("minHeight", $(document).height() - 101);
    //$("#Birthday").datepicker({ autoclose: true });
</script>
<script>
    // 修改自官方demo的js
    var initCropper = function (img, input) {
        var $image = img;
        var options = {
            aspectRatio: 102 / 126, // 纵横比
            viewMode: 2,
            preview: '.img-preview' // 预览图的class名
        };
        $image.cropper(options);
        var $inputImage = input;
        var uploadedImageURL;
        if (URL) {
            // 给input添加监听
            $inputImage.change(function () {
                var files = this.files;
                var file;
                if (!$image.data('cropper')) {
                    return;
                }
                if (files && files.length) {
                    file = files[0];
                    // 判断是否是图像文件
                    if (/^image\/\w+$/.test(file.type)) {
                        // 如果URL已存在就先释放
                        if (uploadedImageURL) {
                            URL.revokeObjectURL(uploadedImageURL);
                        }
                        uploadedImageURL = URL.createObjectURL(file);
                        // 销毁cropper后更改src属性再重新创建cropper
                        $image.cropper('destroy').attr('src', uploadedImageURL).cropper(options);
                        $inputImage.val('');
                    } else {
                        window.alert('请选择一个图像文件！');
                    }
                }
            });
        } else {
            $inputImage.prop('disabled', true).addClass('disabled');
        }
    }
    var crop = function () {
        var $image = $('#photo');
        var $target = $('#self-photo');
        var $pic = $('#pic');
        var $mypic = $('#mypic');
        $image.cropper('getCroppedCanvas', {
            width: 102, // 裁剪后的长宽
            height: 126
        }).toBlob(function (blob) {
            // 裁剪后将图片放到指定标签
            $target.attr('src', URL.createObjectURL(blob));
            var reader = new FileReader();
            reader.onload = (function (file) {
                return function (e) {
                    $pic.attr("value", this.result);
                };
            })(blob);
            reader.readAsDataURL(blob);
        });
    }
    $(function () {
        initCropper($('#photo'), $('#input'));
    });
</script>
</body>
</html>