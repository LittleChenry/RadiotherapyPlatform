<%@ Page Language="C#" AutoEventWireup="true" CodeFile="FixedApply.aspx.cs" Inherits="pages_Main_Records_Fixed" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
     <script src="../../../plugin/laydate/laydate.js"></script>
     <script src="../../../js/Main/fixApply.js" type="text/javascript"></script>
     <!-- css -->
      <link rel="stylesheet" href="../../../css/Main/main.css"/>
      <!-- Bootstrap 3.3.6 -->
      <link rel="stylesheet" href="../../../plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
      <!-- DataTables -->
      <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
      <!-- Font Awesome -->
      <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/font-awesome/css/font-awesome.min.css"/>
      <!-- Ionicons -->
      <link rel="stylesheet" href="../../../plugin/AdminLTE/plugins/ionicons/css/ionicons.min.css"/>
      <!-- Theme style -->
      <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/AdminLTE.min.css"/>
      <!-- AdminLTE Skins. Choose a skin from the css/skins
           folder instead of downloading all of them to reduce the load. -->
      <link rel="stylesheet" href="../../../plugin/AdminLTE/dist/css/skins/_all-skins.min.css"/>

      <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
      <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
      <!--[if lt IE 9]>
      <script src="https://oss.maxcdn.com/html5shiv/3.7.3/html5shiv.min.js"></script>
      <script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
      <![endif]-->
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

</head>
<body>
    <div id="page-wrapper" style="border:0px;margin:0px; min-height: 923px;background-color:#fff;">
        <div class="row">
            <div class="col-md-12">
                <div class="panel panel-default"> 
                     <div class="panel-body" id="otherpanelbody" style="height:800px">
                         <div class="row"> 
                                    <div id="recordbase" style="position:relative;top:100px">
                                            <table style="border: solid thin;margin:auto;width:100%;">
                                                <tr>
                                                      <td colspan="6" style="border-bottom:#000 solid 1px;height:50px;font-weight:bolder;font-size:large;text-align:center">体位固定申请表</td>
                                                 </tr>
                                                  <tr style="height:30px">
                                                    <td style="width:10%;">姓名:</td>
                                                    <td id="username" style="width:10%;"></td>
                                                    <td style="width:10%;">性别:</td>
                                                    <td id="sex" style="width:10%;"> </td>
                                                    <td style="width:15%;">身份证号:</td>
                                                    <td id="idnumber" style="width:20%;"> </td>
                                                 </tr>
                                                  <tr style="height:30px">
                                                    <td style="width:10%;">民族:</td>
                                                    <td id="nation" style="width:10%;"></td> 
                                                    <td style="width:15%;">年龄:</td>
                                                    <td id="age" style="width:20%;"> </td>
                                                    <td style="width:15%;">住址:</td>
                                                    <td id="address" style="width:20%;"> </td>
                                                 </tr>
                                                 <tr style="height:30px">
                                                    <td style="width:10%;">就诊单位:</td>
                                                    <td id="hospital" style="width:15%;"></td> 
                                                     <td style="width:15%;">联系方式1:</td>
                                                    <td id="contact" style="width:15%;"> </td>
                                                    <td style="width:15%;">联系方式2:</td>
                                                    <td id="contact2" style="width:25%;"> </td>
                                               </tr>
                                                  <tr>
                                                      <td colspan="6" style="border-top:#000 solid 1px; border-bottom:#000 solid 1px;height:50px;font-weight:bolder;font-size:large;text-align:center">申请填写</td>
                                                 </tr>
                                                <tr style="height:30px;text-align:center">
                                                    <td style="width:10%;padding-top:10px">疗程号:</td>
                                                    <td colspan="2">
                                                       <input id="treatID" name="treatID" type="text" style="border:none;float:left;margin-top:10px" readonly="true"  />
                                                    </td>  
                                                     <td style="width:15%;padding-top:10px">模具选择:</td>
                                                    <td colspan="2">
                                                     <select id="modelselect" style="width:200px;height:30px;margin-top:10px;float:left" name="modelselect">                
                                                    </select>
                                                    </td>
                                               </tr>
                                                  <tr style="height:30px;text-align:center">
                                                    <td style="width:10%;padding-top:10px">特殊要求:</td>
                                                    <td colspan="2">
                                                       <select id="specialrequest"  style="width:200px;height:30px;margin-top:10px;margin-left:0px;float:left"  name="specialrequest" >                
                                                      </select>
                                                    </td>  
                                                     <td style="width:15%;padding-top:10px">固定装置:</td>
                                                    <td  colspan="2">
                                                      <select id="fixEquip" style="width:200px;height:30px;margin-top:10px;margin-left:0px;float:left" name="fixEquip" >                
                                                        </select>
                                                    </td>
                                               </tr>
                                                  <tr  style="height:30px;text-align:center">
                                                    <td style="width:10%;padding-top:10px" >体位:</td>
                                                    <td colspan="2">
                                                       <select id="bodyPost"  style="width:200px;height:30px;margin-top:10px;margin-left:0px;float:left" name="bodyPost"> 
                                                       <option value="allItem">---------选择体位--------</option> 
                                                       <option value="仰卧">仰卧</option> 
                                                       <option value="俯卧">俯卧</option>
                                                       <option value="侧卧">侧卧</option>                  
                                                       </select> 
                                                    </td>  
                                                     <td style="width:10%;padding-top:10px">设备与时间:</td>
                                                    <td  colspan="2">
                                                        <input id="appointtime"  style="width:190px;height:30px;margin-top:20px;float:left"  name="appointtime" type="text"  readonly="true"  />
                                                        <input type="hidden" id="idforappoint" />
                                                        <input id="chooseappoint" type="button" value="预约"  data-toggle="modal" data-target="#appoint" style="margin:15px;float:right;margin-top:20px;" />
                                                    </td>
                                               </tr>
                                               <tr style="height:30px;text-align:center">
                                                    <td style="width:10%;padding-top:10px" >申请人:</td>
                                                     <td  colspan="2">
                                                          <input type="text" style="border:none;float:left;margin-top:10px" id="applyuser" name="applyuser" readonly="true" />
                                                    </td>
                                                   <td style="width:10%;padding-top:10px" >申请时间:</td>
                                                   <td  colspan="2">
                                                          <input type="text" style="border:none;float:left;margin-top:10px" id="time" name="time" readonly="true" />
                                                    </td>
                                                </tr>
                                           </table>
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
                                    </div>
                                </div>
                                </div>
                                </div>
                                </div>
                    <!-- /.row -->
                                </div>
                               
</body>
</html>
