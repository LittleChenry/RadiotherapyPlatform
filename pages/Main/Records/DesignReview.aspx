<%@ Page Language="C#" AutoEventWireup="true" CodeFile="DesignReview.aspx.cs" Inherits="pages_Main_Records_DesignReview" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title>治疗计划复核</title>
  <!-- css -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/css/Main/Records.css"/>
    <!-- Bootstrap 3.3.6 -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/bootstrap/css/bootstrap.min.css"/>
    <!-- DataTables -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datatables/dataTables.bootstrap.css"/>
    <!-- bootstrap datepicker -->
    <link rel="stylesheet" href="/RadiotherapyPlatform/plugin/AdminLTE/plugins/datepicker/datepicker3.css"/>
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
             <form id="saveReview" method="post" runat="server">
            <input type="hidden" name="ispostback" value="true" />
            <input type="hidden"  id="hidetreatID" name="hidetreatID" />
            <input type="hidden"  id="userID" name="userID" />
            <input type="hidden"  id="TechnologyConfirm1" name="TechnologyConfirm1" value="0"/>
            <input type="hidden"  id="confirmPlanSystem1" name="confirmPlanSystem1" value="0"/>
            <input type="hidden"  id="EquipmentConfirm1" name="EquipmentConfirm1" value="0"/>
            
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
                    <span>复核计划信息：
                    <button id="confirm" type="button" class="btn btn-block btn-success" onclick="check()" disabled="disabled">通过</button></span>
                </div>
                <div class="single-row">
                    <div class="item area-group col-xs-12">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th style="width:8%;text-align:center;">序号</th>
                                    <th style="width:22%;text-align:center;">复核项</th>
                                    <th style="width:25%;text-align:center;">计划信息</th>
                                    <th style="width:25%;text-align:center;">导入信息</th>
                                    <th style="width:20%;text-align:center;">复核结果</th>
                                </tr>
                            </thead>
                            <tbody style="text-align: center;">
                                <tr>
                                    <td>1</td>                                    
                                    <td>摆位信息</td>
                                    <td id="positioninfomation1"></td>
                                    <td id="positioninfomation2"></td>                        
                                    <td id="check1"></td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>分次剂量/总剂量</td>
                                    <td id="dose1" ></td>
                                    <td id="dose2"></td>
                                    <td id="check2"></td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>放疗设备</td>
                                    <td id="Equipment1" ></td>
                                    <td id="Equipment2"></td>
                                    <td id="check3"></td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                     <td>放疗计划系统</td>
                                    <td id="plansystem1" ></td>
                                    <td id="plansystem2"></td>
                                    <td id="check4"></td>
                                </tr>
                                <tr>
                                    <td>5</td>
                                    <td>照射技术</td>
                                    <td id="Irradiation1" ></td>
                                    <td id="Irradiation2"></td>
                                    <td id="check5"></td>
                                </tr>
                                <tr>
                                    <td>6</td>
                                    <td>射线类型</td>
                                    <td id="Raytype1" ></td>
                                    <td id="Raytype2" ></td>
                                    <td id="check6"></td>
                                </tr>
                                <tr>
                                    <td>7</td>
                                    <td>能量</td>
                                    <td id="energy1" ></td>
                                    <td id="energy2"></td>
                                    <td id="check7"></td>
                                </tr>
                                <tr>
                                    <td>8</td>
                                    <td>射野数量</td>
                                    <td id="IlluminatedNumber1" ></td>
                                    <td id="IlluminatedNumber2"></td>
                                    <td id="check8"></td>
                                </tr>
                                <tr>
                                    <td>9</td>
                                    <td>射野角度</td>
                                    <td id="Illuminatedangle1" ></td>
                                    <td id="Illuminatedangle2"></td>
                                    <td id="check9"></td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>机器跳数</td>
                                    <td id="MU1" ></td>
                                    <td id="MU2"></td>
                                    <td id="check10"></td>
                                </tr>
                                <tr>
                                    <td>11</td>
                                    <td>控制点数量</td>
                                    <td id="ControlPoint1" ></td>
                                    <td id="ControlPoint2"></td>
                                    <td id="check11"></td>
                                </tr>
                                <tr>
                                    <td>12</td>
                                    <td>非共面照射</td>
                                    <td id="Coplanar1" ></td>
                                    <td id="Coplanar2"></td>
                                    <td id="check12"></td>
                                </tr>
                                
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="single-row">
                       <span class="form-text col-xs-6" style="padding-left:0px;">移床参数：</span>
                    <span id="check13" class="form-text col-xs-6" > 
                       <button id="confirmCoplanar" class="btn btn-block btn-success" type="button"  onclick="confirm1(this,confirmCoplanar, cancelconfirmCoplanar,TechnologyConfirm1)" disabled="disabled">通过</button>
                       <button id="cancelconfirmCoplanar" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this,confirmCoplanar, cancelconfirmCoplanar,TechnologyConfirm1)" style="display:none;margin:0px;" >取消通过</button>
                    </span>
                        </div> 
                   <div class="single-row">
                       <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">左：</span>
                            <span id="left" ></span>
                       </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" >右：</span>
                            <span id="right" ></span>
                       </div>
                    </div> 
                         <div class="single-row">
                       <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">升：</span>
                            <span id="rise" ></span>
                       </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" >降：</span>
                            <span id="drop" ></span>
                       </div>
                    </div> 
                         <div class="single-row">
                       <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">进：</span>
                            <span id="enter" ></span>
                       </div>
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" >出：</span>
                            <span id="out" ></span>
                       </div>
                    </div> 
                    <div class="single-row">                     
                           <span class="form-text col-xs-6" >治疗计划打印与传输：</span>
                        <span id="check14"  class="form-text col-xs-6" >
                           <button id="Button1" class="btn btn-block btn-success" type="button"  onclick="confirm1(this,Button1,Button2,confirmPlanSystem1)" disabled="disabled">通过</button>
                           <button id="Button2" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this,Button1,Button2,confirmPlanSystem1)" style="display:none;margin:0px;" >取消通过</button>
                        </span>
                    </div> 
                    <div class="single-row">    
                                     
                           <span class="form-text col-xs-6" >参考图像传输：</span>
                            <span id="check15" class="form-text col-xs-6" > 
                           <button id="Button3" class="btn btn-block btn-success" type="button"  onclick="confirm1(this,Button3,Button4,EquipmentConfirm1)" disabled="disabled">通过</button>
                           <button id="Button4" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this,Button3,Button4,EquipmentConfirm1)" style="display:none;margin:0px;" >取消通过</button>
                        </span>
                    </div> 
                    
                    <div class="single-row">                     
                           <span class="form-text col-xs-6" >放疗计划QA：</span>
                            <span class="col-xs-3" style="padding-left:0px;">
                                <input type="radio" name="planQA" id="yes" value="1" />
                                执行
                            </span>
                            <span class="col-xs-3" style="padding-left:0px;">
                                <input type="radio" name="planQA" id="no" value="0" />
                                未执行
                            </span>
                    </div> 
                <div class="single-row">
                        <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">通过率：</span>
                            <input name="degree" id="degree" class="form-item" />
                        </div> 
                         <div class="col-xs-6">
                            <span class="form-text col-xs-4" style="padding-left:0px;">备注条件：</span>
                            <input name="remark" id="remark" class="form-item"/>
                        </div>   
                    </div> 
                 <div id="pdfplan" class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">计划PDF上传：</span>
                        <div class="group-item col-xs-3">                        
                            <input id="fp_upload" type="file" accept="application/pdf" name="fp_upload" disabled="disabled"/>
                        </div>                       
                    </div>
                </div>
                <div  id="reviewplan" class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">复核PDF上传：</span>
                        <div class="group-item col-xs-3">                        
                            <input id="fp_upload1" type="file" accept="application/pdf" name="fp_upload1" disabled="disabled"/>
                        </div>                       
                    </div>
                </div>
            </div>
            <div class="paper-footer">
                <div class="single-row">
                    <div class="item col-xs-6">医生签字：<span id="applyuser" class="underline"></span></div>
                    <div class="item col-xs-6">复核时间：<span  id="time" class="underline"></span></div>
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
    <!-- SlimScroll -->
    <script src="../../../plugin/AdminLTE/plugins/slimScroll/jquery.slimscroll.min.js"></script>
    <!-- FastClick -->
    <script src="../../../plugin/AdminLTE/plugins/fastclick/fastclick.js"></script>
         <script src="../../../plugin/AdminLTE/jquery.PrintArea.js"></script>
    <!-- Bootstrap 3.3.6 -->
    <script src="../../../plugin/AdminLTE/bootstrap/js/bootstrap.min.js"></script>
    <!-- AdminLTE App -->
    <script src="../../../plugin/AdminLTE/dist/js/app.min.js"></script>
    <!-- AdminLTE for demo purposes -->
    <script src="../../../plugin/AdminLTE/dist/js/demo.js"></script>
    <script src="../../../js/Main/ReviewPrint.js"></script>
    <!-- javascript -->
    <script src="../../../js/Main/DesignReview.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>