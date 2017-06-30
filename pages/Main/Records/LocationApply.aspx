<%@ Page Language="C#" AutoEventWireup="true" CodeFile="LocationApply.aspx.cs" Inherits="pages_Main_Records_Location" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
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
                模拟定位申请表
            </div>
            <div class="paper-content">
                <div class="single-row">
                    <span class="item col-xs-4">姓名：<span id="username" class="underline"></span></span>
                    <span class="item col-xs-4">性别：<span id="sex" class="underline"></span></span>
                    <span class="item col-xs-4">身份证号：<span id="idnumber" class="underline"></span></span>
                </div>
                <div class="single-row">
                    <span class="item col-xs-4">民族：<span id="nation" class="underline"></span></span>
                    <span class="item col-xs-4">年龄：<span id="age" class="underline"> </span></span>
                    <span class="item col-xs-4">地址：<span id="address" class="underline"></span></span>
                </div>
                <div class="single-row">
                    <span class="item col-xs-4">分中心医院：<span id="hospital" class="underline"></span></span>
                    <span class="item col-xs-4">联系方式1：<span id="contact" class="underline"></span></span>
                    <span class="item col-xs-4">联系方式2：<span id="contact2" class="underline"></span></span>
                </div>
            </div>
            <div class="paper-content">
                <div class="single-row">
                     <span class="item col-xs-4">疗程号：
                          <input id="treatID"  name="treatID" class="form-item" type="text" readonly="true"   />
                     </span>
                    <span class="item col-xs-4">扫描部位：
                           <select id="scanpart" name="scanpart" class="form-item">                
                           </select>
                     </span>
                    <span class="item col-xs-4">扫描方式：
                           <select id="scanmethod" name="scanmethod" class="form-item">                
                          </select>
                     </span>
                 </div> 
                  <div class="single-row">
                     <span class="item col-xs-4">上界：
                           <input id="up" name="up" type="text"  class="form-item"  />
                     </span>
                    <span class="item col-xs-4">下界：
                            <input id="down" name="down" type="text"  class="form-item"  />
                     </span>
                     <span class="item col-xs-4">是否增强：
                        <span>
                            <input  id="yes" type="radio" name="add" checked="true" style="width:20pt" onclick="forchange()" value="1"/>
                             是
                            <input id="No" type="radio" name="add"  style="width:20pt" onclick="forchange()" value="0"/>
                             否
                        </span>
                        </span>
                     </div>
                   <div class="single-row">
                          <span class="item col-xs-4">增强方式：
                           <select id="addmethod" name="addmethod" class="form-item">                
                         </select> 
                          </span>
                          <span class="item col-xs-4">特殊要求：
                           <select id="special" name="special" class="form-item">                
                          </select>
                         </span>
                        <span class="item col-xs-4">设备与时间：
                            <input id="appointtime" name="appoint" type="text" readonly="true" class="form-item"  />
                             <input id="idforappoint"  value="0" type="hidden" />
                             <input id="chooseappoint" type="button" value="预约"  data-toggle="modal" data-target="#appoint" style="margin:15px;float:right;margin-top:20px;" />
                       </span>
                 </div> 
                 <div class="single-row">
                    <span class="item area-group col-xs-12">
                        备注：
                        <textarea id="remark" class="form-area" style="height:50px"></textarea>
                    </span>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <span class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></span>
                    <span class="item col-xs-6">日期：<span  id="time" class="underline"></span></span>
                </div>
            </div>
        </div>
           <div class="modal fade " id="appoint" tabindex="-1" role="dialog" aria-labelledby="exampleModalLabel" aria-hidden="true" style="margin-top:100px;">  
                     <div class="panel panel-default" style="max-width:1000px;margin:auto;">
                               <div class="panel-heading" style="text-align:center">
                                            预约设备与时间窗口         
                                </div>
                                 <div class="panel-body">
                                     <table class="table table-striped table-bordered table-hover" style="float:left;border: solid thin;width:38%;">
                                          <tr style="height:30px;text-align:center">
                                              <td style="width:45%;">选择设备:</td>
                                                <td>
                                                 <select style="width:150px;height:40px" id="equipmentName">
                                                 </select>
                                                 </td>
                                           </tr>
                                            <tr style="height:30px;text-align:center">
                                                 <td style="width:45%">预约时间:</td>
                                                  <td>
                                                  <input id="AppiontDate" style="width:150px;height:40px" placeholder="请输入时间" onclick="laydate()" />
                                                  </td>
                                                  </tr>
                                                   <tr>
                                                    <td colspan="2" style="text-align:center">
                                                     <input type="button" class="btn btn-default" id="chooseProject" value="查询该项" />
                                                        <input class="btn btn-default" style="margin-left:40px;" id="cannel" type="button" value="取消" data-dismiss="modal" aria-label="Close" />
                                                        <input class="btn btn-default" id="sure" type="button" value="确定" data-dismiss="modal" />
                                                   </td>
                                           </tr>
                                          </table>
                                          <table class="table table-striped table-bordered table-hover" style="margin-top:0px;width:60%;float:right" id="apptiontTable">
                                          </table> 
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
     <script src="../../../js/Main/LocationApply.js" type="text/javascript"></script>
     <script src="../../../plugin/laydate/laydate.js"></script>
</body>
</html>
