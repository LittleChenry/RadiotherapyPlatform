<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Blank.aspx.cs" Inherits="pages_Main_Records_Blank" %>

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
    <!-- AdminLTE Skins. Choose a skin from the css/skins
    folder instead of downloading all of them to reduce the load. -->
    <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>
</head>
<body style="width:auto;min-width:900px;margin:auto;">
    <section class="content">
        <div class="paper" style="display:none;">
            <div class="paper-title">
                EXAMPLE表单
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>患者基本信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">姓名：<span class="underline">赵一</span></div>
                    <div class="item col-xs-4">性别：<span class="underline">男</span></div>
                    <div class="item col-xs-4">身份证号：<span class="underline">320624196506251100</span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">民族：<span class="underline">汉族</span></div>
                    <div class="item col-xs-4">年龄：<span class="underline"> 72</span></div>
                    <div class="item col-xs-4">地址：<span class="underline">安徽省滁州市人民大道12号</span></div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">分中心医院：<span class="underline">滁州市中西医结合医院</span></div>
                    <div class="item col-xs-4">联系方式1：<span class="underline">189-2001-0020</span></div>
                    <div class="item col-xs-4">联系方式2：<span class="underline">182-1212-1224</span></div>
                </div>
            </div>
            <div class="paper-content">
                <div class="content-title">
                    <span>患者基本信息：</span>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">
                        select：
                        <select class="form-item">
                            <option>select 1</option>
                            <option>select 2</option>
                            <option>select 3</option>
                            <option>select 4</option>
                        </select>
                    </div>
                    <div class="item col-xs-4">
                        input：
                        <input type="text" class="form-item" />
                    </div>
                    <div class="item col-xs-4">
                        Date：
                        <input type="text" class="form-item" id="Text1" placeholder="选择日期" />
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">
                        单选框：
                        <span>
                            <input type="radio" name="radio" id="radio3" value="value1" checked="" />
                            Option1
                            <input type="radio" name="radio" id="radio4" value="value2" />
                            Option2
                        </span>
                    </div>
                    <div class="item col-xs-4">
                        复选框：
                        <span>
                            <input type="checkbox" name="radio" id="checkbox4" value="value1" />
                            Option1
                            <input type="checkbox" name="radio" id="checkbox5" value="value2" />
                            Option2
                            <input type="checkbox" name="radio" id="checkbox6" value="value3" />
                            Option3
                        </span>
                    </div>
                    <div class="item col-xs-4">
                        Modal：
                        <button class="btn btn-default" data-toggle="modal" data-target="#myModal">Modal</button>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-4">
                        前缀：
                        <div class="group-item">
                            <span class="input-group-addon">$</span>
                            <input type="text" class="form-group-input" />
                        </div>
                    </div>
                    <div class="item col-xs-4">
                        单位后缀：
                        <div class="group-item">
                            <input type="text" class="form-group-input" />
                            <span class="input-group-addon">.00</span>
                        </div>
                    </div>
                    <div class="item col-xs-4">
                        前后缀：
                        <div class="group-item">
                            <span class="input-group-addon">$</span>
                            <input type="text" class="form-group-input" />
                            <span class="input-group-addon">.00</span>
                        </div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        备注：
                        <textarea class="form-area" placeholder="textarea最好不使用row属性，直接设置高度"></textarea>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-12">
                        单图片上传：
                        <div class="imgbox">
                            <div class="boxes">
                                <div class="imgnum">
                                    <input type="file" name="avatar" class="singlefilepath filepath" />
                                    <span class="closecamera resetarra"><i class="fa fa-times"></i></span>
                                    <img src="../../../img/avatar.jpg" class="camera-picture" />
                                    <!-- <i class="camera fa fa-camera" style="font-size:110px;"></i> -->
                                    <img class="img" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="item col-xs-12">
                        多图片上传：
                        <div class="imgbox multifile">
                            <div class="boxes">
                                <div class="imgnum">
                                    <input type="file" name="avatar" class="multifilepath filepath" />
                                    <span class="closecamera closearea"><i class="fa fa-times"></i></span>
                                    <img src="../../../img/camera.png" class="camera-picture" />
                                    <!-- <i class="camera fa fa-camera" style="font-size:110px;"></i> -->
                                    <img class="img" />
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span class="underline">王医生</span></div>
                    <div class="item col-xs-6">日期：<span class="underline">2017年6月28日</span></div>
                </div>
            </div>
        </div>
        <div id="myModal" class="modal fade" tabindex="-1" role="dialog">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                        <h4 class="modal-title">Modal title</h4>
                    </div>
                    <div class="modal-body">
                        <p>One fine body&hellip;</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary">Save changes</button>
                    </div>
                </div><!-- /.modal-content -->
            </div><!-- /.modal-dialog -->
        </div><!-- /.modal -->
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
    <!-- Page script -->
    <script type="text/javascript">
        $("#datepicker").datepicker({ autoclose: true });
    </script>
</body>
</html>