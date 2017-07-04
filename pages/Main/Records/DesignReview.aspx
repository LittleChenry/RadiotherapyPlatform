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
             <form id="saveReview" method="post" runat="server">
            <input type="hidden" name="ispostback" value="true" />
            <input type="hidden"  id="hidetreatID" name="hidetreatID" />
            <input type="hidden"  id="userID" name="userID" />
            <input type="hidden"  id="TechnologyConfirm1" name="TechnologyConfirm1" value="0"/>
            <input type="hidden"  id="confirmPlanSystem1" name="confirmPlanSystem1" value="0"/>
            <input type="hidden"  id="EquipmentConfirm1" name="EquipmentConfirm1" value="0"/>
            <input type="hidden"  id="confirmAngle1" name="confirmAngle1" value="0"/>
            <input type="hidden"  id="confirmCoplanar1" name="confirmCoplanar1" value="0"/>
            <input type="hidden"  id="confirmMachineNumbe1" name="confirmMachineNumbe1" value="0"/>
            <input type="hidden"  id="confirmControlPoint1" name="confirmControlPoint1" value="0"/>
            <input type="hidden"  id="confirmGrid1" name="confirmGrid1" value="0"/>
            <input type="hidden"  id="confirmAlgorithm1" name="confirmAlgorithm1" value="0"/>
            <input type="hidden"  id="confirmReoptimization1" name="confirmReoptimization1" value="0"/>
            <input type="hidden"  id="confirmFeasibility1" name="confirmFeasibility1" value="0"/>
            <input type="hidden"  id="confirmPlaceInformation1" name="confirmPlaceInformation1" value="0"/>
            <input type="hidden"  id="confirmIsExport1" name="confirmIsExport1" value="0"/>
            <input type="hidden"  id="confirmDRR1" name="confirmDRR1" value="0"/>                  
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
                    <div class="item col-xs-4">所属医生：<span id="Reguser" class="underline"></span></div>
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
                                    <td id="Technology"></td>
                                    <td id="TechnologyConfirm">未通过</td>                        
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmTechnology" class="btn btn-block btn-success"  type="button" onclick="confirm(this, TechnologyConfirm, TechnologyConfirm1, confirmTechnology, cancelconfirmTechnology)" >通过</button>
                                        <button id="cancelconfirmTechnology" class="btn btn-block btn-warning"  type="button" onclick="cancelconfirm(this, TechnologyConfirm, TechnologyConfirm1, confirmTechnology, cancelconfirmTechnology)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>2</td>
                                    <td>计划系统</td>
                                    <td id="PlanSystem" ></td>
                                    <td id="PlanSystemConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmPlanSystem" class="btn btn-block btn-success" type="button"  onclick="confirm(this, PlanSystemConfirm, confirmPlanSystem1, confirmPlanSystem, cancelconfirmPlanSystem)" >通过</button>
                                        <button id="cancelconfirmPlanSystem" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, PlanSystemConfirm, confirmPlanSystem1, confirmPlanSystem, cancelconfirmPlanSystem)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>3</td>
                                    <td>放疗设备</td>
                                    <td id="Equipment" ></td>
                                    <td id="EquipmentConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmEquipment" class="btn btn-block btn-success" type="button"  onclick="confirm(this, EquipmentConfirm, EquipmentConfirm1, confirmEquipment, cancelconfirmEquipment)" >通过</button>
                                        <button id="cancelconfirmEquipment" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, EquipmentConfirm, EquipmentConfirm1, confirmEquipment, cancelconfirmEquipment)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>4</td>
                                     <td>射野角度</td>
                                    <td id="IlluminatedNumber" ></td>
                                    <td id="AngleConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmAngle" class="btn btn-block btn-success" type="button"  onclick="confirm(this, AngleConfirm, confirmAngle1, confirmAngle, cancelconfirmAngle)" >通过</button>
                                        <button id="cancelconfirmAngle" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, AngleConfirm, confirmAngle1, confirmAngle, cancelconfirmAngle)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>5</td>
                                    <td>非共面照射</td>
                                    <td id="Coplanar" ></td>
                                    <td id="CoplanarConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmCoplanar" class="btn btn-block btn-success" type="button"  onclick="confirm(this, CoplanarConfirm, confirmCoplanar1, confirmCoplanar, cancelconfirmCoplanar)" >通过</button>
                                        <button id="cancelconfirmCoplanar" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, CoplanarConfirm, confirmCoplanar1, confirmCoplanar, cancelconfirmCoplanar)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>6</td>
                                    <td>机器跳数</td>
                                    <td id="MachineNumbe" ></td>
                                    <td id="MachineNumbeConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmMachineNumbe" class="btn btn-block btn-success" type="button"  onclick="confirm(this, MachineNumbeConfirm, confirmMachineNumbe1, confirmMachineNumbe, cancelconfirmMachineNumbe)" >通过</button>
                                        <button id="cancelconfirmMachineNumbe" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, MachineNumbeConfirm, confirmMachineNumbe1, confirmMachineNumbe, cancelconfirmMachineNumbe)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>7</td>
                                    <td>控制点数量</td>
                                    <td id="ControlPoint" ></td>
                                    <td id="ControlPointConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmControlPoint" class="btn btn-block btn-success" type="button"  onclick="confirm(this, ControlPointConfirm, confirmControlPoint1, confirmControlPoint, cancelconfirmControlPoint)" >通过</button>
                                        <button id="cancelconfirmControlPoint" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, ControlPointConfirm, confirmControlPoint1, confirmControlPoint, cancelconfirmControlPoint)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>8</td>
                                    <td>计算网格</td>
                                    <td id="Grid" ></td>
                                    <td id="GridConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmGrid" class="btn btn-block btn-success" type="button"  onclick="confirm(this, GridConfirm, confirmGrid1, confirmGrid, cancelconfirmGrid)" >通过</button>
                                        <button id="cancelconfirmGrid" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, GridConfirm, confirmGrid1, confirmGrid, cancelconfirmGrid)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>9</td>
                                    <td>优化算法</td>
                                    <td id="Algorithm" ></td>
                                    <td id="AlgorithmConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmAlgorithm" class="btn btn-block btn-success" type="button"  onclick="confirm(this, AlgorithmConfirm, confirmAlgorithm1, confirmAlgorithm, cancelconfirmAlgorithm)" >通过</button>
                                        <button id="cancelconfirmAlgorithm" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, AlgorithmConfirm, confirmAlgorithm1, confirmAlgorithm, cancelconfirmAlgorithm)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>10</td>
                                    <td>放疗计划可执行度</td>
                                     <td id="Feasibility" ></td>
                                    <td id="FeasibilityConfirm">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmFeasibility" class="btn btn-block btn-success" type="button"  onclick="confirm(this, FeasibilityConfirm, confirmFeasibility1, confirmFeasibility, cancelconfirmFeasibility)" >通过</button>
                                        <button id="cancelconfirmFeasibility" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, FeasibilityConfirm, confirmFeasibility1, confirmFeasibility, cancelconfirmFeasibility)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>11</td>
                                    <td>放疗计划再优化程度</td>
                                   <td id="Td1" ></td>
                                    <td id="Reoptimization">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmReoptimization" class="btn btn-block btn-success" type="button" onclick="confirm(this, Reoptimization, confirmReoptimization1, confirmReoptimization, cancelconfirmReoptimization)" >通过</button>
                                        <button id="cancelconfirmReoptimization" class="btn btn-block btn-warning" type="button" onclick="cancelconfirm(this, Reoptimization, confirmReoptimization1, confirmReoptimization, cancelconfirmReoptimization)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>12</td>
                                    <td>摆位野信息</td>
                                    <td id="Td2" ></td>
                                    <td id="PlaceInformation">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmPlaceInformation" class="btn btn-block btn-success" type="button"  onclick="confirm(this, PlaceInformation, confirmPlaceInformation1, confirmPlaceInformation, cancelconfirmPlaceInformation)" >通过</button>
                                        <button id="cancelconfirmPlaceInformation" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, PlaceInformation, confirmPlaceInformation1, confirmPlaceInformation, cancelconfirmPlaceInformation)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>13</td>
                                    <td>DRR</td>
                                    <td id="Td4" ></td>
                                    <td id="DRR">未通过</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmDRR" class="btn btn-block btn-success" type="button"  onclick="confirm(this, DRR, confirmDRR1, confirmDRR, cancelconfirmDRR)" >通过</button>
                                        <button id="cancelconfirmDRR" class="btn btn-block btn-warning" type="button"  onclick="cancelconfirm(this, DRR, confirmDRR1, confirmDRR, cancelconfirmDRR)" style="display:none" >取消通过</button>
                                    </td>
                                </tr>
                                <tr>
                                    <td>14</td>
                                    <td>计划和图像导出到放疗网络</td>
                                    <td id="Td6" ></td>
                                    <td id="IsExport">否</td>
                                    <td style="padding:1px 35px;vertical-align:middle;">
                                        <button id="confirmIsExport" class="btn btn-block btn-success" type="button" onclick="confirm(this, IsExport, confirmIsExport1, confirmIsExport, cancelconfirmIsExport)" >是</button>
                                        <button id="cancelconfirmIsExport" class="btn btn-block btn-warning" type="button" onclick="cancelconfirm(this, IsExport, confirmIsExport1, confirmIsExport, cancelconfirmIsExport)" style="display:none" >否</button>
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
                            <input id="ReferenceCenterX" name="ReferenceCenterX" type="number" class="form-group-input" />
                            <span class="input-group-addon">cm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">y</span>
                             <input id="ReferenceCenterY" name="ReferenceCenterY" type="number" class="form-group-input" />
                            <span class="input-group-addon">cm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">z</span>
                             <input id="ReferenceCenterZ" name="ReferenceCenterZ" type="number" class="form-group-input" />
                            <span class="input-group-addon">cm</span>
                        </div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">治疗等中心：</span>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">x</span>
                            <input id="TreatmentCenterX" name="TreatmentCenterX" type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">y</span>
                            <input id="TreatmentCenterY" name="TreatmentCenterY" type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">z</span>
                            <input id="TreatmentCenterZ" name="TreatmentCenterZ" type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                    </div>
                </div>
                <div class="single-row">
                    <div class="col-xs-12">
                        <span class="form-text col-xs-2" style="padding-left:0px;">移床参数：</span>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">左</span>
                            <input id="MovementX" name="MovementX" type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">头</span>
                            <input id="MovementY" name="MovementY" type="number" class="form-group-input" />
                            <span class="input-group-addon">mm</span>
                        </div>
                        <div class="group-item col-xs-3">
                            <span class="input-group-addon">腹</span>
                            <input id="MovementZ" name="MovementZ" type="number" class="form-group-input" />
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
    <script src="../../../js/Main/DesignReview.js" type="text/javascript"></script>
    <!-- Page script -->
    <script type="text/javascript">
        $("#AppiontDate").datepicker({ autoclose: true });
    </script>
</body>
</html>